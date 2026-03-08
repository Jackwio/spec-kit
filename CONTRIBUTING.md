# 為 Spec Kit 做出貢獻

你好呀！我們很高興您願意為 Spec Kit 做出貢獻。根據 [專案的開源許可證](LICENSE)，此專案的貢獻為 [釋放](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) 。

請注意，該專案是使用 [貢獻者行為準則](CODE_OF_CONDUCT.md) 發布的。參與專案即表示您同意其條款。

## 執行和測試程式碼的先決條件

這些是您一次性安裝，很快就能夠在本地測試的更改，作為拉取請求 (PR) 提交過程的一部分。

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
1. 安裝 [uv](https://docs.astral.sh/uv/) 進行套件管理
1. 安裝 [git](https://git-scm.com/downloads)
1. 有一個 [AI 可用程式碼助理](README.md#-supported-ai-agents)

<details>
<summary><b>💡 提示您是否正在使用 <code>VS程式碼</code> 或者 <code>GitHub碼空間</code> 作為你的 IDE</b></summary>

<br>

如果您的電腦上安裝了 [碼頭工人](https://docker.com)，您就可以跨越 [VSCode 補充](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 利用 [開發容器](https://containers.dev)，輕鬆設定您的開發環境，並使用已安裝和設定的上述工具，這要形成 `.devcontainer/devcontainer.json` 檔案（位於專案的根目錄）。

為此，只需：

- 查看倉函式庫
- 使用VSCode打開
- 打開[命令面板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette)並選擇“開發容器：打開容器中的資料夾...”

在 [GitHub碼空間](https://github.com/features/codespaces) 上，它甚至更簡單，因為它在打開程式碼空間時會自動使用 `.devcontainer/devcontainer.json`。

</details>

## 提交拉取請求

> [！筆記]
> 如果您的拉取請求引入了重大變更，對CLI或儲存函式函式庫其餘部分的工作產生重大影響（例如，您正在引入新的範本、參數或其他重大變更），請確保專案維護人員**討論並同意**。沒有事先對話和協議的、具有更大變更的拉取請求將被關閉。

1. 分叉並克隆儲存庫
1. 設定並安裝依賴項：`uv sync`
1. 保證 CLI 在您的機器上工作：`uv run specify --help`
1. 建立一個新分支：`git checkout -b my-branch-name`
1. 進行更改、添加測試並確保一切仍然有效
1. 使用範例專案測試 CLI 功能（如果相關）
1. 推送到您的分叉並提交拉取請求
1. 等待您的拉取請求被審核和合併。

您可以執行以下一些操作來增加拉取請求被接受的可能性：

- 遵循專案的編碼約定。
- 為新功能編寫測試。
- 如果您的變更影響了使用者導向的功能，請更新檔案（`README.md`、`spec-driven.md`）。
- 讓你的改變盡可能集中。如果您想要進行多項彼此不依賴的更改，請考慮將它們作為單獨的拉取請求提交。
- 寫入[良好的提交訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 使用 Spec-Driven Development 工作流程測試您的變更以確保相容性。

## 開發流程

使用規格套件時：

1. 在您選擇的編碼代理中使用 `specify` CLI 指令（`/speckit.specify`、`/speckit.plan`、`/speckit.tasks`）測試更改
2. 驗證範本在 `templates/` 目錄中正常運作
3. 測試 `scripts/` 目錄中的腳本功能
4. 如果進行重大流程更改，請確保更新記憶體檔案 (`memory/constitution.md`)

### 在本地測試模板和命令更改

執行 `uv run specify init` 會拉取已發佈的軟體包，其中不包括您的本機變更。  
若要在本機上測試您的範本、命令和其他更改，請按照以下步驟操作：

1. **建立發布包**

   執行以下命令產生本機包：

   ```bash
   ./.github/workflows/scripts/create-release-packages.sh v1.0.0
   ```

2. **將相關套件複製到您的測試專案**

   ```bash
   cp -r .genreleases/sdd-copilot-package-sh/. <path-to-test-project>/
   ```

3. **打開並測試代理**

   導航到您的測試專案資料夾並開啟代理以驗證您的實作。

## AI 對 Spec Kit 的貢獻

> [！重要的]
>
> 如果您正在使用**任何類型的 AI 援助**來為 Spec Kit 做出貢獻，
> 它必須在拉取請求或問題中披露。

我們歡迎並鼓勵使用 AI 工具來幫助改進 Spec Kit！利用 AI 對計劃碼產生、問題偵測和功能定義的幫助，許多有價值的貢獻都得到了增強。

話雖然這麼說，如果您在為 Spec Kit 做出貢獻的同時使用任何類型的 AI 救援（例如代理、ChatGPT），
**這必須在拉取請求或問題中暴露**，以及使用 AI 幫助的程度（例如，文件註解與程式碼產生）。

如果您的公關回覆或評論是由 AI 產生的，也請揭露這一點。

作為例外，不需要披露瑣碎的間距或拼寫錯誤修復，只要更改僅限於程式碼或短語的一小部分。

揭露範例：

> 本公關主要由GitHub Copilot撰寫。

或更詳細的披露：

> 我諮詢了 ChatGPT 以了解程式碼函數函式庫，但解決方案
> 完全由我自己手動編寫。

未能披露這一點首先對拉取請求另一端的操作人員來說是粗魯的，但這也使得很難
確定對貢獻進行多少審查。

在一個完美的世界中，AI 援助將產生與任何相同的人或更高品質的工作。那不是我們今天生活的世界，而且在大多數情況下
如果沒有人類監督或專業知識，就會產生無法合理維護或發展的程式碼。

### 我們正在尋找什麼

提交 AI 捐款時，請確保包括：

- ** 明確暴露 AI 使用** - 您對 AI 使用以及您使用它進行貢獻的程度保持透明
- **人類理解和測試** - 您親自測試了這些更改並了解它們的作用
- ** 清晰的理由** - 您可以解釋為什麼需要進行更改以及它如何符合 Spec Kit 的目標
- **具體證據** - 包括證明改進的測試案例、場景或範例
- **您自己的分析** - 分享您對端到端開發人員體驗的想法

### 我們將關閉什麼

我們保留關閉以下貢獻的權利：

- 未經驗證而提交的未經測試的更改
- 不符合特定Spec Kit需求的一般建議
- 未經人工審核或理解的批量提交

### 成功指南

關鍵是證明您理解並已經驗證了您提出的更改。如果維護者可以輕鬆判斷貢獻完全由 AI 生成，無需人工輸入或測試，那麼在提交之前可能需要更多工作。

持續提交 AI 產生省力變更的貢獻者可能會被維護者酌情限制進一步貢獻。

請尊重維護者並揭露 AI 幫助。

## 資源

- [Spec-Driven Development 方法論](./spec-driven.md)
- [如何為開源做出貢獻](https://opensource.guide/how-to-contribute/)
- [使用拉取請求](https://help.github.com/articles/about-pull-requests/)
- [GitHub 幫助](https://help.github.com)
