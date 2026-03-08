# 擴充 API 參考

Spec Kit 擴充系統 API 和清單架構的技術參考。

## 目錄

1. [擴充清單](#擴充清單)
2. [蟒蛇 API](#蟒蛇-api)
3. [命令檔格式](#命令檔格式)
4. [設定架構](#設定架構)
5. [掛鉤系統](#掛鉤系統)
6. [CLI 指令](#cli-指令)

---

## 擴充清單

### 架構版本 1.0

文件：`extension.yml`

```yaml
schema_version: "1.0"  # Required

extension:
  id: string           # Required, pattern: ^[a-z0-9-]+$
  name: string         # Required, human-readable name
  version: string      # Required, semantic version (X.Y.Z)
  description: string  # Required, brief description (<200 chars)
  author: string       # Required
  repository: string   # Required, valid URL
  license: string      # Required (e.g., "MIT", "Apache-2.0")
  homepage: string     # Optional, valid URL

requires:
  speckit_version: string  # Required, version specifier (>=X.Y.Z)
  tools:                   # Optional, array of tool requirements
    - name: string         # Tool name
      version: string      # Optional, version specifier
      required: boolean    # Optional, default: false

provides:
  commands:              # Required, at least one command
    - name: string       # Required, pattern: ^speckit\.[a-z0-9-]+\.[a-z0-9-]+$
      file: string       # Required, relative path to command file
      description: string # Required
      aliases: [string]  # Optional, array of alternate names

  config:                # Optional, array of config files
    - name: string       # Config file name
      template: string   # Template file path
      description: string
      required: boolean  # Default: false

hooks:                   # Optional, event hooks
  event_name:            # e.g., "after_tasks", "after_implement"
    command: string      # Command to execute
    optional: boolean    # Default: true
    prompt: string       # Prompt text for optional hooks
    description: string  # Hook description
    condition: string    # Optional, condition expression

tags:                    # Optional, array of tags (2-10 recommended)
  - string

defaults:                # Optional, default configuration values
  key: value             # Any YAML structure
```

### 現場規格

#### `extension.id`

- **類型**：字串
- **模式**：`^[a-z0-9-]+$`
- **描述**：唯一的擴充標識符
- **範例**： `jira`、`linear`、`azure-devops`
- **無效**：`Jira`、`my_extension`、`extension.id`

#### `extension.version`

- **類型**：字串
- **格式**：語意版本控制 (X.Y.Z)
- **描述**：擴充版本
- **範例**： `1.0.0`、`0.9.5`、`2.1.3`
- **無效**：`v1.0`、`1.0`、`1.0.0-beta`

#### `requires.speckit_version`

- **類型**：字串
- **格式**：版本說明符
- **描述**：所需的規格套件版本範圍
- **範例**：
  - `>=0.1.0` - 任何版本 0.1.0 或更高版本
  - `>=0.1.0,<2.0.0` - 版本 0.1.x 或 1.x
  - `==0.1.0` - 正好 0.1.0
- **無效**：`0.1.0`、`>= 0.1.0`（空格）、`latest`

#### `provides.commands[].name`

- **類型**：字串
- **模式**：`^speckit\.[a-z0-9-]+\.[a-z0-9-]+$`
- **描述**：命名空間指令名稱
- **格式**：`speckit.{extension-id}.{command-name}`
- **範例**： `speckit.jira.specstoissues`、`speckit.linear.sync`
- **無效**：`jira.specstoissues`、`speckit.command`、`speckit.jira.CreateIssues`

#### `hooks`

- **類型**：對象
- **按鍵**：事件名稱（例如 `after_tasks`、`after_implement`、`before_commit`）
- **描述**：在生命週期事件中執行的鉤子
- **事件**：由核心規範套件指令定義

---

## 蟒蛇 API

### 擴充清單

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionManifest

manifest = ExtensionManifest(Path("extension.yml"))
```

**特性**：

```python
manifest.id                        # str: Extension ID
manifest.name                      # str: Extension name
manifest.version                   # str: Version
manifest.description               # str: Description
manifest.requires_speckit_version  # str: Required spec-kit version
manifest.commands                  # List[Dict]: Command definitions
manifest.hooks                     # Dict: Hook definitions
```

**方法**：

```python
manifest.get_hash()  # str: SHA256 hash of manifest file
```

**例外**：

```python
ValidationError       # Invalid manifest structure
CompatibilityError    # Incompatible with current spec-kit version
```

### 擴展註冊中心

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionRegistry

registry = ExtensionRegistry(extensions_dir)
```

**方法**：

```python
# Add extension to registry
registry.add(extension_id: str, metadata: dict)

# Remove extension from registry
registry.remove(extension_id: str)

# Get extension metadata
metadata = registry.get(extension_id: str)  # Optional[dict]

# List all extensions
extensions = registry.list()  # Dict[str, dict]

# Check if installed
is_installed = registry.is_installed(extension_id: str)  # bool
```

**註冊表格式**：

```json
{
  "schema_version": "1.0",
  "extensions": {
    "jira": {
      "version": "1.0.0",
      "source": "catalog",
      "manifest_hash": "sha256...",
      "enabled": true,
      "registered_commands": ["speckit.jira.specstoissues", ...],
      "installed_at": "2026-01-28T..."
    }
  }
}
```

### 擴充管理器

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionManager

manager = ExtensionManager(project_root)
```

**方法**：

```python
# Install from directory
manifest = manager.install_from_directory(
    source_dir: Path,
    speckit_version: str,
    register_commands: bool = True
)  # Returns: ExtensionManifest

# Install from ZIP
manifest = manager.install_from_zip(
    zip_path: Path,
    speckit_version: str
)  # Returns: ExtensionManifest

# Remove extension
success = manager.remove(
    extension_id: str,
    keep_config: bool = False
)  # Returns: bool

# List installed extensions
extensions = manager.list_installed()  # List[Dict]

# Get extension manifest
manifest = manager.get_extension(extension_id: str)  # Optional[ExtensionManifest]

# Check compatibility
manager.check_compatibility(
    manifest: ExtensionManifest,
    speckit_version: str
)  # Raises: CompatibilityError if incompatible
```

### 擴充目錄

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionCatalog

catalog = ExtensionCatalog(project_root)
```

**方法**：

```python
# Fetch catalog
catalog_data = catalog.fetch_catalog(force_refresh: bool = False)  # Dict

# Search extensions
results = catalog.search(
    query: Optional[str] = None,
    tag: Optional[str] = None,
    author: Optional[str] = None,
    verified_only: bool = False
)  # Returns: List[Dict]

# Get extension info
ext_info = catalog.get_extension_info(extension_id: str)  # Optional[Dict]

# Check cache validity
is_valid = catalog.is_cache_valid()  # bool

# Clear cache
catalog.clear_cache()
```

### 鉤子執行器

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import HookExecutor

hook_executor = HookExecutor(project_root)
```

**方法**：

```python
# Get project config
config = hook_executor.get_project_config()  # Dict

# Save project config
hook_executor.save_project_config(config: Dict)

# Register hooks
hook_executor.register_hooks(manifest: ExtensionManifest)

# Unregister hooks
hook_executor.unregister_hooks(extension_id: str)

# Get hooks for event
hooks = hook_executor.get_hooks_for_event(event_name: str)  # List[Dict]

# Check if hook should execute
should_run = hook_executor.should_execute_hook(hook: Dict)  # bool

# Format hook message
message = hook_executor.format_hook_message(
    event_name: str,
    hooks: List[Dict]
)  # str
```

### 命令註冊器

**模組**：`specify_cli.extensions`

```python
from specify_cli.extensions import CommandRegistrar

registrar = CommandRegistrar()
```

**方法**：

```python
# Register commands for Claude Code
registered = registrar.register_commands_for_claude(
    manifest: ExtensionManifest,
    extension_dir: Path,
    project_root: Path
)  # Returns: List[str] (command names)

# Parse frontmatter
frontmatter, body = registrar.parse_frontmatter(content: str)

# Render frontmatter
yaml_text = registrar.render_frontmatter(frontmatter: Dict)  # str
```

---

## 命令檔格式

### 通用命令格式

**文件**： `commands/{command-name}.md`

```markdown
---
description: "Command description"
tools:
  - 'mcp-server/tool_name'
  - 'other-mcp-server/other_tool'
---

# Command Title

Command documentation in Markdown.

## Prerequisites

1. Requirement 1
2. Requirement 2

## User Input

$ARGUMENTS

## Steps

### Step 1: Description

Instruction text...

\`\`\`bash
# Shell commands
\`\`\`

### Step 2: Another Step

More instructions...

## Configuration Reference

Information about configuration options.

## Notes

Additional notes and tips.
```

### 前沿領域

```yaml
description: string   # Required, brief command description
tools: [string]       # Optional, MCP tools required
```

### 特殊變數

- `$ARGUMENTS` - 使用者提供的參數的佔位符
- 自動注入擴充上下文：

  ```markdown
  <!-- Extension: {extension-id} -->
  <!-- Config: .specify/extensions/{extension-id}/ -->
  ```

---

## 設定架構

### 擴充設定檔案

**文件**： `.specify/extensions/{extension-id}/{extension-id}-config.yml`

擴充定義自己的設定模式。常見模式：

```yaml
# Connection settings
connection:
  url: string
  api_key: string

# Project settings
project:
  key: string
  workspace: string

# Feature flags
features:
  enabled: boolean
  auto_sync: boolean

# Defaults
defaults:
  labels: [string]
  assignee: string

# Custom fields
field_mappings:
  internal_name: "external_field_id"
```

### 設定層

1. **擴充預設值**（來自 `extension.yml` `defaults` 部分）
2. **專案設定** (`{extension-id}-config.yml`)
3. **本地覆蓋**（`{extension-id}-config.local.yml`，gitignored）
4. **環境變數** (`SPECKIT_{EXTENSION}_*`)

### 環境變數模式

格式：`SPECKIT_{EXTENSION}_{KEY}`

範例：

- `SPECKIT_JIRA_PROJECT_KEY`
- `SPECKIT_LINEAR_API_KEY`
- `SPECKIT_GITHUB_TOKEN`

---

## 掛鉤系統

### 鉤子定義

**在副檔名.yml 中**：

```yaml
hooks:
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    prompt: "Create Jira issues from tasks?"
    description: "Automatically create Jira hierarchy"
    condition: null
```

### 掛鉤事件

標準事件（由核心定義）：

- `after_tasks` - 任務產生後
- `after_implement` - 實施後
- `before_commit` - git 提交之前
- `after_commit` - git 提交後

### 掛鉤設定

**在 `.specify/extensions.yml`** 中：

```yaml
hooks:
  after_tasks:
    - extension: jira
      command: speckit.jira.specstoissues
      enabled: true
      optional: true
      prompt: "Create Jira issues from tasks?"
      description: "..."
      condition: null
```

### 掛鉤訊息格式

```markdown
## Extension Hooks

**Optional Hook**: {extension}
Command: `/{command}`
Description: {description}

Prompt: {prompt}
To execute: `/{command}`
```

或對於強制掛鉤：

```markdown
**Automatic Hook**: {extension}
Executing: `/{command}`
EXECUTE_COMMAND: {command}
```

---

## CLI 指令

### 擴充列表

**用法**： `specify extension list [OPTIONS]`

**選項**：

- `--available` - 顯示目錄中的可用擴展
- `--all` - 顯示已安裝和可用

**輸出**：已安裝擴充功能的清單以及元數據

### 擴充功能添加

**用法**： `specify extension add EXTENSION [OPTIONS]`

**選項**：

- `--from URL` - 從自訂 URL 安裝
- `--dev PATH` - 從本地目錄安裝
- `--version VERSION` - 安裝特定版本
- `--no-register` - 跳過指令註冊

**參數**：

- `EXTENSION` - 副檔名或 URL

### 擴充刪除

**用法**： `specify extension remove EXTENSION [OPTIONS]`

**選項**：

- `--keep-config` - 保留設定檔
- `--force` - 跳過確認

**參數**：

- `EXTENSION` - 擴充 ID

### 擴展搜尋

**用法**： `specify extension search [QUERY] [OPTIONS]`

**選項**：

- `--tag TAG` - 按標籤過濾
- `--author AUTHOR` - 依作者過濾
- `--verified` - 僅顯示經過驗證的擴展

**參數**：

- `QUERY` - 可選搜尋查詢

### 擴充訊息

**用法**： `specify extension info EXTENSION`

**參數**：

- `EXTENSION` - 擴充 ID

### 擴充更新

**用法**： `specify extension update [EXTENSION]`

**參數**：

- `EXTENSION` - 可選，擴充 ID（預設值：全部）

### 擴展使能

**用法**： `specify extension enable EXTENSION`

**參數**：

- `EXTENSION` - 擴充 ID

### 擴充功能禁用

**用法**： `specify extension disable EXTENSION`

**參數**：

- `EXTENSION` - 擴充 ID

---

## 例外情況

### 驗證錯誤

當擴充清單驗證失敗時引發。

```python
from specify_cli.extensions import ValidationError

try:
    manifest = ExtensionManifest(path)
except ValidationError as e:
    print(f"Invalid manifest: {e}")
```

### 相容性錯誤

當擴充與當前規範套件版本不相容時引發。

```python
from specify_cli.extensions import CompatibilityError

try:
    manager.check_compatibility(manifest, "0.1.0")
except CompatibilityError as e:
    print(f"Incompatible: {e}")
```

### 擴充錯誤

所有與擴展相關的錯誤的基本異常。

```python
from specify_cli.extensions import ExtensionError

try:
    manager.install_from_directory(path, "0.1.0")
except ExtensionError as e:
    print(f"Extension error: {e}")
```

---

## 版本功能

### 版本滿足

檢查版本是否滿足說明符。

```python
from specify_cli.extensions import version_satisfies

# True if 1.2.3 satisfies >=1.0.0,<2.0.0
satisfied = version_satisfies("1.2.3", ">=1.0.0,<2.0.0")  # bool
```

---

## 檔案系統佈局

```text
.specify/
├── extensions/
│   ├── .registry               # Extension registry (JSON)
│   ├── .cache/                 # Catalog cache
│   │   ├── catalog.json
│   │   └── catalog-metadata.json
│   ├── .backup/                # Config backups
│   │   └── {ext}-{config}.yml
│   ├── {extension-id}/         # Extension directory
│   │   ├── extension.yml       # Manifest
│   │   ├── {ext}-config.yml    # User config
│   │   ├── {ext}-config.local.yml  # Local overrides (gitignored)
│   │   ├── {ext}-config.template.yml  # Template
│   │   ├── commands/           # Command files
│   │   │   └── *.md
│   │   ├── scripts/            # Helper scripts
│   │   │   └── *.sh
│   │   ├── docs/               # Documentation
│   │   └── README.md
│   └── extensions.yml          # Project extension config
└── scripts/                    # (existing spec-kit)

.claude/
└── commands/
    └── speckit.{ext}.{cmd}.md  # Registered commands
```

---

*最後更新：2026-01-28*
*API 版本：1.0*
*Spec Kit 版本：0.1.0*
