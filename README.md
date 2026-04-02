# This is a Chinese translation of the original project.

Original project:
https://github.com/github/spec-kit

License: MIT
Copyright GitHub, Inc.

<div align="center">
    <img src="./media/logo_large.webp" alt="Spec Kit 標誌" width="200" height="200"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快地建立高品質軟體。</em></h3>
</div>

<p align="center">
    <strong>一個開源工具包，可讓您專注於產品場景和可預測的結果，而不是從頭開始對每個部分進行編碼。</strong>
</p>

<p align="center">
    <a href="https://github.com/github/spec-kit/actions/workflows/release.yml"><img src="https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg" alt="發布"/></a>
    <a href="https://github.com/github/spec-kit/stargazers"><img src="https://img.shields.io/github/stars/github/spec-kit?style=social" alt="GitHub 星星"/></a>
    <a href="https://github.com/github/spec-kit/blob/main/LICENSE"><img src="https://img.shields.io/github/license/github/spec-kit" alt="執照"/></a>
    <a href="https://github.github.io/spec-kit/"><img src="https://img.shields.io/badge/docs-GitHub_Pages-blue" alt="文件"/></a>
</p>

---

## 目錄

- [🤔 什麼是 Spec-Driven Development？](#什麼是-spec-driven-development)
- [⚡ 開始吧](#開始吧)
- [📽️影片概述](#影片概述)
- [🤖 支援 AI 代理](#支援-ai-代理)
- [🔧 Specify CLI 參考](#specify-cli-參考)
- [📚 核心理念](#核心理念)
- [🌟 發展階段](#發展階段)
- [🎯 實驗目標](#實驗目標)
- [🔧 先決條件](#先決條件)
- [📖 了解更多](#了解更多)
- [📋詳細流程](#詳細流程)
- [🔍 故障排除](#故障排除)
- [💬 支持](#支持)
- [🙏致謝](#致謝)
- [📄 許可證](#許可證)

## 🤔 什麼是 Spec-Driven Development？

Spec-Driven Development **翻轉傳統軟體開發的腳本**。幾十年來，程式碼一直是王道——規範只是我們建造的腳手架，一旦編碼的「真正工作」開始就被丟棄。 Spec-Driven Development 改變了這一點：**規範變得可執行**，直接產生工作實現，而不僅僅是指導它們。

## ⚡ 開始吧

### 1.安裝Specify CLI

選擇您喜歡的安裝方法：

#### 選項 1：持久安裝（建議）

安裝一次並隨處使用：

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

然後直接使用該工具：

```bash
# Create new project
specify init <PROJECT_NAME>

# Or initialize in existing project
specify init . --ai claude
# or
specify init --here --ai claude

# Check installed tools
specify check
```

若要升級指定，請參閱 [升級指南](./docs/upgrade.md) 以了解詳細說明。快速升級：

```bash
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
```

#### 選項 2：一次性使用

無需安裝直接運作：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

**持久安裝的好處：**

- 工具在 PATH 中保持安裝狀態並可用
- 無需建立 shell 別名
- 透過 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 來實現更好的刀具管理
- 更乾淨的外殼設定

### 2. 建立專案原則

在專案目錄中啟用 AI 助手。 `/speckit.*` 指令在助手中可用。

使用 **`/speckit.constitution`** 指令建立專案的管理原則和開髮指南，以指導所有後續開發。

```bash
/speckit.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements
```

### 3. 建立規範

使用 **`/speckit.specify`** 指令描述您想要建立的內容。專注於**什麼**和**為什麼**，而不是技術堆疊。

```bash
/speckit.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

### 4.制定技術實施計劃

使用 **`/speckit.plan`** 指令提供您的技術堆疊和架構選擇。

```bash
/speckit.plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.
```

### 5. 分解任務

使用 **`/speckit.tasks`** 根據您的實施計畫建立可操作的任務清單。

```bash
/speckit.tasks
```

### 6.執行實施

使用 **`/speckit.implement`** 執行所有任務並根據計劃建立您的功能。

```bash
/speckit.implement
```

有關詳細的逐步說明，請參閱我們的 [綜合指南](./spec-driven.md)。

## 📽️影片概述

想看看 Spec Kit 的實際效果嗎？看我們的 [影片概覽](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)！

[![Spec Kit 影片標題](/media/spec-kit-video-header.jpg)](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)

## 🤖 支援 AI 代理

| 代理人                                                                                | 支援 | 筆記                                                                                                                                     |
| ------------------------------------------------------------------------------------ | ------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| [Qoder CLI](https://qoder.com/cli)                                                   | ✅      |                                                                                                                                           |
| [Amazon Q Developer CLI](https://aws.amazon.com/developer/learning/q-developer-cli/) | ⚠️      | Amazon Q Developer CLI [不支援](https://github.com/aws/amazon-q-developer-cli/issues/3064) 斜線指令的自訂參數。 |
| [Amp](https://ampcode.com/)                                                          | ✅      |                                                                                                                                           |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview)                              | ✅      |                                                                                                                                           |
| [Claude Code](https://www.anthropic.com/claude-code)                                 | ✅      |                                                                                                                                           |
| [CodeBuddy CLI](https://www.codebuddy.ai/cli)                                        | ✅      |                                                                                                                                           |
| [Codex CLI](https://github.com/openai/codex)                                         | ✅      |                                                                                                                                           |
| [Cursor](https://cursor.sh/)                                                         | ✅      |                                                                                                                                           |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli)                            | ✅      |                                                                                                                                           |
| [GitHub Copilot](https://code.visualstudio.com/)                                     | ✅      |                                                                                                                                           |
| [IBM Bob](https://www.ibm.com/products/bob)                                          | ✅      | 基於 IDE 的代理，支援斜線指令                                                                                                |
| [朱爾斯](https://jules.google.com/)                                                   | ✅      |                                                                                                                                           |
| [Kilo Code](https://github.com/Kilo-Org/kilocode)                                    | ✅      |                                                                                                                                           |
| [opencode](https://opencode.ai/)                                                     | ✅      |                                                                                                                                           |
| [Qwen Code](https://github.com/QwenLM/qwen-code)                                     | ✅      |                                                                                                                                           |
| [Roo Code](https://roocode.com/)                                                     | ✅      |                                                                                                                                           |
| [SHAI (OVHcloud)](https://github.com/ovh/shai)                                       | ✅      |                                                                                                                                           |
| [Windsurf](https://windsurf.com/)                                                    | ✅      |                                                                                                                                           |
| [反重力（agy）](https://agy.ai/)                                                 | ✅      |                                                                                                                                           |
| 通用的                                                                              | ✅      | 帶上你自己的代理 - 使用 `--ai generic --ai-commands-dir <path>` 對於不受支援的代理                                                 |

## 🔧 Specify CLI 參考

`specify` 指令支援以下選項：

### 命令

| 命令 | 描述                                                                                                                                             |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `init`  | 從最新範本初始化新的 Specify 專案                                                                                               |
| `check` | 檢查已安裝的工具（`git`、`claude`、`gemini`、`code`/`code-insiders`、`cursor-agent`、`windsurf`、`qwen`、`opencode`、`codex`、`shai`、`qodercli`） |

### `specify init` 參數與選項

| 參數/選項        | 類型     | 描述                                                                                                                                                                                  |
| ---------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `<project-name>`       | 參數 | 新專案目錄名稱（若使用 `--here` 則可省略，或使用 `.` 代表目前目錄）                                                                                           |
| `--ai`                 | 選項   | 要使用的 AI 助理：`claude`、`gemini`、`copilot`、`cursor-agent`、`qwen`、`opencode`、`codex`、`windsurf`、`kilocode`、`auggie`、`roo`、`codebuddy`、`amp`、`shai`、`q`、`agy`、`bob`、`qodercli`，或 `generic`（需搭配 `--ai-commands-dir`） |
| `--ai-commands-dir`    | 選項   | 代理命令檔案的目錄（`--ai generic` 需要，例如 `.myagent/commands/`）                                                                                                  |
| `--script`             | 選項   | 要使用的腳本變體：`sh` (bash/zsh) 或 `ps` (PowerShell)                                                                                                                                  |
| `--ignore-agent-tools` | 旗幟     | 跳過對 AI 代理工具（如 Claude Code）的檢查                                                                                                                                              |
| `--no-git`             | 旗幟     | 跳過 git 儲存庫初始化                                                                                                                                                           |
| `--here`               | 旗幟     | 在當前目錄中初始化專案而不是建立新專案                                                                                                                    |
| `--force`              | 旗幟     | 在目前目錄中初始化時強制合併/覆寫（跳過確認）                                                                                                             |
| `--skip-tls`           | 旗幟     | 跳過 SSL/TLS 驗證（不建議）                                                                                                                                                  |
| `--debug`              | 旗幟     | 啟用詳細的調試輸出以進行故障排除                                                                                                                                             |
| `--github-token`       | 選項   | GitHub 令牌用於 API 請求（或設定 GH_TOKEN/GITHUB_TOKEN 環境變數）                                                                                                                    |
| `--ai-skills`          | 旗幟     | 在特定代理的 `skills/` 目錄中安裝 Prompt.MD 範本作為代理技能（需要 `--ai`）                                                                                          |

### 範例

```bash
# Basic project initialization
specify init my-project

# Initialize with specific AI assistant
specify init my-project --ai claude

# Initialize with Cursor support
specify init my-project --ai cursor-agent

# Initialize with Qoder support
specify init my-project --ai qodercli

# Initialize with Windsurf support
specify init my-project --ai windsurf

# Initialize with Amp support
specify init my-project --ai amp

# Initialize with SHAI support
specify init my-project --ai shai

# Initialize with IBM Bob support
specify init my-project --ai bob

# Initialize with an unsupported agent (generic / bring your own agent)
specify init my-project --ai generic --ai-commands-dir .myagent/commands/

# Initialize with PowerShell scripts (Windows/cross-platform)
specify init my-project --ai copilot --script ps

# Initialize in current directory
specify init . --ai copilot
# or use the --here flag
specify init --here --ai copilot

# Force merge into current (non-empty) directory without confirmation
specify init . --force --ai copilot
# or
specify init --here --force --ai copilot

# Skip git initialization
specify init my-project --ai gemini --no-git

# Enable debug output for troubleshooting
specify init my-project --ai claude --debug

# Use GitHub token for API requests (helpful for corporate environments)
specify init my-project --ai claude --github-token ghp_your_token_here

# Install agent skills with the project
specify init my-project --ai claude --ai-skills

# Initialize in current directory with agent skills
specify init --here --ai gemini --ai-skills

# Check system requirements
specify check
```

### 可用的斜杠命令

執行 `specify init` 後，您的 AI 編碼代理程式將可以存取這些斜線命令以進行結構化開發：

#### 核心指令

Spec-Driven Development 工作流程的基本指令：

| 命令                 | 描述                                                              |
| ----------------------- | ------------------------------------------------------------------------ |
| `/speckit.constitution` | 建立或更新專案管理原則和開髮指南 |
| `/speckit.specify`      | 定義您想要建立的內容（需求和使用者故事）            |
| `/speckit.plan`         | 使用您選擇的技術堆疊建立技術實施計劃        |
| `/speckit.tasks`        | 產生可操作的任務清單以供實施                        |
| `/speckit.implement`    | 根據計劃執行所有任務以建立功能             |

#### 可選命令

用於增強品質和驗證的附加命令：

| 命令              | 描述                                                                                                                          |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `/speckit.clarify`   | 澄清未指定的區域（建議在 `/speckit.plan` 之前；以前是 `/quizme`）                                                |
| `/speckit.analyze`   | 跨工件一致性與覆蓋率分析（在 `/speckit.tasks` 之後、 `/speckit.implement` 之前執行）                             |
| `/speckit.checklist` | 產生自訂品質檢查表，以驗證需求的完整性、清晰度和一致性（例如「英語單元測試」） |

### 環境變數

| 多變的          | 描述                                                                                                                                                                                                                                                                                            |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `SPECIFY_FEATURE` | 覆寫非 Git 儲存庫的功能偵測。設定為功能目錄名稱（例如 `001-photo-albums`）以在不使用 Git 分支時處理特定功能。<br/>\*\*必須在使用 `/speckit.plan` 或後續命令之前在您正在使用的代理程式上下文中進行設定。 |

## 📚 核心理念

Spec-Driven Development 是一個結構化流程，強調：

- **意圖驅動的開發**，其中規範在“*如何*”之前定義“*什麼*”
- **使用護欄和組織原則創造豐富的規範**
- **多步驟細化**而不是根據提示一次性產生程式碼
- **嚴重依賴**先進的 AI 模型功能進行規範解釋

## 🌟 發展階段

| 階段                                    | 重點                    | 主要活動                                                                                                                                                     |
| ---------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **0對1開發**（“綠地”）    | 從頭開始生成    | <ul><li>從高水準要求開始</li><li>產生規格</li><li>計劃實施步驟</li><li>建立生產就緒的應用程式</li></ul> |
| **創意探索**                 | 平行實現 | <ul><li>探索多樣化的解決方案</li><li>支援多種技術棧和架構</li><li>嘗試使用者體驗模式</li></ul>                         |
| **迭代增強**（“棕地”） | 棕地現代化 | <ul><li>迭代添加功能</li><li>將遺留系統進行現代化改造</li><li>調整流程</li></ul>                                                                |

## 🎯 實驗目標

我們的研究和實驗重點是：

### 技術獨立性

- 使用不同的技術堆疊建立應用程式
- 驗證以下假設：Spec-Driven Development 是一個與特定技術、程式語言或框架無關的進程

### 企業約束

- 展示關鍵任務應用程式開發
- 納入組織約束（雲端提供者、技術堆疊、工程實務）
- 支援企業設計系統和合規性要求

### 以使用者為中心的開發

- 為不同的用戶群體和偏好建立應用程式
- 支援各種開發方法（從vivi-coding到AI-native開發）

### 創意和迭代過程

- 驗證並行實施探索的概念
- 提供強大的迭代功能開發工作流程
- 擴展流程以處理升級和現代化任務

## 🔧 先決條件

- **Linux/macOS/Windows**
- [支援的 AI 代理](#-支援-ai-代理)。
- [uv](https://docs.astral.sh/uv/) 用於套件管理
- [Python 3.11+](https://www.python.org/downloads/)
- [git](https://git-scm.com/downloads)

如果您遇到代理問題，請提出問題，以便我們改進整合。

## 📖 了解更多

- **[完整的 Spec-Driven Development 方法](./spec-driven.md)** - 深入了解整個過程
- **[詳細演練](#詳細演練)** - 逐步實施指南

---

## 📋詳細流程

<details>
<summary>點擊展開詳細的分步演練</summary>

您可以使用 Specify CLI 引導您的專案，這將在您的環境中引入所需的工件。跑步：

```bash
specify init <project_name>
```

或在當前目錄初始化：

```bash
specify init .
# or use the --here flag
specify init --here
# Skip confirmation when the directory already has files
specify init . --force
# or
specify init --here --force
```

![Specify CLI 在終端機中引導一個新專案](./media/specify_cli.gif)

系統將提示您選擇您正在使用的 AI 代理程式。您也可以直接在終端機中主動指定它：

```bash
specify init <project_name> --ai claude
specify init <project_name> --ai gemini
specify init <project_name> --ai copilot

# Or in current directory:
specify init . --ai claude
specify init . --ai codex

# or use --here flag
specify init --here --ai claude
specify init --here --ai codex

# Force merge into a non-empty current directory
specify init . --force --ai claude

# or
specify init --here --force --ai claude
```

CLI 將檢查您是否安裝了 Claude Code、Gemini CLI、Cursor CLI、Qwen CLI、opencode、Codex CLI、Qoder CLI 或 Amazon Q Developer CLI。如果您不這樣做，或者您希望在不檢查正確工具的情況下取得模板，請在命令中使用 `--ignore-agent-tools`：

```bash
specify init <project_name> --ai claude --ignore-agent-tools
```

### **第 1 步：** 建立專案原則

轉到專案資料夾並執行您的 AI 代理程式。在我們的範例中，我們使用 `claude`。

![引導 Claude Code 環境](./media/bootstrap-claude-code.gif)

如果您看到 `/speckit.constitution`、`/speckit.specify`、`/speckit.plan`、`/speckit.tasks` 和 `/speckit.implement` 指令可用，表示設定正確。

第一步應該是使用 `/speckit.constitution` 指令建立專案的管理原則。這有助於確保在所有後續開發階段做出一致的決策：

```text
/speckit.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements. Include governance for how these principles should guide technical decisions and implementation choices.
```

此步驟使用 AI 代理程式將在規範、規劃和實施階段參考的專案基本準則建立或更新 `.specify/memory/constitution.md` 檔案。

### **第 2 步：** 建立專案規範

確定了專案原則後，您現在可以建立功能規格。使用 `/speckit.specify` 指令，然後提供您要開發的專案的具體要求。

> [！重要的]
> 盡可能明確地說明您正在嘗試建立的*什麼*以及*為什麼*。 **此時不要注意技術堆疊**。

提示範例：

```text
Develop Taskify, a team productivity platform. It should allow users to create projects, add team members,
assign tasks, comment and move tasks between boards in Kanban style. In this initial phase for this feature,
let's call it "Create Taskify," let's have multiple users but the users will be declared ahead of time, predefined.
I want five users in two different categories, one product manager and four engineers. Let's create three
different sample projects. Let's have the standard Kanban columns for the status of each task, such as "To Do,"
"In Progress," "In Review," and "Done." There will be no login for this application as this is just the very
first testing thing to ensure that our basic features are set up. For each task in the UI for a task card,
you should be able to change the current status of the task between the different columns in the Kanban work board.
You should be able to leave an unlimited number of comments for a particular card. You should be able to, from that task
card, assign one of the valid users. When you first launch Taskify, it's going to give you a list of the five users to pick
from. There will be no password required. When you click on a user, you go into the main view, which displays the list of
projects. When you click on a project, you open the Kanban board for that project. You're going to see the columns.
You'll be able to drag and drop cards back and forth between different columns. You will see any cards that are
assigned to you, the currently logged in user, in a different color from all the other ones, so you can quickly
see yours. You can edit any comments that you make, but you can't edit comments that other people made. You can
delete any comments that you made, but you can't delete comments anybody else made.
```

輸入此提示後，您應該會看到 Claude Code 啟用規劃和規範起草過程。 Claude Code 也會觸發一些內建腳本來設定儲存庫。

完成此步驟後，您應該建立一個新分支（例如 `001-create-taskify`），並在 `specs/001-create-taskify` 目錄中建立一個新規格。

產生的規格應包含模板中定義的一組使用者故事和功能需求。

在此階段，您的專案資料夾內容應類似於以下內容：

```text
└── .specify
    ├── memory
    │  └── constitution.md
    ├── scripts
    │  ├── check-prerequisites.sh
    │  ├── common.sh
    │  ├── create-new-feature.sh
    │  ├── setup-plan.sh
    │  └── update-claude-md.sh
    ├── specs
    │  └── 001-create-taskify
    │      └── spec.md
    └── templates
        ├── plan-template.md
        ├── spec-template.md
        └── tasks-template.md
```

### **第3步：**功能規範澄清（規劃前需）

建立基線規格後，您可以繼續澄清第一次嘗試中未正確捕獲的任何需求。

您應該在建立技術計劃之前執行結構化澄清工作流程以減少下游返工。

首選訂單：

1. 使用 `/speckit.clarify`（結構化）－順序、基於覆蓋範圍的提問，將答案記錄在「澄清」部分。
2. 如果仍然感覺模糊，可以選擇進行臨時的自由形式細化。

如果您故意想要跳過澄清（例如，尖峰或探索性原型），請明確說明，以便代理商不會阻止缺少的澄清。

自由形式細化提示範例（如果仍需要，則在 `/speckit.clarify` 之後）：

```text
For each sample project or project that you create there should be a variable number of tasks between 5 and 15
tasks for each one randomly distributed into different states of completion. Make sure that there's at least
one task in each stage of completion.
```

您也應該要求 Claude Code 驗證**審核和驗收清單**，勾選已驗證的內容/pass 要求，並保留未選取的內容。可使用以下提示：

```text
Read the review and acceptance checklist, and check off each item in the checklist if the feature spec meets the criteria. Leave it empty if it does not.
```

重要的是要利用與 Claude Code 的交互作為澄清和提出有關規範的問題的機會 - **不要將其第一次嘗試視為最終**。

### **第 4 步：** 制定計劃

現在您可以具體了解技術堆疊和其他技術要求。您可以使用專案範本中內建的 `/speckit.plan` 指令，並顯示以下提示：

```text
We are going to generate this using .NET Aspire, using Postgres as the database. The frontend should use
Blazor server with drag-and-drop task boards, real-time updates. There should be a REST API created with a projects API,
tasks API, and a notifications API.
```

此步驟的輸出將包括許多實作細節文檔，您的目錄樹類似於：

```text
.
├── CLAUDE.md
├── memory
│  └── constitution.md
├── scripts
│  ├── check-prerequisites.sh
│  ├── common.sh
│  ├── create-new-feature.sh
│  ├── setup-plan.sh
│  └── update-claude-md.sh
├── specs
│  └── 001-create-taskify
│      ├── contracts
│      │  ├── api-spec.json
│      │  └── signalr-spec.md
│      ├── data-model.md
│      ├── plan.md
│      ├── quickstart.md
│      ├── research.md
│      └── spec.md
└── templates
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

檢查 `research.md` 文檔，確保根據您的說明使用正確的技術堆疊。如果有任何元件突出，您可以要求 Claude Code 對其進行改進，甚至讓它檢查您要使用的平台 /framework 的本機安裝版本（例如 .NET）。

此外，如果所選技術堆疊正在快速變化（例如 .NET Aspire、JS 框架），您可能需要要求 Claude Code 研究有關所選技術堆疊的詳細信息，提示如下：

```text
I want you to go through the implementation plan and implementation details, looking for areas that could
benefit from additional research as .NET Aspire is a rapidly changing library. For those areas that you identify that
require further research, I want you to update the research document with additional details about the specific
versions that we are going to be using in this Taskify application and spawn parallel research tasks to clarify
any details using research from the web.
```

在此過程中，您可能會發現 Claude Code 陷入了研究錯誤的事情 - 您可以透過以下提示協助將其推向正確的方向：

```text
I think we need to break this down into a series of steps. First, identify a list of tasks
that you would need to do during implementation that you're not sure of or would benefit
from further research. Write down a list of those tasks. And then for each one of these tasks,
I want you to spin up a separate research task so that the net results is we are researching
all of those very specific tasks in parallel. What I saw you doing was it looks like you were
researching .NET Aspire in general and I don't think that's gonna do much for us in this case.
That's way too untargeted research. The research needs to help you solve a specific targeted question.
```

> [！筆記]
> Claude Code 可能過於渴望並添加了您不需要的組件。要求其澄清變更的理由和來源。

### **第 5 步：** 讓 Claude Code 驗證計劃

計劃到位後，您應該讓 Claude Code 仔細檢查它，以確保沒有遺漏的部分。您可以使用這樣的提示：

```text
Now I want you to go and audit the implementation plan and the implementation detail files.
Read through it with an eye on determining whether or not there is a sequence of tasks that you need
to be doing that are obvious from reading this. Because I don't know if there's enough here. For example,
when I look at the core implementation, it would be useful to reference the appropriate places in the implementation
details where it can find the information as it walks through each step in the core implementation or in the refinement.
```

這有助於完善實施計劃，並幫助您避免 Claude Code 在其規劃週期中錯過的潛在盲點。初始細化階段完成後，請 Claude Code 再次檢查清單，然後才能開始實施。

您也可以要求 Claude Code（如果您安裝了 [GitHub CLI](https://docs.github.com/en/github-cli/github-cli)）繼續建立從目前分支到 `main` 的拉取請求，並附上詳細說明，以確保正確追蹤工作。

> [！筆記]
> 在讓代理實作之前，也值得提示 Claude Code 交叉檢查細節，看看是否有任何過度設計的部分（記住 - 它可能過於渴望）。如果存在過度設計的組件或決策，您可以要求 Claude Code 來解決它們。確保 Claude Code 遵循 [憲法](base/memory/constitution.md) 作為製定計劃時必須遵守的基礎部分。

### **第 6 步：** 使用 /speckit.tasks 產生任務細分

驗證實施計劃後，您現在可以將計劃分解為具體的、可操作的任務，並且可以按正確的順序執行。使用 `/speckit.tasks` 指令根據您的實施計畫自動產生詳細的任務分解：

```text
/speckit.tasks
```

此步驟會在功能規格目錄中建立一個 `tasks.md` 文件，其中包含：

- **按使用者故事組織的任務分解** - 每個使用者故事都成為一個單獨的實施階段，具有自己的一組任務
- **依賴關係管理** - 任務被排序以尊重元件之間的依賴關係（例如，模型在服務之前，服務在端點之前）
- **並行執行標記** - 可以並行執行的任務標有 `[P]` 以優化開發工作流程
- **檔案路徑規格** - 每個任務都包含應該執行的確切檔案路徑
- **測試驅動的開發結構** - 如果需要測試，則包含測試任務並命令在實施之前編寫
- **檢查點驗證** - 每個使用者故事階段都包含用於驗證獨立功能的檢查點

產生的tasks.md為`/speckit.implement`指令提供了清晰的路線圖，確保系統實施，保持程式碼品質並允許增量交付使用者故事。

### **第 7 步：** 實施

準備好後，使用 `/speckit.implement` 指令執行您的實施計畫：

```text
/speckit.implement
```

`/speckit.implement` 指令將：

- 驗證所有先決條件均已到位（章程、規範、計劃和任務）
- 從 `tasks.md` 解析任務分解
- 以正確的順序執行任務，尊重依賴性和並行執行標記
- 遵循任務計劃中定義的 TDD 方法
- 提供進度更新並適當處理錯誤

> [！重要的]
> AI 代理程式將執行本機 CLI 指令（例如 `dotnet`、`npm` 等） - 確保您的電腦上安裝了所需的工具。

實現完成後，測試應用程式並解決 CLI 日誌中可能不可見的任何執行時間錯誤（例如，瀏覽器控制台錯誤）。您可以將此類錯誤複製並貼上回您的 AI 代理程式以尋求解決。

</details>

---

## 🔍 故障排除

### Linux 上的 Git 憑證管理器

如果您在 Linux 上遇到 Git 驗證問題，可以安裝 Git Credential Manager：

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```

## 💬 支持

如需支持，請打開 [GitHub 問題](https://github.com/github/spec-kit/issues/new)。我們歡迎錯誤報告、功能請求以及使用 Spec-Driven Development 的問題。

## 🙏致謝

該計畫深受 [林俊傑](https://github.com/jflam) 的工作和研究的影響並基於其基礎。

## 📄 許可證

此專案根據 MIT 開源許可證條款獲得許可。請參閱 [執照](./LICENSE) 文件以了解完整條款。
