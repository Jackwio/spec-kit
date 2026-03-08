# RFC：Spec Kit 擴充系統

**狀態**：草案
**作者**：Stats Perform Engineering
**建立**：2026-01-28
**更新**：2026-01-28

---

## 目錄

1. [概括](#概括)
2. [動機](#動機)
3. [設計原則](#設計原則)
4. [架構概述](#架構概述)
5. [擴充清單規範](#擴充清單規範)
6. [延長生命週期](#延長生命週期)
7. [命令註冊](#命令註冊)
8. [設定管理](#設定管理)
9. [掛鉤系統](#掛鉤系統)
10. [擴展發現和目錄](#擴展發現和目錄)
11. [CLI 指令](#cli-指令)
12. [相容性和版本控制](#相容性和版本控制)
13. [安全考慮](#安全考慮)
14. [遷移策略](#遷移策略)
15. [實施階段](#實施階段)
16. [開放式問題](#開放式問題)
17. [附錄](#附錄)

---

## 概括

向 Spec Kit 引入擴展系統，允許與外部工具（Jira、Linear、Azure DevOps 等）進行模組化集成，而不會導致核心框架膨脹。擴充功能是安裝到 `.specify/extensions/` 的獨立包，具有聲明性清單，獨立版本控制，並且可以透過中央目錄發現。

---

## 動機

### 目前的問題

1. **整體成長**：將 Jira 整合加入核心規格套件會建立：
   - 影響所有用戶的大型設定文件
   - 每個人都依賴 Jira MCP 伺服器
   - 隨著功能的累積合併衝突

2. **靈活性有限**：不同的組織使用不同的工具：
   - GitHub 問題 vs Jira vs Linear vs Azure DevOps
   - 自訂內部工具
   - 沒有辦法在不臃腫的情況下支持所有內容

3. **維護負擔**：每次整合都會增加：
   - 文件複雜性
   - 測試矩陣擴展
   - 表面積發生重大變化

4. **社群摩擦**：如果沒有核心儲存庫 PR 批准和發布週期，外部貢獻者無法輕鬆新增整合。

### 目標

1. **模組化**：核心規格套件保持精簡，擴充可供選擇
2. **可擴展性**：清除 API 以建立新的集成
3. **獨立**：擴充版本/release 與核心分開
4. **可發現性**：用於尋找擴充功能的中央目錄
5. **安全性**：驗證、相容性檢查、沙箱

---

## 設計原則

### 1.約定優於設定

- 標準目錄結構 (`.specify/extensions/{name}/`)
- 聲明性清單 (`extension.yml`)
- 可預測的指令命名 (`speckit.{extension}.{command}`)

### 2. 故障安全預設設定

- 丟失的擴展會優雅地降級（跳過鉤子）
- 無效擴充會發出警告，但不會破壞核心功能
- 與核心操作隔離的擴充故障

### 3. 向後相容性

- 核心命令保持不變
- 僅附加擴充（無核心修改）
- 舊專案無需擴展即可執行

### 4. 開發者經驗

- 安裝簡單：`specify extension add jira`
- 清除相容性問題的錯誤訊息
- 用於測試擴充功能的本機開發模式

### 5. 安全第一

- 擴展在與 AI 代理相同的上下文中執行（信任邊界）
- 清單驗證可防止惡意程式碼
- 驗證官方擴充的簽名（未來）

---

## 架構概述

### 目錄結構

```text
project/
├── .specify/
│   ├── scripts/                 # Core scripts (unchanged)
│   ├── templates/               # Core templates (unchanged)
│   ├── memory/                  # Session memory
│   ├── extensions/              # Extensions directory (NEW)
│   │   ├── .registry            # Installed extensions metadata (NEW)
│   │   ├── jira/                # Jira extension
│   │   │   ├── extension.yml    # Manifest
│   │   │   ├── jira-config.yml  # Extension config
│   │   │   ├── commands/        # Command files
│   │   │   ├── scripts/         # Helper scripts
│   │   │   └── docs/            # Documentation
│   │   └── linear/              # Linear extension (example)
│   └── extensions.yml           # Project extension configuration (NEW)
└── .gitignore                   # Ignore local extension configs
```

### 元件圖

```text
┌─────────────────────────────────────────────────────────┐
│                    Spec Kit Core                        │
│  ┌──────────────────────────────────────────────────┐   │
│  │  CLI (specify)                                   │   │
│  │  - init, check                                   │   │
│  │  - extension add/remove/list/update  ← NEW       │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Extension Manager  ← NEW                        │   │
│  │  - Discovery, Installation, Validation           │   │
│  │  - Command Registration, Hook Execution          │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Core Commands                                   │   │
│  │  - /speckit.specify                              │   │
│  │  - /speckit.tasks                                │   │
│  │  - /speckit.implement                            │   │
│  └─────────┬────────────────────────────────────────┘   │
└────────────┼────────────────────────────────────────────┘
             │ Hook Points (after_tasks, after_implement)
             ↓
┌─────────────────────────────────────────────────────────┐
│                    Extensions                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Jira Extension                                  │   │
│  │  - /speckit.jira.specstoissues                   │   │
│  │  - /speckit.jira.discover-fields                 │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Linear Extension                                │   │
│  │  - /speckit.linear.sync                          │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
             │ Calls external tools
             ↓
┌─────────────────────────────────────────────────────────┐
│                    External Tools                       │
│  - Jira MCP Server                                      │
│  - Linear API                                           │
│  - GitHub API                                           │
└─────────────────────────────────────────────────────────┘
```

---

## 擴充清單規範

### 架構：`extension.yml`

```yaml
# Extension Manifest Schema v1.0
# All extensions MUST include this file at root

# Schema version for compatibility
schema_version: "1.0"

# Extension metadata (REQUIRED)
extension:
  id: "jira"                    # Unique identifier (lowercase, alphanumeric, hyphens)
  name: "Jira Integration"      # Human-readable name
  version: "1.0.0"              # Semantic version
  description: "Create Jira Epics, Stories, and Issues from spec-kit artifacts"
  author: "Stats Perform"       # Author/organization
  repository: "https://github.com/statsperform/spec-kit-jira"
  license: "MIT"                # SPDX license identifier
  homepage: "https://github.com/statsperform/spec-kit-jira/blob/main/README.md"

# Compatibility requirements (REQUIRED)
requires:
  # Spec-kit version (semantic version range)
  speckit_version: ">=0.1.0,<2.0.0"

  # External tools required by extension
  tools:
    - name: "jira-mcp-server"
      required: true
      version: ">=1.0.0"          # Optional: version constraint
      description: "Jira MCP server for API access"
      install_url: "https://github.com/your-org/jira-mcp-server"
      check_command: "jira --version"  # Optional: CLI command to verify

  # Core spec-kit commands this extension depends on
  commands:
    - "speckit.tasks"             # Extension needs tasks command

  # Core scripts required
  scripts:
    - "check-prerequisites.sh"

# What this extension provides (REQUIRED)
provides:
  # Commands added to AI agent
  commands:
    - name: "speckit.jira.specstoissues"
      file: "commands/specstoissues.md"
      description: "Create Jira hierarchy from spec and tasks"
      aliases: ["speckit.specstoissues"]  # Alternate names

    - name: "speckit.jira.discover-fields"
      file: "commands/discover-fields.md"
      description: "Discover Jira custom fields for configuration"

    - name: "speckit.jira.sync-status"
      file: "commands/sync-status.md"
      description: "Sync task completion status to Jira"

  # Configuration files
  config:
    - name: "jira-config.yml"
      template: "jira-config.template.yml"
      description: "Jira integration configuration"
      required: true              # User must configure before use

  # Helper scripts
  scripts:
    - name: "parse-jira-config.sh"
      file: "scripts/parse-jira-config.sh"
      description: "Parse jira-config.yml to JSON"
      executable: true            # Make executable on install

# Extension configuration defaults (OPTIONAL)
defaults:
  project:
    key: null                     # No default, user must configure
  hierarchy:
    issue_type: "subtask"
  update_behavior:
    mode: "update"
    sync_completion: true

# Configuration schema for validation (OPTIONAL)
config_schema:
  type: "object"
  required: ["project"]
  properties:
    project:
      type: "object"
      required: ["key"]
      properties:
        key:
          type: "string"
          pattern: "^[A-Z]{2,10}$"
          description: "Jira project key (e.g., MSATS)"

# Integration hooks (OPTIONAL)
hooks:
  # Hook fired after /speckit.tasks completes
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    prompt: "Create Jira issues from tasks?"
    description: "Automatically create Jira hierarchy after task generation"

  # Hook fired after /speckit.implement completes
  after_implement:
    command: "speckit.jira.sync-status"
    optional: true
    prompt: "Sync completion status to Jira?"

# Tags for discovery (OPTIONAL)
tags:
  - "issue-tracking"
  - "jira"
  - "atlassian"
  - "project-management"

# Changelog URL (OPTIONAL)
changelog: "https://github.com/statsperform/spec-kit-jira/blob/main/CHANGELOG.md"

# Support information (OPTIONAL)
support:
  documentation: "https://github.com/statsperform/spec-kit-jira/blob/main/docs/"
  issues: "https://github.com/statsperform/spec-kit-jira/issues"
  discussions: "https://github.com/statsperform/spec-kit-jira/discussions"
  email: "support@statsperform.com"
```

### 驗證規則

1. **必有** `schema_version`、`extension`、`requires`、`provides`
2. **必須遵循** `version` 的語意版本控制
3. **必須有**唯一的 `id` （不與其他副檔名衝突）
4. **必須聲明**所有外部工具依賴項
5. **如果擴充使用設定，則應包含** `config_schema`
6. **應包括** `support` 訊息
7. 指令 `file` 路徑 **必須** 相對於擴充根目錄
8. 掛鉤 `command` 名稱 **必須符合** `provides.commands` 中的指令

---

## 延長生命週期

### 1. 發現

```bash
specify extension search jira
# Searches catalog for extensions matching "jira"
```

**過程：**

1. 從 GitHub 取得擴充目錄
2. 依搜尋字詞過濾（名稱、標籤、描述）
3. 顯示帶有元資料的結果

### 2. 安裝

```bash
specify extension add jira
```

**過程：**

1. **解決**：在目錄中尋找擴展名
2. **下載**：取得擴充包（來自 GitHub 版本的 ZIP）
3. **驗證**：檢查清單架構、相容性
4. **提取**：解壓縮到 `.specify/extensions/jira/`
5. **設定**：複製設定模板
6. **註冊**：將指令新增至 AI 代理程式設定
7. **記錄**：更新 `.specify/extensions/.registry`

**註冊表格式** (`.specify/extensions/.registry`)：

```json
{
  "schema_version": "1.0",
  "extensions": {
    "jira": {
      "version": "1.0.0",
      "installed_at": "2026-01-28T14:30:00Z",
      "source": "catalog",
      "manifest_hash": "sha256:abc123...",
      "enabled": true
    }
  }
}
```

### 3. 設定

```bash
# User edits extension config
vim .specify/extensions/jira/jira-config.yml
```

**設定發現順序：**

1. 擴充預設值 (`extension.yml` → `defaults`)
2. 專案設定 (`jira-config.yml`)
3. 本地覆蓋（`jira-config.local.yml` - gitignored）
4. 環境變數 (`SPECKIT_JIRA_*`)

### 4. 使用方法

```bash
claude
> /speckit.jira.specstoissues
```

**命令解析度：**

1. AI 代理在 `.claude/commands/speckit.jira.specstoissues.md` 找到指令
2. 指令檔引用擴充腳本/config
3. 擴充在完整上下文中執行

### 5. 更新

```bash
specify extension update jira
```

**過程：**

1. 檢查目錄以取得新版本
2. 下載新版本
3. 驗證相容性
4. 備份當前設定
5. 提取新版本（保留設定）
6. 重新註冊命令
7. 更新註冊表

### 6. 拆除

```bash
specify extension remove jira
```

**過程：**

1. 與用戶確認（顯示將刪除的內容）
2. 從 AI 代理取消註冊命令
3. 從 `.specify/extensions/jira/` 刪除
4. 更新註冊表
5. 可以選擇保留設定以便重新安裝

---

## 命令註冊

### 每個代理註冊

擴充功能提供**通用命令格式**（基於 Markdown），並且 CLI 在註冊期間轉換為特定於代理的格式。

#### 通用命令格式

**位置**：分機號碼 `commands/specstoissues.md`

```markdown
---
# Universal metadata (parsed by all agents)
description: "Create Jira hierarchy from spec and tasks"
tools:
  - 'jira-mcp-server/epic_create'
  - 'jira-mcp-server/story_create'
scripts:
  sh: ../../scripts/bash/check-prerequisites.sh --json
  ps: ../../scripts/powershell/check-prerequisites.ps1 -Json
---

# Command implementation
## User Input
$ARGUMENTS

## Steps
1. Load jira-config.yml
2. Parse spec.md and tasks.md
3. Create Jira items
```

#### Claude Code 註冊

**輸出**：`.claude/commands/speckit.jira.specstoissues.md`

```markdown
---
description: "Create Jira hierarchy from spec and tasks"
tools:
  - 'jira-mcp-server/epic_create'
  - 'jira-mcp-server/story_create'
scripts:
  sh: .specify/scripts/bash/check-prerequisites.sh --json
  ps: .specify/scripts/powershell/check-prerequisites.ps1 -Json
---

# Command implementation (copied from extension)
## User Input
$ARGUMENTS

## Steps
1. Load jira-config.yml from .specify/extensions/jira/
2. Parse spec.md and tasks.md
3. Create Jira items
```

**轉變：**

- 複製前言並進行調整
- 重寫腳本路徑（相對於倉函式庫根目錄）
- 新增擴充上下文（設定位置）

#### Gemini CLI 註冊

**輸出**：`.gemini/commands/speckit.jira.specstoissues.toml`

```toml
[command]
name = "speckit.jira.specstoissues"
description = "Create Jira hierarchy from spec and tasks"

[command.tools]
tools = [
  "jira-mcp-server/epic_create",
  "jira-mcp-server/story_create"
]

[command.script]
sh = ".specify/scripts/bash/check-prerequisites.sh --json"
ps = ".specify/scripts/powershell/check-prerequisites.ps1 -Json"

[command.template]
content = """
# Command implementation
## User Input
{{args}}

## Steps
1. Load jira-config.yml from .specify/extensions/jira/
2. Parse spec.md and tasks.md
3. Create Jira items
"""
```

**轉變：**

- 將 Markdown frontmatter 轉換為 TOML
- 將 `$ARGUMENTS` 轉換為 `{{args}}`
- 重寫腳本路徑

### 註冊碼

**地點**：`src/specify_cli/extensions.py`

```python
def register_extension_commands(
    project_path: Path,
    ai_assistant: str,
    manifest: dict
) -> None:
    """Register extension commands with AI agent."""

    agent_config = AGENT_CONFIG.get(ai_assistant)
    if not agent_config:
        console.print(f"[yellow]Unknown agent: {ai_assistant}[/yellow]")
        return

    ext_id = manifest['extension']['id']
    ext_dir = project_path / ".specify" / "extensions" / ext_id
    agent_commands_dir = project_path / agent_config['folder'].rstrip('/') / "commands"
    agent_commands_dir.mkdir(parents=True, exist_ok=True)

    for cmd_info in manifest['provides']['commands']:
        cmd_name = cmd_info['name']
        source_file = ext_dir / cmd_info['file']

        if not source_file.exists():
            console.print(f"[red]Command file not found:[/red] {cmd_info['file']}")
            continue

        # Convert to agent-specific format
        if ai_assistant == "claude":
            dest_file = agent_commands_dir / f"{cmd_name}.md"
            convert_to_claude(source_file, dest_file, ext_dir)
        elif ai_assistant == "gemini":
            dest_file = agent_commands_dir / f"{cmd_name}.toml"
            convert_to_gemini(source_file, dest_file, ext_dir)
        elif ai_assistant == "copilot":
            dest_file = agent_commands_dir / f"{cmd_name}.md"
            convert_to_copilot(source_file, dest_file, ext_dir)
        # ... other agents

        console.print(f"  ✓ Registered: {cmd_name}")

def convert_to_claude(
    source: Path,
    dest: Path,
    ext_dir: Path
) -> None:
    """Convert universal command to Claude format."""

    # Parse universal command
    content = source.read_text()
    frontmatter, body = parse_frontmatter(content)

    # Adjust script paths (relative to repo root)
    if 'scripts' in frontmatter:
        for key in frontmatter['scripts']:
            frontmatter['scripts'][key] = adjust_path_for_repo_root(
                frontmatter['scripts'][key]
            )

    # Inject extension context
    body = inject_extension_context(body, ext_dir)

    # Write Claude command
    dest.write_text(render_frontmatter(frontmatter) + "\n" + body)
```

---

## 設定管理

### 設定檔層次結構

```yaml
# .specify/extensions/jira/jira-config.yml (Project config)
project:
  key: "MSATS"

hierarchy:
  issue_type: "subtask"

defaults:
  epic:
    labels: ["spec-driven", "typescript"]
```

```yaml
# .specify/extensions/jira/jira-config.local.yml (Local overrides - gitignored)
project:
  key: "MYTEST"  # Override for local testing
```

```bash
# Environment variables (highest precedence)
export SPECKIT_JIRA_PROJECT_KEY="DEVTEST"
```

### 設定載入功能

**位置**：擴充指令（例如 `commands/specstoissues.md`）

````markdown
## Load Configuration

1. Run helper script to load and merge config:

```bash
config_json=$(bash .specify/extensions/jira/scripts/parse-jira-config.sh)
echo "$config_json"
```

1. Parse JSON and use in subsequent steps
````

**Script**: `.specify/extensions/jira/scripts/parse-jira-config.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

EXT_DIR=".specify/extensions/jira"
CONFIG_FILE="$EXT_DIR/jira-config.yml"
LOCAL_CONFIG="$EXT_DIR/jira-config.local.yml"

# Start with defaults from extension.yml
defaults=$(yq eval '.defaults' "$EXT_DIR/extension.yml" -o=json)

# Merge project config
if [ -f "$CONFIG_FILE" ]; then
  project_config=$(yq eval '.' "$CONFIG_FILE" -o=json)
  defaults=$(echo "$defaults $project_config" | jq -s '.[0] * .[1]')
fi

# Merge local config
if [ -f "$LOCAL_CONFIG" ]; then
  local_config=$(yq eval '.' "$LOCAL_CONFIG" -o=json)
  defaults=$(echo "$defaults $local_config" | jq -s '.[0] * .[1]')
fi

# Apply environment variable overrides
if [ -n "${SPECKIT_JIRA_PROJECT_KEY:-}" ]; then
  defaults=$(echo "$defaults" | jq ".project.key = \"$SPECKIT_JIRA_PROJECT_KEY\"")
fi

# Output merged config as JSON
echo "$defaults"
```

### 設定驗證

**在命令檔**：

````markdown
## Validate Configuration

1. Load config (from previous step)
2. Validate against schema from extension.yml:

```python
import jsonschema

schema = load_yaml(".specify/extensions/jira/extension.yml")['config_schema']
config = json.loads(config_json)

try:
    jsonschema.validate(config, schema)
except jsonschema.ValidationError as e:
    print(f"❌ Invalid jira-config.yml: {e.message}")
    print(f"   Path: {'.'.join(str(p) for p in e.path)}")
    exit(1)
```

1. Proceed with validated config
````

---

## Hook System

### Hook Definition

**In extension.yml:**

```yaml
hooks:
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    prompt: "Create Jira issues from tasks?"
    description: "Automatically create Jira hierarchy"
    condition: "config.project.key is set"
```

### 掛鉤註冊

**在擴充安裝過程中**，在專案設定中記錄鉤子：

**檔案**：`.specify/extensions.yml`（專案級擴充設定）

```yaml
# Extensions installed in this project
installed:
  - jira
  - linear

# Global extension settings
settings:
  auto_execute_hooks: true  # Prompt for optional hooks after commands

# Hook configuration
hooks:
  after_tasks:
    - extension: jira
      command: speckit.jira.specstoissues
      enabled: true
      optional: true
      prompt: "Create Jira issues from tasks?"

  after_implement:
    - extension: jira
      command: speckit.jira.sync-status
      enabled: true
      optional: true
      prompt: "Sync completion status to Jira?"
```

### 鉤子執行

**在核心指令中**（例如，`templates/commands/tasks.md`）：

在命令末尾添加：

````markdown
## Extension Hooks

After task generation completes, check for registered hooks:

```bash
# Check if extensions.yml exists and has after_tasks hooks
if [ -f ".specify/extensions.yml" ]; then
  # Parse hooks for after_tasks
  hooks=$(yq eval '.hooks.after_tasks[] | select(.enabled == true)' .specify/extensions.yml -o=json)

  if [ -n "$hooks" ]; then
    echo ""
    echo "📦 Extension hooks available:"

    # Iterate hooks
    echo "$hooks" | jq -c '.' | while read -r hook; do
      extension=$(echo "$hook" | jq -r '.extension')
      command=$(echo "$hook" | jq -r '.command')
      optional=$(echo "$hook" | jq -r '.optional')
      prompt_text=$(echo "$hook" | jq -r '.prompt')

      if [ "$optional" = "true" ]; then
        # Prompt user
        echo ""
        read -p "$prompt_text (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          echo "▶ Executing: $command"
          # Let AI agent execute the command
          # (AI agent will see this and execute)
          echo "EXECUTE_COMMAND: $command"
        fi
      else
        # Auto-execute mandatory hooks
        echo "▶ Executing: $command (required)"
        echo "EXECUTE_COMMAND: $command"
      fi
    done
  fi
fi
```
````

**AI Agent Handling:**

The AI agent sees `EXECUTE_COMMAND: speckit.jira.specstoissues` in output and automatically invokes that command.

**Alternative**: Direct call in agent context (if agent supports it):

```python
# In AI agent's command execution engine
def execute_command_with_hooks(command_name: str, args: str):
    # Execute main command
    result = execute_command(command_name, args)

    # Check for hooks
    hooks = load_hooks_for_phase(f"after_{command_name}")
    for hook in hooks:
        if hook.optional:
            if confirm(hook.prompt):
                execute_command(hook.command, args)
        else:
            execute_command(hook.command, args)

    return result
```

### 掛鉤條件

擴充可以為鉤子指定**條件**：

```yaml
hooks:
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    condition: "config.project.key is set and config.enabled == true"
```

**條件評估**（在鉤子執行器中）：

```python
def should_execute_hook(hook: dict, config: dict) -> bool:
    """Evaluate hook condition."""
    condition = hook.get('condition')
    if not condition:
        return True  # No condition = always eligible

    # Simple expression evaluator
    # "config.project.key is set" → check if config['project']['key'] exists
    # "config.enabled == true" → check if config['enabled'] is True

    return eval_condition(condition, config)
```

---

## 擴展發現和目錄

### 雙目錄系統

Spec Kit 使用兩個不同用途的目錄檔案：

#### 使用者目錄 (`catalog.json`)

**網址**： `https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.json`

- **目的**：組織批准的擴展的精選目錄
- **預設狀態**：設計為空 - 使用者使用他們信任的擴充功能進行填充
- **用法**： `specify extension` CLI 指令使用的預設目錄
- **控制**：組織為其團隊維護自己的分叉/version

#### 社區參考目錄 (`catalog.community.json`)

**網址**： `https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json`

- **目的**：可用社區貢獻的擴展的參考目錄
- **驗證**：社區擴展最初可能有 `verified: false`
- **狀態**：活躍 - 開放供社區貢獻
- **提交**：按照擴充發布指南透過 Pull Request
- **用法**：瀏覽以發現擴展，然後複製到您的 `catalog.json`

**它是如何工作的：**

1. **發現**：瀏覽 `catalog.community.json` 以查找可用的擴展
2. **審查**：評估擴展的安全性、品質和組織適應性
3. **規劃**：將批准的​​擴展條目從社區目錄複製到您的 `catalog.json`
4. **安裝**：使用`指定擴充功能添加 <name>`（從您策劃的目錄中提取）

這種方法使組織能夠完全控制其團隊可以使用哪些擴展，同時維護共享的社區資源以供發現。

### 目錄格式

**格式**（兩個目錄相同）：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-01-28T14:30:00Z",
  "extensions": {
    "jira": {
      "name": "Jira Integration",
      "id": "jira",
      "description": "Create Jira Epics, Stories, and Issues from spec-kit artifacts",
      "author": "Stats Perform",
      "version": "1.0.0",
      "download_url": "https://github.com/statsperform/spec-kit-jira/releases/download/v1.0.0/spec-kit-jira-1.0.0.zip",
      "repository": "https://github.com/statsperform/spec-kit-jira",
      "homepage": "https://github.com/statsperform/spec-kit-jira/blob/main/README.md",
      "documentation": "https://github.com/statsperform/spec-kit-jira/blob/main/docs/",
      "changelog": "https://github.com/statsperform/spec-kit-jira/blob/main/CHANGELOG.md",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0,<2.0.0",
        "tools": [
          {
            "name": "jira-mcp-server",
            "version": ">=1.0.0"
          }
        ]
      },
      "tags": ["issue-tracking", "jira", "atlassian", "project-management"],
      "verified": true,
      "downloads": 1250,
      "stars": 45
    },
    "linear": {
      "name": "Linear Integration",
      "id": "linear",
      "description": "Sync spec-kit tasks with Linear issues",
      "author": "Community",
      "version": "0.9.0",
      "download_url": "https://github.com/example/spec-kit-linear/releases/download/v0.9.0/spec-kit-linear-0.9.0.zip",
      "repository": "https://github.com/example/spec-kit-linear",
      "requires": {
        "speckit_version": ">=0.1.0"
      },
      "tags": ["issue-tracking", "linear"],
      "verified": false
    }
  }
}
```

### 目錄發現指令

```bash
# List all available extensions
specify extension search

# Search by keyword
specify extension search jira

# Search by tag
specify extension search --tag issue-tracking

# Show extension details
specify extension info jira
```

### 客製化目錄

**⚠️ 未來功能 - 尚未實現**

以下目錄管理指令是建議的設計概念，但在目前實作中尚不可用：

```bash
# Add custom catalog (FUTURE - NOT AVAILABLE)
specify extension add-catalog https://internal.company.com/spec-kit/catalog.json

# Set as default (FUTURE - NOT AVAILABLE)
specify extension set-catalog --default https://internal.company.com/spec-kit/catalog.json

# List catalogs (FUTURE - NOT AVAILABLE)
specify extension catalogs
```

**建議的目錄優先順序**（未來設計）：

1. 專案特定目錄 (`.specify/extension-catalogs.yml`) - *未實施*
2. 使用者級目錄 (`~/.specify/extension-catalogs.yml`) - *未實現*
3. 預設 GitHub 目錄

#### 目前實作：SPECKIT_CATALOG_URL

**目前可用的使用自訂目錄的方法**是 `SPECKIT_CATALOG_URL` 環境變數：

```bash
# Point to your organization's catalog
export SPECKIT_CATALOG_URL="https://internal.company.com/spec-kit/catalog.json"

# All extension commands now use your custom catalog
specify extension search       # Uses custom catalog
specify extension add jira     # Installs from custom catalog
```

**要求：**
- URL 必須使用 HTTPS（HTTP 僅允許用於本機主機測試）
- 目錄必須遵循標準catalog.json架構
- 必須可公開存取或在您的網路內可訪問

**測試範例：**
```bash
# Test with localhost during development
export SPECKIT_CATALOG_URL="http://localhost:8000/catalog.json"
specify extension search
```

---

## CLI 指令

### `specify extension` 子指令

#### `specify extension list`

列出目前專案中已安裝的擴充功能。

```bash
$ specify extension list

Installed Extensions:
  ✓ jira (v1.0.0) - Jira Integration
    Commands: 3 | Hooks: 2 | Status: Enabled

  ✓ linear (v0.9.0) - Linear Integration
    Commands: 1 | Hooks: 1 | Status: Enabled
```

**選項：**

- `--available`：顯示目錄中可用（未安裝）的擴展
- `--all`：顯示已安裝和可用

#### `specify extension search [QUERY]`

搜尋擴充目錄。

```bash
$ specify extension search jira

Found 1 extension:

┌─────────────────────────────────────────────────────────┐
│ jira (v1.0.0) ✓ Verified                                │
│ Jira Integration                                        │
│                                                         │
│ Create Jira Epics, Stories, and Issues from spec-kit   │
│ artifacts                                               │
│                                                         │
│ Author: Stats Perform                                   │
│ Tags: issue-tracking, jira, atlassian                   │
│ Downloads: 1,250                                        │
│                                                         │
│ Repository: github.com/statsperform/spec-kit-jira       │
│ Documentation: github.com/.../docs                      │
└─────────────────────────────────────────────────────────┘

Install: specify extension add jira
```

**選項：**

- `--tag TAG`：按標籤過濾
- `--author AUTHOR`：按作者過濾
- `--verified`：僅顯示經過驗證的擴展

#### `specify extension info NAME`

顯示有​​關擴充功能的詳細資訊。

```bash
$ specify extension info jira

Jira Integration (jira) v1.0.0

Description:
  Create Jira Epics, Stories, and Issues from spec-kit artifacts

Author: Stats Perform
License: MIT
Repository: https://github.com/statsperform/spec-kit-jira
Documentation: https://github.com/statsperform/spec-kit-jira/blob/main/docs/

Requirements:
  • Spec Kit: >=0.1.0,<2.0.0
  • Tools: jira-mcp-server (>=1.0.0)

Provides:
  Commands:
    • speckit.jira.specstoissues - Create Jira hierarchy from spec and tasks
    • speckit.jira.discover-fields - Discover Jira custom fields
    • speckit.jira.sync-status - Sync task completion status

  Hooks:
    • after_tasks - Prompt to create Jira issues
    • after_implement - Prompt to sync status

Tags: issue-tracking, jira, atlassian, project-management

Downloads: 1,250 | Stars: 45 | Verified: ✓

Install: specify extension add jira
```

#### `specify extension add NAME`

安裝擴充。

```bash
$ specify extension add jira

Installing extension: Jira Integration

✓ Downloaded spec-kit-jira-1.0.0.zip (245 KB)
✓ Validated manifest
✓ Checked compatibility (spec-kit 0.1.0 ≥ 0.1.0)
✓ Extracted to .specify/extensions/jira/
✓ Registered 3 commands with claude
✓ Installed config template (jira-config.yml)

⚠  Configuration required:
   Edit .specify/extensions/jira/jira-config.yml to set your Jira project key

Extension installed successfully!

Next steps:
  1. Configure: vim .specify/extensions/jira/jira-config.yml
  2. Discover fields: /speckit.jira.discover-fields
  3. Use commands: /speckit.jira.specstoissues
```

**選項：**

- `--from URL`：從自訂 URL 或 Git 儲存庫安裝
- `--version VERSION`：安裝特定版本
- `--dev PATH`：從本機路徑安裝（開發模式）
- `--no-register`：跳過指令註冊（手動設定）

#### `specify extension remove NAME`

卸載擴充功能。

```bash
$ specify extension remove jira

⚠  This will remove:
   • 3 commands from AI agent
   • Extension directory: .specify/extensions/jira/
   • Config file: jira-config.yml (will be backed up)

Continue? (yes/no): yes

✓ Unregistered commands
✓ Backed up config to .specify/extensions/.backup/jira-config.yml
✓ Removed extension directory
✓ Updated registry

Extension removed successfully.

To reinstall: specify extension add jira
```

**選項：**

- `--keep-config`：不要刪除設定文件
- `--force`：跳過確認

#### `specify extension update [NAME]`

將擴充功能更新到最新版本。

```bash
$ specify extension update jira

Checking for updates...

jira: 1.0.0 → 1.1.0 available

Changes in v1.1.0:
  • Added support for custom workflows
  • Fixed issue with parallel tasks
  • Improved error messages

Update? (yes/no): yes

✓ Downloaded spec-kit-jira-1.1.0.zip
✓ Validated manifest
✓ Backed up current version
✓ Extracted new version
✓ Preserved config file
✓ Re-registered commands

Extension updated successfully!

Changelog: https://github.com/statsperform/spec-kit-jira/blob/main/CHANGELOG.md#v110
```

**選項：**

- `--all`：更新所有擴展
- `--check`：檢查更新而不安裝
- `--force`：強制更新，即使已經是最新的

#### `specify extension enable/disable NAME`

啟用或停用擴充功能而不刪除它。

```bash
$ specify extension disable jira

✓ Disabled extension: jira
  • Commands unregistered (but files preserved)
  • Hooks will not execute

To re-enable: specify extension enable jira
```

---

## 相容性和版本控制

### 語意版本控制

擴展遵循 [語意版本 2.0.0](https://semver.org/)：

- **主要**：重大變更（指令 API 變更、設定架構變更）
- **次要**：新功能（新指令、新設定選項）
- **補丁**：錯誤修復（無 API 更改）

### 相容性檢查

**安裝時：**

```python
def check_compatibility(extension_manifest: dict) -> bool:
    """Check if extension is compatible with current environment."""

    requires = extension_manifest['requires']

    # 1. Check spec-kit version
    current_speckit = get_speckit_version()  # e.g., "0.1.5"
    required_speckit = requires['speckit_version']  # e.g., ">=0.1.0,<2.0.0"

    if not version_satisfies(current_speckit, required_speckit):
        raise IncompatibleVersionError(
            f"Extension requires spec-kit {required_speckit}, "
            f"but {current_speckit} is installed. "
            f"Upgrade spec-kit with: uv tool install specify-cli --force"
        )

    # 2. Check required tools
    for tool in requires.get('tools', []):
        tool_name = tool['name']
        tool_version = tool.get('version')

        if tool.get('required', True):
            if not check_tool(tool_name):
                raise MissingToolError(
                    f"Extension requires tool: {tool_name}\n"
                    f"Install from: {tool.get('install_url', 'N/A')}"
                )

            if tool_version:
                installed = get_tool_version(tool_name, tool.get('check_command'))
                if not version_satisfies(installed, tool_version):
                    raise IncompatibleToolVersionError(
                        f"Extension requires {tool_name} {tool_version}, "
                        f"but {installed} is installed"
                    )

    # 3. Check required commands
    for cmd in requires.get('commands', []):
        if not command_exists(cmd):
            raise MissingCommandError(
                f"Extension requires core command: {cmd}\n"
                f"Update spec-kit to latest version"
            )

    return True
```

### 棄用政策

**擴充清單可以將功能標記為已棄用：**

```yaml
provides:
  commands:
    - name: "speckit.jira.old-command"
      file: "commands/old-command.md"
      deprecated: true
      deprecated_message: "Use speckit.jira.new-command instead"
      removal_version: "2.0.0"
```

**執行時，顯示警告：**

```text
⚠️  Warning: /speckit.jira.old-command is deprecated
   Use /speckit.jira.new-command instead
   This command will be removed in v2.0.0
```

---

## 安全考慮

### 信任模型

擴充功能以**與 AI 代理程式相同的權限執行**：

- 可以執行shell命令
- 可以讀取專案中的/write文件
- 可以發出網路請求

**信任邊界**：使用者必須信任擴展作者。

### 確認

**已驗證的擴充**（在目錄中）：

- 由已知組織發布（GitHub、Stats Perform 等）
- 由規範套件維護者審查的程式碼
- 目錄中標有 ✓ 徽章

**社群擴展**：

- 未經驗證，使用風險自擔
- 安裝過程中顯示警告：

  ```text
  ⚠️  This extension is not verified.
     Review code before installing: https://github.com/...

     Continue? (yes/no):
  ```

### 沙盒（未來）

**第 2 階段**（不在初始版本）：

- 擴充在清單中聲明所需的權限
- CLI 強制執行權限邊界
- 權限範例：`filesystem:read`、`network:external`、`env:read`

```yaml
# Future extension.yml
permissions:
  - "filesystem:read:.specify/extensions/jira/"  # Can only read own config
  - "filesystem:write:.specify/memory/"          # Can write to memory
  - "network:external:*.atlassian.net"           # Can call Jira API
  - "env:read:SPECKIT_JIRA_*"                    # Can read own env vars
```

### 包裝完整性

**未來**：使用 GPG/Sigstore 簽署擴充包

```yaml
# catalog.json
"jira": {
  "download_url": "...",
  "checksum": "sha256:abc123...",
  "signature": "https://github.com/.../spec-kit-jira-1.0.0.sig",
  "signing_key": "https://github.com/statsperform.gpg"
}
```

CLI 在提取之前驗證簽名。

---

## 遷移策略

### 向後相容性

**目標**：現有規範套件專案無需更改即可執行。

**戰略**：

1. **核心指令不變**：`/speckit.tasks`、`/speckit.implement` 等保留在核心中

2. **可選擴展**：用戶選擇擴展

3. **逐步遷移**：現有 `taskstoissues` 保留在核心中，Jira 擴充是替代方案

4. **棄用時間表**：
   - **v0.2.0**：引進擴充系統，保留核心`taskstoissues`
   - **v0.3.0**：將核心 `taskstoissues` 標記為「舊版」（仍然有效）
   - **v1.0.0**：考慮刪除核心 `taskstoissues` 以支援擴展

### 使用者遷移路徑

**場景 1**：使用者沒有 `taskstoissues` 使用情況

- 無需遷移，擴展是可選的

**場景 2**：使用者使用核心 `taskstoissues`（GitHub 問題）

- 像以前一樣工作
- 可選：遷移到 `github-projects` 擴充以獲得更多功能

**場景 3**：使用者想要 Jira（新要求）

- `specify extension add jira`
- 設定和使用

**場景 4**：使用者有呼叫 `taskstoissues` 的自訂腳本

- 腳本仍然有效（保留核心命令）
- 遷移指南展示如何呼叫擴充命令

### 擴展遷移指南

**對於擴展作者**（如果核心命令成為擴展）：

```bash
# Old (core command)
/speckit.taskstoissues

# New (extension command)
specify extension add github-projects
/speckit.github.taskstoissues
```

**相容性墊片**（如果需要）：

```yaml
# extension.yml
provides:
  commands:
    - name: "speckit.github.taskstoissues"
      file: "commands/taskstoissues.md"
      aliases: ["speckit.taskstoissues"]  # Backward compatibility
```

AI 代理程式註冊了兩個名稱，因此舊腳本可以工作。

---

## 實施階段

### 第一階段：核心擴展系統（第 1-2 週）

**目標**：基本的擴展基礎設施

**可交付成果**：

- [ ] 擴充清單架構 (`extension.yml`)
- [ ] 擴展目錄結構
- [ ] CLI 指令：
  - [ ] `specify extension list`
  - [ ] `specify extension add`（來自 URL）
  - [ ] `specify extension remove`
- [ ] 擴充註冊表 (`.specify/extensions/.registry`)
- [ ] 命令註冊（僅限克勞德最初）
- [ ] 基本驗證（清單架構、相容性）
- [ ] 文件（擴充開發指南）

**測試**：

- [ ] 清單解析的單元測試
- [ ] 整合測試：安裝虛擬擴展
- [ ] 整合測試：向 Claude 註冊命令

### 第 2 階段：Jira 擴展（第 3 週）

**目標**：首次生產擴展

**可交付成果**：

- [ ] 建立 `spec-kit-jira` 儲存庫
- [ ] 將 Jira 功能移植到擴展
- [ ] 建立 `jira-config.yml` 模板
- [ ] 命令：
  - [ ] `specstoissues.md`
  - [ ] `discover-fields.md`
  - [ ] `sync-status.md`
- [ ] 幫助腳本
- [ ] 文件（README、設定指南、範例）
- [ ] 發布v1.0.0

**測試**：

- [ ] 在 `eng-msa-ts` 專案上進行測試
- [ ] 驗證規格→史詩、階段→故事、任務→問題映射
- [ ] 測試設定載入和驗證
- [ ] 測試自訂欄位應用程式

### 第 3 階段：擴展目錄（第 4 週）

**目標**：發現與分發

**可交付成果**：

- [ ] 中央目錄（規格套件儲存庫中的 `extensions/catalog.json`）
- [ ] 目錄取得和解析
- [ ] CLI 指令：
  - [ ] `specify extension search`
  - [ ] `specify extension info`
- [ ] 目錄發布過程（GitHub 操作）
- [ ] 文件（如何發布擴充功能）

**測試**：

- [ ] 測試目錄獲取
- [ ] 測試擴充搜尋_/filtering
- [ ] 測試目錄緩存

### 第 4 階段：進階功能（第 5-6 週）

**目標**：掛鉤、更新、多代理支持

**可交付成果**：

- [ ] 掛鉤系統（extension.yml 中的 `hooks`）
- [ ] 鉤子註冊和執行
- [ ] 專案擴充設定 (`.specify/extensions.yml`)
- [ ] CLI 指令：
  - [ ] `specify extension update`
  - [ ] `specify extension enable/disable`
- [ ] 多個代理的命令註冊（Gemini，Copilot）
- [ ] 擴展更新通知
- [ ] 設定層解析（專案、本地、env）

**測試**：

- [ ] 測試核心命令中的鉤子
- [ ] 測試擴充更新（保留設定）
- [ ] 測試多代理註冊

### 第 5 階段：潤飾和文件（第 7 週）

**目標**：生產就緒

**可交付成果**：

- [ ] 綜合文檔：
  - [ ] 使用者指南（安裝/using 擴充功能）
  - [ ] 擴充開發指南
  - [ ] 擴充 API 參考
  - [ ] 遷移指南（核心→擴充）
- [ ] 錯誤訊息和驗證改進
- [ ] CLI 幫助文字更新
- [ ] 範例擴充模板 (cookiecutter)
- [ ] 部落格文章/公告
- [ ] 影片教學

**測試**：

- [ ] 對多個專案進行端對端測試
- [ ] 社區 Beta 測試
- [ ] 效能測試（大型專案）

---

## 開放式問題

### 1. 擴充命名空間

**問題**：擴充指令是否應該使用命名空間前綴？

**選項**：

- A) 字首：`/speckit.jira.specstoissues`（明確，避免衝突）
- B) 短別名：`/jira.specstoissues`（更短、更簡潔）
- C) 兩者：註冊兩個名稱，最好在文件中加入前綴

**推薦**：C（兩者），前綴是規範的

---

### 2. 設定檔位置

**問題**：擴充設定應該放在哪裡？

**選項**：

- A) 擴充目錄：`.specify/extensions/jira/jira-config.yml`（封裝的）
- B) 根級別：`.specify/jira-config.yml`（更明顯）
- C) 統一：`.specify/extensions.yml`（所有擴充設定位於一個檔案）

**推薦**：A（擴充目錄），更乾淨的分離

---

### 3. 命令檔格式

**問題**：擴充應該使用通用格式還是特定於代理的格式？

**選項**：

- A) 通用 Markdown：擴充寫入一次，CLI 轉換每個代理
- B) 特定於代理：擴展為每個代理提供單獨的文件
- C) 混合：通用預設值、特定於代理的覆蓋

**推薦**：A（通用），減少重複

---

### 4. Hook執行模型

**問題**：hooks應該如何執行？

**選項**：

- A) AI 代理解釋：核心指令輸出 `EXECUTE_COMMAND: name`
- B) CLI 執行：核心指令呼叫 `specify extension hook after_tasks`
- C) 內建代理：擴充系統內建於AI代理程式中（Claude SDK）

**建議**：最初是 A（更簡單），長期轉向 C

---

### 5. 擴展分發

**問題**：擴充應該如何打包？

**選項**：

- A) ZIP 檔案：從 GitHub 版本下載
- B) Git 儲存庫：直接克隆 (`git clone`)
- C) Python 套件：可透過 `uv tool install` 安裝

**推薦**：A (ZIP)，對於未來的非 Python 擴充來說更簡單

---

### 6. 多版本支持

**問題**：同一擴充的多個版本可以共存嗎？

**選項**：

- A) 單版本：一次只安裝一個版本
- B) 多重版本：平行版本（`.specify/extensions/jira@1.0/`、`.specify/extensions/jira@2.0/`）
- C) 每個分支：不同分支使用不同版本

**建議**：最初是A（更簡單），如果需要的話將來考慮B

---

## 附錄

### 附錄 A：擴展結構範例

** `spec-kit-jira` 擴充的完整結構：**

```text
spec-kit-jira/
├── README.md                        # Overview, features, installation
├── LICENSE                          # MIT license
├── CHANGELOG.md                     # Version history
├── .gitignore                       # Ignore local configs
│
├── extension.yml                    # Extension manifest (required)
├── jira-config.template.yml         # Config template
│
├── commands/                        # Command files
│   ├── specstoissues.md            # Main command
│   ├── discover-fields.md          # Helper: Discover custom fields
│   └── sync-status.md              # Helper: Sync completion status
│
├── scripts/                         # Helper scripts
│   ├── parse-jira-config.sh        # Config loader (bash)
│   ├── parse-jira-config.ps1       # Config loader (PowerShell)
│   └── validate-jira-connection.sh # Connection test
│
├── docs/                            # Documentation
│   ├── installation.md             # Installation guide
│   ├── configuration.md            # Configuration reference
│   ├── usage.md                    # Usage examples
│   ├── troubleshooting.md          # Common issues
│   └── examples/
│       ├── eng-msa-ts-config.yml   # Real-world config example
│       └── simple-project.yml      # Minimal config example
│
├── tests/                           # Tests (optional)
│   ├── test-extension.sh           # Extension validation
│   └── test-commands.sh            # Command execution tests
│
└── .github/                         # GitHub integration
    └── workflows/
        └── release.yml              # Automated releases
```

### 附錄B：擴展開髮指南（概要）

**建立新擴充的文件：**

1. **入門**
   - 先決條件（需要的工具）
   - 擴充模板（cookiecutter）
   - 目錄結構

2. **擴充清單**
   - 架構參考
   - 必填字段與可選字段
   - 版本控制指南

3. **命令開發**
   - 通用命令格式
   - 前端規範
   - 模板變數
   - 腳本參考

4. **設定**
   - 設定檔結構
   - 模式驗證
   - 分層設定解析
   - 環境變數覆蓋

5. **掛鉤**
   - 可用的掛鉤點
   - 鉤子註冊
   - 有條件執行
   - 最佳實踐

6. **測試**
   - 本地開發設定
   - 使用 `--dev` 標誌進行測試
   - 驗證清單
   - 整合測試

7. **出版**
   - 包裝（ZIP 格式）
   - GitHub 發布
   - 目錄提交
   - 版本控制策略

8. **範例**
   - 最小延伸
   - 帶掛鉤的延長件
   - 帶設定的擴展
   - 具有多個命令的擴展

### 附錄 C：相容性矩陣

**計劃支援矩陣：**

| 擴充功能 | Spec Kit 版本 | AI 代理支持 |
|-------------------|------------------|------------------|
| 基本指令 | 0.2.0+ | 克勞德，Gemini，Copilot |
| 掛鉤（after_tasks） | 0.3.0+ | 克勞德，Gemini |
| 設定驗證 | 0.2.0+ | 全部 |
| 多個目錄 | 0.4.0+ | 全部 |
| 權限（沙盒） | 1.0.0+ | 待定 |

### 附錄 D：擴充目錄架構

** `catalog.json` 的完整架構：**

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["schema_version", "updated_at", "extensions"],
  "properties": {
    "schema_version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+$"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time"
    },
    "extensions": {
      "type": "object",
      "patternProperties": {
        "^[a-z0-9-]+$": {
          "type": "object",
          "required": ["name", "id", "version", "download_url", "repository"],
          "properties": {
            "name": { "type": "string" },
            "id": { "type": "string", "pattern": "^[a-z0-9-]+$" },
            "description": { "type": "string" },
            "author": { "type": "string" },
            "version": { "type": "string", "pattern": "^\\d+\\.\\d+\\.\\d+$" },
            "download_url": { "type": "string", "format": "uri" },
            "repository": { "type": "string", "format": "uri" },
            "homepage": { "type": "string", "format": "uri" },
            "documentation": { "type": "string", "format": "uri" },
            "changelog": { "type": "string", "format": "uri" },
            "license": { "type": "string" },
            "requires": {
              "type": "object",
              "properties": {
                "speckit_version": { "type": "string" },
                "tools": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "required": ["name"],
                    "properties": {
                      "name": { "type": "string" },
                      "version": { "type": "string" }
                    }
                  }
                }
              }
            },
            "tags": {
              "type": "array",
              "items": { "type": "string" }
            },
            "verified": { "type": "boolean" },
            "downloads": { "type": "integer" },
            "stars": { "type": "integer" },
            "checksum": { "type": "string" }
          }
        }
      }
    }
  }
}
```

---

## 摘要與後續步驟

該 RFC 為 Spec Kit 提出了一個全面的擴展系統，該系統：

1. **保持核心精益**，同時實現無限集成
2. **支援多個代理商**（Claude、Gemini、Copilot 等）
3. **為社區貢獻提供明確的擴展 API_**
4. **啟用擴充功能和核心的獨立版本控制**
5. **包括安全機制**（驗證、相容性檢查）

### 立即採取的後續步驟

1. **與利害關係人一起審查此 RFC**
2. **收集有關開放問題的回饋**
3. **根據回饋完善設計**
4. **進入A階段**：實施核心擴充系統
5. **然後是 B 階段**：建立 Jira 擴充作為概念驗證

---

## 供討論的問題

1. 擴展架構是否滿足您對 Jira 整合的需求？
2. 我們還應該考慮其他掛鉤點嗎？
3. 我們是否應該支援擴展依賴關係（擴展 A 需要擴展 B）？
4. 我們該如何處理目錄中的擴充棄用/removal？
5. v1.0 我們需要什麼等級的沙箱/permissions？
