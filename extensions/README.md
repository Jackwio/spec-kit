# Spec Kit 擴展

[Spec Kit](https://github.com/github/spec-kit) 的擴展系統 - 增加新功能而不造成核心框架膨脹。

## 擴充目錄

Spec Kit 提供了兩個不同用途的目錄檔案：

### 您的目錄 (`catalog.json`)

- **用途**： Spec Kit CLI 使用的補充的預設上游目錄
- **狀態預設**：上游專案中設計為空 - 您或您的組織使用您信任的擴展分裝叉/副本
- **位置（上游）**： `extensions/catalog.json` 在 GitHub 託管的規範套件儲存函式函式庫中
- **CLI 預設**： `specify extension` 預設預設使用上游目錄 URL，除非被覆寫
- **組織目錄**：將 `SPECKIT_CATALOG_URL` 指向您組織的分支或託管目錄 JSON 以使用它而不是上游預設值
- **自訂**：將社區目錄中的條目複製到您的組織目錄中，或直接添加您自己的擴展

**覆蓋範例：**
```bash
# Override the default upstream catalog with your organization's catalog
export SPECKIT_CATALOG_URL="https://your-org.com/spec-kit/catalog.json"
specify extension search  # Now uses your organization's catalog instead of the upstream default
```

### 社區參考目錄 (`catalog.community.json`)

- **目的**：瀏覽可用的社區貢獻的擴展
- **狀態**：活動 - 包含社區提交的擴展
- **地點**：`extensions/catalog.community.json`
- **用法**：用於發現可用擴充功能的參考目錄
- **提交**：透過 Pull Request 接受社群貢獻

**它是如何工作的：**

## 使擴充可用

您可以控制您的團隊可以發現和安裝哪些擴充功能：

### 選項 1：精選目錄（推薦給組織）

使用已核准的補充功能填滿您的 `catalog.json`：

1. **發現**來自各種來源的擴展：
   - 瀏覽 `catalog.community.json` 取得社群擴展
   - 在您組織的儲存函式函式庫中尋找 private/internal 補充
   - 發現來自可信任第三方的擴展
2. **查看**擴展並選擇您想要提供的擴展
3. **將**這些補充新增至您自己的 `catalog.json`
4. **團隊成員**現在可以發現並安裝它們：
   - `specify extension search` 顯示規劃的目錄
   - `指定擴展名添加 <name>` 從您的目錄安裝

**優點**： 完全控制可用擴充、團隊一致性、組織審批工作流程

**範例**：將從 `catalog.community.json` 複製到您的 `catalog.json`，然後您的團隊可以按名稱找到並安裝它。

### 選項2：直接URL（供臨時使用）

跳過目錄管理 - 團隊成員直接使用URL進行安裝：

```bash
specify extension add --from https://github.com/org/spec-kit-ext/archive/refs/tags/v1.0.0.zip
```

**優點**：快速進行一次性測試或私人擴展

**權衡**：以這種方式安裝的增強功能不會出現在其他團隊成員的 `specify extension search` 中，除非您也將它們新增至您的 `catalog.json` 中。

## 可用的社區擴展

[`catalog.community.json`](catalog.community.json) 中提供了以下社區貢獻的擴展：

| 擴大 | 目的 | 網址 |
|-----------|---------|-----|
| V型增強包 | 強制執行V模型生產開發規範和測試規範，並具有完全可追溯性 | [規格套件V模型](https://github.com/leocamello/spec-kit-v-model) |
| 清理擴充 | 實施後品質關卡，用於審查變更、修復小問題（偵察規則）、為中型問題建立任務以及為大問題產生分析 | [規格套件清理](https://github.com/dsrednicki/spec-kit-cleanup) |

## 添加您的擴展

### 提交流程

要將您的擴充功能新增到社區目錄：

1. **依照 [擴充開發指南](EXTENSION-DEVELOPMENT-GUIDE.md) 準備您的補充**
2. **為您建立 GitHub 版本**
3. **提交請求請求**：
   - 將您的增強功能加入到 `extensions/catalog.community.json`
   - 使用可用的增強表中的增強功能更新此 README
4. **等待審核** - 如果滿足條件，維護人員將審核並合併

請參閱 [擴充發布指南](EXTENSION-PUBLISHING-GUIDE.md) 以了解詳細的逐步說明。

### 提交清單

提交之前，請確保：

- ✅ 有效的 `extension.yml` 清單
- ✅ 完成 README 以及安裝和使用說明
- ✅ 包含許可證文件
- ✅ 使用語意版本建立的 GitHub 版本（例如 v1.0.0）
- ✅ 在真實專案上測試擴展
- ✅ 所有指令均依記錄執行

## 安裝擴充
一旦新增功能可用（在您的目錄中或透過直接 URL），請安裝它們：

```bash
# From your curated catalog (by name)
specify extension search                  # See what's in your catalog
specify extension add <extension-name>    # Install by name

# Direct from URL (bypasses catalog)
specify extension add --from https://github.com/<org>/<repo>/archive/refs/tags/<version>.zip

# List installed extensions
specify extension list
```

有關詳細信息，請參閱[分機使用指南](EXTENSION-USER-GUIDE.md)。
