# Feature Specification: Claude Code Workflow Optimization

**Feature Branch**: `018-claude-code-workflow`

**创建日期**: 2026-06-09

**状态**: Draft

**用户描述**: 添加针对Claude Code的专门优化，如果初始化时选择Claude Code，则vipd-task和vipd-implement阶段直接编写和调用Claude Code的Workflow（https://code.claude.com/docs/en/agent-sdk/typescript#workflow）开启并行工作和多Agent协同。

## 澄清记录

### 会话 2026-06-09

- Q: Claude Code 模式标记应存储在哪里？ → A: 集中存储在 `.vipd/config.yml`，`init-options.json` 仅作为初始化时的传递中间态。
- Q: 传统模式如何升级到 Claude Code 模式？ → A: 提供专用配置命令 `vipd config set mode claude-code`，无需重新初始化。
- Q: Workflow 脚本如何与 tasks.md 保持同步？ → A: 每次运行 `vipd-tasks` 时自动重新生成 Workflow 脚本。
- Q: 并行 Agent 并发数如何确定？ → A: 根据 User Story 数量自适应，公式为 `min(5, 用户故事数)`，无需额外配置。运行时上限为 16 个并发 Agent。
- Q: 如何检测当前是否为 Claude Code 运行环境？ → A: 运行时探测 — 先读配置标记，再尝试调用 Workflow 工具验证能力，失败则降级到传统模式。

## 用户场景与测试 *(必填)*

### 用户场景 1 — 选择 Claude Code 模式初始化项目 (P1)

作为一名项目经理，我想在初始化项目时选择"Claude Code"模式，这样后续的任务生成和执行就能自动利用 Claude Code 的 Workflow 引擎并行处理任务，从而显著缩短开发周期。

**为什么是这个优先级**: 这是整个功能的基础入口。没有这个入口点，后续的 Workflow 生成和执行都无法触发。

**独立测试**: 在全新目录中运行 `vipd init` 并选择 Claude Code 模式，随后检查 `init-options.json` 中是否正确标记了 Workflow 模式。

**验收场景**:

1. **Given** 一个全新的项目目录，**When** 运行 `vipd init` 并指定 `--integration claude-code`，**Then** `init-options.json` 中应包含 `"mode": "claude-code"` 标记
2. **Given** 一个全新的项目目录，**When** 运行 `vipd init` 并指定 `--integration claude`（传统模式），**Then** `init-options.json` 中不应包含 Workflow 模式标记
3. **Given** 已初始化的项目，**When** 查看 `.vipd/` 目录，**Then** 应能通过配置文件清晰看出当前是否为 Claude Code 模式

---

### 用户场景 2 — 任务生成阶段自动生成 Workflow 脚本 (P1)

作为一名开发者，在使用 Claude Code 模式的项目中运行 `vipd-tasks` 时，我希望系统自动生成一个 Claude Code Workflow 脚本，将各个 User Story 的任务组织成并行可执行的工作流，而不是仅仅生成一个平铺的任务列表。

**为什么是这个优先级**: 这是 Workflow 执行的前提。必须有 Workflow 脚本，后续才能并行执行任务。

**独立测试**: 在 Claude Code 模式的项目中运行 `vipd-tasks`，验证是否在 `.claude/workflows/` 目录下生成有效的 Workflow 脚本文件。

**验收场景**:

1. **Given** 一个 Claude Code 模式的项目且 spec.md 和 plan.md 已就绪，**When** 运行 `vipd-tasks`，**Then** 在 `.claude/workflows/` 目录下生成 `execute-tasks.wf.js` 文件
2. **Given** 生成的 Workflow 脚本文件，**When** 检查其内容，**Then** 应使用 `agent()`、`parallel()`、`pipeline()`、`phase()` 等 Claude Code Workflow API
3. **Given** Workflow 脚本，**When** 检查其结构，**Then** 应包含正确的 `export const meta` 定义（包含 `name`、`description`、`phases`）
4. **Given** 传统模式的项目，**When** 运行 `vipd-tasks`，**Then** 不应生成 Workflow 脚本，维持现有 tasks.md 行为

---

### 用户场景 3 — 实现阶段通过 Workflow 并行执行任务 (P1)

作为一名开发者，在 Claude Code 模式的项目中运行 `vipd-implement` 时，我希望系统直接调用之前生成的 Workflow 脚本通过 Workflow 工具执行，让多个 Agent 并行处理不同 User Story 的任务，从而显著缩短总体实现时间。

**为什么是这个优先级**: 这是最终价值的交付点。前面的准备都是为了这一步的并行执行。

**独立测试**: 在 Claude Code 模式的项目中运行 `vipd-implement`，验证是否触发了 Workflow 执行，并且多个 Agent 同时工作。

**验收场景**:

1. **Given** 一个 Claude Code 模式的项目且 tasks.md 和 Workflow 脚本已就绪，**When** 运行 `vipd-implement`，**Then** 应调用 Workflow 工具执行 `.claude/workflows/execute-tasks.wf.js`
2. **Given** Workflow 执行期间，**When** 多个无依赖关系的任务被派发，**Then** 至少有两个 Agent 同时并行工作
3. **Given** 传统模式的项目，**When** 运行 `vipd-implement`，**Then** 应维持现有顺序执行行为，不触发 Workflow

---

### 用户场景 4 — 混合模式：部分顺序，部分并行 (P2)

作为一名系统架构师，我希望 Workflow 脚本能正确识别任务依赖关系：有依赖的任务顺序执行，无依赖的任务并行执行。Setup 阶段和 Foundational 阶段完成后，各 User Story 才能并行启动。

**为什么是这个优先级**: 这是 Workflow 正确性的关键保证，直接影响实现质量。

**独立测试**: 在 Claude Code 模式的项目中生成 Workflow 脚本，检查是否按依赖关系正确编排。

**验收场景**:

1. **Given** 一个包含多个 User Story 的 tasks.md，**When** 生成 Workflow 脚本，**Then** Phase 1（Setup）和 Phase 2（Foundational）的任务应在并行块之前顺序执行
2. **Given** Workflow 脚本中 P3/P4 的 User Story 任务，**When** 它们之间不存在文件冲突和逻辑依赖，**Then** 应被组织到 `parallel()` 块中同时执行
3. **Given** Workflow 脚本中标记了 `[P]` 的并行任务，**When** Workflow 执行，**Then** 每个 `[P]` 任务应通过独立的 `agent()` 调用执行

---

### 用户场景 5 — 执行进度透明可追踪 (P2)

作为一名项目经理或开发者，在 Workflow 执行过程中，我希望能够实时看到各个 Agent 的进度状态、已完成的任务和当前正在执行的任务，从而对整个实现过程有清晰的掌握。

**为什么是这个优先级**: 可见性是信任的前提。用户需要知道并行执行没有"失控"。

**独立测试**: 启动 Workflow 执行后，通过 `/workflows` 命令查看进度。

**验收场景**:

1. **Given** Workflow 正在执行中，**When** 用户查看进度，**Then** 应显示当前处于哪个 Phase、每个 Phase 下有哪些 Agent 正在运行
2. **Given** Workflow 部分任务已完成，**When** 用户查看状态，**Then** 应清晰区分已完成、进行中、待处理的任务
3. **Given** Workflow 执行完成，**When** 用户查看最终报告，**Then** 应展示所有并行 Agent 的产出摘要

---

### 边界情况

- **模式切换**: 如果一个项目最初是传统模式初始化，后续用户想切换到 Claude Code 模式，可通过 `vipd config set mode claude-code` 命令完成升级，无需重新初始化。
- **Workflow 不存在**: 如果 `vipd-implement` 运行时发现 `.claude/workflows/` 目录为空或 Workflow 脚本缺失，应优雅降级到传统顺序执行模式而非崩溃。
- **Workflow 执行中断**: 如果 Workflow 执行被中断（如用户取消），应提供恢复/重试机制，不丢失已完成的工作。
- **超大项目**: 当有 20+ 个 User Story 时，Workflow 脚本应使用自适应并发控制（`min(5, 用户故事数)`），避免一次性派发过多并行 Agent
- **任务失败处理**: 当并行执行的某个 Agent 失败时，不应影响其他正在执行的 Agent，失败信息应在最终报告中清晰呈现。

## TR 门控评估 *(IPD only)*

- **适用 TR 门**: TR1 (概念), TR2/TR3 (计划), TR4 (开发)
- **风险等级**: 中 — 涉及核心工作流的变更，但具有清晰的降级路径
- **门控证据要求**: 功能规格说明书、Workflow 模板设计、端到端测试报告

## 需求 *(必填)*

### 功能需求

- **FR-001**: 系统必须在 `vipd init` 中支持 `--integration claude-code` 选项，以指定 Claude Code 工作流模式
- **FR-002**: `vipd init` 必须在 `.vipd/config.yml` 中写入 `mode: claude-code` 配置项，并在 `init-options.json` 中保留临时标记作为初始化记录。所有下游技能（vipd-tasks、vipd-implement）从 `.vipd/config.yml` 读取模式状态。
- **FR-003**: 在 Claude Code 模式下，每次运行 `vipd-tasks` 时，必须在生成 tasks.md 的同时自动重新生成 `.claude/workflows/execute-tasks.wf.js` 文件，保持两者始终同步
- **FR-004**: Workflow 脚本必须使用 Claude Code Workflow API（`export const meta`、`agent()`、`parallel()`、`pipeline()`、`phase()`、`log()`）编写
- **FR-005**: Workflow 脚本必须正确映射 tasks.md 中的任务依赖关系：Setup → Foundational → User Stories（并行）
- **FR-006**: 在 Claude Code 模式下，`vipd-implement` 必须先读取 `.vipd/config.yml` 中的模式标记，再尝试调用 Workflow 工具确认运行时能力，两者均验证通过后才执行 Workflow 脚本
- **FR-007**: 当 Workflow 脚本不存在时，`vipd-implement` 必须优雅降级到传统顺序执行模式
- **FR-008**: Workflow 脚本中每个标记为 `[P]` 的并行任务必须通过独立的 `agent()` 调用执行
- **FR-009**: 每个 User Story 的独立测试验证必须在对应的并行 `agent()` 块完成后自动执行。验证方式为对照 spec.md 中该 User Story 的验收场景（Given/When/Then）逐条确认，无需编写自动化测试代码。
- **FR-010**: Workflow 执行完成后必须提供汇总报告，包含每个 Agent 的执行结果和状态
- **FR-011**: 系统必须提供专用配置命令（如 `vipd config set mode claude-code`）支持从传统模式升级到 Claude Code 模式，无需重新运行初始化

### 关键实体

- **Workflow 模式标记**: 存储在 `.vipd/config.yml` 中的 `mode: claude-code` 配置项，指示当前项目是否启用 Claude Code Workflow。`init-options.json` 在初始化时写入，仅作为初始化记录。
- **Workflow 脚本**: 存储在 `.claude/workflows/execute-tasks.wf.js` 的文件，包含完整的 Workflow 编排逻辑
- **任务映射表**: 将 tasks.md 中的任务 ID 和 User Story 映射到 Workflow 脚本中 `agent()` 调用的数据模型
- **执行报告**: Workflow 执行完成后生成的汇总数据，包含每个 Agent 的成功/失败状态和产出

## 成功标准 *(必填)*

### 可衡量的成果

- **SC-001**: 在 Claude Code 模式下，vipd-tasks 任务生成时间不超过 30 秒（包括 tasks.md 和 Workflow 脚本的生成）
- **SC-002**: 在 Claude Code 模式下，vipd-implement 的并行执行比传统顺序执行快至少 40%（对于 3+ 个独立 User Story 的项目）
- **SC-003**: 降级机制 100% 可靠 — 当 Workflow 脚本不存在时，vipd-implement 始终能退回到传统模式而不报错
- **SC-004**: Workflow 执行中断后恢复时，已完成的任务结果 100% 保留，不会重复执行。利用 Claude Code Workflow 运行时的原生恢复能力（同 session 内已完成 agent 返回缓存结果），无需额外实现恢复机制。
- **SC-005**: 用户无需学习 Workflow API 即可使用 — Workflow 脚本的生成和调用完全自动化，用户零干预

## 假设

- 用户已在系统中安装了 Claude Code CLI 且版本支持 Workflow API（Workflow 工具可用）
- Claude Code 模式仅在项目初始化时选择，不支持运行时动态切换（但支持通过配置手动升级）
- 生成的 Workflow 脚本遵循 Claude Code 官方 Workflow 规范（https://code.claude.com/docs/en/agent-sdk/typescript#workflow）
- 传统模式（`--integration claude`）的行为不受此功能影响
- Workflow 的并发上限由 Claude Code 运行时决定，本功能不做额外限制
- tasks.md 仍然是单源真相（Single Source of Truth），Workflow 脚本是从 tasks.md 派生的可执行工件

## 风险登记 *(IPD only)*

| 风险 | 影响 | 可能性 | 缓解措施 |
|------|------|--------|----------|
| Claude Code Workflow API 版本变更导致脚本不兼容 | 高 | 中 | 在 Workflow 脚本头部添加版本注释，并提供脚本重新生成命令 |
| 用户误删除 Workflow 脚本 | 中 | 中 | 自动降级到传统模式，并提供 `/vipd-tasks --regenerate-workflow` 重新生成命令 |
| 并行 Agent 过多导致令牌消耗激增 | 中 | 中 | Workflow 脚本使用自适应并发控制，公式 `min(5, 用户故事数)` |
| 用户使用非 Claude Code 环境运行 | 高 | 低 | `vipd-implement` 执行时运行时探测：先读配置标记，再尝试调用 Workflow 工具验证能力，失败则自动降级到传统模式。无需用户干预。 |
