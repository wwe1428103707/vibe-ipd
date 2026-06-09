---

description: "Auto Gate Fix & Report 功能实现任务"
---

# Tasks: Auto Gate Fix & Report

**Input**: Design documents from `/specs/019-auto-gate-fix/`

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Gate scripts**: `.specify/scripts/powershell/`
- **Skills**: `.claude/skills/<name>/SKILL.md`
- **Templates**: `.claude/templates/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: 创建新目录结构和 HTML 模板

- [x] T001 创建 HTML 报告模板 `.claude/templates/report-template.html`，包含完整的内联 CSS/JS 框架
- [x] T002 [P] 创建 `.specify/memory/gate-history.jsonl` 空文件作为初始化占位

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: 所有 User Story 依赖的核心脚本改造

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 增强 `gate-check.ps1` 的 Test-DepthValidation 函数：在每个条件结果中添加 `fix_hint`（修复提示）和 `category`（分类：documentation/code/security/compliance/process）字段
- [x] T004 [P] 增强 `gate-record.ps1`：增加 JSONL 追加写入逻辑，每次记录操作同时写入 `gate-history.jsonl`

**Checkpoint**: Foundation ready

---

## Phase 3: User Story 1 — 门控失败自动修复 (Priority: P1) 🎯 MVP

**Goal**: 门控失败时 Agent 自动分析原因并修复，不再中断询问用户

**Independent Test**: 故意删除 plan.md 后运行 vipd-plan，验证自动创建 plan.md 模板并继续而非询问用户

### Implementation for User Story 1

- [x] T005 [US1] 修改 `vipd-tasks/SKILL.md`：将 TR4 门控失败后的"询问用户是否继续"改为"自动分析失败原因 → 尝试修复 → 重试(最多3次) → 降级"
- [x] T006 [P] [US1] 修改 `vipd-implement/SKILL.md`：将 TR4/TR4A 门控失败处理改为自动修复流程
- [x] T007 [P] [US1] 修改 `vipd-plan/SKILL.md`：将 TR2/TR3 门控失败处理改为自动修复流程
- [x] T008 [P] [US1] 修改 `vipd-clarify/SKILL.md` 和 `vipd-specify/SKILL.md`：将 TR1 门控失败处理改为自动修复流程
- [x] T009 [US1] 验证自动修复闭环：模拟各门控失败场景 → 验证 Agent 自动分析 → 修复 → 重检 → 继续的完整闭环

**Checkpoint**: US1 complete — gate auto-fix operational

---

## Phase 4: User Story 2 — 门控内容详细记录 (Priority: P1)

**Goal**: 每个门控检查的完整条件级别数据记录到 gate-history.jsonl

**Independent Test**: 通过完整 feature 门控流程后检查 gate-history.jsonl，验证包含每条条件的单独结果

### Implementation for User Story 2

- [x] T010 [US2] 实现 JSONL 记录：在每个 gate 执行事件中（gate-record.ps1），采集 GateRecord 全部字段（timestamp, gate, feature, status, conditions[], attempt, auto_fix）并追加写入 `gate-history.jsonl`
- [x] T011 [P] [US2] 实现 JSONL 记录完整性验证：读回 `gate-history.jsonl`，验证每行 JSON 合法且字段完整
- [x] T012 [US2] 同步更新 `gate-status.json` 的 evidence 字段，使其引用 `gate-history.jsonl` 中的对应行号

**Checkpoint**: US2 complete — detailed gate history recorded

---

## Phase 5: User Story 3 — 静态 HTML 报告生成 (Priority: P2)

**Goal**: 通过 `/vipd-report` 命令生成自包含的 HTML 门控报告

**Independent Test**: 运行 `vipd-report` 后打开生成的 HTML，验证门控仪表盘正确渲染

### Implementation for User Story 3

- [x] T013 [US3] 创建 `generate-report.ps1` 脚本：读取 `gate-history.jsonl`，解析 JSONL 记录，输出自包含 HTML 文件
- [x] T014 [P] [US3] 创建 `vipd-report` 技能 (`SKILL.md`)：封装 `/vipd-report` 命令，支持 `--output` 和 `--gate` 过滤参数
- [x] T015 [P] [US3] 填充 `report-template.html`：实现门控总览仪表盘、展开/折叠详情、色彩状态标识（绿/红/黄）的核心 HTML/CSS/JS
- [x] T016 [US3] 端到端验证：运行 `/vipd-report` → 用浏览器打开生成的 HTML → 确认所有门控阶段正确渲染

**Checkpoint**: US3 complete — HTML report available

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: 收尾和加固

- [x] T017 [P] 更新 `quickstart.md` 和 `contracts/` 文档，确保与最终实现一致
- [x] T018 运行快速入门验证 — 测试所有验收场景

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all stories
- **US1 (Phase 3)**: Depends on Foundational (T003 gate-check.ps1 + fix_hint)
- **US2 (Phase 4)**: Depends on Foundational (T004 JSONL recording)
- **US3 (Phase 5)**: Depends on US2 (reads gate-history.jsonl)
- **Polish (Phase 8)**: Depends on all stories

### Parallel Opportunities

- T001 and T002 can run in parallel
- T003 and T004 can run in parallel (gate-check vs gate-record)
- T006, T007, T008 (different SKILL.md files) can run in parallel
- T014 and T015 can run in parallel (SKILL.md + HTML template)

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Setup + Foundational → gate-check.ps1 enhanced + JSONL recording
2. US1 → gate auto-fix works ✅
3. US2 → gate history recorded ✅
4. US3 → HTML report available ✅

---

## Notes

- Step 5 (Claude Code Workflow script auto-generation) should be skipped for this feature — it's not a Claude Code mode feature, it's a gate system enhancement.
- All gate-check.ps1 modifications must maintain backward compatibility (existing callers use only the original 4 fields).
