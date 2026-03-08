---
描述：根據可用的設計工件，將現有任務轉換為可操作的、按依賴性排序的 GitHub 功能問題。
工具：['github/github-mcp-server/issue_write']
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
1. 從執行的腳本中，提取 **tasks** 的路徑。
1. 透過執行以下命令來取得 Git 遠端：

```bash
git config --get remote.origin.url
```

> [！警告]
> 只有當遙控器是 GITHUB URL 時才繼續執行後續步驟

1. 對於清單中的每個任務，使用 GitHub MCP 伺服器在代表 Git 遠端的儲存庫中建立一個新問題。

> [！警告]
> 在任何情況下都不會在與遠端 URL 不符的儲存庫中產生問題
