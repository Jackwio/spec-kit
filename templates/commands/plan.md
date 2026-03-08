---
描述：使用計劃範本執行實施計劃工作流程以產生設計工件。
交接： 
  - 標籤： 建立任務
    代理：speckit.tasks
    提示：將計劃分解為任務
    發送：真
  - 標籤： 建立清單
    代理：speckit.checklist
    提示：為以下網域建立清單...
腳本：
  sh: 腳本/bash/setup-plan.sh --json
  ps：腳本/powershell/setup-plan.ps1 -Json
代理腳本：
  sh: 腳本/bash/update-agent-context.sh __AGENT__
  ps：腳本/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，您**必須**考慮使用者輸入（如果不為空）。

## 大綱

1. **設定**：從儲存庫根執行 `{SCRIPT}` 並解析 JSON 以取得 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。對於像「I'm Groot」這樣的參數中的單引號，請使用轉義語法：例如'I'\''m Groot'（或如果可能的話使用雙引號：「I'm Groot」）。

2. **載入上下文**：閱讀 FEATURE_SPEC 和 `/memory/constitution.md`。載入 IMPL_PLAN 範本（已複製）。

3. **執行計劃工作流程**：遵循 IMPL_PLAN 範本中的結構來：
   - 填寫技術背景（將未知標記為“需要澄清”）
   - 填寫憲法中的憲法檢查部分
   - 評估門（如果違規不合理則出現錯誤）
   - 第0階段：產生research.md（解決所有需求澄清）
   - 第1階段：產生data-model.md、contracts/、quickstart.md
   - 第 1 階段：透過執行代理程式腳本更新代理上下文
   - 設計後重新評估憲法檢查

4. **停止並報告**：命令在第二階段計劃後結束。報告分支、IMPL_PLAN 路徑和產生的工件。

## 階段

### 第 0 階段：摘要與研究

1. **從上面的技術背景中提取未知數**：
   - 對於每個需求澄清 → 研究任務
   - 對於每個相依性 → 最佳實務任務
   - 對於每個整合 → 模式任務

2. **生成和派遣研究代理**：

   ```text
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **使用格式在 `research.md` 合併調查結果**：
   - 決定：[選擇什麼]
   - 理由：【為什麼選擇】
   - 考慮的替代方案：[也評估了什麼]

**輸出**：research.md 已解決所有需求澄清

### 第一階段：設計和合約

**先修條件：** `research.md` 完成

1. **從功能規格中提取實體** → `data-model.md`：
   - 實體名稱、欄位、關係
   - 來自需求的驗證規則
   - 狀態轉換（如果適用）

2. **定義介面契約**（如果專案有外部介面）→ `/contracts/`：
   - 確定專案向使用者或其他系統公開哪些介面
   - 記錄適合專案類型的合約格式
   - 範例：函式庫的公共 API、CLI 工具的命令模式、Web 服務的端點、解析器的語法、應用程式的 UI 契約
   - 如果專案是純粹內部的（建置腳本、一次性工具等），則跳過

3. **代理上下文更新**：
   - 跑 `{AGENT_SCRIPT}`
   - 這些腳本檢測正在使用哪個 AI 代理
   - 更新適當的特定於代理的上下文文件
   - 僅添加當前計劃中的新技術
   - 保留標記之間的手動新增

**輸出**：data-model.md、/contracts/*、quickstart.md、代理特定文件

## 關鍵規則

- 使用絕對路徑
- 門故障或未解決的澄清錯誤
