---

description: "Task list for IPD Agent-Driven Project Management Integration"
---

# Tasks: IPD Agent-Driven Project Management Integration

**Input**: Design documents from `specs/002-ipd-agent-pm-integration/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: N/A — manual review against spec acceptance scenarios. No automated test framework for skill files.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Skill files**: `.claude/skills/vipd-speckit-*/skill.md`
- **Templates**: `.specify/templates/*-template.md`
- **Blueprint docs**: `docs/ipd-transformation/03-tooling-integration-blueprint.md` and `zh/03-工具集成蓝图.md`

## Phase 1: Setup

**Purpose**: Analyze existing files to understand injection points

- [x] T001 Read and map all 7 existing skill files in `.claude/skills/vipd-speckit-*/` to identify exact IPD gate injection points per `contracts/gate-check-interface.md`
- [x] T002 [P] Read `.specify/templates/constitution-template.md` to plan IPD section insertions per `contracts/template-sections.md`
- [x] T003 [P] Read `.specify/templates/spec-template.md` to plan TR Gate Assessment and Risk Register insertions
- [x] T004 [P] Read `.specify/templates/plan-template.md` to plan Gate Readiness and WSJF Score insertions
- [x] T005 [P] Read `.specify/templates/tasks-template.md` to plan Gate Completion Verification insertions

**Checkpoint**: All injection points identified and mapped

---

## Phase 2: Foundational

**Purpose**: Create the IPD detection utility and gate criteria definitions

- [x] T006 Create the IPD mode detection script at `.claude/skills/_shared/ipd-detect.sh` (or equivalent embedded block) that checks constitution for "Gate Criteria Reference" section — shared across all 7 commands
- [x] T007 [P] Create the TR gate criteria reference at `.claude/skills/_shared/tr-gate-criteria.md` listing all 6 gates (TR0–TR5) with deep content validation patterns per `research.md` gate mapping

**⚠️ CRITICAL**: Shared utilities must be created first — all 7 command skills depend on them

**Checkpoint**: Shared infrastructure ready — command modifications can begin

---

## Phase 3: User Story 1 — Agent Skill Commands for TR Gate Enforcement (Priority: P1) 🎯 MVP

**Goal**: Modify all 7 existing `/vipd-speckit-*` skill files to add TR gate pre-flight checks with deep content validation and constitution-based IPD mode detection

**Independent Test**: Running `/vipd-speckit-plan` on a project without a ratified constitution produces a clear gate-block warning

### Implementation for User Story 1

- [x] T008 [US1] Add IPD gate pre-flight check to `.claude/skills/vipd-speckit-constitution/skill.md` — TR0 (project setup): verify constitution existence + "Gate Criteria Reference" section; on first-run success, register TR0 as passed
- [x] T009 [US1] Add IPD gate pre-flight check to `.claude/skills/vipd-speckit-specify/skill.md` — TR1 (concept): check TR0 passed, verify constitution has "Agile-Stage-Gate Governance" heading; post-creation generate TR1 readiness summary
- [x] T010 [P] [US1] Add IPD gate post-execution evidence to `.claude/skills/vipd-speckit-clarify/skill.md` — TR1: after clarifications resolved, generate risk assessment output as TR1 gate evidence
- [x] T011 [US1] Add IPD gate pre-flight check to `.claude/skills/vipd-speckit-checklist/skill.md` — TR2: check TR1 passed, reframe checklist output as TR2 entry evidence
- [x] T012 [US1] Add IPD gate pre-flight check to `.claude/skills/vipd-speckit-plan/skill.md` — TR2/TR3: check TR1 passed, post-creation generate architecture decision log as TR3 evidence
- [x] T013 [US1] Add IPD gate pre-flight check to `.claude/skills/vipd-speckit-tasks/skill.md` — TR4: check TR2/TR3 passed, tasks become development baseline
- [x] T014 [US1] Add IPD gate pre-flight check to `.claude/skills/vipd-speckit-implement/skill.md` — TR4/TR4A: check TR4 passed, post-completion generate quality report
- [x] T015 [P] [US1] Enhance `.claude/skills/vipd-speckit-analyze/skill.md` with TR5 gate compliance check — verify all prior gate evidence exists, generate TR5 validation report

**Checkpoint**: All 7 commands have IPD gate awareness. User can run any command and receive appropriate gate status feedback.

---

## Phase 4: User Story 2 — IPD-Aware Constitution Template (Priority: P1)

**Goal**: Update the constitution template to include IPD gate criteria sections, enabling IPD mode detection

**Independent Test**: Running `/vipd-speckit-constitution` on a new project produces a constitution with "Gate Criteria Reference" section

### Implementation for User Story 2

- [x] T016 [US2] Add "VI. Agile-Stage-Gate Governance" principle section to `.specify/templates/constitution-template.md` after existing Principle V per `contracts/template-sections.md`
- [x] T017 [US2] Add "Tooling & Platform Requirements" section to `.specify/templates/constitution-template.md` (matching the IPD-enhanced constitution in `.specify/memory/constitution.md`)
- [x] T018 [US2] Add "Gate Criteria Reference" section to `.specify/templates/constitution-template.md` with TR1–TR6 Must-Meet/Should-Meet table
- [x] T019 [US2] Update Governance section of `.specify/templates/constitution-template.md` to require TR gate re-review on MAJOR version changes

**Checkpoint**: The constitution template produces IPD-aware constitutions that activate IPD mode in all 7 commands.

---

## Phase 5: User Story 3 — IPD-Aware Spec, Plan & Tasks Template Sections (Priority: P2)

**Goal**: Update remaining templates with IPD-specific sections that capture gate-relevant information

**Independent Test**: Creating a new spec on an IPD-enhanced project produces a spec with "TR Gate Assessment" section

### Implementation for User Story 3

- [x] T020 [P] [US3] Add "TR Gate Assessment" section to `.specify/templates/spec-template.md` after User Scenarios, before Requirements per `contracts/template-sections.md`
- [x] T021 [P] [US3] Add "Risk Register" section to `.specify/templates/spec-template.md` after Assumptions
- [x] T022 [P] [US3] Add "Gate Readiness" section to `.specify/templates/plan-template.md` after Summary, before Technical Context
- [x] T023 [P] [US3] Add "WSJF Priority Score" field to `.specify/templates/plan-template.md` Technical Context section
- [x] T024 [P] [US3] Add "Gate Completion Verification" checkpoint item to each phase in `.specify/templates/tasks-template.md`

**Checkpoint**: All 4 templates produce IPD-aware documents that gate checks can validate against.

---

## Phase 6: Blueprint Documentation Updates

**Purpose**: Update the Tooling Integration Blueprint documents (English and Chinese) to describe the new agent-driven document-state mode

- [x] T025 [P] Add "Spec Kit Agent Integration (Document-State Mode)" section to `docs/ipd-transformation/03-tooling-integration-blueprint.md` after CI/CD Integration section per `contracts/blueprint-agent-section.md`
- [x] T026 [P] Add comparison table (Document-State vs Jira-Integrated modes) to `docs/ipd-transformation/03-tooling-integration-blueprint.md`
- [x] T027 [P] Update `docs/ipd-transformation/zh/03-工具集成蓝图.md` with parallel Chinese translation of the new agent PM section (matching English update per FR-011)
- [x] T028 [P] Update `docs/ipd-transformation/zh/03-工具集成蓝图.md` comparison table in Chinese with English term cross-references
- [x] T029 [P] Update `docs/ipd-transformation/02-command-template-redesign-guide.md` to reference the new agent-driven enforcement mode in the TR gate mapping table
- [x] T030 [P] Update `docs/ipd-transformation/zh/02-命令与模板改造指南.md` with parallel Chinese update

**Checkpoint**: Both English and Chinese blueprint documents describe both document-state and Jira-integrated gate enforcement modes.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verification and validation across all modified files

- [x] T031 [P] Verify backward compatibility — confirm SDD-only projects with no "Gate Criteria Reference" section in constitution trigger no gate warnings from any command
- [x] T032 [P] Verify all 7 command skill files consistently reference the same IPD detection logic and gate criteria
- [x] T033 [P] Verify all 4 template insertions follow the exact section structure defined in `contracts/template-sections.md`
- [x] T034 [P] Verify all cross-references between blueprint documents (English and Chinese) remain consistent

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Phase 2 — can start as soon as shared utilities exist
- **US2 (Phase 4)**: Independent of Phase 3 — can run in parallel with US1
- **US3 (Phase 5)**: Independent of Phase 3 — can run in parallel with US1 and US2
- **Blueprint (Phase 6)**: Depends on US1 and US3 completing (blueprint references both)
- **Polish (Phase 7)**: Depends on ALL prior phases completing

### User Story Dependencies

- **US1 (P1)**: No dependencies on other stories — fully independent
- **US2 (P1)**: No dependencies on other stories — fully independent
- **US3 (P2)**: No dependencies on other stories — fully independent
- **Blueprint (Phase 6)**: Depends on US1 and US3 — references command changes and template changes

### Within Each User Story

- Follow the file order listed — no cross-file conflicts within a story
- [P]-marked tasks can run in parallel within the same phase

### Parallel Opportunities

- T002–T005 (template analysis) can run in parallel
- T006 and T007 (shared utilities) are sequential to each other
- T010 and T015 (clarify + analyze) can run in parallel with other US1 commands
- T016–T019 (constitution template) can run in parallel with US1 and US3
- T020–T024 (spec/plan/tasks templates) can run in parallel within US3
- T025–T030 (blueprint updates) can run in parallel within Phase 6
- T031–T034 (verification) can run in parallel

---

## Implementation Strategy

### MVP First (US1 + US2 — Both P1)

1. Complete Phase 1: Setup (identify all injection points)
2. Complete Phase 2: Foundational (create shared utilities)
3. Complete Phase 3: US1 (modify 7 skill files)
4. Complete Phase 4: US2 (update constitution template)
5. **STOP and VALIDATE**: Test gate enforcement with `/vipd-speckit-plan` on test project
6. Continue with US3 (templates) and Blueprint updates

### Incremental Delivery

1. Setup + Foundational → Ready to modify
2. US1 (commands) → Gate enforcement working
3. US2 (constitution template) → IPD mode activation via constitution
4. US3 (remaining templates) → Full template coverage
5. Blueprint updates → Documentation complete
6. Polish → Verification complete

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- No automated tests — verify against spec acceptance scenarios manually
- Task IDs start at T001 (first task for this feature)
- IPD detection is constitution-based (per Q2 clarification) — no config files needed
- Deep content validation (per Q1 clarification) — verify sections exist with content
