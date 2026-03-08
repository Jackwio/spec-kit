# 擴充發布指南

本指南介紹如何將您的擴充功能發佈到 Spec Kit 擴充目錄，使其可以被 `specify extension search` 發現。

## 目錄

1. [先決條件](#先決條件)
2. [準備你的擴展](#準備你的擴展)
3. [提交到目錄](#提交到目錄)
4. [驗證流程](#驗證流程)
5. [發布工作流程](#發布工作流程)
6. [最佳實踐](#最佳實踐)

---

## 先決條件

在發布擴充功能之前，請確保您擁有：

1. **有效擴展**：具有有效 `extension.yml` 清單的工作擴展
2. **Git 儲存庫**：託管在 GitHub（或其他公共 git 託管）上的擴展
3. **文件**：README.md 包含安裝和使用說明
4. **許可證**：開源許可證文件（MIT、Apache 2.0 等）
5. **版本控制**：語意版本控制（例如，1.0.0）
6. **測試**：在真實專案上測試的擴展

---

## 準備你的擴展

### 1. 擴展結構

確保您的擴充遵循標準結構：

```text
your-extension/
├── extension.yml              # Required: Extension manifest
├── README.md                  # Required: Documentation
├── LICENSE                    # Required: License file
├── CHANGELOG.md               # Recommended: Version history
├── .gitignore                 # Recommended: Git ignore rules
│
├── commands/                  # Extension commands
│   ├── command1.md
│   └── command2.md
│
├── config-template.yml        # Config template (if needed)
│
└── docs/                      # Additional documentation
    ├── usage.md
    └── examples/
```

### 2.extension.yml驗證

驗證您的清單是否有效：

```yaml
schema_version: "1.0"

extension:
  id: "your-extension"           # Unique lowercase-hyphenated ID
  name: "Your Extension Name"     # Human-readable name
  version: "1.0.0"                # Semantic version
  description: "Brief description (one sentence)"
  author: "Your Name or Organization"
  repository: "https://github.com/your-org/spec-kit-your-extension"
  license: "MIT"
  homepage: "https://github.com/your-org/spec-kit-your-extension"

requires:
  speckit_version: ">=0.1.0"    # Required spec-kit version

provides:
  commands:                       # List all commands
    - name: "speckit.your-extension.command"
      file: "commands/command.md"
      description: "Command description"

tags:                             # 2-5 relevant tags
  - "category"
  - "tool-name"
```

**驗證清單**：

- ✅ `id` 是小寫字母，只包含連字號（沒有底線、空格或特殊字元）
- ✅ `version` 遵循語意版本控制 (X.Y.Z)
- ✅ `description` 簡潔（100 個字元以下）
- ✅ `repository` URL 有效且公開
- ✅ 所有指令檔案都存在於擴充目錄中
- ✅ 標籤為小寫且具描述性

### 3. 建立 GitHub 版本

為您的擴充版本建立 GitHub 版本：

```bash
# Tag the release
git tag v1.0.0
git push origin v1.0.0

# Create release on GitHub
# Go to: https://github.com/your-org/spec-kit-your-extension/releases/new
# - Tag: v1.0.0
# - Title: v1.0.0 - Release Name
# - Description: Changelog/release notes
```

發布存檔 URL 將是：

```text
https://github.com/your-org/spec-kit-your-extension/archive/refs/tags/v1.0.0.zip
```

### 4. 測試安裝

測試使用者是否可以從您的版本安裝：

```bash
# Test dev installation
specify extension add --dev /path/to/your-extension

# Test from GitHub archive
specify extension add --from https://github.com/your-org/spec-kit-your-extension/archive/refs/tags/v1.0.0.zip
```

---

## 提交到目錄

### 了解目錄

Spec Kit 使用雙目錄系統。有關目錄如何工作的詳細信息，請參閱主要 [擴充 README](README.md#extension-catalogs)。

**對於擴展發布**：所有社區擴展都應添加到 `catalog.community.json`。使用者瀏覽此目錄並將他們信任的擴充功能複製到自己的 `catalog.json` 中。

### 1. 分叉規格套件儲存庫

```bash
# Fork on GitHub
# https://github.com/github/spec-kit/fork

# Clone your fork
git clone https://github.com/YOUR-USERNAME/spec-kit.git
cd spec-kit
```

### 2. 將擴充功能加入到社群目錄

編輯 `extensions/catalog.community.json` 並新增您的副檔名：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-01-28T15:54:00Z",
  "catalog_url": "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json",
  "extensions": {
    "your-extension": {
      "name": "Your Extension Name",
      "id": "your-extension",
      "description": "Brief description of your extension",
      "author": "Your Name",
      "version": "1.0.0",
      "download_url": "https://github.com/your-org/spec-kit-your-extension/archive/refs/tags/v1.0.0.zip",
      "repository": "https://github.com/your-org/spec-kit-your-extension",
      "homepage": "https://github.com/your-org/spec-kit-your-extension",
      "documentation": "https://github.com/your-org/spec-kit-your-extension/blob/main/docs/",
      "changelog": "https://github.com/your-org/spec-kit-your-extension/blob/main/CHANGELOG.md",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0",
        "tools": [
          {
            "name": "required-mcp-tool",
            "version": ">=1.0.0",
            "required": true
          }
        ]
      },
      "provides": {
        "commands": 3,
        "hooks": 1
      },
      "tags": [
        "category",
        "tool-name",
        "feature"
      ],
      "verified": false,
      "downloads": 0,
      "stars": 0,
      "created_at": "2026-01-28T00:00:00Z",
      "updated_at": "2026-01-28T00:00:00Z"
    }
  }
}
```

**重要的**：

- 設定 `verified: false` （維護人員將驗證）
- 設定 `downloads: 0` 和 `stars: 0`（稍後自動更新）
- 對 `created_at` 和 `updated_at` 使用目前時間戳
- 將頂 `updated_at` 更新為目前時間

### 3. 更新擴充 README

將您的擴充功能加入到 `extensions/README.md` 中的可用擴充表中：

```markdown
| Your Extension Name | Brief description of what it does | [repo-name](https://github.com/your-org/spec-kit-your-extension) |
```

按字母順序在表中插入您的副檔名。

### 4. 提交拉取請求

```bash
# Create a branch
git checkout -b add-your-extension

# Commit your changes
git add extensions/catalog.community.json extensions/README.md
git commit -m "Add your-extension to community catalog

- Extension ID: your-extension
- Version: 1.0.0
- Author: Your Name
- Description: Brief description
"

# Push to your fork
git push origin add-your-extension

# Create Pull Request on GitHub
# https://github.com/github/spec-kit/compare
```

**拉取請求範本**：

```markdown
## Extension Submission

**Extension Name**: Your Extension Name
**Extension ID**: your-extension
**Version**: 1.0.0
**Author**: Your Name
**Repository**: https://github.com/your-org/spec-kit-your-extension

### Description
Brief description of what your extension does.

### Checklist
- [x] Valid extension.yml manifest
- [x] README.md with installation and usage docs
- [x] LICENSE file included
- [x] GitHub release created (v1.0.0)
- [x] Extension tested on real project
- [x] All commands working
- [x] No security vulnerabilities
- [x] Added to extensions/catalog.community.json
- [x] Added to extensions/README.md Available Extensions table

### Testing
Tested on:
- macOS 13.0+ with spec-kit 0.1.0
- Project: [Your test project]

### Additional Notes
Any additional context or notes for reviewers.
```

---

## 驗證流程

### 提交後會發生什麼

1. **自動檢查**（如果有）：
   - 清單驗證
   - 下載網址可存取性
   - 儲存庫存在
   - 許可證文件存在

2. **手動審核**：
   - 程式碼品質審查
   - 安全審計
   - 功能測試
   - 文件審查

3. **確認**：
   - 如果獲得批准，則設定 `verified: true`
   - 副檔名出現在 `specify extension search --verified` 中

### 驗證標準

要進行驗證，您的擴充功能必須：

✅ **功能**：

- 按照文件中的描述工作
- 所有指令均執行無錯誤
- 使用者工作流程沒有重大變化

✅ **安全**：

- 無已知漏洞
- 無惡意程式碼
- 安全處理用戶數據
- 正確驗證輸入

✅ **程式碼品質**：

- 乾淨、可讀的程式碼
- 遵循擴展最佳實踐
- 正確的錯誤處理
- 有用的錯誤訊息

✅ **文件**：

- 清晰的安裝說明
- 使用範例
- 故障排除部分
- 準確描述

✅ **維護**：

- 活動儲存庫
- 積極響應問題
- 定期更新
- 隨後進行語意版本控制

### 典型的審查時間表

- **自動檢查**：立即（如果實施）
- **人工審核**：3-7 個工作天
- **驗證**：審核成功後

---

## 發布工作流程

### 發布新版本

發布新版本時：

1. **更新版本**在 `extension.yml`：

   ```yaml
   extension:
     version: "1.1.0"  # Updated version
   ```

2. **更新 CHANGELOG.md**：

   ```markdown
   ## [1.1.0] - 2026-02-15

   ### Added
   - New feature X

   ### Fixed
   - Bug fix Y
   ```

3. **建立 GitHub 版本**：

   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   # Create release on GitHub
   ```

4. **更新目錄**：

   ```bash
   # Fork spec-kit repo (or update existing fork)
   cd spec-kit

   # Update extensions/catalog.json
   jq '.extensions["your-extension"].version = "1.1.0"' extensions/catalog.json > tmp.json && mv tmp.json extensions/catalog.json
   jq '.extensions["your-extension"].download_url = "https://github.com/your-org/spec-kit-your-extension/archive/refs/tags/v1.1.0.zip"' extensions/catalog.json > tmp.json && mv tmp.json extensions/catalog.json
   jq '.extensions["your-extension"].updated_at = "2026-02-15T00:00:00Z"' extensions/catalog.json > tmp.json && mv tmp.json extensions/catalog.json
   jq '.updated_at = "2026-02-15T00:00:00Z"' extensions/catalog.json > tmp.json && mv tmp.json extensions/catalog.json

   # Submit PR
   git checkout -b update-your-extension-v1.1.0
   git add extensions/catalog.json
   git commit -m "Update your-extension to v1.1.0"
   git push origin update-your-extension-v1.1.0
   ```

5. **提交更新 PR**，並在描述中包含變更日誌

---

## 最佳實踐

### 擴充設計

1. **單一職責**：每個擴充應該專注於一個工具/integration
2. **清晰命名**：使用描述性、明確的名稱
3. **最小依賴關係**：避免不必要的依賴關係
4. **向後相容性**：嚴格遵循語義版本控制

### 文件

1. **README.md 結構**：
   - 概述和特點
   - 安裝說明
   - 設定指南
   - 使用範例
   - 故障排除
   - 貢獻指南

2. **命令文檔**：
   - 清晰的描述
   - 列出的先決條件
   - 逐步說明
   - 錯誤處理指導
   - 範例

3. **設定**：
   - 提供範本文件
   - 記錄所有選項
   - 包括範例
   - 解釋預設值

### 安全

1. **輸入驗證**：驗證所有使用者輸入
2. **無硬編碼秘密**：切勿包含憑證
3. **安全依賴關係**：僅使用受信任的依賴關係
4. **定期審核**：檢查漏洞

### 維護

1. **回應問題**：在 1-2 週內解決問題
2. **定期更新**：保持依賴項更新
3. **變更日誌**：維護詳細的變更日誌
4. **棄用**：提前通知重大變更

### 社群

1. **許可證**：使用寬鬆的開源許可證（MIT、Apache 2.0）
2. **貢獻**：歡迎貢獻
3. **行為準則**：尊重與包容
4. **支援**：提供取得協助的方式（問題、討論、電子郵件）

---

## 常問問題

### Q：我可以發布私有/proprietary 擴充功能嗎？

答：主目錄僅供公共擴充使用。對於私人分機：

- 託管您自己的catalog.json 文件
- 使用者加入您的目錄：`specify extension add-catalog https://your-domain.com/catalog.json`
- 尚未實施 - 將在第 4 階段實施

### Q：驗證需要多長時間？

答：初步審核通常需要 3-7 個工作天。經過驗證的擴充的更新通常會更快。

### Q：如果我的延期被拒絕怎麼辦？

答：您將收到有關需要修復的問題的回饋。進行更改並重新提交。

### Q：我可以隨時更新我的擴充功能嗎？

答：是的，提交 PR 以使用您的新版本更新目錄。已驗證的狀態可能會因重大變更而重新評估。

### Q：我需要經過驗證才能進入目錄嗎？

答：不，未經驗證的擴充功能仍然可以搜尋。驗證只會增加信任和可見性。

### Q：擴充功能可以具有付費功能嗎？

答：擴充應該是免費且開源的。允許商業支援/services，但核心功能必須免費。

---

## 支援

- **目錄問題**： <https://github.com/statsperform/spec-kit/issues>
- **擴充模板**： <https://github.com/statsperform/spec-kit-extension-template> （即將推出）
- **開發指南**：請參閱 EXTENSION-DEVELOPMENT-GUIDE.md
- **社群**：討論與問答

---

## 附錄：目錄架構

### 完整的目錄條目架構

```json
{
  "name": "string (required)",
  "id": "string (required, unique)",
  "description": "string (required, <200 chars)",
  "author": "string (required)",
  "version": "string (required, semver)",
  "download_url": "string (required, valid URL)",
  "repository": "string (required, valid URL)",
  "homepage": "string (optional, valid URL)",
  "documentation": "string (optional, valid URL)",
  "changelog": "string (optional, valid URL)",
  "license": "string (required)",
  "requires": {
    "speckit_version": "string (required, version specifier)",
    "tools": [
      {
        "name": "string (required)",
        "version": "string (optional, version specifier)",
        "required": "boolean (default: false)"
      }
    ]
  },
  "provides": {
    "commands": "integer (optional)",
    "hooks": "integer (optional)"
  },
  "tags": ["array of strings (2-10 tags)"],
  "verified": "boolean (default: false)",
  "downloads": "integer (auto-updated)",
  "stars": "integer (auto-updated)",
  "created_at": "string (ISO 8601 datetime)",
  "updated_at": "string (ISO 8601 datetime)"
}
```

### 有效標籤

推薦標籤類別：

- **整合**：jira、線性、github、gitlab、azure-devops
- **類別**：問題追蹤、vcs、ci-cd、文件、測試
- **平台**：atlassian、微軟、谷歌
- **功能**：自動化、報告、部署、監控

使用 2-5 個最能描述您的擴充功能的標籤。

---

*最後更新：2026-01-28*
*目錄格式版本：1.0*
