# 規範驅動開發 (SDD)

## 功率反轉

幾十年來，程式碼一直是王道。規範為程式碼服務——它們是我們建造的腳手架，然後在編碼的「真正工作」開始後就被丟棄。我們編寫 PRD 來指導開發，建立設計文件來指導實施，繪製圖表來視覺化架構。但這些始終服從於程式碼本身。程式碼就是真理。其他一切充其量只是善意。程式碼是真理的源泉，隨著程式碼的發展，規範很少跟上。由於資產（程式碼）和實作是一體的，因此如果不嘗試從程式碼構建，就很難擁有並行實現。

Spec-Driven Development (SDD) 顛倒了這個權力結構。規範不服務於程式碼－程式碼服務於規範。產品需求文件 (PRD) 不是實施指南；而是實施指南。它是生成實作的來源。技術計劃不是指導編碼的文檔；而是指導編碼的文檔。它們是生成程式碼的精確定義。這並不是我們建構軟體方式的漸進式改進。這是對發展驅動因素的根本反思。

自軟體開發誕生以來，規範和實現之間的差距一直困擾著軟體開發。我們試圖透過更好的文件、更詳細的要求、更嚴格的流程來彌補它。這些方法之所以失敗，是因為它們認為差距是不可避免的。他們試圖縮小範圍，但從未消除它。 SDD 透過使規範及其由規範產生的具體實施計劃可執行來消除差距。當規範和實施計劃產生程式碼時，沒有間隙，只有轉換。

這種轉變現在成為可能，因為 AI 可以理解和實施複雜的規範，並建立詳細的實施計劃。但是沒有結構的原始 AI 生成會產生混亂。 SDD 透過精確、完整且明確的規範和後續實施計劃提供了該結構，足以產生工作系統。規格成為主要工件。程式碼成為其在特定語言和框架中的表達（作為實施計劃的實施）。

在這個新世界中，維護軟體意味著不斷發展的規格。開發團隊的意圖以自然語言（「**意圖驅動開發**」）、設計資產、核心原則和其他準則來表達。開發的**通用語言**邁向更高的水平，程式碼是最後一英里的方法。

調試意味著修復生成錯誤程式碼的規範及其實施計劃。重構意味著為了清晰而重組。整個開發工作流程圍繞著規範作為中心事實來源進行重組，實施計劃和程式碼作為不斷重新產生的輸出。因為我們是富有創造力的人，所以用新功能更新應用程式或建立新的平行實現意味著重新審視規範並建立新的實現計劃。因此這個過程是 0 -> 1, (1', ..), 2, 3, N。

開發團隊專注於他們的創造力、實驗性和批判性思維。

## SDD 工作流程的實踐

工作流程始於一個想法——通常是模糊且不完整的。透過與AI的迭代對話，這個想法變成了一個綜合性的PRD。 AI 提出澄清問題、辨識邊緣情況並協助定義精確的驗收標準。在傳統開發中可能需要數天會議和文件記錄的事情只需數小時的集中規範工作即可實現。這改變了傳統的 SDLC——需求和設計成為連續的活動，而不是離散的階段。這支援**團隊流程**，其中團隊審查的規範被表達和版本化，在分支中建立並合併。

當產品經理更新驗收標準時，實施計畫會自動標示受影響的技術決策。當架構師發現更好的模式時，PRD 就會更新以反映新的可能性。

在整個規範過程中，研究者收集重要的背景資訊。他們調查函式庫相容性、效能基準和安全影響。自動發現並套用組織約束 - 您公司的資料函式庫標準、身份驗證要求和部署策略無縫整合到每個規範中。

AI 從 PRD 產生將需求對應到技術決策的實施計劃。每項技術選擇都有記錄在案的理由。每個架構決策都可以追溯到特定的需求。在整個過程中，一致性驗證不斷提高品質。 AI 分析規範的模糊性、矛盾性和差距－不是作為一次性的門，而是作為持續的改進。

一旦規範及其實施計劃足夠穩定，程式碼產生就會開始，但它們不必是「完整的」。早期版本可能是探索性的——測試規範在實踐中是否有意義。領域概念成為資料模型。使用者故事成為 API 端點。驗收場景變成了測試。這透過規範合併了開發和測試——測試場景不是在程式碼之後編寫的，它們是生成實作和測試的規範的一部分。

反饋循環超出了最初的開發範圍。生產指標和事件不僅會觸發修補程序，還會更新下一次再生的規格。效能瓶頸成為新的非功能性需求。安全漏洞成為影響子孫後代的限制因素。這種規範、實施和操作現實之間的迭代舞蹈是真正理解出現的地方，也是傳統 SDLC 轉變為持續演進的地方。

## 為什麼 SDD 現在很重要

三個趨勢使 SDD 不僅成為可能，而且成為必要：

首先，AI 功能已經達到了自然語言規範可以可靠地產生工作程式碼的閾值。這不是要取代開發人員，而是要透過自動化從規範到實現的機械轉換來提高他們的效率。它可以放大探索和創造力，輕鬆支持“重新開始”，並支持加法、減法和批判性思維。

其次，軟體複雜度持續呈指數級增長。現代系統整合了數十種服務、框架和依賴項。透過手動流程使所有這些部分與原始意圖保持一致變得越來越困難。 SDD 透過規範驅動的生成提供系統對齊。框架可能會發展為提供 AI 優先支持，而不是人為優先支持，或圍繞可重複使用元件進行架構設計。

三是變革步伐加快。今天的需求變化比以往任何時候都快得多。旋轉不再是例外——這是人們所期望的。現代產品開發需要根據使用者回饋、市場狀況和競爭壓力進行快速迭代。傳統開發將這些變化視為破壞。每個樞紐都需要透過文件、設計和程式碼手動傳播變更。結果要不是緩慢、謹慎的更新，限制了速度，就是快速、魯莽的變化，累積了技術債。

SDD 可以支持假設/simulation 實驗：“如果我們需要重新實施或更改應用程式以促進業務需要銷售更多 T 卹，我們將如何實施和實驗？”

SDD 將需求變更從障礙轉變為正常工作流程。當規範推動實施時，支點就變成了系統性的再生，而不是手動重寫。更改 PRD 中的核心需求，受影響的實施計畫會自動更新。修改使用者故事，並重新產生對應的 API 端點。這不僅僅是初始開發的問題，而是透過不可避免的變化來維持工程速度的問題。

## 核心原則

**作為通用語言的規範**：規範成為主要工件。程式碼成為其在特定語言和框架中的表達。維護軟體意味著不斷發展的規格。

**可執行規格**：規格必須精確、完整且足夠明確，才能產生工作系統。這消除了意圖和實施之間的差距。

**持續細化**：一致性驗證是連續發生的，而不是一次性的。 AI 將分析規範中的歧義、矛盾和差距作為一個持續的過程。

**研究驅動的背景**：研究代理在整個規範過程中收集關鍵背景，調查技術選項、績效影響和組織限制。

**雙向回饋**：生產現實告知規範的演變。指標、事件和操作學習成為規範細化的輸入。

**探索分支**：從相同規範產生多種實作方法，以探索不同的最佳化目標—效能、可維護性、使用者體驗、成本。

## 實施方法

如今，實踐 SDD 需要組裝現有工具並在整個過程中保持紀律。該方法可以透過以下方式進行實踐：

- AI 迭代規格開發助手
- 用於收集技術背景的研究代理
- 用於將規範轉化為實現的程式碼生成工具
- 適用於規範優先工作流程的版本控制系統
- 透過 AI 分析規格文件進行一致性檢查

關鍵是將規範視為事實來源，將程式碼視為服務於規範的生成輸出，而不是相反。

## 使用指令簡化 SDD

SDD 方法透過三個強大的指令得到顯著增強，這些指令可自動執行規格 → 規劃 → 任務指派工作流程：

### `/speckit.specify` 指令

此命令將簡單的功能描述（使用者提示）轉換為具有自動儲存庫管理的完整的結構化規格：

1. **自動功能編號**：掃描現有規格以確定下一個功能編號（例如，001、002、003）
2. **分支建立**：根據您的描述產生語義分支名稱並自動建立
3. **基於模板的生成**：根據您的要求複製和自訂功能規範模板
4. **目錄結構**：為所有相關文件建立正確的 `specs/[branch-name]/` 結構

### `/speckit.plan` 指令

一旦存在功能規範，此命令就會建立一個全面的實施計劃：

1. **規範分析**：閱讀並瞭解功能要求、使用者故事和驗收標準
2. **憲法合規性**：確保與專案憲法和架構原則保持一致
3. **技術翻譯**：將業務需求轉換為技術架構和實作細節
4. **詳細文檔**：產生資料模型、API 合約和測試場景的支援文檔
5. **快速入門驗證**：產生捕捉關鍵驗證場景的快速入門指南

### `/speckit.tasks` 指令

建立計劃後，此命令會分析計劃和相關設計文件以產生可執行任務清單：

1. **輸入**：讀取 `plan.md`（必需）以及 `data-model.md`、`contracts/` 和 `research.md`（如果存在）
2. **任務派生**：將合約、實體、場景轉換為具體任務
3. **並行化**：標記獨立任務 `[P]` 並概述安全並行群組
4. **輸出**：將 `tasks.md` 寫入功能目錄中，準備好由任務代理執行

### 範例：建立聊天功能

以下是這些指令如何改變傳統開發工作流程：

**傳統方法：**

```text
1. Write a PRD in a document (2-3 hours)
2. Create design documents (2-3 hours)
3. Set up project structure manually (30 minutes)
4. Write technical specifications (3-4 hours)
5. Create test plans (2 hours)
Total: ~12 hours of documentation work
```

**使用指令方法的 SDD：**

```bash
# Step 1: Create the feature specification (5 minutes)
/speckit.specify Real-time chat system with message history and user presence

# This automatically:
# - Creates branch "003-chat-system"
# - Generates specs/003-chat-system/spec.md
# - Populates it with structured requirements

# Step 2: Generate implementation plan (5 minutes)
/speckit.plan WebSocket for real-time messaging, PostgreSQL for history, Redis for presence

# Step 3: Generate executable tasks (5 minutes)
/speckit.tasks

# This automatically creates:
# - specs/003-chat-system/plan.md
# - specs/003-chat-system/research.md (WebSocket library comparisons)
# - specs/003-chat-system/data-model.md (Message and User schemas)
# - specs/003-chat-system/contracts/ (WebSocket events, REST endpoints)
# - specs/003-chat-system/quickstart.md (Key validation scenarios)
# - specs/003-chat-system/tasks.md (Task list derived from the plan)
```

15 分鐘內，您將獲得：

- 包含使用者故事和驗收標準的完整功能規範
- 包含技術選擇和理由的詳細實施計劃
- API 合約和資料模型準備好產生程式碼
- 自動和手動測試的綜合測試場景
- 功能分支中的所有文件已正確版本化

### 結構化自動化的力量

這些命令不僅可以節省時間，還可以增強一致性和完整性：

1. **不會忘記細節**：模板確保考慮到各個方面，從非功能性需求到錯誤處理
2. **可追蹤的決策**：每個技術選擇都連結到特定的要求
3. **動態文件**：規格與程式碼保持同步，因為它們產生程式碼
4. **快速迭代**：更改需求並在幾分鐘內重新產生計劃，而不是幾天

這些命令透過將規範視為可執行工件而不是靜態文件來體現 SDD 原則。它們將規範過程從不可避免的罪惡轉變為發展的驅動力。

### 範本驅動的品質：結構如何限制法學碩士以獲得更好的成果

這些命令的真正力量不僅在於自動化，還在於模板如何引導 LLM 行為實現更高品質的規格。這些範本可作為複雜的提示，以高效的方式限制法學碩士的輸出：

#### 1. **防止過早實施細節**

功能規格模板明確指示：

```text
- ✅ Focus on WHAT users need and WHY
- ❌ Avoid HOW to implement (no tech stack, APIs, code structure)
```

這項限制迫使法學碩士保持適當的抽象層次。當法學碩士可能會自然地跳到「使用 React 和 Redux 來實現」時，該模板將重點放在「用戶需要即時更新其數據」上。即使實現技術變化，這種分離也能確保規範保持穩定。

#### 2. **強制使用顯式的不確定性標記**

這兩個模板都要求使用 `[NEEDS CLARIFICATION]` 標記：

```text
When creating this spec from a user prompt:
1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question]
2. **Don't guess**: If the prompt doesn't specify something, mark it
```

這可以防止法學碩士做出看似合理但可能不正確的假設的常見行為。 LLM 必須將其標記為 `[NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]`，而不是猜測「登入系統」使用電子郵件 /password 驗證。

#### 3. **透過清單進行結構化思考**

這些範本包括充當規範的「單元測試」的綜合檢查表：

```markdown
### Requirement Completeness

- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable
```

這些清單迫使法學碩士有系統地自我審查其輸出，找出可能漏掉的差距。這就像為法學碩士提供了一個品質保證框架。

#### 4. **透過大門遵守憲法**

實施計劃範本透過階段門強制實施架構原則：

```markdown
### Phase -1: Pre-Implementation Gates

#### Simplicity Gate (Article VII)

- [ ] Using ≤3 projects?
- [ ] No future-proofing?

#### Anti-Abstraction Gate (Article VIII)

- [ ] Using framework directly?
- [ ] Single model representation?
```

這些門透過使法學碩士明確證明任何複雜性的合理性來防止過度設計。如果一個門失敗了，法學碩士必須在「複雜性追蹤」部分記錄原因，為架構決策建立問責制。

#### 5. **分層細節管理**

模板強制執行正確的資訊架構：

```text
**IMPORTANT**: This implementation plan should remain high-level and readable.
Any code samples, detailed algorithms, or extensive technical specifications
must be placed in the appropriate `implementation-details/` file
```

這可以防止規範成為不可讀的程式碼轉儲的常見問題。法學碩士學習保持適當的細節級別，將複雜性提取到單獨的文件中，同時保持主文檔的可導航性。

#### 6. **測試優先思維**

實作範本強制執行測試優先開發：

```text
### File Creation Order
1. Create `contracts/` with API specifications
2. Create test files in order: contract → integration → e2e → unit
3. Create source files to make tests pass
```

這種排序約束確保法學碩士在實施之前考慮可測試性和合同，從而產生更強大和可驗證的規範。

#### 7. **防止投機功能**

模板明確阻止猜測：

```text
- [ ] No speculative or "might need" features
- [ ] All phases have clear prerequisites and deliverables
```

這可以阻止法學碩士添加「最好有」的功能，從而使實施變得複雜。每個功能都必須追溯到具有明確驗收標準的具體使用者故事。

### 複合效應

這些約束共同產生以下規格：

- **完整**：檢查表確保不會忘記任何事情
- **明確**：強制澄清標記突出了不確定性
- **可測試**：測試優先的思維融入流程中
- **可維護**：適當的抽象層級和資訊層次結構
- **可實施**：明確的階段和具體的可交付成果

這些模板將法學碩士從富有創意的作家轉變為訓練有素的規範工程師，將其能力引導至產生始終如一的高品質、可執行的規範，從而真正推動開發。

## 憲法基礎：加強建築紀律

SDD 的核心在於憲法——一組控制規範如何成為程式碼的不變原則。憲法 (`memory/constitution.md`) 充當系統的架構 DNA，確保每個生成的實作保持一致性、簡單性和品質。

### 發展九條

憲法定義了九個條款，影響發展過程的各個面向：

#### 第一：圖書館優先原則

每個功能都必須從一個獨立的函式函式庫開始—無一例外。這迫使從一開始就進行模組化設計：

```text
Every feature in Specify MUST begin its existence as a standalone library.
No feature shall be implemented directly within application code without
first being abstracted into a reusable library component.
```

這項原則確保規範產生模組化、可重複使用的程式碼，而不是單一的應用程式。當法學碩士產生實施計劃時，它必須將功能建構成具有清晰邊界和最小依賴性的函式庫。

#### 第二條：CLI 介面授權

每個函式庫都必須透過命令列介面公開其功能：

```text
All CLI interfaces MUST:
- Accept text as input (via stdin, arguments, or files)
- Produce text as output (via stdout)
- Support JSON format for structured data exchange
```

這增強了可觀察性和可測試性。 LLM 不能隱藏不透明類別中的功能——所有內容都必須可以透過基於文字的介面進行存取和驗證。

#### 第三條：測試第一的必要性

最具變革性的文章－測試前無程式碼：

```text
This is NON-NEGOTIABLE: All implementation MUST follow strict Test-Driven Development.
No implementation code shall be written before:
1. Unit tests are written
2. Tests are validated and approved by the user
3. Tests are confirmed to FAIL (Red phase)
```

這完全顛倒了傳統的 AI 程式碼生成。法學碩士必須先產生定義行為的全面測試，獲得批准，然後才能產生實現，而不是產生程式碼並希望它能運作。

#### 第七條和第八條：簡單性與反抽象

這些配對的文章反對過度設計：

```text
Section 7.3: Minimal Project Structure
- Maximum 3 projects for initial implementation
- Additional projects require documented justification

Section 8.1: Framework Trust
- Use framework features directly rather than wrapping them
```

當法學碩士可能自然地建立複雜的抽象時，這些文章迫使它證明每一層複雜性的合理性。實施計劃範本的「階段-1 門」直接執行這些原則。

#### 第九條：整合優先測試

優先考慮實際測試而不是孤立的單元測試：

```text
Tests MUST use realistic environments:
- Prefer real databases over mocks
- Use actual service instances over stubs
- Contract tests mandatory before implementation
```

這確保生成的程式碼在實踐中有效，而不僅僅是理論上。

### 透過模板執行憲法

實施計劃範本透過具體的檢查點來操作這些文章：

```markdown
### Phase -1: Pre-Implementation Gates

#### Simplicity Gate (Article VII)

- [ ] Using ≤3 projects?
- [ ] No future-proofing?

#### Anti-Abstraction Gate (Article VIII)

- [ ] Using framework directly?
- [ ] Single model representation?

#### Integration-First Gate (Article IX)

- [ ] Contracts defined?
- [ ] Contract tests written?
```

這些門充當架構原則的編譯時檢查。如果沒有通過門檻或在「複雜性追蹤」部分記錄合理的例外情況，法學碩士就無法繼續進行。

### 不變原則的力量

憲法的力量在於它的不變性。雖然實施細節可能會發生變化，但核心原則保持不變。這提供了：

1. **跨時間的一致性**：今天產生的程式碼遵循與明年產生的程式碼相同的原則
2. **法學碩士之間的一致性**：不同的 AI 模型產生架構相容的程式碼
3. **架構完整性**：每個功能都加強而不是破壞系統設計
4. **品質保證**：測試優先、函式庫優先和簡單性原則確保程式碼可維護

### 憲法的演變

雖然原則是一成不變的，但它們的應用可以不斷發展：

```text
Section 4.2: Amendment Process
Modifications to this constitution require:
- Explicit documentation of the rationale for change
- Review and approval by project maintainers
- Backwards compatibility assessment
```

這使得該方法能夠在保持穩定性的同時進行學習和改進。憲法透過過時的修正案展示了其自身的演變，展示瞭如何根據現實世界的經驗來完善原則。

### 超越規則：發展理念

章程不僅僅是一本規則手冊，它是一種哲學，塑造了法學碩士如何看待程式碼生成：

- **可觀察性高於不透明度**：一切都必須透過 CLI 介面進行檢查
- **簡單勝過​​聰明**：從簡單開始，僅在證明有必要時才增加複雜性
- **整合勝於隔離**：在真實環境中進行測試，而不是人工環境
- **模組化優於單體**：每個功能都是邊界清晰的函式庫

透過將這些原則嵌入到規範和規劃流程中，SDD 確保產生的程式碼不僅具有功能性，而且具有可維護性、可測試性和架構合理性。该章程将 AI 从代码生成器转变为尊重并强化系统设计原则的架构合作伙伴。

## 轉變

這並不是要取代開發人員或自動化創造力。它是透過自動化機械翻譯來增強人類能力。它是關於建立一個緊密的反饋循環，其中規範、研究和程式碼一起發展，每次迭代都會帶來更深入的理解以及意圖和實現之間更好的一致性。

軟體開發需要更好的工具來保持意圖和實現之間的一致性。 SDD 提供了透過產生程式碼而不是僅僅指導程式碼的可執行規範來實現這種一致性的方法。
