# AGENTS.md

## 關於 Spec Kit 並指定

**GitHub Spec Kit** 是用於實施 Spec-Driven Development (SDD) 的綜合工具包 - 一種強調在實施之前建立明確規範的方法。該工具包包括範本、腳本和工作流程，可指導開發團隊透過結構化方法建立軟體。

**Specify CLI** 是使用 Spec Kit 框架引導專案的命令列介面。它設定必要的目錄結構、模板和 AI 代理整合以支援 Spec-Driven Development 工作流程。

該工具包支援多個 AI 程式碼助理，讓團隊可以使用他們喜歡的工具，同時保持一致的專案結構和開發實踐。

---

## 一般做法

- 對 Specify CLI 的 `__init__.py` 進行的任何更改都需要在 `pyproject.toml` 中進行版本修訂，並向 `CHANGELOG.md` 新增條目。

## 新增代理支援

本節介紹如何在 Specify CLI 中新增對新 AI 代理程式 /assistants 的支援。將新的 AI 工具整合到 Spec-Driven Development 工作流程時，請使用本指南作為參考。

### 概述

指定透過在初始化專案時產生特定於代理的命令檔案和目錄結構來支援多個 AI 代理程式。每個代理人都有自己的約定：

- **指令檔格式**（Markdown、TOML 等）
- **目錄結構**（`.claude/commands/`、`.windsurf/workflows/` 等）
- **指令呼叫模式**（斜線指令、CLI 工具等）
- **參數傳遞約定**（`$ARGUMENTS`、`{{args}}` 等）

### 目前支援的代理

| 代理人                      | 目錄              | 格式   | CLI 工具        | 描述                 |
| -------------------------- | ---------------------- | -------- | --------------- | --------------------------- |
| **Claude Code**            | `.claude/commands/`    | Markdown | `claude`        | 人類的 Claude Code CLI |
| **Gemini CLI**             | `.gemini/commands/`    | TOML     | `gemini`        | 谷歌的 Gemini CLI         |
| **GitHub Copilot**         | `.github/agents/`      | Markdown | N/A（基於IDE） | GitHub Copilot 在 VS Code   |
| **Cursor**                 | `.cursor/commands/`    | Markdown | `cursor-agent`  | Cursor CLI                  |
| **Qwen Code**              | `.qwen/commands/`      | TOML     | `qwen`          | 阿里巴巴的 Qwen Code CLI     |
| **opencode**               | `.opencode/command/`   | Markdown | `opencode`      | opencode CLI                |
| **Codex CLI**              | `.codex/commands/`     | Markdown | `codex`         | Codex CLI                   |
| **Windsurf**               | `.windsurf/workflows/` | Markdown | N/A（基於IDE） | Windsurf IDE 工作流程      |
| **Kilo Code**              | `.kilocode/rules/`     | Markdown | N/A（基於IDE） | Kilo Code IDE               |
| **Auggie CLI**             | `.augment/rules/`      | Markdown | `auggie`        | Auggie CLI                  |
| **Roo Code**               | `.roo/rules/`          | Markdown | N/A（基於IDE） | Roo Code IDE                |
| **CodeBuddy CLI**          | `.codebuddy/commands/` | Markdown | `codebuddy`     | CodeBuddy CLI               |
| **Qoder CLI**              | `.qoder/commands/`     | Markdown | `qodercli`      | Qoder CLI                   |
| **Amazon Q Developer CLI** | `.amazonq/prompts/`    | Markdown | `q`             | Amazon Q Developer CLI      |
| **Amp**                    | `.agents/commands/`    | Markdown | `amp`           | Amp CLI                     |
| **SHAI**                   | `.shai/commands/`      | Markdown | `shai`          | SHAI CLI                    |
| **IBM Bob**                | `.bob/commands/`       | Markdown | N/A（基於IDE） | IBM Bob IDE                 |
| **通用的**                | 使用者透過 `--ai-commands-dir` 指定 | Markdown | N/A | 帶上自己的經紀人        |

### 逐步整合指南

請依照以下步驟新增代理程式（以假設的新代理程式為例）：

#### 1. 添加到AGENT_CONFIG

**重要**：使用實際的 CLI 工具名稱作為金鑰，而不是縮寫版本。

將新代理程式加入 `src/specify_cli/__init__.py` 中的 `AGENT_CONFIG` 字典。這是所有代理元資料的**單一事實來源**：

```python
AGENT_CONFIG = {
    # ... existing agents ...
    "new-agent-cli": {  # Use the ACTUAL CLI tool name (what users type in terminal)
        "name": "New Agent Display Name",
        "folder": ".newagent/",  # Directory for agent files
        "commands_subdir": "commands",  # Subdirectory name for command files (default: "commands")
        "install_url": "https://example.com/install",  # URL for installation docs (or None if IDE-based)
        "requires_cli": True,  # True if CLI tool required, False for IDE-based agents
    },
}
```

**金鑰設計原則**：字典金鑰應與使用者安裝的實際可可執行檔名稱相符。例如：

- ✅ 使用 `"cursor-agent"` 因為 CLI 工具字面意思是 `cursor-agent`
- ❌ 如果工具是 `cursor-agent`，請勿使用 `"cursor"` 作為捷徑

這消除了整個程式碼函式庫中特殊情況映射的需要。

**欄位說明**：

- `name`：向使用者顯示的人類可讀的顯示名稱
- `folder`：儲存特定於代理程式的檔案的目錄（相對於專案根目錄）
- `commands_subdir`：儲存指令/prompt 檔案的代理程式資料夾內的子目錄名稱（預設值：`"commands"`）
  - 大多數代理程式使用 `"commands"`（例如 `.claude/commands/`）
  - 有些特工使用替代名稱：`"agents"`（副駕駛）、`"workflows"`（windsurf、kilocode、agy）、`"prompts"`（codex、q）、`"command"`（opencode - 單數）
  - 此欄位使 `--ai-skills` 能夠正確定位命令範本以產生技能
- `install_url`：安裝文件 URL（基於 IDE 的代理，設定為 `None`）
- `requires_cli`：代理在初始化期間是否需要 CLI 工具檢查

#### 2. 更新 CLI 幫助文本

更新 `init()` 指令中的 `--ai` 參數說明文字以包含新代理程式：

```python
ai_assistant: str = typer.Option(None, "--ai", help="AI assistant to use: claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, codebuddy, new-agent-cli, or q"),
```

也要更新列出可用代理程式的所有函數文件字串、範例和錯誤訊息。

#### 3. 更新 README 文檔

更新 `README.md` 中的 **支援的 AI 代理** 部分以包含新代理：

- 將新代理程式新增至具有適當支援等級的表中 (Full/Partial)
- 包含代理商的官方網站鏈接
- 新增有關代理實施的任何相關註釋
- 確保表格格式保持對齊和一致

#### 4.更新發布包腳本

修改`.github/workflows/scripts/create-release-packages.sh`：

##### 添加到 ALL_AGENTS 數組

```bash
ALL_AGENTS=(claude gemini copilot cursor-agent qwen opencode windsurf q)
```

##### 新增目錄結構的 case 語句

```bash
case $agent in
  # ... existing cases ...
  windsurf)
    mkdir -p "$base_dir/.windsurf/workflows"
    generate_commands windsurf md "\$ARGUMENTS" "$base_dir/.windsurf/workflows" "$script" ;;
esac
```

#### 4.更新GitHub發布腳本

修改 `.github/workflows/scripts/create-github-release.sh` 以包含新代理程式的軟體包：

```bash
gh release create "$VERSION" \
  # ... existing packages ...
  .genreleases/spec-kit-template-windsurf-sh-"$VERSION".zip \
  .genreleases/spec-kit-template-windsurf-ps-"$VERSION".zip \
  # Add new agent packages here
```

#### 5. 更新代理程式上下文腳本

##### Bash 腳本 (`scripts/bash/update-agent-context.sh`)

新增檔案變數：

```bash
WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/specify-rules.md"
```

新增到案例聲明：

```bash
case "$AGENT_TYPE" in
  # ... existing cases ...
  windsurf) update_agent_file "$WINDSURF_FILE" "Windsurf" ;;
  "")
    # ... existing checks ...
    [ -f "$WINDSURF_FILE" ] && update_agent_file "$WINDSURF_FILE" "Windsurf";
    # Update default creation condition
    ;;
esac
```

##### PowerShell 腳本 (`scripts/powershell/update-agent-context.ps1`)

新增檔案變數：

```powershell
$windsurfFile = Join-Path $repoRoot '.windsurf/rules/specify-rules.md'
```

加到 switch 語句：

```powershell
switch ($AgentType) {
    # ... existing cases ...
    'windsurf' { Update-AgentFile $windsurfFile 'Windsurf' }
    '' {
        foreach ($pair in @(
            # ... existing pairs ...
            @{file=$windsurfFile; name='Windsurf'}
        )) {
            if (Test-Path $pair.file) { Update-AgentFile $pair.file $pair.name }
        }
        # Update default creation condition
    }
}
```

#### 6. 更新 CLI 工具檢查（選用）

對於需要 CLI 工具的代理，請在 `check()` 指令和代理驗證中新增檢查：

```python
# In check() command
tracker.add("windsurf", "Windsurf IDE (optional)")
windsurf_ok = check_tool_for_tracker("windsurf", "https://windsurf.com/", tracker)

# In init validation (only if CLI tool required)
elif selected_ai == "windsurf":
    if not check_tool("windsurf", "Install from: https://windsurf.com/"):
        console.print("[red]Error:[/red] Windsurf CLI is required for Windsurf projects")
        agent_tool_missing = True
```

**注意**：CLI 工具檢查現在根據 AGENT_CONFIG 中的 `requires_cli` 欄位自動處理。 `check()` 或 `init()` 命令中不需要進行額外的程式碼變更 - 它們會自動循環 AGENT_CONFIG 並根據需要檢查工具。

## 重要的設計決策

### 使用實際 CLI 工具名稱作為鍵

**關鍵**：將新代理程式新增至 AGENT_CONFIG 時，請務必使用 **實際可執行檔名稱** 作為字典鍵，而不是縮短或方便的版本。

**為什麼這很重要：**

- `check_tool()` 函數使用 `shutil.which(tool)` 在系統 PATH 中尋找可執行檔
- 如果金鑰與實際的 CLI 工具名稱不匹配，則需要在整個程式碼函式庫中進行特殊情況映射
- 這會造成不必要的複雜性和維護負擔

**範例 - Cursor 課程：**

❌ **錯誤的方法**（需要特殊情況映射）：

```python
AGENT_CONFIG = {
    "cursor": {  # Shorthand that doesn't match the actual tool
        "name": "Cursor",
        # ...
    }
}

# Then you need special cases everywhere:
cli_tool = agent_key
if agent_key == "cursor":
    cli_tool = "cursor-agent"  # Map to the real tool name
```

✅ **正確的方法**（無需映射）：

```python
AGENT_CONFIG = {
    "cursor-agent": {  # Matches the actual executable name
        "name": "Cursor",
        # ...
    }
}

# No special cases needed - just use agent_key directly!
```

**這種方法的好處：**

- 消除分散在整個程式碼函式庫中的特殊情況邏輯
- 讓程式碼更易於維護、更易於理解
- 減少新增代理程式時出現錯誤的機會
- 工具檢查“正常工作”，無需額外映射

#### 7. 更新 Devcontainer 檔案（可選）

對於具有 VS Code 副檔名或需要 CLI 安裝的代理，請更新 devcontainer 設定檔：

##### VS Code 基於擴充的代理

對於可用作 VS Code 分機的代理，請將它們加到 `.devcontainer/devcontainer.json`：

```json
{
  "customizations": {
    "vscode": {
      "extensions": [
        // ... existing extensions ...
        // [New Agent Name]
        "[New Agent Extension ID]"
      ]
    }
  }
}
```

##### 基於 CLI 的代理

對於需要 CLI 工具的代理，請將安裝指令新增至 `.devcontainer/post-create.sh`：

```bash
#!/bin/bash

# Existing installations...

echo -e "\n🤖 Installing [New Agent Name] CLI..."
# run_command "npm install -g [agent-cli-package]@latest" # Example for node-based CLI
# or other installation instructions (must be non-interactive and compatible with Linux Debian "Trixie" or later)...
echo "✅ Done"

```

**快速提示：**

- **基於擴充的代理程式**：新增到 `devcontainer.json` 中的 `extensions` 數組
- **基於CLI 的代理程式**：將安裝腳本新增至 `post-create.sh`
- **混合代理**：可能需要擴充和 CLI 安裝
- **徹底測試**：確保安裝在 devcontainer 環境中正常運作

## 代理類別

### 基於 CLI 的代理

需要安裝命令列工具：

- **Claude Code**： `claude` CLI
- **Gemini CLI**： `gemini` CLI
- **Cursor**： `cursor-agent` CLI
- **Qwen Code**： `qwen` CLI
- **opencode**： `opencode` CLI
- **Amazon Q Developer CLI**： `q` CLI
- **CodeBuddy CLI**： `codebuddy` CLI
- **Qoder CLI**： `qodercli` CLI
- **Amp**： `amp` CLI
- **SHAI**： `shai` CLI

### 基於 IDE 的代理

在整合開發環境中工作：

- **GitHub Copilot**：內建於 VS Code/相容編輯器中
- **Windsurf**：內建於 Windsurf IDE
- **IBM Bob**：內建於 IBM Bob IDE

## 命令檔格式

### Markdown 格式

使用者：Claude、Cursor、opencode、Windsurf、Amazon Q 開發人員、Amp、SHAI、IBM Bob

**標準格式：**

```markdown
---
description: "Command description"
---

Command content with {SCRIPT} and $ARGUMENTS placeholders.
```

**GitHub Copilot 聊天模式格式：**

```markdown
---
description: "Command description"
mode: speckit.command-name
---

Command content with {SCRIPT} and $ARGUMENTS placeholders.
```

### TOML 格式

使用者：Gemini，Qwen

```toml
description = "Command description"

prompt = """
Command content with {SCRIPT} and {{args}} placeholders.
"""
```

## 目錄約定

- **CLI 代理**：通常為 `.<agent-name>/指令/`
- **IDE 代理**：遵循 IDE 特定模式：
  - Copilot：`.github/agents/`
  - Cursor：`.cursor/commands/`
  - Windsurf：`.windsurf/workflows/`

## 論證模式

不同的代理使用不同的參數佔位符：

- **Markdown/提示式**：`$ARGUMENTS`
- **基於TOML**：`{{args}}`
- **腳本佔位符**：`{SCRIPT}`（替換為實際腳本路徑）
- **代理佔位符**：`__AGENT__`（替換為代理名稱）

## 測試新代理集成

1. **建置測試**：在本機執行套件建立腳本
2. **CLI 測驗**：測驗`指定 init --ai <agent>` 指令
3. **檔案產生**：驗證正確的目錄結構和文件
4. **命令驗證**：確保產生的命令適用於代理
5. **上下文更新**：測試代理程式上下文更新腳本

## 常見陷阱

1. **使用簡寫鍵而不是實際的 CLI 工具名稱**：始終使用實際的可可執行檔名稱作為 AGENT_CONFIG 鍵（例如，`"cursor-agent"` 而不是 `"cursor"`）。這可以避免在整個程式碼函式庫中進行特殊情況映射的需要。
2. **忘記更新腳本**：新增代理程式時，必須更新 bash 和 PowerShell 腳本。
3. **不正確的 `requires_cli` 值**：僅針對實際具有 CLI 工具進行檢查的代理設定為 `True`；對於基於 IDE 的代理，設定為 `False`。
4. **參數格式錯誤**：對每個代理類型使用正確的佔位符格式（`$ARGUMENTS` 表示 Markdown，`{{args}}` 表示 TOML）。
5. **目錄命名**：嚴格遵循特定於代理的約定（檢查現有代理的模式）。
6. **幫助文字不一致**：一致更新所有使用者導向的文字（幫助字串、文件字串、README、錯誤訊息）。

## 未來的考慮因素

新增代理時：

- 考慮代理的本機指令/workflow 模式
- 確保與 Spec-Driven Development 進程相容
- 記錄任何特殊要求或限制
- 根據經驗教訓更新本指南
- 在新增至 AGENT_CONFIG 之前驗證實際的 CLI 工具名稱

---

*每當新增代理程式時，應更新本文檔，以保持準確性和完整性。 *
