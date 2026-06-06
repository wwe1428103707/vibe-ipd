---

description: "Task list for Blueprint Document-State Only rewrite"
---

# Tasks: Blueprint Document-State Only

**Input**: Design documents from `specs/003-blueprint-docstate-only/`

## Phase 1: English Blueprint Rewrite

**Goal**: Remove Jira content from `docs/ipd-transformation/03-tooling-integration-blueprint.md`, retaining only docstate mode

- [x] T001 [US1] Rewrite the English blueprint Overview section to focus on document-state mode as primary approach
- [x] T002 [P] [US1] Remove Issue Hierarchy Configuration section from `docs/ipd-transformation/03-tooling-integration-blueprint.md`
- [x] T003 [P] [US1] Remove Workflow States & TR Gate Transitions section
- [x] T004 [P] [US1] Remove Automation Rules section (all 3 gates)
- [x] T005 [P] [US1] Remove Dependency Management section
- [x] T006 [P] [US1] Remove CI/CD Integration section
- [x] T007 [US1] Retain Spec Kit Agent Integration section (core content) and simplify Platform Alternatives to minimal table

**Checkpoint**: English blueprint simplified, zero Jira references remain

## Phase 2: Chinese Blueprint Rewrite

**Goal**: Parallel update to `docs/ipd-transformation/zh/03-工具集成蓝图.md`

- [x] T008 [US2] Rewrite Chinese blueprint Overview section to match English structure
- [x] T009 [P] [US2] Remove all Jira-specific sections from `docs/ipd-transformation/zh/03-工具集成蓝图.md` (Chinese translations of Issue Hierarchy, Workflow States, Automation Rules, Dependency Mgmt, CI/CD)
- [x] T010 [US2] Retain Spec Kit Agent Integration section and simplify Platform Alternatives

**Checkpoint**: Chinese blueprint matches English structure

## Phase 3: Cross-Reference Cleanup

- [x] T011 [US3] Update cross-references in `docs/ipd-transformation/02-command-template-redesign-guide.md` to remove Jira-specific language
- [x] T012 [P] [US3] Verify `docs/ipd-transformation/zh/02-命令与模板改造指南.md` cross-references are correct

## Phase 4: Verification

- [x] T013 [P] Search all files in `docs/ipd-transformation/` for "Jira", "Advanced Roadmaps", "webhook" — confirm zero matches in blueprint files
- [x] T014 Verify English blueprint line count is ≤90 (was 218)
