# 安裝指南

## 先決條件

- **Linux/macOS**（或 Windows；現在支援 PowerShell 腳本，無需 WSL）
- AI 程式碼助理：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[CodeBuddy CLI](https://www.codebuddy.ai/cli) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [uv](https://docs.astral.sh/uv/) 用於套件管理
- [Python 3.11+](https://www.python.org/downloads/)
- [git](https://git-scm.com/downloads)

## 安裝

### 初始化一個新專案

最簡單的開始方法是初始化一個新專案：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

或在當前目錄初始化：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init .
# or use the --here flag
uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

### 指定 AI 代理

您可以在初始化期間主動指定 AI 代理計畫：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai claude
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai gemini
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai copilot
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai codebuddy
```

### 指定腳本類型（Shell 與 PowerShell）

所有自動化腳本現在都有 Bash (`.sh`) 和 PowerShell (`.ps1`) 變體。

自動行為：

- Windows 預設值：`ps`
- 其他作業系統預設值：`sh`
- 互動模式：除非您通過 `--script`，否則系統會提示您

強制使用特定的腳本類型：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --script sh
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --script ps
```

### 忽略代理工具檢查

如果您希望在不檢查是否有正確工具的情況下取得範本：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai claude --ignore-agent-tools
```

## 確認

初始化後，您應該在 AI 代理程式中看到以下可用命令：

- `/speckit.specify` - 建立規格
- `/speckit.plan` - 產生實施計劃  
- `/speckit.tasks` - 拆分為可操作的任務

`.specify/scripts` 目錄將包含 `.sh` 和 `.ps1` 腳本。

## 故障排除

### Linux 上的 Git 資源管理器

如果您在 Linux 上遇到 Git 驗證問題，可以安裝 Git Credential Manager：

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```
