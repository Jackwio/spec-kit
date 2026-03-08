# 實施計劃：[特點]

**分行**： `[###-feature-name]` | **日期**：[日期] | **規格**：[連結]
**輸入**：來自 `/specs/[###-feature-name]/spec.md` 的功能規範

**注意**：此模板由 `/speckit.plan` 指令填寫。請參閱 `.specify/templates/plan-template.md` 以了解執行工作流程。

## 概括

[功能規範摘錄：主要要求+研究的技術方法]

## 技術背景

<!--
  需要採取的行動：用技術細節取代本節的內容
  對於該專案。這裡的結構是以顧問的身份提出的，以指導
  迭代過程。
-->

**語言/Version**: [例如，Python 3.11、Swift 5.9、Rust 1.75 或需要澄清]  
**主要依賴項**：[例如 FastAPI、UIKit、LLVM 或需要澄清]  
**儲存**：[如果適用，例如 PostgreSQL、CoreData、檔案或 N/A]  
**測試**：[例如 pytest、XCTest、貨物測試或需要澄清]  
**目標平台**：[例如，Linux 伺服器、iOS 15+、WASM 或需要澄清]
**專案類型**：[例如，函式庫/cli/web-service/mobile-app/compiler/desktop-app 或需要澄清]  
**效能目標**：[特定領域，例如 1000 條請求/s、10k 行/sec、60 fps 或需要澄清]  
**限制**：[特定領域，例如，<200ms p95、<100MB 記憶體、離線功能或需要澄清]  
**規模/Scope**: [特定領域，例如 10k 用戶、1M LOC、50 個螢幕或需要澄清]

## 體質檢查

*GATE：必須在第 0 階段研究前通過。第一階段設計後重新檢查。 *

[根據憲法文件確定的大門]

## 專案結構

### 文件（此功能）

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### 原始碼（儲存庫根）
<!--
  所需操作：用具體佈局取代下面的佔位符樹
  對於這個功能。刪除未使用的選項並擴展所選結構
  真實路徑（例如，apps/admin、packages/something）。交付的計劃必須
  不包括選項標籤。
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**結構決策**：[記錄所選結構並參考真實的結構
上面捕獲的目錄]

## 複雜性追蹤

> **僅當憲法檢查存在必須證明合理的違規行為時才填寫**

| 違反 | 為什麼需要 | 更簡單的替代方案被拒絕，因為 |
|-----------|------------|-------------------------------------|
| [例如，第四個專案] | [當前需求] | 【為什麼3個專案不足】 |
| [例如，儲存庫模式] | [具體問題] | [為什麼直接DB存取不夠] |
