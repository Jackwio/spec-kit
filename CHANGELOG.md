# 變更日誌

<!-- markdownlint-disable MD024 -->

此處記錄了最近對 Specify CLI 和範本的變更。

格式基於 [保留變更日誌](https://keepachangelog.com/en/1.0.0/)，
且該專案遵循 [語意版本控制](https://semver.org/spec/v2.0.0.html)。

## [0.1.6] - 2026-02-23

### 固定的

- **參數排序問題 (#1641)**：修正了 CLI 參數解析問題，其中選項標誌被錯誤地用作前面選項的值
  - 新增了驗證以偵測 `--ai` 或 `--ai-commands-dir` 何時錯誤地消耗以下標誌，例如 `--here` 或 `--ai-skills`
  - 現在提供清晰的錯誤訊息：“--ai 的值無效：'--here'”
  - 包括建議正確使用和列出可用代理的有用提示
  - 像 `specify init --ai-skills --ai --here` 這樣的命令現在會失敗並提供可操作的回饋，而不是令人困惑的「必須指定專案名稱」錯誤
  - 添加了全面的測試套件（5 個新測試）以防止回歸

## [0.1.5] - 2026-02-21

### 固定的

- **AI 技能安裝錯誤 (#1658)**：修正了 `--ai-skills` 標誌不為 GitHub Copilot 和其他具有非標準命令目錄結構的代理生成技能文件
  - 將 `commands_subdir` 欄位新增至 `AGENT_CONFIG` 以明確指定每個代理程式的子目錄名稱
  - 受影響的代理現在可以正常工作：副駕駛 (`.github/agents/`)、opencode (`.opencode/command/`)、windsurf (`.windsurf/workflows/`)、codex (`.codex/prompts/`)、kilocode (`.kilocode/workflows/`)、q (`.amazonq/prompts/`) 和 agy (`.agent/workflows/`)
  - `install_ai_skills()` 函數現在為所有代理人使用正確的路徑，而不是為每個人假設 `commands/`

## [0.1.4] - 2026-02-20

### 固定的

- **Qoder CLI 偵測**：將 `AGENT_CONFIG` 鍵從 `"qoder"` 重新命名為 `"qodercli"` 以符合實際的可執行檔名稱，修正 `specify check` 和 `specify init --ai` 偵測失敗

## [0.1.3] - 2026-02-20

### 額外

- **通用代理支援**：為不支援的 AI 代理程式新增了 `--ai generic` 選項（「自帶代理」）
  - 需要`--ai-commands-dir <path>` 指定代理程式從何處讀取命令
  - 產生 Markdown 格式為 `$ARGUMENTS` 的指令（與大多數代理程式相容）
  - 例：`specify init my-project --ai generic --ai-commands-dir .myagent/commands/`
  - 使用戶能夠在代理等待正式支援時立即開始使用 Spec Kit

## [0.0.102] - 2026-02-20

- 修正：在發布工作流程觸發器中包含 'src/**' 路徑 (#1646)

## [0.0.101] - 2026-02-19

- 雜務(deps)：將 github/codeql-action 從 3 提升到 4 (#1635)

## [0.0.100] - 2026-02-19

- 將 pytest 和 Python linting (ruff) 加入 CI (#1637)
- 壯舉：新增拉取請求範本以獲得更好的貢獻指南（#1634）

## [0.0.99] - 2026-02-19

- 壯舉/ai 技能 (#1632)

## [0.0.98] - 2026-02-19

- 雜務（deps）：將動作/stale從9增加到10（#1623）
- feat：為 pip 和 GitHub Actions 更新新增 dependentabot 設定 (#1622)

## [0.0.97] - 2026-02-18

- 從 README.md 中刪除維護者部分 (#1618)

## [0.0.96] - 2026-02-17

- 修復：plan-template.md 中的拼字錯誤 (#1446)

## [0.0.95] - 2026-02-12

- 壯舉：新增代理：Google Anti Gravity (#1220)

## [0.0.94] - 2026-02-11

- 為 180 天不活動的問題和 PR 添加過時的工作流程 (#1594)
