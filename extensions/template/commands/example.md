---
描述：“演示擴充功能的範例命令”
# CUSTOMIZE：列出此指令使用的 MCP 工具
工具：
  - '範例-mcp-伺服器/example_tool'
---

# 命令範例

<!-- CUSTOMIZE: Replace this entire file with your command documentation -->

這是一個範例指令，示範如何為 Spec Kit 擴充功能建立指令。

## 目的

描述該命令的作用以及何時使用它。

## 先決條件

使用此命令之前列出要求：

1. 先決條件 1（例如，「MCP 伺服器已設定」）
2. 先決條件 2（例如，「設定檔存在」）
3. 先修條件 3（例如，「有效的 API 憑證」）

## 使用者輸入

$ARGUMENTS

## 步驟

### 第1步：載入設定

<!-- CUSTOMIZE: Replace with your actual steps -->

從專案載入擴充設定：

``重擊
config_file=".指定/extensions/my-extension/my-extension-config.yml"

如果 [ ！ -f“$config_file”];然後
  echo“❌錯誤：在$config_file中找不到設定”
  echo“執行‘指定擴充功能添加我的擴充功能’來安裝和設定”
  1號出口
菲

# 讀取設定值

設定值=$(yq eval '.settings.key' "$config_file")

# 應用環境變數覆蓋

設定值 =“${SPECKIT_MY_EXTENSION_KEY:-$setting_value}”

# 驗證設定

if [ -z "$setting_value" ];然後
  echo“❌錯誤：未設定設定值”
  echo“編輯$config_file並設定'settings.key'”
  1號出口
菲

echo "📋 已載入設定：$setting_value"
``

### 第 2 步：執行主要操作

<!-- CUSTOMIZE: Replace with your command logic -->

描述一下這一步的作用：

『降價
使用MCP工具執行主要操作：

- 工具：example-mcp-server example_tool
- 參數：{“key”：“$setting_value”}

這將呼叫 MCP 伺服器工具來執行操作。
``

### 第 3 步：處理結果

<!-- CUSTOMIZE: Add more steps as needed -->

處理結果並提供輸出：

`` 重擊
迴聲“”
echo "✅ 指令成功完成！"
迴聲“”
回顯“結果：”
echo " • 第 1 項：值"
echo " • 第 2 項：值"
迴聲“”
``

### 第 4 步：儲存輸出（可選）

如果需要，將結果儲存到文件中：

``重擊
輸出文件=“。指定/my-extension-output.json"

貓>「$輸出檔」<<EOF
{
  "timestamp": "$(日期 -u +"%Y-%m-%dT%H:%M:%SZ")",
  “設定”：“$setting_value”，
  「結果」： []
}
EOF

echo "💾 輸出儲存到 $output_file"
``

## 設定參考

<!-- CUSTOMIZE: Document configuration options -->

此指令使用 `my-extension-config.yml` 中的下列設定：

- **settings.key**：此設定的作用的描述
  - 類型：字串
  - 必填：是
  - 例：`"example-value"`

- **settings.another_key**：另一個設定的描述
  - 類型：布林值
  - 必需： 否
  - 預設值：`false`
  - 例：`true`

## 環境變數

<!-- CUSTOMIZE: Document environment variable overrides -->

可以使用環境變數覆蓋設定：

- `SPECKIT_MY_EXTENSION_KEY` - 覆蓋 `settings.key`
- `SPECKIT_MY_EXTENSION_ANOTHER_KEY` - 覆蓋 `settings.another_key`

例子：
``重擊
匯出 SPECKIT_MY_EXTENSION_KEY="覆蓋值"
``

## 故障排除

<!-- CUSTOMIZE: Add common issues and solutions -->

### “未找到設定”

**解決方案**：安裝擴充功能並建立設定：
``重擊
指定副檔名 新增 my-extension
cp .指定/extensions/my-extension/config-template.yml \
   .指定/extensions/my-extension/my-extension-config.yml
``

### “MCP 工具不可用”

**解決方案**：確保在 AI 代理設定中設定 MCP 伺服器。

### “沒有權限”

**解決方案**：檢查外部服務中的憑證和權限。

## 筆記

<!-- CUSTOMIZE: Add helpful notes and tips -->

- 此命令需要與外部服務的活動連接
- 緩存結果以提高效能
- 重新執行命令刷新數據

## 範例

<!-- CUSTOMIZE: Add usage examples -->

### 範例 1：基本用法

``重擊

# 使用預設設定執行
>
> /speckit.my-extension.example
``

### 範例 2：使用環境覆蓋

``重擊

# 使用環境變數覆蓋設定

匯出 SPECKIT_MY_EXTENSION_KEY="自訂值"
> /speckit.my-extension.example
``

### 範例 3：核心命令之後

``重擊

# 作為工作流程的一部分使用
>
> /speckit.tasks
> /speckit.my-extension.example
``

---

*有關更多信息，請參閱擴展 README 或執行 `specify extension info my-extension`*
