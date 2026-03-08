---
描述：透過處理並執行tasks.md中定義的所有任務來執行執行計劃
腳本：
  sh：腳本/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps：腳本/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，您**必須**考慮使用者輸入（如果不為空）。

## 大綱

1. 從儲存庫根目錄執行 `{SCRIPT}` 並解析 FEATURE_DIR 和 AVAILABLE_DOCS 清單。所有路徑都必須是絕對路徑。對於像「I'm Groot」這樣的參數中的單引號，請使用轉義語法：例如'I'\''m Groot'（或如果可能的話使用雙引號：「I'm Groot」）。

2. **檢查清單狀態**（如果 FEATURE_DIR/checklists/ 存在）：
   - 掃描 checklists/ 目錄中的所有清單文件
   - 對於每個清單，計算：
     - 總專案：與 `- [ ]` 或 `- [X]` 或 `- [x]` 相符的所有行
     - 已完成的專案：符合 `- [X]` 或 `- [x]` 的行
     - 不完整的專案：符合 `- [ ]` 的行
   - 建立狀態表：

     ```text
     | Checklist | Total | Completed | Incomplete | Status |
     |-----------|-------|-----------|------------|--------|
     | ux.md     | 12    | 12        | 0          | ✓ PASS |
     | test.md   | 8     | 5         | 3          | ✗ FAIL |
     | security.md | 6   | 6         | 0          | ✓ PASS |
     ```

   - 計算總體狀態：
     - **通過**：所有清單都有 0 個不完整的專案
     - **FAIL**：一個或多個清單包含不完整的專案

   - **如果任何清單不完整**：
     - 顯示專案計數不完整的表
     - **停止**並詢問：“有些清單不完整。您是否仍想繼續實施？（是/no）”
     - 等待用戶回應後再繼續
     - 如果使用者說“不”或“等待”或“停止”，則停止執行
     - 如果使用者說“是”或“繼續”或“繼續”，則繼續執行步驟 3

   - **如果所有清單都已完成**：
     - 顯示表格，顯示所有已通過的清單
     - 自動進行步驟3

3. 載入並分析實作上下文：
   - **必需**：閱讀tasks.md以取得完整的任務清單和執行計劃
   - **必要**：閱讀 plan.md 以了解技術堆疊、架構和檔案結構
   - **IF EXISTS**：讀取 data-model.md 以取得實體和關係
   - **如果存在**：閱讀合約/了解 API 規格和測試要求
   - **如果存在**：閱讀research.md以了解技術決策和限制
   - **如果存在**：閱讀quickstart.md以了解整合場景

4. **專案設定驗證**：
   - **必要**：根據實際專案設定建立/verify忽略文件：

   **檢測與建立邏輯**：
   - 檢查以下命令是否成功確定儲存庫是否為 git 儲存庫（如果是，則建立 /verify .gitignore）：

     ```sh
     git rev-parse --git-dir 2>/dev/null
     ```

   - 檢查 Plan.md 中的 Dockerfile* 或 Docker 是否存在 → create/verify .dockerignore
   - 檢查 .eslintrc* 是否存在 → create/verify .eslintignore
   - 檢查 eslint.config.* 是否存在 → 確保設定的 `ignores` 條目涵蓋所需的模式
   - 檢查 .prettierrc* 是否存在 → create/verify .prettierignore
   - 檢查 .npmrc 或 package.json 是否存在 → create/verify .npmignore （如果發布）
   - 檢查 terraform 檔案 (*.tf) 是否存在 → create/verify .terraformignore
   - 檢查是否需要 .helmignore（存在 helm 圖表）→ 建立/verify .helmignore

   **如果忽略文件已存在**：驗證它包含基本模式，僅附加缺少的關鍵模式
   **如果忽略文件遺失**：使用檢測到的技術的完整模式集建立

   **以技術劃分的常見模式**（來自 plan.md 技術堆疊）：
   - **Node.js/JavaScript/TypeScript**: `node_modules/`、`dist/`、`build/`、`*.log`、`.env*`
   - **Python**：`__pycache__/`、`*.pyc`、`.venv/`、`venv/`、`dist/`、`*.egg-info/`
   - **Java**：`target/`、`*.class`、`*.jar`、`.gradle/`、`build/`
   - **C#/.NET**：`bin/`、`obj/`、`*.user`、`*.suo`、`packages/`
   - **開始**：`*.exe`、`*.test`、`vendor/`、`*.out`
   - **紅寶石**： `.bundle/`、`log/`、`tmp/`、`*.gem`、`vendor/bundle/`
   - **PHP**：`vendor/`、`*.log`、`*.cache`、`*.env`
   - **鐵鏽**：`target/`、`debug/`、`release/`、`*.rs.bk`、`*.rlib`、`*.prof*`、`.idea/`、`*.log`、`.env*`
   - **Kotlin**：`build/`、`out/`、`.gradle/`、`.idea/`、`*.class`、`*.jar`、`*.iml`、`*.log`、`.env*`
   - **C++**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.so`、`*.a`、`*.exe`、`*.dll`、`.idea/`、`*.log`、`.env*`
   - **C**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.a`、`*.so`、`*.exe`、`Makefile`、`config.log`、`.idea/`、`*.log`、`.env*`
   - **斯威夫特**：`.build/`、`DerivedData/`、`*.swiftpm/`、`Packages/`
   - **R**：`.Rproj.user/`、`.Rhistory`、`.RData`、`.Ruserdata`、`*.Rproj`、`packrat/`、`renv/`
   - **通用**：`.DS_Store`、`Thumbs.db`、`*.tmp`、`*.swp`、`.vscode/`、`.idea/`

   **特定於工具的模式**：
   - **碼頭工人**：`node_modules/`、`.git/`、`Dockerfile*`、`.dockerignore`、`*.log*`、`.env*`、`coverage/`
   - **ESLint**：`node_modules/`、`dist/`、`build/`、`coverage/`、`*.min.js`
   - **更漂亮**：`node_modules/`、`dist/`、`build/`、`coverage/`、`package-lock.json`、`yarn.lock`、`pnpm-lock.yaml`
   - **地形**：`.terraform/`、`*.tfstate*`、`*.tfvars`、`.terraform.lock.hcl`
   - **Kubernetes/k8s**: `*.secret.yaml`、`secrets/`、`.kube/`、`kubeconfig*`、`*.key`、`*.crt`

5. 解析tasks.md結構並擷取：
   - **任務階段**：設定、測試、核心、整合、完善
   - **任務依賴關係**：順序與並行執行規則
   - **任務詳細資料**：ID、描述、檔案路徑、並行標記 [P]
   - **執行流程**：順序和依賴關係要求

6. 依照任務計畫執行實施：
   - **分階段執行**：完成每個階段，然後再進入下一階段
   - **尊重依賴關係**：依序執行順序任務，並行任務[P]可以一起執行  
   - **遵循 TDD 方法**：在對應的執行任務之前執行測試任務
   - **基於文件的協調**：影響相同文件的任務必須按順序執行
   - **驗證檢查點**：在繼續之前驗證每個階段的完成情況

7. 實施執行規則：
   - **首先設定**：初始化專案結構、依賴項、設定
   - **程式碼之前的測試**：如果您需要為合約、實體和整合場景編寫測試
   - **核心開發**：實作模型、服務、CLI 指令、端點
   - **整合工作**：資料函式庫連線、中間件、日誌記錄、外部服務
   - **完善與驗證**：單元測試、效能最佳化、文檔

8. 進度追蹤和錯誤處理：
   - 每完成一項任務後報告進度
   - 如果任何非並行任務失敗則停止執行
   - 對於並行任務 [P]，繼續成功的任務，報告失敗的任務
   - 提供清晰的錯誤訊息以及調試上下文
   - 如果實施無法繼續，建議後續步驟
   - **重要** 對於已完成的任務，請確保在任務文件中將任務標記為 [X]。

9. 完成驗證：
   - 驗證所有必需的任務已完成
   - 檢查實現的功能是否符合原始規範
   - 驗證測試是否通過且覆蓋範圍符合要求
   - 確認實施遵循技術計劃
   - 報告最終狀態以及已完成工作的摘要

注意：此指令假設tasks.md 中存在完整的任務細分。如果任務不完整或遺失，建議先執行 `/speckit.tasks` 重新產生任務清單。
