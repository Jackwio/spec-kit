# 文件

此資料夾包含 Spec Kit 的文件來源文件，使用 [文件FX](https://dotnet.github.io/docfx/) 建置。

## 本地建設

若要在本機建置文件：

1. 安裝DocFX：

   ```bash
   dotnet tool install -g docfx
   ```

2. 建置文件：

   ```bash
   cd docs
   docfx docfx.json --serve
   ```

3. 開啟瀏覽器到 `http://localhost:8080` 以查看文件。

## 結構

- `docfx.json` - DocFX 設定文件
- `index.md` - 主要文件首頁
- `toc.yml` - 目錄設定
- `installation.md` - 安裝指南
- `quickstart.md` - 快速入門指南
- `_site/` - 產生的文檔輸出（被 git 忽略）

## 部署

當變更被推送到 `main` 分支時，文件會自動建置並部署到 GitHub 頁面。工作流程在 `.github/workflows/docs.yml` 中定義。
