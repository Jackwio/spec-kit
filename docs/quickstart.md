# 快速入門指南

本指南將幫助您開始使用 Spec Kit 來使用 Spec-Driven Development。

> [！筆記]
> 所有自動化腳本現在都提供 Bash (`.sh`) 和 PowerShell (`.ps1`) 變體。 `specify` CLI 根據作業系統自動選擇，除非您透過 `--script sh|ps`。

## 六步驟流程

> [！提示]
> **上下文感知**：Spec Kit 指令會根據您目前的 Git 分支（例如 `001-feature-name`）自動偵測活動功能。要在不同規格之間切換，只需切換 Git 分支即可。

### 第1步：安裝指定

**在終端機中**，執行 `specify` CLI 指令來初始化您的專案：

```bash
# Create a new project directory
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# OR initialize in the current directory
uvx --from git+https://github.com/github/spec-kit.git specify init .
```

明確選擇腳本類型（可選）：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script ps  # Force PowerShell
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script sh  # Force POSIX shell
```

### 第二步：定義你的憲法

**在您的 AI 代理程式的聊天介面**，使用 `/speckit.constitution` 斜線指令為您的專案建立核心規則和原則。您應該提供專案的具體原則作為論點。

```markdown
/speckit.constitution This project follows a "Library-First" approach. All features must be implemented as standalone libraries first. We use TDD strictly. We prefer functional programming patterns.
```

### 第 3 步：建立規範

**在聊天中**，使用 `/speckit.specify` 斜線命令來描述您想要建立的內容。專注於**什麼**和**為什麼**，而不是技術堆疊。

```markdown
/speckit.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

### 第 4 步：完善規範

**在聊天中**，使用 `/speckit.clarify` 斜線指令來辨識和解決規範中的歧義。您可以提供特定的重點領域作為參數。

```bash
/speckit.clarify Focus on security and performance requirements.
```

### 第 5 步：制定技術實施計劃

**在聊天中**，使用 `/speckit.plan` 斜線指令提供您的技術堆疊和架構選擇。

```markdown
/speckit.plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.
```

### 第 6 步：分解並實施

**在聊天中**，使用 `/speckit.tasks` 斜線指令建立可操作的任務清單。

```markdown
/speckit.tasks
```

（可選）使用 `/speckit.analyze` 驗證計劃：

```markdown
/speckit.analyze
```

然後，使用 `/speckit.implement` 斜線指令執行計畫。

```markdown
/speckit.implement
```

> [！提示]
> **分階段實施**：對於複雜的專案，分階段實施以避免壓倒代理的上下文。從核心功能開始，驗證其工作原理，然後逐步添加功能。

## 詳細範例：建立 Taskify

以下是建立團隊生產力平台的完整範例：

### 第一步：定義憲法

初始化專案的章程以設定基本規則：

```markdown
/speckit.constitution Taskify is a "Security-First" application. All user inputs must be validated. We use a microservices architecture. Code must be fully documented.
```

### 第 2 步：使用 `/speckit.specify` 定義需求

```text
Develop Taskify, a team productivity platform. It should allow users to create projects, add team members,
assign tasks, comment and move tasks between boards in Kanban style. In this initial phase for this feature,
let's call it "Create Taskify," let's have multiple users but the users will be declared ahead of time, predefined.
I want five users in two different categories, one product manager and four engineers. Let's create three
different sample projects. Let's have the standard Kanban columns for the status of each task, such as "To Do,"
"In Progress," "In Review," and "Done." There will be no login for this application as this is just the very
first testing thing to ensure that our basic features are set up.
```

### 第 3 步：完善規範

使用 `/speckit.clarify` 指令以互動方式解決規範中的任何歧義。您還可以提供您想要確保包含在內的具體詳細資訊。

```bash
/speckit.clarify I want to clarify the task card details. For each task in the UI for a task card, you should be able to change the current status of the task between the different columns in the Kanban work board. You should be able to leave an unlimited number of comments for a particular card. You should be able to, from that task card, assign one of the valid users.
```

您可以使用 `/speckit.clarify` 繼續細化規格並提供更多詳細資訊：

```bash
/speckit.clarify When you first launch Taskify, it's going to give you a list of the five users to pick from. There will be no password required. When you click on a user, you go into the main view, which displays the list of projects. When you click on a project, you open the Kanban board for that project. You're going to see the columns. You'll be able to drag and drop cards back and forth between different columns. You will see any cards that are assigned to you, the currently logged in user, in a different color from all the other ones, so you can quickly see yours. You can edit any comments that you make, but you can't edit comments that other people made. You can delete any comments that you made, but you can't delete comments anybody else made.
```

### 第 4 步：驗證規格

使用 `/speckit.checklist` 指令驗證規格清單：

```bash
/speckit.checklist
```

### 第 5 步：使用 `/speckit.plan` 產生技術計劃

具體說明您的技術堆疊和技術要求：

```bash
/speckit.plan We are going to generate this using .NET Aspire, using Postgres as the database. The frontend should use Blazor server with drag-and-drop task boards, real-time updates. There should be a REST API created with a projects API, tasks API, and a notifications API.
```

### 第 6 步：定義任務

使用 `/speckit.tasks` 指令產生可操作的任務清單：

```bash
/speckit.tasks
```

### 第 7 步：驗證與實施

讓您的 AI 代理程式使用 `/speckit.analyze` 審核實施計畫：

```bash
/speckit.analyze
```

最後，實施解決方案：

```bash
/speckit.implement
```

> [！提示]
> **分階段實施**：對於像 Taskify 這樣的大型專案，考慮分階段實施（例如，第 1 階段：基本專案/task 結構，第 2 階段：看板功能，第 3 階段：評論和作業）。這可以防止上下文飽和並允許在每個階段進行驗證。

## 關鍵原則

- **明確**您正在建造什麼以及為什麼
- **在規範階段不要專注於技術堆疊**
- **在實施之前迭代並完善**您的規範
- **在編碼開始之前驗證**計劃
- **讓 AI 代理處理**實作細節

## 下一步

- 閱讀 [完整的方法論](../spec-driven.md) 以獲得深入指導
- 在儲存庫中查看 [更多例子](../templates)
- 探索 [GitHub 上的原始碼](https://github.com/github/spec-kit)
