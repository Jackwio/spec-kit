# 分機使用指南

使用 Spec Kit 擴充功能來增強您的工作流程的完整指南。

## 目錄

1. [介紹](#介紹)
2. [入門](#入門)
3. [尋找擴充](#尋找擴充)
4. [安裝擴充](#安裝擴充)
5. [使用擴充](#使用擴充)
6. [管理擴充](#管理擴充)
7. [設定](#設定)
8. [故障排除](#故障排除)
9. [最佳實踐](#最佳實踐)

---

## 介紹

### 什麼是擴充？

擴充功能是模組化包，可為 Spec Kit 新增指令和功能，而不會使核心框架變得臃腫。它們允許您：

- **與外部工具整合**（Jira、Linear、GitHub 等）
- **使用鉤子自動化**重複性任務
- **為您的團隊客製化**工作流程
- **跨專案共享**解決方案

### 為什麼要使用擴充？

- **清潔核心**：保持規格套件輕量且專注
- **選用功能**：僅安裝您需要的功能
- **社群驅動**：任何人都可以建立和分享擴展
- **版本控制**：擴充是獨立版本控制的

---

## 入門

### 先決條件

- Spec Kit 版本 0.1.0 或更高版本
- 規格套件專案（帶有 `.specify/` 資料夾的目錄）

### 檢查您的版本

```bash
specify version
# Should show 0.1.0 or higher
```

### 第一次延期

我們以安裝 Jira 擴充功能為例：

```bash
# 1. Search for the extension
specify extension search jira

# 2. Get detailed information
specify extension info jira

# 3. Install it
specify extension add jira

# 4. Configure it
vim .specify/extensions/jira/jira-config.yml

# 5. Use it
# (Commands are now available in Claude Code)
/speckit.jira.specstoissues
```

---

## 尋找擴充

**注意**：預設情況下，`specify extension search` 使用您組織的目錄 (`catalog.json`)。如果目錄為空，您將看不到任何結果。請參閱 [擴充目錄](#擴充目錄) 以了解如何從社區參考目錄填入您的目錄。

### 瀏覽所有擴充功能

```bash
specify extension search
```

顯示您組織目錄中的所有擴充功能。

### 按關鍵字搜尋

```bash
# Search for "jira"
specify extension search jira

# Search for "issue tracking"
specify extension search issue
```

### 按標籤過濾

```bash
# Find all issue-tracking extensions
specify extension search --tag issue-tracking

# Find all Atlassian tools
specify extension search --tag atlassian
```

### 按作者過濾

```bash
# Extensions by Stats Perform
specify extension search --author "Stats Perform"
```

### 僅顯示已驗證

```bash
# Only show verified extensions
specify extension search --verified
```

### 獲取擴展詳細信息

```bash
# Detailed information
specify extension info jira
```

顯示：

- 描述
- 要求
- 提供的命令
- 可用掛鉤
- 連結（文件、儲存庫、變更日誌）
- 安裝狀態

---

## 安裝擴充

### 從目錄安裝

```bash
# By name (from catalog)
specify extension add jira
```

這將：

1. 從 GitHub 下載擴展
2. 驗證清單
3. 檢查與您的規格套件版本的兼容性
4. 安裝到 `.specify/extensions/jira/`
5. 向您的 AI 代理註冊命令
6. 建立設定模板

### 從網址安裝

```bash
# From GitHub release
specify extension add --from https://github.com/org/spec-kit-ext/archive/refs/tags/v1.0.0.zip
```

### 從本機目錄安裝（開發）

```bash
# For testing or development
specify extension add --dev /path/to/extension
```

### 安裝輸出

```text
✓ Extension installed successfully!

Jira Integration (v1.0.0)
  Create Jira Epics, Stories, and Issues from spec-kit artifacts

Provided commands:
  • speckit.jira.specstoissues - Create Jira hierarchy from spec and tasks
  • speckit.jira.discover-fields - Discover Jira custom fields for configuration
  • speckit.jira.sync-status - Sync task completion status to Jira

⚠  Configuration may be required
   Check: .specify/extensions/jira/
```

---

## 使用擴充

### 使用擴充命令

擴充功能加入出現在 AI 代理程式 (Claude Code) 中的指令：

```text
# In Claude Code
> /speckit.jira.specstoissues

# Or use short alias (if provided)
> /speckit.specstoissues
```

### 擴充設定

大多數擴充功能需要設定：

```bash
# 1. Find the config file
ls .specify/extensions/jira/

# 2. Copy template to config
cp .specify/extensions/jira/jira-config.template.yml \
   .specify/extensions/jira/jira-config.yml

# 3. Edit configuration
vim .specify/extensions/jira/jira-config.yml

# 4. Use the extension
# (Commands will now work with your config)
```

### 延長鉤

一些擴充功能提供了在核心命令之後執行的鉤子：

**範例**：Jira 擴充掛鉤到 `/speckit.tasks`

```text
# Run core command
> /speckit.tasks

# Output includes:
## Extension Hooks

**Optional Hook**: jira
Command: `/speckit.jira.specstoissues`
Description: Automatically create Jira hierarchy after task generation

Prompt: Create Jira issues from tasks?
To execute: `/speckit.jira.specstoissues`
```

然後您可以選擇執行該掛鉤或跳過它。

---

## 管理擴充

### 列出已安裝的擴充

```bash
specify extension list
```

輸出：

```text
Installed Extensions:

  ✓ Jira Integration (v1.0.0)
     Create Jira Epics, Stories, and Issues from spec-kit artifacts
     Commands: 3 | Hooks: 1 | Status: Enabled
```

### 更新擴充

```bash
# Check for updates (all extensions)
specify extension update

# Update specific extension
specify extension update jira
```

輸出：

```text
🔄 Checking for updates...

Updates available:

  • jira: 1.0.0 → 1.1.0

Update these extensions? [y/N]:
```

### 暫時禁用擴充

```bash
# Disable without removing
specify extension disable jira

✓ Extension 'jira' disabled

Commands will no longer be available. Hooks will not execute.
To re-enable: specify extension enable jira
```

### 重新啟用擴充

```bash
specify extension enable jira

✓ Extension 'jira' enabled
```

### 刪除擴充

```bash
# Remove extension (with confirmation)
specify extension remove jira

# Keep configuration when removing
specify extension remove jira --keep-config

# Force removal (no confirmation)
specify extension remove jira --force
```

---

## 設定

### 設定檔

擴充可以有多個設定檔：

```text
.specify/extensions/jira/
├── jira-config.yml           # Main config (version controlled)
├── jira-config.local.yml     # Local overrides (gitignored)
└── jira-config.template.yml  # Template (reference)
```

### 設定層

設定按以下順序合併（最高優先級最後）：

1. **擴展預設值**（來自 `extension.yml`）
2. **專案設定** (`jira-config.yml`)
3. **本地覆蓋** (`jira-config.local.yml`)
4. **環境變數** (`SPECKIT_JIRA_*`)

### 範例：Jira 設定

**專案設定** (`.specify/extensions/jira/jira-config.yml`):

```yaml
project:
  key: "MSATS"

defaults:
  epic:
    labels: ["spec-driven"]
```

**本地覆蓋** (`.specify/extensions/jira/jira-config.local.yml`)：

```yaml
project:
  key: "MYTEST"  # Override for local development
```

**環境變數**：

```bash
export SPECKIT_JIRA_PROJECT_KEY="DEVTEST"
```

最終解析的設定使用環境變數中的 `DEVTEST`。

### 專案範圍的擴展設置

文件：`.specify/extensions.yml`

```yaml
# Extensions installed in this project
installed:
  - jira
  - linear

# Global settings
settings:
  auto_execute_hooks: true

# Hook configuration
hooks:
  after_tasks:
    - extension: jira
      command: speckit.jira.specstoissues
      enabled: true
      optional: true
      prompt: "Create Jira issues from tasks?"
```

### 核心環境變數

除了特定於擴展的環境變數 (`SPECKIT_{EXT_ID}_*`) 之外，spec-kit 還支援核心環境變數：

| 多變的 | 描述 | 預設 |
|----------|-------------|---------|
| `SPECKIT_CATALOG_URL`       | 覆蓋擴充目錄 URL | GitHub 託管目錄 |
| `GH_TOKEN` / `GITHUB_TOKEN` | GitHub API 用於下載的令牌     | 沒有任何                  |

#### 範例：使用自訂目錄進行測試

```bash
# Point to a local or alternative catalog
export SPECKIT_CATALOG_URL="http://localhost:8000/catalog.json"

# Or use a staging catalog
export SPECKIT_CATALOG_URL="https://example.com/staging/catalog.json"
```

---

## 擴充目錄

有關 Spec Kit 的雙目錄系統如何運作的資訊（`catalog.json` 與 `catalog.community.json`），請參閱主要 [擴充 README](README.md#extension-catalogs)。

## 組織目錄定制

### 為什麼要自訂您的目錄

組織將其 `catalog.json` 定制為：

- **控制可用擴展** - 策劃您的團隊可以安裝哪些擴展
- **託管私有擴充** - 不應公開的內部工具
- **定制合規性** - 滿足安全/audit 要求
- **支援氣隙環境** - 無需網路存取即可運作

### 設定自訂目錄

#### 1. 建立您的目錄文件

使用您的副檔名建立 `catalog.json` 檔案：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-02-03T00:00:00Z",
  "catalog_url": "https://your-org.com/spec-kit/catalog.json",
  "extensions": {
    "jira": {
      "name": "Jira Integration",
      "id": "jira",
      "description": "Create Jira issues from spec-kit artifacts",
      "author": "Your Organization",
      "version": "2.1.0",
      "download_url": "https://github.com/your-org/spec-kit-jira/archive/refs/tags/v2.1.0.zip",
      "repository": "https://github.com/your-org/spec-kit-jira",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0",
        "tools": [
          {"name": "atlassian-mcp-server", "required": true}
        ]
      },
      "provides": {
        "commands": 3,
        "hooks": 1
      },
      "tags": ["jira", "atlassian", "issue-tracking"],
      "verified": true
    },
    "internal-tool": {
      "name": "Internal Tool Integration",
      "id": "internal-tool",
      "description": "Connect to internal company systems",
      "author": "Your Organization",
      "version": "1.0.0",
      "download_url": "https://internal.your-org.com/extensions/internal-tool-1.0.0.zip",
      "repository": "https://github.internal.your-org.com/spec-kit-internal",
      "license": "Proprietary",
      "requires": {
        "speckit_version": ">=0.1.0"
      },
      "provides": {
        "commands": 2
      },
      "tags": ["internal", "proprietary"],
      "verified": true
    }
  }
}
```

#### 2. 託管目錄

託管目錄的選項：

| 方法 | 網址範例 | 使用案例 |
| ------ | ----------- | -------- |
| GitHub 頁 | `https://your-org.github.io/spec-kit-catalog/catalog.json` | 公共或組織可見 |
| 內部網路伺服器 | `https://internal.company.com/spec-kit/catalog.json` | 公司網路 |
| S3/Cloud 存儲 | `https://s3.amazonaws.com/your-bucket/catalog.json` | 雲端託管團隊 |
| 本地檔案伺服器 | `http://localhost:8000/catalog.json` | 發展/testing |

**安全性需求**：URL 必須使用 HTTPS（測試用的 `localhost` 除外）。

#### 3. 設定您的環境

##### 選項 A：環境變數（建議用於 CI_/CD）

```bash
# In ~/.bashrc, ~/.zshrc, or CI pipeline
export SPECKIT_CATALOG_URL="https://your-org.com/spec-kit/catalog.json"
```

##### 選項 B：每個專案設定

在執行 spec-kit 指令之前建立 `.env` 或在 shell 中設定：

```bash
SPECKIT_CATALOG_URL="https://your-org.com/spec-kit/catalog.json" specify extension search
```

#### 4. 驗證設定

```bash
# Search should now show your catalog's extensions
specify extension search

# Install from your catalog
specify extension add jira
```

### 目錄 JSON 架構

每個擴充條目的必填欄位：

| 場地 | 類型 | 必需的 | 描述 |
| ----- | ---- | -------- | ----------- |
| `name` | 細繩 | 是的 | 人類可讀的名稱 |
| `id` | 細繩 | 是的 | 唯一識別符（小寫、連字符） |
| `version` | 細繩 | 是的 | 語意版本 (X.Y.Z) |
| `download_url` | 細繩 | 是的 | ZIP 存檔的 URL |
| `repository` | 細繩 | 是的 | 原始碼網址 |
| `description` | 細繩 | 不 | 簡要說明 |
| `author` | 細繩 | 不 | 作者/organization |
| `license` | 細繩 | 不 | SPDX 許可證標識符 |
| `requires.speckit_version` | 細繩 | 不 | 版本限制 |
| `requires.tools` | 大批 | 不 | 所需的外部工具 |
| `provides.commands` | 數位 | 不 | 命令數量 |
| `provides.hooks` | 數位 | 不 | 掛鉤數量 |
| `tags` | 大批 | 不 | 搜尋標籤 |
| `verified` | 布林值 | 不 | 驗證狀態 |

### 使用案例

#### 私人/Internal 擴展

託管與內部系統整合的專有擴充：

```json
{
  "internal-auth": {
    "name": "Internal SSO Integration",
    "download_url": "https://artifactory.company.com/spec-kit/internal-auth-1.0.0.zip",
    "verified": true
  }
}
```

#### 策劃團隊目錄

限制您的團隊可以安裝哪些擴充功能：

```json
{
  "extensions": {
    "jira": { "..." },
    "github": { "..." }
  }
}
```

只有 `jira` 和 `github` 會出現在 `specify extension search` 。

#### 氣隙環境

對於無法上網的網路：

1. 將擴充 ZIP 下載到內部檔案伺服器
2. 建立指向內部 URL 的目錄
3. 內部 Web 伺服器上的主機目錄

```json
{
  "jira": {
    "download_url": "https://files.internal/spec-kit/jira-2.1.0.zip"
  }
}
```

#### 發展/Testing

在發布之前測試新擴充功能：

```bash
# Start local server
python -m http.server 8000 --directory ./my-catalog/

# Point spec-kit to local catalog
export SPECKIT_CATALOG_URL="http://localhost:8000/catalog.json"

# Test installation
specify extension add my-new-extension
```

### 與直接安裝結合

您仍然可以使用 `--from` 安裝不在目錄中的擴充功能：

```bash
# From catalog
specify extension add jira

# Direct URL (bypasses catalog)
specify extension add --from https://github.com/someone/spec-kit-ext/archive/v1.0.0.zip

# Local development
specify extension add --dev /path/to/extension
```

**注意**：直接 URL 安裝會顯示安全性警告，因為擴充功能不是來自您設定的目錄。

---

## 故障排除

### 未找到擴充程式

**錯誤**：`在目錄中找不到副檔名“jira”

**解決方案**：

1. 檢查拼字：`specify extension search jira`
2. 刷新目錄：`specify extension search --help`
3. 檢查網路連線
4. 擴展可能尚未發布

### 未找到設定

**錯誤**：`Jira configuration not found`

**解決方案**：

1. 檢查是否安裝了擴充功能：`specify extension list`
2. 從範本建立設定：

   ```bash
   cp .specify/extensions/jira/jira-config.template.yml \
      .specify/extensions/jira/jira-config.yml
   ```

3. 重新安裝擴充：`specify extension remove jira && specify extension add jira`

### 命令不可用

**問題**：擴充指令未出現在 AI 代理程式中

**解決方案**：

1. 檢查擴充功能是否已啟用：`specify extension list`
2. 重新啟用 AI 代理程式 (Claude Code)
3. 檢查命令檔案是否存在：

   ```bash
   ls .claude/commands/speckit.jira.*.md
   ```

4. 重新安裝擴充功能

### 不相容版本

**錯誤**：`Extension requires spec-kit >=0.2.0, but you have 0.1.0`

**解決方案**：

1. 升級規格套件：

   ```bash
   uv tool upgrade specify-cli
   ```

2. 安裝舊版的擴充功能：

   ```bash
   specify extension add --from https://github.com/org/ext/archive/v1.0.0.zip
   ```

### MCP 工具不可用

**錯誤**：`Tool 'jira-mcp-server/epic_create' not found`

**解決方案**：

1. 檢查MCP伺服器是否安裝
2. 檢查 AI 代理 MCP 設定
3. 重新啟用 AI 代理
4. 檢查擴充要求：`specify extension info jira`

### 沒有權限

**錯誤**：存取 Jira 時出現 `Permission denied`

**解決方案**：

1. 檢查 MCP 伺服器設定中的 Jira 憑證
2. 驗證 Jira 中的專案權限
3. 獨立測試MCP伺服器連接

---

## 最佳實踐

### 1.版本控制

**執行承諾**：

- `.specify/extensions.yml`（專案擴充設定）
- `.specify/extensions/*/jira-config.yml`（專案設定）

**不要承諾**：

- `.specify/extensions/.cache/`（目錄快取）
- `.specify/extensions/.backup/`（設定備份）
- `.specify/extensions/*/*.local.yml`（本地覆蓋）
- `.specify/extensions/.registry`（安裝狀態）

加到 `.gitignore`：

```gitignore
.specify/extensions/.cache/
.specify/extensions/.backup/
.specify/extensions/*/*.local.yml
.specify/extensions/.registry
```

### 2. 團隊工作流程

**對於團隊**：

1. 就使用哪些擴充功能達成一致
2. 提交擴充設定
3. README 中的文件副檔名使用情況
4. 保持擴充一起更新

**範例 README 部分**：

```markdown
## Extensions

This project uses:
- **jira** (v1.0.0) - Jira integration
  - Config: `.specify/extensions/jira/jira-config.yml`
  - Requires: jira-mcp-server

To install: `specify extension add jira`
```

### 3. 地方發展

使用本地設定進行開發：

```yaml
# .specify/extensions/jira/jira-config.local.yml
project:
  key: "DEVTEST"  # Your test project

defaults:
  task:
    custom_fields:
      customfield_10002: 1  # Lower story points for testing
```

### 4. 環境特定設定

使用 CI/CD: 的環境變數

```bash
# .github/workflows/deploy.yml
env:
  SPECKIT_JIRA_PROJECT_KEY: ${{ secrets.JIRA_PROJECT }}

- name: Create Jira Issues
  run: specify extension add jira && ...
```

### 5. 擴充更新

**定期檢查更新**：

```bash
# Weekly or before major releases
specify extension update
```

**穩定的引腳版本**：

```yaml
# .specify/extensions.yml
installed:
  - id: jira
    version: "1.0.0"  # Pin to specific version
```

### 6. 最小擴展

僅安裝您經常使用的擴充功能：

- 降低複雜性
- 更快的命令加載
- 設定少

### 7. 文檔

記錄專案中擴充的使用：

```markdown
# PROJECT.md

## Working with Jira

After creating tasks, sync to Jira:
1. Run `/speckit.tasks` to generate tasks
2. Run `/speckit.jira.specstoissues` to create Jira issues
3. Run `/speckit.jira.sync-status` to update status
```

---

## 常問問題

### Q：我可以同時使用多個擴充功能嗎？

**答**：是的！擴展旨在協同工作。根據需要安裝多個。

### Q：擴充會減慢規格套件的速度嗎？

**A**：不會。擴充功能是按需載入的，並且僅在使用其命令時載入。

### Q：我可以建立私有擴充嗎？

**答**：是的。使用 `--dev` 或 `--from` 安裝並保持私密。公共目錄提交是可選的。

### Q：我如何知道擴充是否安全？

**A**：尋找 ✓ 已驗證徽章。已驗證的擴充由維護人員審核。安裝前請務必檢查擴充程式碼。

### Q：擴充可以修改規格套件核心嗎？

**A**：不行。擴充只能添加命令和掛鉤。他們無法修改核心功能。

### Q：如果兩個擴充功能具有相同的命令名稱會怎麼樣？

**A**：擴充使用命名空間指令 (`speckit.{extension}.{command}`)，因此衝突非常罕見。如果發生衝突，分機系統會警告您。

### Q：我可以為現有擴展做出貢獻嗎？

**答**：是的！大多數擴充都是開源的。檢查 `specify extension info {extension}` 中的儲存庫連結。

### Q：如何報告擴充錯誤？

**A**：前往擴充功能的儲存庫（如 `specify extension info` 所示）並建立問題。

### Q：擴充功能可以離線使用嗎？

**A**：安裝後，擴充功能可以離線工作。但是，某些擴充功能可能需要網路才能實現其功能（例如，Jira 需要 Jira API 存取權限）。

### Q：如何備份我的擴充設定？

**A**：擴充設定位於 `.specify/extensions/{extension}/` 中。備份此目錄或將設定提交至 git。

---

## 支援

- **擴充問題**：向擴充儲存庫報告（請參閱 `specify extension info`）
- **Spec Kit 問題**： <https://github.com/statsperform/spec-kit/issues>
- **擴充目錄**： <https://github.com/statsperform/spec-kit/tree/main/extensions>
- **文件**：請參閱 EXTENSION-DEVELOPMENT-GUIDE.md 和 EXTENSION-PUBLISHING-GUIDE.md

---

*最後更新：2026-01-28*
*Spec Kit 版本：0.1.0*
