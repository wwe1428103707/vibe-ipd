---

description: "生成 Claude Code Workflow 优化功能的实现任务列表"
---

# Tasks: Claude Code Workflow Optimization

**Input**: Design documents from `/specs/018-claude-code-workflow/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: IPD 模式激活，测试为强制要求。

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Skills**: `.claude/skills/<skill-name>/SKILL.md`
- **Templates**: `.claude/templates/<template-name>.js`
- **Config**: `.vipd/config.yml`
- **Contracts**: `specs/018-claude-code-workflow/contracts/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: 创建 Workflow 模板目录结构和初始文件

- [x] T001 创建 `.claude/templates/` 目录结构和初始占位文件
- [x] T002 [P] 创建 Workflow 脚本模板 `.claude/templates/workflow-template.js`，包含 `export const meta`、`phase()`、`parallel()`、`agent()`、`log()` 框架代码和 `{{PLACEHOLDER}}` 标记

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: 所有 User Story 依赖的核心基础设施

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 实现 `.vipd/config.yml` 的 `mode` 字段读写功能：读取 mode 值、写入 mode 值、处理字段不存在时的默认值（`standard`）
- [x] T004 [P] 创建环境探测工具脚本，验证 Workflow 工具可用性（最小 Workflow 脚本探测）

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel
> **Gate Completion Verification**: All setup and foundational tasks [ ] completed / [ ] verified

---

## Phase 3: User Story 1 — 选择 Claude Code 模式初始化项目 (Priority: P1) 🎯 MVP

**Goal**: 用户在 `vipd init` 中通过 `--integration claude-code` 指定 Claude Code 模式，初始化完成后 `.vipd/config.yml` 中写入 `mode: claude-code`

**Independent Test**: 在临时目录运行 `vipd init test-project --integration claude-code`，检查 `.vipd/config.yml` 中是否存在 `mode: claude-code` 字段

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **NOTE**: 本功能的测试通过验收场景验证，无需独立的合同/集成测试任务。验收测试场景已在 spec.md 中定义。

### Implementation for User Story 1

- [x] T005 [P] [US1] 扩展 `vipd-init` 的 SKILL.md 参数说明，添加 `--integration claude-code` 支持示例和说明 in `.claude/skills/vipd-init/SKILL.md`
- [x] T006 [US1] 在 `vipd init` 后置步骤中增加 `.vipd/config.yml` 的 `mode: claude-code` 写入逻辑，读取 `init-options.json` 中的 `integration` 字段
- [x] T007 [P] [US1] 实现 `vipd config set mode <standard|claude-code>` 命令，允许运行时切换模式（更新 `.vipd/config.yml`）
- [x] T008 [US1] 验证集成：在测试目录运行 `vipd init --integration claude-code` → 确认 `.vipd/config.yml` 包含 mode 字段

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 — 任务生成阶段自动生成 Workflow 脚本 (Priority: P1)

**Goal**: 在 Claude Code 模式下运行 `vipd-tasks` 时，自动解析 tasks.md 并生成 `.claude/workflows/execute-tasks.wf.js`

**Independent Test**: 在 Claude Code 模式的项目中运行 `vipd-tasks`，验证 `.claude/workflows/execute-tasks.wf.js` 是否存在且内容包含 `export const meta` 和 `agent()` 调用

### Implementation for User Story 2

- [x] T009 [US2] 在 `vipd-tasks` SKILL.md 中增加 Claude Code 模式检测步骤（读取 `.vipd/config.yml` 的 `mode` 字段）in `.claude/skills/vipd-tasks/SKILL.md`
- [x] T010 [P] [US2] 实现 tasks.md 解析器：提取 Phase 结构、User Story 标签（`[US1]`、`[US2]` 等）、`[P]` 并行标记、任务描述和文件路径
- [x] T011 [P] [US2] 实现 Workflow 模板注入引擎：用解析结果替换 `workflow-template.js` 中的 `{{PLACEHOLDER}}` 标记
- [x] T012 [US2] 在 `vipd-tasks` SKILL.md 中添加 Workflow 脚本自动生成步骤：生成结果写入 `.claude/workflows/execute-tasks.wf.js`
- [x] T013 [US2] 验证生成结果：运行 `vipd-tasks` → 检查 `.wf.js` 文件语法、`export const meta` 存在性、Phase 映射正确性

**Checkpoint**: User Story 2 complete — Workflow 脚本可自动生成

---

## Phase 5: User Story 3 — 实现阶段通过 Workflow 并行执行 (Priority: P1)

**Goal**: 在 Claude Code 模式下运行 `vipd-implement` 时，通过 Workflow 工具执行 `.claude/workflows/execute-tasks.wf.js`，多 Agent 并行工作

**Independent Test**: 在 Claude Code 模式的项目中（tasks.md 和 .wf.js 已就绪），运行 `vipd-implement`，确认通过 Workflow 工具执行而非顺序执行

### Implementation for User Story 3

- [x] T014 [US3] 在 `vipd-implement` SKILL.md 中添加环境探测步骤：先读 `.vipd/config.yml` 的 `mode` 字段，再通过最小 Workflow 脚本验证 Workflow 工具可用性 in `.claude/skills/vipd-implement/SKILL.md`
- [x] T015 [P] [US3] 添加 Workflow 工具调用逻辑：检测到 `.claude/workflows/execute-tasks.wf.js` 存在时，通过 Workflow 工具执行
- [x] T016 [P] [US3] 添加优雅降级路径：当 Workflow 脚本不存在、工具不可用或执行出错时，自动回退到传统顺序执行模式，并记录降级原因
- [x] T017 [US3] 添加执行报告聚合：Workflow 执行完成后，汇总各 Agent 的状态、产出摘要和执行时长，展示为完成报告
- [x] T018 [US3] 端到端验证：完整的 `vipd-tasks` → `vipd-implement` 工作流测试（Claude Code 模式）

**Checkpoint**: User Story 3 complete — 多 Agent 并行执行可用，降级路径可靠

---

## Phase 6: User Story 4 — 混合模式：部分顺序，部分并行 (Priority: P2)

**Goal**: Workflow 脚本正确识别任务依赖关系：Setup/Foundational 顺序执行，User Stories 并行执行，`[P]` 任务独立 Agent

**Independent Test**: 检查生成的 Workflow 脚本中 Setup/Foundational 是否在 `parallel()` Barrier 之前，User Stories 是否在 Barrier 之后

### Implementation for User Story 4

- [x] T019 [US4] 实现依赖感知的任务编排：Setup 和 Foundational 阶段任务使用 `phase()` + `parallel()` Barrier 确保全部完成后才进入 User Story 阶段
- [x] T020 [P] [US4] 实现自适应并发控制：Workflow 脚本中根据 User Story 数量动态设置并行度（`min(5, 用户故事数)`）
- [x] T021 [US4] 实现 `[P]` 标记任务路由：每个 `[P]` 标记的任务通过独立的 `agent()` 调用执行，非 `[P]` 的同一 Story 任务合并到同一 `agent()` 调用

**Checkpoint**: User Story 4 complete — 依赖关系正确映射

---

## Phase 7: User Story 5 — 执行进度透明可追踪 (Priority: P2)

**Goal**: Workflow 执行过程中用户可通过 `/workflows` 查看进度，执行完成后可查看汇总报告

**Independent Test**: 启动 Workflow 执行后，运行 `/workflows` 命令查看进度面板

### Implementation for User Story 5

- [x] T022 [US5] 在 Workflow 脚本中使用 `phase()` 和 `log()` API 实现进度分组和消息输出，确保 `/workflows` 视图可正确显示各 Phase 和 Agent 状态
- [x] T023 [P] [US5] 添加 Agent 产出摘要收集：在每个 `agent()` 调用中使用 `label` 参数标记任务身份，执行完成后汇总所有产出
- [x] T024 [US5] 更新 CLAUDE.md 的 SPECKIT 区块，包含 Workflow 执行上下文引用（Workflow 脚本路径和执行状态）

**Checkpoint**: User Story 5 complete — 进度可查看，结果可追踪

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: 影响多个 User Story 的改进和收尾工作

- [x] T025 [P] 更新 `quickstart.md` 和完善 `contracts/` 文档，确保与最终实现一致
- [x] T026 [P] 运行 `quickstart.md` 验证 — 按步骤执行所有验收场景，确保端到端可用
- [x] T027 代码清理和一致性问题修复

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational (T003 config read/write)
- **User Story 2 (Phase 4)**: Depends on Foundational (T003, T004) + Phase 1 templates
- **User Story 3 (Phase 5)**: Depends on US2 (needs Workflow script) + Foundational
- **User Story 4 (Phase 6)**: Depends on US2 (modifies Workflow script generation)
- **User Story 5 (Phase 7)**: Depends on US3 (adds progress to execution flow)
- **Polish (Phase 8)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational — No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational — No dependencies on US1
- **User Story 3 (P1)**: Depends on US2 — needs .wf.js generation available
- **User Story 4 (P2)**: Depends on US2 — modifies .wf.js generation logic
- **User Story 5 (P2)**: Depends on US3 — extends execution flow

### Within Each User Story

- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- T002 and T001 can run in parallel (different files)
- T003 and T004 can run in parallel (different domains: config vs probe)
- T005 and T007 can run in parallel (SKILL.md vs new command)
- T010 and T011 can run in parallel (parser vs injector, different files)
- T015 and T016 can run in parallel (execution path vs degradation path)
- T020 and T021 can run in parallel (concurrency vs [P] routing)
- All Polish [P] tasks can run in parallel

---

## Parallel Example: User Story 2

```text
# Launch parser and injector in parallel (both needed for generation):
Task: "Implement tasks.md parser" (T010)
Task: "Implement template injection engine" (T011)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (.claude/templates/ + workflow-template.js)
2. Complete Phase 2: Foundational (config read/write + probe)
3. Complete Phase 3: User Story 1 (init integration)
4. **MVP READY**: User can init project with `--integration claude-code`

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add User Story 1 → Claude Code init works ✅ (MVP!)
3. Add User Story 2 → Workflow auto-generation works ✅
4. Add User Story 3 → Workflow parallel execution works ✅
5. Add User Story 4 → Mixed mode + concurrency control ✅
6. Add User Story 5 → Progress tracking + execution reports ✅
7. Polish → Documentation + validation ✅

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- This feature modifies existing SKILL.md files — changes must be backward compatible
- All modifications to SKILL.md must preserve existing content and only add claude-code logic branches
