# 升級指南

> 您已安裝 Spec Kit 並希望升級到最新版本以獲得新功能、錯誤修復或更新的斜線命令。本指南涵蓋升級 CLI 工具和更新專案文件。

---

## 快速參考

| 升級什麼 | 命令 | 何時使用 |
|----------------|---------|-------------|
| **CLI 僅工具** | `uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git` | 無需接觸專案文件即可取得最新的 CLI 功能 |
| **專案文件** | `指定初始化 --here --force --ai <your-agent>` | 更新專案中的斜線命令、模板和腳本 |
| **兩個都** | 執行 CLI 升級，然後更新專案 | 推薦用於主要版本更新 |

---

## 第 1 部分：升級 CLI 工具

CLI 工具 (`specify`) 與您的專案文件是分開的。升級以獲得最新功能和錯誤修復。

### 如果您安裝了 `uv tool install`

```bash
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
```

### 如果您使用一次性 `uvx` 指令

無需升級 —`uvx` 始終取得最新版本。只需照常執行命令即可：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init --here --ai copilot
```

### 驗證升級

```bash
specify check
```

這顯示了已安裝的工具並確認 CLI 正在工作。

---

## 第 2 部分：更新專案文件

當 Spec Kit 發布新功能（例如新的斜線指令或更新的範本）時，您需要重新整理專案的 Spec Kit 檔案。

### 更新了什麼？

執行 `specify init --here --force` 將更新：

- ✅ **斜線指令檔**（`.claude/commands/`、`.github/prompts/` 等）
- ✅ **腳本檔** (`.specify/scripts/`)
- ✅ **範本文件** (`.specify/templates/`)
- ✅ **共享記憶體檔案** (`.specify/memory/`) - **⚠️ 請參閱下方的警告**

### 什麼保持安全？

升級**永遠不會觸及**這些文件 - 模板包甚至不包含它們：

- ✅ **您的規格**（`specs/001-my-feature/spec.md` 等）- **已確認安全**
- ✅ **您的實施計畫**（`specs/001-my-feature/plan.md`、`tasks.md` 等）- **確認安全**
- ✅ **您的原始碼** - **已確認安全性**
- ✅ **您的 git 歷史記錄** - **已確認安全**

`specs/` 目錄完全排除在模板包之外，並且在升級過程中永遠不會被修改。

### 更新命令

在您的專案目錄中執行此命令：

```bash
specify init --here --force --ai <your-agent>
```

替換 `<your-agent>` 與您的 AI 助理。請參閱 [支援的 AI 代理](../README.md#-supported-ai-agents) 的列表

**範例：**

```bash
specify init --here --force --ai copilot
```

### 了解 `--force` 標誌

如果沒有 `--force`，CLI 會警告您並要求確認：

```text
Warning: Current directory is not empty (25 items)
Template files will be merged with existing content and may 覆寫 existing files
Proceed? [y/N]
```

使用 `--force`，它會跳過確認並立即繼續。

**重要提示：您的 `specs/` 目錄始終是安全的。 ** `--force` 標誌僅影響範本檔案（指令、腳本、範本、記憶體）。您在 `specs/` 中的功能規格、計劃和任務永遠不會包含在升級包中，並且不能被覆蓋。

---

## ⚠️重要警告

### 1.憲法文件將被覆蓋

**已知問題：** `specify init --here --force` 目前會使用預設範本覆蓋 `.specify/memory/constitution.md`，從而刪除您所做的任何自訂設定。

**解決方法：**

```bash
# 1. Back up your constitution before upgrading
cp .specify/memory/constitution.md .specify/memory/constitution-backup.md

# 2. Run the upgrade
specify init --here --force --ai copilot

# 3. Restore your customized constitution
mv .specify/memory/constitution-backup.md .specify/memory/constitution.md
```

或使用git恢復：

```bash
# After upgrade, restore from git history
git restore .specify/memory/constitution.md
```

### 2.自訂範本修改

如果您在 `.specify/templates/` 中自訂了任何模板，升級將覆蓋它們。首先備份它們：

```bash
# Back up custom templates
cp -r .specify/templates .specify/templates-backup

# After upgrade, merge your changes back manually
```

### 3. 重複的斜線指令（基於IDE的代理）

某些基於 IDE 的代理程式（如 Kilo Code、Windsurf）可能會在升級後顯示**重複的斜槓指令** — 新舊版本都會出現。

**解決方案：** 從代理資料夾手動刪除舊命令檔案。

** Kilo Code 的範例：**

```bash
# Navigate to the agent's commands folder
cd .kilocode/rules/

# List files and identify duplicates
ls -la

# Delete old versions (example filenames - yours may differ)
rm speckit.specify-old.md
rm speckit.plan-v1.md
```

重新啟用您的 IDE 以刷新命令清單。

---

## 常見場景

### 場景 1：“我只想要新的斜杠指令”

```bash
# Upgrade CLI (if using persistent install)
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git

# Update project files to get new commands
specify init --here --force --ai copilot

# Restore your constitution if customized
git restore .specify/memory/constitution.md
```

### 場景2：“我定制了模板和章程”

```bash
# 1. Back up customizations
cp .specify/memory/constitution.md /tmp/constitution-backup.md
cp -r .specify/templates /tmp/templates-backup

# 2. Upgrade CLI
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git

# 3. Update project
specify init --here --force --ai copilot

# 4. Restore customizations
mv /tmp/constitution-backup.md .specify/memory/constitution.md
# Manually merge template changes if needed
```

### 場景 3：“我在 IDE 中看到重複的斜杠命令”

基於 IDE 的代理（Kilo Code、Windsurf、Roo Code 等）會發生這種情況。

```bash
# Find the agent folder (example: .kilocode/rules/)
cd .kilocode/rules/

# List all files
ls -la

# Delete old command files
rm speckit.old-command-name.md

# Restart your IDE
```

### 場景 4：“我正在開發一個沒有 Git 的專案”

如果您使用 `--no-git` 初始化專案，您仍然可以升級：

```bash
# Manually back up files you customized
cp .specify/memory/constitution.md /tmp/constitution-backup.md

# Run upgrade
specify init --here --force --ai copilot --no-git

# Restore customizations
mv /tmp/constitution-backup.md .specify/memory/constitution.md
```

`--no-git` 標誌會跳過 git 初始化，但不影響檔案更新。

---

## 使用 `--no-git` 標誌

`--no-git` 標誌告訴 Spec Kit **跳過 git 儲存庫初始化**。這在以下情況下很有用：

- 您以不同的方式管理版本控制（Mercurial、SVN 等）
- 您的專案是具有現有 git 設定的更大 monorepo 的一部分
- 您正在嘗試並且還不需要版本控制

**初始設定期間：**

```bash
specify init my-project --ai copilot --no-git
```

**升級期間：**

```bash
specify init --here --force --ai copilot --no-git
```

### `--no-git` 不做什麼

❌ 不阻止檔案更新
❌ 不跳過斜線指令安裝
❌ 不影響模板合併

它**僅**跳過執行 `git init` 並建立初始提交。

### 無需 Git 即可運作

如果您使用 `--no-git`，則需要手動管理功能目錄：

**在使用規劃指令之前設定 `SPECIFY_FEATURE` 環境變數**：

```bash
# Bash/Zsh
export SPECIFY_FEATURE="001-my-feature"

# PowerShell
$env:SPECIFY_FEATURE = "001-my-feature"
```

這告訴 Spec Kit 在建立規格、計畫和任務時要使用哪個功能目錄。

**為什麼這很重要：** 如果沒有 git，Spec Kit 無法偵測您目前的分支名稱來確定活動功能。環境變數手動提供該上下文。

---

## 故障排除

### “升級後斜槓指令不顯示”

**原因：** 代理未重新載入命令檔。

**修正方式：**

1. **完全重新啟用您的 IDE/編輯器**（而不僅僅是重新載入視窗）
2. **對於基於 CLI 的代理程式**，驗證檔案是否存在：

   ```bash
   ls -la .claude/commands/      # Claude Code
   ls -la .gemini/commands/       # Gemini
   ls -la .cursor/commands/       # Cursor
   ```

3. **檢查特定於代理的設定：**
   - Codex 需要 `CODEX_HOME` 環境變量
   - 某些代理程式需要重新啟用工作區或清除快取

### “我失去了我的憲法定制”

**修復：** 從 git 或備份還原：

```bash
# If you committed before upgrading
git restore .specify/memory/constitution.md

# If you backed up manually
cp /tmp/constitution-backup.md .specify/memory/constitution.md
```

**預防：** 在升級之前始終提交或備份 `constitution.md`。

### “警告：目前目錄不為空”

**完整警告訊息：**

```text
Warning: Current directory is not empty (25 items)
Template files will be merged with existing content and may 覆寫 existing files
Do you want to continue? [y/N]
```

**這意味著什麼：**

當您在已有檔案的目錄中執行 `specify init --here`（或 `specify init .`）時，會出現此警告。它在告訴你：

1. **該目錄已存在內容** - 在範例中，有 25 個檔案/folders
2. **文件將合併** - 新的範本文件將與現有文件一起添加
3. **某些檔案可能會被覆蓋** - 如果您已有 Spec Kit 檔案（`.claude/`、`.specify/` 等），它們將被新版本取代

**被覆蓋的內容：**

僅 Spec Kit 基礎架構文件：

- 代理指令檔（`.claude/commands/`、`.github/prompts/` 等）
- `.specify/scripts/` 中的腳本
- `.specify/templates/` 中的模板
- `.specify/memory/` 中的記憶體檔案（包括構成）

**保持不變的內容：**

- 您的 `specs/` 目錄（規格、計畫、任務）
- 您的原始碼文件
- 您的 `.git/` 目錄和 git 歷史記錄
- 不屬於 Spec Kit 範本的任何其他文件

**如何回應：**

- **輸入 `y` 並按 Enter** - 繼續合併（如果升級，建議這樣做）
- **輸入 `n` 並按 Enter** - 取消操作
- **使用 `--force` 標誌** - 完全跳過此確認：

  ```bash
  specify init --here --force --ai copilot
  ```

**當您看到此警告時：**

- ✅ **升級現有 Spec Kit 專案時的預期**
- ✅ **將 Spec Kit 加入現有程式碼函式庫時的預期**
- ⚠️ **意外**如果您認為自己是在空白目錄中建立新專案

**預防提示：** 在升級之前，請提交或備份您的 `.specify/memory/constitution.md`（如果您自訂了它）。

### “CLI 升級似乎不起作用”

驗證安裝：

```bash
# Check installed tools
uv tool list

# Should show specify-cli

# Verify path
which specify

# Should point to the uv tool installation directory
```

如果找不到，請重新安裝：

```bash
uv tool uninstall specify-cli
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

### “我每次打開專案時都需要執行指定嗎？”

**簡短回答：** 不，每個專案（或升級時）僅執行 `specify init` 一次。

**解釋：**

`specify` CLI 工具用於：

- **初始設定：** `specify init` 在您的專案中引導 Spec Kit
- **升級：** `specify init --here --force` 更新範本和指令
- **診斷：** `specify check` 驗證工具安裝

執行 `specify init` 後，斜槓指令（如 `/speckit.specify`、`/speckit.plan` 等）將**永久安裝**在專案的代理資料夾（`.claude/`、`.github/prompts/` 等）中。您的 AI 助理直接讀取這些命令文件，無需再次執行 `specify`。

**如果您的代理商無法辨識斜線指令：**

1. **驗證命令檔是否存在：**

   ```bash
   # For GitHub Copilot
   ls -la .github/prompts/

   # For Claude
   ls -la .claude/commands/
   ```

2. **完全重新啟用您的 IDE/編輯器**（不僅僅是重新載入視窗）

3. **檢查您是否位於執行 `specify init` 的正確目錄**

4. **對於某些代理程式**，您可能需要重新載入工作區或清除快取

**相關問題：** 如果 Copilot 無法開啟本機檔案或意外使用 PowerShell 指令，這通常是 IDE 上下文問題，與 `specify` 無關。嘗試：

- 重新啟用 VS Code
- 檢查檔案權限
- 確保工作區資料夾已正確開啟

---

## 版本相容性

Spec Kit 遵循主要版本的語意版本控制。 CLI 和專案文件設計為在同一主要版本中相容。

**最佳實務：** 在主要版本變更期間一起升級，使 CLI 和專案檔案保持同步。

---

## 下一步

升級後：

- **測試新的斜線指令：** 執行 `/speckit.constitution` 或其他指令來驗證一切正常
- **查看發行說明：** 檢查 [GitHub 發布](https://github.com/github/spec-kit/releases) 是否有新功能和重大更改
- **更新工作流程：** 如果新增了新指令，請更新團隊的開發工作流程
- **檢查文件：** 造訪 [github.io/spec-kit](https://github.github.io/spec-kit/) 以取得更新指南
