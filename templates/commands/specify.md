---
描述：根據自然語言特徵描述建立或更新特徵規範。
交接： 
  - 標籤： 建構技術計劃
    代理：speckit.plan
    提示：為規範建立計劃。我正在建設...
  - 標籤： 澄清規格要求
    代理：speckit.clarify
    提示：明確規範要求
    發送：真
腳本：
  sh：腳本/bash/create-new-feature.sh --json“{ARGS}”
  ps：腳本/powershell/create-new-feature.ps1 -Json“{ARGS}”
---

## 使用者輸入

```text
$ARGUMENTS
```

在繼續之前，您**必須**考慮使用者輸入（如果不為空）。

## 大綱

使用者在觸發訊息中 `/speckit.specify` 之後鍵入的文字**是**功能描述。假設您在此對話中始終可以使用它，即使 `{ARGS}` 確實出現在下面。不要要求用戶重複它，除非他們提供了空命令。

鑑於該功能描述，請執行以下操作：

1. **為分支產生一個簡潔的短名稱**（2-4 個字）：
   - 分析特徵描述並提取最有意義的關鍵字
   - 建立一個 2-4 個單字的短名稱，以抓住該功能的本質
   - 盡可能使用操作名詞格式（例如「add-user-auth」、「fix- payment-bug」）
   - 保留技術術語和首字母縮略詞（OAuth2、API、JWT 等）
   - 保持簡潔但具有足夠的描述性，以便一目了然地了解該功能
   - 範例：
     - “我想新增用戶身份驗證”→“用戶身份驗證”
     - “為 API 實作 OAuth2 整合”→“oauth2-api-integration”
     - “建立分析儀表板”→“分析儀表板”
     - “修復支付處理超時錯誤”→“修復支付超時”

2. **建立新分支之前檢查現有分支**：

   一個。首先，獲取所有遠端分支以確保我們擁有最新資訊：

      ```bash
      git fetch --all --prune
      ```

   b.找出所有來源中短名稱的最高特徵編號：
      - 遠端分支：`git ls-remote --heads origin | grep -E 'refs/heads/[0-9]+-<short-name>$'`
      - 本地分支：`git分支| grep -E '^[*]*[0-9]+-<short-name>$'`
      - Specs 目錄：檢查符合 `specs/[0-9]+- 的目錄<short-name>`

   c.確定下一個可用號碼：
      - 從所有三個來源提取所有數字
      - 找出最大的數N
      - 使用 N+1 作為新的分支編號

   d.使用計算出的數字和短名稱來執行腳本 `{SCRIPT}`：
      - 傳遞 `--number N+1` 和 `--short-name "your-short-name"` 以及功能描述
      - Bash 例： `{SCRIPT} --json --number 5 --short-name "user-auth" "Add user authentication"`
      - PowerShell 例： `{SCRIPT} -Json -Number 5 -ShortName "user-auth" "Add user authentication"`

   **重要的**：
   - 檢查所有三個來源（遠端分支、本地分支、specs 目錄）以找到最大的數字
   - 僅將分支 /directories 與確切的短名稱模式匹配
   - 如果沒有找到具有此短名稱的現有分支/directories，則從數字 1 開始
   - 每個功能只能執行此腳本一次
   - JSON 在終端中作為輸出提供 - 始終引用它來獲取您要查找的實際內容
   - JSON 輸出將包含 BRANCH_NAME 和 SPEC_FILE 路徑
   - 對於像「I'm Groot」這樣的參數中的單引號，請使用轉義語法：例如'I'\''m Groot'（或如果可能的話使用雙引號：「I'm Groot」）

3. 載入 `templates/spec-template.md` 以了解所需部分。

4. 按照這個執行流程：

    1. 從輸入解析使用者描述
       如果為空：錯誤“未提供功能描述”
    2. 從描述中提取關鍵概念
       辨識：參與者、行動、數據、約束
    3. 對於不清楚的方面：
       - 根據背景和行業標準做出明智的猜測
       - 僅在以下情況下標記為[需要澄清：具體問題]：
         - 此選擇會顯著影響功能範圍或使用者體驗
         - 存在多種合理的解釋，具有不同的含義
         - 不存在合理的違約
       - **限制：總共最多 3 個 [需要澄清] 標記**
       - 依影響力優先澄清：範圍 > 安全/privacy > 使用者體驗 > 技術細節
    4. 填寫使用者場景和測試部分
       如果沒有明確的使用者流程：錯誤“無法確定使用者場景”
    5. 生成功能需求
       每個需求都必須是可測試的
       對未指定的細節使用合理的預設值（假設部分中的文件假設）
    6. 定義成功標準
       創造可衡量的、與科技無關的成果
       包括定量指標（時間、表現、數量）和定性指標（使用者滿意度、任務完成）
       每個標準都必須是可驗證的，無需實施細節
    7. 識別關鍵實體（如果涉及資料）
    8. 返回：成功（規範已準備好進行規劃）

5. 使用模板結構將規範寫入 SPEC_FILE，以從功能描述（參數）派生的具體細節取代佔位符，同時保留部分順序和標題。

6. **規範品質驗證**：編寫初始規範後，依照品質標準進行驗證：

   一個。 **建立規格品質檢查表**：使用具有以下驗證專案的檢查表範本結構在 `FEATURE_DIR/checklists/requirements.md` 產生檢查表檔案：

      ```markdown
      # Specification Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate specification completeness and quality before proceeding to planning
      **Created**: [DATE]
      **Feature**: [Link to spec.md]
      
      ## Content Quality
      
      - [ ] No implementation details (languages, frameworks, APIs)
      - [ ] Focused on user value and business needs
      - [ ] Written for non-technical stakeholders
      - [ ] All mandatory sections completed
      
      ## Requirement Completeness
      
      - [ ] No [NEEDS CLARIFICATION] markers remain
      - [ ] Requirements are testable and unambiguous
      - [ ] Success criteria are measurable
      - [ ] Success criteria are technology-agnostic (no implementation details)
      - [ ] All acceptance scenarios are defined
      - [ ] Edge cases are identified
      - [ ] Scope is clearly bounded
      - [ ] Dependencies and assumptions identified
      
      ## Feature Readiness
      
      - [ ] All functional requirements have clear acceptance criteria
      - [ ] User scenarios cover primary flows
      - [ ] Feature meets measurable outcomes defined in Success Criteria
      - [ ] No implementation details leak into specification
      
      ## Notes
      
      - Items marked incomplete require spec updates before `/speckit.clarify` or `/speckit.plan`
      ```

   b. **執行驗證檢查**：針對每個清單專案檢查規格：
      - 對於每個專案，確定它是通過還是失敗
      - 記錄發現的具體問題（引用相關規範部分）

   c. **處理驗證結果**：

      - **如果所有專案都通過**：將清單標記為已完成並繼續執行步驟 6

      - **如果專案失敗（不包括[需要澄清]）**：
        1. 列出失敗的專案和具體問題
        2. 更新規格以解決每個問題
        3. 重新執行驗證，直到所有專案都通過（最多 3 次迭代）
        4. 如果 3 次迭代後仍然失敗，請在清單註釋中記錄剩餘問題並警告用戶

      - **如果[需要澄清]標記仍然存在**：
        1. 從規範中提取所有 [NEEDS CLARIFICATION: ...] 標記
        2. **限制檢查**：如果存在超過 3 個標記，則僅保留 3 個最關鍵的標記（按範圍 /security/UX 影響）並對其餘標記進行明智的猜測
        3. 對於所需的每項說明（最多 3 個），請按以下格式向使用者提供選項：

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant spec section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the feature] |
           | B      | [Second suggested answer] | [What this means for the feature] |
           | C      | [Third suggested answer] | [What this means for the feature] |
           | Custom | Provide your own answer | [Explain how to provide custom input] |
           
           **Your choice**: _[Wait for user response]_
           ```

        4. **關鍵 - 表格格式**：確保降價表格格式正確：
           - 使用一致的間距並對齊管道
           - 每個單元格內容周圍應有空格： `| Content |` 而非 `|Content|`
           - 標頭分隔符號必須至少有 3 個破折號：`|--------|`
           - 測驗表格在 Markdown 預覽中是否正確呈現
        5. 依序為問題編號（Q1、Q2、Q3 - 最多 3 個）
        6. 在等待答覆之前將所有問題一起提出
        7. 等待使用者回答所有問題的選擇（例如“Q1：A，Q2：自訂 - [詳細資訊]，Q3：B”）
        8. 透過以使用者選擇或提供的答案取代每個 [NEEDS CLARIFICATION] 標記來更新規範
        9. 解決所有問題後重新執行驗證

   d. **更新檢查表**：每次驗證迭代後，使用當前 pass/fail 狀態更新檢查表文件

7. 報告完成情況，包括分支名稱、規範文件路徑、清單結果以及下一階段的準備情況（`/speckit.clarify` 或 `/speckit.plan`）。

**注意：** 此腳本建立並簽出新分支，並在寫入之前初始化規格文件。

## 一般準則

## 快速指南

- 關注**用戶需要什麼**以及**為什麼**。
- 避免如何實作（沒有技術堆疊、APIs、程式碼結構）。
- 為業務利害關係人而不是開發人員編寫。
- 不要建立嵌入在規範中的任何清單。這將是一個單獨的命令。

### 部分要求

- **必填部分**：每個功能都必須完成
- **可選部分**：僅在與功能相關時包含
- 當某個部分不適用時，將其完全刪除（不要保留為“N/A"”）

### 對於 AI 一代

從使用者提示建立此規格時：

1. **做出明智的猜測**：使用背景、行業標準和常見模式來填補空白
2. **記錄假設**：在假設部分記錄合理的預設值
3. **限制澄清**：最多 3 個 [需要澄清] 標記 - 僅用於以下關鍵決策：
   - 顯著影響功能範圍或使用者體驗
   - 有多種合理的解釋，具有不同的意義
   - 缺乏任何合理的違約
4. **優先澄清**：範圍 > 安全性/privacy > 使用者體驗 > 技術細節
5. **像測試人員一樣思考**：每個模糊的要求都應該失敗「可測試且明確」清單項
6. **需要澄清的公共區域**（僅當不存在合理預設值時）：
   - 功能範圍和邊界（包括/exclude特定用例）
   - 使用者類型和權限（如果可能有多種相互衝突的解釋）
   - 安全/compliance 要求（在法律上/financially 重要時）

**合理預設值的範例**（不要詢問這些）：

- 資料保留：該領域的行業標準實踐
- 效能目標：標準 web/mobile 應用程式期望（除非另有說明）
- 錯誤處理：具有適當後備功能的使用者友善訊息
- 驗證方法：基於標準會話或適用於 Web 應用程式的 OAuth2
- 整合模式：使用適合專案的模式（用於 Web 服務的 REST/GraphQL、用於函式函式庫的函式呼叫、用於工具的 CLI 參數等）

### 成功標準指南

成功的標準必須是：

1. **可衡量**：包含具體指標（時間、百分比、計數、比率）
2. **與技術無關**：沒有提及框架、語言、資料函式庫或工具
3. **以使用者為中心**：從使用者/business角度描述結果，而不是系統內部
4. **可驗證**：可以在不知道實作細節的情況下進行測試/validated

**好例子**：

- “用戶可以在3分鐘內完成結帳”
- “系統支援10000個並髮用戶”
- “95% 的搜尋會在 1 秒內傳回結果”
- “任務完成率提高40%”

**不好的例子**（以實現為重點）：

- 「API 回應時間低於 200 毫秒」（技術性太強，請使用「使用者立即看到結果」）
- 「資料函式庫可以處理 1000 TPS」（實作細節，使用使用者導向的指標）
- 「React 元件高效渲染」（特定於框架）
- 《Redis快取命中率80%以上》（技術專用）
