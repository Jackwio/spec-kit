# 範例：副檔名 README

這是自訂後擴充 README 的範例。
**刪除此檔案並將 README.md 替換為與此類似的內容。 **

---

# 我的擴展

<!-- CUSTOMIZE: Replace with your extension description -->

簡要描述您的擴充功能的用途以及它的用途。

## 特徵

<!-- CUSTOMIZE: List key features -->

- 特徵1：描述
- 特徵 2：描述
- 特徵 3：描述

## 安裝

```bash
# Install from catalog
specify extension add my-extension

# Or install from local development directory
specify extension add --dev /path/to/my-extension
```

## 設定

1. 建立設定檔：

   ```bash
   cp .specify/extensions/my-extension/config-template.yml \
      .specify/extensions/my-extension/my-extension-config.yml
   ```

2. 編輯設定：

   ```bash
   vim .specify/extensions/my-extension/my-extension-config.yml
   ```

3. 設定所需值：
   <!-- CUSTOMIZE: List required configuration -->
   ```yaml
   connection:
     url: "https://api.example.com"
     api_key: "your-api-key"

   project:
     id: "your-project-id"
   ```

## 用法

<!-- CUSTOMIZE: Add usage examples -->

### 命令：範例

描述該命令的作用。

```bash
# In Claude Code
> /speckit.my-extension.example
```

**先決條件**：

- 先決條件1
- 先決條件2

**輸出**：

- 該命令產生什麼
- 結果儲存位置

## 設定參考

<!-- CUSTOMIZE: Document all configuration options -->

### 連接設定

| 環境 | 類型 | 必需的 | 描述 |
|---------|------|----------|-------------|
| `connection.url` | 細繩 | 是的 | API 端點 URL |
| `connection.api_key` | 細繩 | 是的 | API 身份驗證金鑰 |

### 專案設定

| 環境 | 類型 | 必需的 | 描述 |
|---------|------|----------|-------------|
| `project.id` | 細繩 | 是的 | 專案標識符 |
| `project.workspace` | 細繩 | 不 | 工作空間或組織 |

## 環境變數

使用環境變數覆蓋設定：

```bash
# Override connection settings
export SPECKIT_MY_EXTENSION_CONNECTION_URL="https://custom-api.com"
export SPECKIT_MY_EXTENSION_CONNECTION_API_KEY="custom-key"
```

## 範例

<!-- CUSTOMIZE: Add real-world examples -->

### 範例 1：基本工作流程

```bash
# Step 1: Create specification
> /speckit.spec

# Step 2: Generate tasks
> /speckit.tasks

# Step 3: Use extension
> /speckit.my-extension.example
```

## 故障排除

<!-- CUSTOMIZE: Add common issues -->

### 問題：找不到設定

**解決方案**：從範本建立設定（請參閱設定部分）

### 問題：命令不可用

**解決方案**：

1. 檢查擴充功能是否已安裝：`specify extension list`
2. 重新啟用 AI 代理
3. 重新安裝擴充功能

## 執照

MIT 許可證 - 請參閱許可證文件

## 支援

- **問題**： <https://github.com/your-org/spec-kit-my-extension/issues>
- **Spec Kit 文件**： <https://github.com/statsperform/spec-kit>

## 變更日誌

請參閱 [CHANGELOG.md](CHANGELOG.md) 以了解版本歷史記錄。

---

*擴充版本：1.0.0*
*Spec Kit：>=0.1.0*
