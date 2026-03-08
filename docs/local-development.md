# 本地開發指南

本指南展示如何在本地迭代 `specify` CLI，而無需先發布版本或提交到 `main`。

> 腳本現在具有 Bash (`.sh`) 和 PowerShell (`.ps1`) 變體。 CLI 根據作業系統自動選擇，除非您透過 `--script sh|ps`。

## 1. 克隆和切換分支

```bash
git clone https://github.com/github/spec-kit.git
cd spec-kit
# Work on a feature branch
git checkout -b your-feature-branch
```

## 2.直接執行CLI（最快回饋）

您可以透過模組入口點執行 CLI 而無需安裝任何東西：

```bash
# From repo root
python -m src.specify_cli --help
python -m src.specify_cli init demo-project --ai claude --ignore-agent-tools --script sh
```

如果您喜歡呼叫腳本檔案樣式（使用 shebang）：

```bash
python src/specify_cli/__init__.py init demo-project --script ps
```

## 3.使用可編輯安裝（隔離環境）

使用 `uv` 建立一個隔離的環境，以便依賴關係的解析與最終使用者取得它們的方式完全相同：

```bash
# Create & activate virtual env (uv auto-manages .venv)
uv venv
source .venv/bin/activate  # or on Windows PowerShell: .venv\Scripts\Activate.ps1

# Install project in editable mode
uv pip install -e .

# Now 'specify' entrypoint is available
specify --help
```

由於可編輯模式，程式碼編輯後重新執行不需要重新安裝。

## 4. 直接從 Git（目前分支）呼叫 uvx

`uvx` 可以從本地路徑（或 Git 引用）執行來模擬使用者流程：

```bash
uvx --from . specify init demo-uvx --ai copilot --ignore-agent-tools --script sh
```

您也可以將 uvx 指向特定分支而不合併：

```bash
# Push your working branch first
git push origin your-feature-branch
uvx --from git+https://github.com/github/spec-kit.git@your-feature-branch specify init demo-branch-test --script ps
```

### 4a.絕對路徑 uvx（從任何地方執行）

如果您位於另一個目錄中，請使用絕對路徑而不是 `.`：

```bash
uvx --from /mnt/c/GitHub/spec-kit specify --help
uvx --from /mnt/c/GitHub/spec-kit specify init demo-anywhere --ai copilot --ignore-agent-tools --script sh
```

為了方便起見設定一個環境變數：

```bash
export SPEC_KIT_SRC=/mnt/c/GitHub/spec-kit
uvx --from "$SPEC_KIT_SRC" specify init demo-env --ai copilot --ignore-agent-tools --script ps
```

（可選）定義 shell 函數：

```bash
specify-dev() { uvx --from /mnt/c/GitHub/spec-kit specify "$@"; }
# Then
specify-dev --help
```

## 5. 測試腳本權限邏輯

執行 `init` 後，檢查 shell 腳本在 POSIX 系統上是否可執行：

```bash
ls -l scripts | grep .sh
# Expect owner execute bit (e.g. -rwxr-xr-x)
```

在 Windows 上，您將使用 `.ps1` 腳本（無需 chmod）。

## 6. 執行 Lint/基本檢查（新增您自己的）

目前沒有捆綁強制 lint 設定，但您可以快速檢查可導入性：

```bash
python -c "import specify_cli; print('Import OK')"
```

## 7. 在本地建造一個輪子（可選）

發布前驗證打包：

```bash
uv build
ls dist/
```

如果需要，將建置的工件安裝到新的一次性環境中​​。

## 8. 使用臨時工作空間

在髒目錄中測試 `init --here` 時，建立一個臨時工作區：

```bash
mkdir /tmp/spec-test && cd /tmp/spec-test
python -m src.specify_cli init --here --ai claude --ignore-agent-tools --script sh  # if repo copied here
```

或者，如果您想要更輕的沙箱，則僅複製修改後的 CLI 部分。

## 9. 調試網路/TLS 跳過

如果您在試驗時需要繞過 TLS 驗證：

```bash
specify check --skip-tls
specify init demo --skip-tls --ai gemini --ignore-agent-tools --script ps
```

（僅用於本地實驗。）

## 10. 快速編輯循環總結

| 行動 | 命令 |
|--------|---------|
| 直接運轉 CLI | `python -m src.specify_cli --help` |
| 可編輯安裝 | `uv pip install -e .` 然後 `specify ...` |
| 本地 uvx 執行（repo root） | `uvx --from . specify ...` |
| 本地uvx執行（abs路徑） | `uvx --from /mnt/c/GitHub/spec-kit specify ...` |
| Git 分支 uvx | `uvx --from git+URL@branch specify ...` |
| 造輪 | `uv build` |

## 11. 清理

快速刪除建置工件/虛擬環境：

```bash
rm -rf .venv dist build *.egg-info
```

## 12. 常見問題

| 症狀 | 使固定 |
|---------|-----|
| `ModuleNotFoundError: typer` | 跑 `uv pip install -e .` |
| 腳本不可執行 (Linux) | 重新執行 init 或 `chmod +x scripts/*.sh` |
| 跳過了 Git 步驟 | 您通過了 `--no-git` 或 Git 未安裝 |
| 下載的腳本類型錯誤 | 明確傳遞 `--script sh` 或 `--script ps` |
| 公司網路上的 TLS 錯誤 | 嘗試 `--skip-tls` （不適用於生產） |

## 13. 後續步驟

- 更新文件並使用修改後的 CLI 執行快速入門
- 滿意後打開 PR
- （可選）在 `main` 中更改土地後標記發布
