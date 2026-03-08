# 擴充模板

用於建立 Spec Kit 擴充功能的入門範本。

## 快速入門

1. **複製此範本**：

   ```bash
   cp -r extensions/template my-extension
   cd my-extension
   ```

2. **自訂 `extension.yml`**：
   - 變更擴充 ID、名稱、描述
   - 更新作者和儲存庫
   - 定義你的命令

3. **建立命令**：
   - 在 `commands/` 目錄中新增指令文件
   - 使用 Markdown 格式和 YAML frontmatter

4. **建立設定範本**：
   - 定義設定選項
   - 記錄所有設定

5. **撰寫文檔**：
   - 使用使用說明更新 README.md
   - 新增範例

6. **本地測試**：

   ```bash
   cd /path/to/spec-kit-project
   specify extension add --dev /path/to/my-extension
   ```

7. **發布**（可選）：
   - 建立 GitHub 儲存庫
   - 建立版本
   - 提交至目錄（請參閱 EXTENSION-PUBLISHING-GUIDE.md）

## 此範本中的文件

- `extension.yml` - 擴充清單（自訂此）
- `config-template.yml` - 設定模板（自訂此）
- `commands/example.md` - 範例指令（取代此）
- `README.md` - 擴充文件（取代此）
- `LICENSE` - 麻省理工學院許可證（請參閱此內容）
- `CHANGELOG.md` - 版本歷史記錄（更新此）
- `.gitignore` - Git 忽略規則

## 客製化清單

- [ ] 使用您的分機詳細資料更新 `extension.yml`
- [ ] 將擴充 ID 變更為您的擴充名稱
- [ ] 更新作者訊息
- [ ] 定義你的命令
- [ ] 在 `commands/` 中建立指令文件
- [ ] 更新設定模板
- [ ] 寫入 README 並附上使用說明
- [ ] 新增範例
- [ ] 如果需要更新許可證
- [ ] 本地測試擴展
- [ ] 建立 git 儲存庫
- [ ] 建立第一個版本

## 需要幫助嗎？

- **開發指南**：請參閱 EXTENSION-DEVELOPMENT-GUIDE.md
- **API 參考**：請參閱 EXTENSION-API-REFERENCE.md
- **發布指南**：請參閱 EXTENSION-PUBLISHING-GUIDE.md
- **使用者指南**：請參閱 EXTENSION-USER-GUIDE.md

## 模板版本

- 版本：1.0.0
- 最後更新：2026-01-28
- 與 Spec Kit 相容：>=0.1.0
