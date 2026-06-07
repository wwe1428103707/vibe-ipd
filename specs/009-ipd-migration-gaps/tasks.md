# Tasks: IPD Migration Functional Gaps

**Input**: Design documents from `/specs/009-ipd-migration-gaps/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in the specification. Tests are omitted per the template guidance.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3...)
- Include exact file paths in descriptions

## Path Conventions

- **Gate scripts**: `.specify/scripts/powershell/` and `.specify/scripts/bash/`
- **Python CLI**: `src/specify_cli/`
- **Agent skills**: `.claude/skills/vipd-*/SKILL.md`
- **Templates**: `.specify/templates/`
- **Workflow**: `.specify/workflows/`

---

## Phase 1: Setup — Gate Script Foundation (FR-001, FR-020)

**Purpose**: Add TR6 support, fix bugs, and enhance gate scripts with depth validation, ordering, and audit trail. These are prerequisites for all other user stories.

- [x] T001 Add `TR6` to valid gate IDs in `.specify/scripts/powershell/gate-common.ps1` — add `TR6` to the `Test-ValidGateId` function's valid set and update `gate-order` arrays
- [x] T002 [P] Add `TR6` to valid gate IDs in `.specify/scripts/bash/gate-common.sh` — mirror the PS1 change for Bash
- [x] T003 Add `Check-TR6` function to `.specify/scripts/powershell/gate-check.ps1` — validate deployment verification and ops handover for the Launch gate, following the Check-TR5 pattern with depth validation for TR6 Must-Meet patterns (Deployment Verification, Ops Handover, Training Pass Rate)
- [x] T004 [P] Add `check_tr6` function to `.specify/scripts/bash/gate-check.sh` — mirror the PS1 TR6 check for Bash
- [x] T005 Fix the double-invocation bug in `.specify/scripts/bash/gate-check.sh` lines 109-113 — remove the redundant first call
- [x] T006 Add depth validation function `Test-DepthValidation` to `.specify/scripts/powershell/gate-check.ps1`
- [x] T007 [P] Add depth validation function `test_depth_validation` to `.specify/scripts/bash/gate-check.sh`
- [x] T008 Add Should-Meet advisory evaluation to `.specify/scripts/powershell/gate-check.ps1`
- [x] T009 [P] Add Should-Meet advisory evaluation to `.specify/scripts/bash/gate-check.sh`
- [x] T010 Add `Test-GateOrder` function to `.specify/scripts/powershell/gate-common.ps1`
- [x] T011 [P] Add `test_gate_order` function to `.specify/scripts/bash/gate-common.sh` — mirror PS1 gate ordering for Bash
- [x] T012 Enhance `gate-record.ps1` with audit trail and ordering — add `Write-GateEntry` function that appends to a `history` array instead of overwriting, add `Test-GateOrder` call before recording (FR-013, FR-014). Add `Decision`, `DecisionMaker`, `DecisionRationale` parameters for Go/Kill/Hold/Recycle support (FR-025). Add `TR6` default entry to the skeleton creation. Expand evidence limit from 500 to 2000 chars
- [x] T013 [P] Create new `.specify/scripts/bash/gate-record.sh` — implement Bash equivalent of `gate-record.ps1` with the same interface: `--gate`, `--status`, `--evidence`, `--json`, `--feature` parameters. Include audit trail, ordering check, and Go/Kill/Hold/Recycle support
- [x] T014 Update `gate-record.ps1` to support per-feature gate status paths — add `Get-FeatureGateStatusPath` function that resolves `specs/NNN-feature-name/gate-status.json` from `.specify/feature.json`, with fallback to legacy `.specify/memory/gate-status.json`. Update `Write-GateEntry` to write to the per-feature path
- [x] T015 [P] Update `gate-check.ps1` and `gate-detect-ipd-mode.ps1` to read per-feature gate-status.json — modify `Check-TR5` (which reads gate-status.json) and `gate-detect-ipd-mode.ps1` to use the new `Get-FeatureGateStatusPath` function. Add `-FeatureDir` parameter to gate-check.ps1

**Checkpoint**: Gate scripts now support TR6, depth validation, Should-Meet advisory, ordering enforcement, audit trail, per-feature paths, and Go/Kill/Hold/Recycle decisions
> **Gate Completion Verification**: All setup and foundational tasks [x] completed / [x] verified

---

## Phase 2: Foundational — Per-Feature Gate Status Migration (FR-003b, US3)

**Purpose**: Migrate from project-level to per-feature gate-status.json, and create the Python `_gate_utils.py` module. This phase MUST be complete before any user story that depends on gate enforcement.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T016 Migrate existing `.specify/memory/gate-status.json` to per-feature path
- [x] T017 Create `src/specify_cli/_gate_utils.py` — new Python module implementing `detect_ipd_mode()`, `check_gate()`, `record_gate()`, `get_gate_status()`, and `enforce_gate()` functions following the contract in `contracts/gate-enforcement-contract.md`. Use `subprocess.run()` to invoke PS1/Bash gate scripts and parse their JSON output
- [x] T018 Define exception classes in `src/specify_cli/_gate_utils.py` — implement `GateError`, `GateBlockedError`, `GateOrderError`, and `GateScriptError` exception hierarchy with user-friendly error messages per the contract's Error Messages section
- [x] T019 Add `require_gate()` decorator to `src/specify_cli/_gate_utils.py` — implement a Typer-compatible decorator that calls `enforce_gate()` before a VIPD command executes, blocking with a clear error message if the gate check fails. Apply dual-mode logic: skip gate check entirely if IPD mode is inactive
- [x] T020 Extend `src/specify_cli/__init__.py` `check` command with `--gate-status` flag — add a `gate_status: bool = typer.Option(False, "--gate-status")` parameter that, when true, reads and displays the per-feature gate-status.json in a human-readable table format showing each TR gate, status, evidence summary, and Should-Meet advisory results

**Checkpoint**: Foundation ready — per-feature gate status is active, Python gate utilities are available, and commands can be gate-protected
> **Gate Completion Verification**: All setup and foundational tasks [x] completed / [x] verified

---

## Phase 3: User Story 1 — Gate Lifecycle Completeness (Priority: P1) 🎯 MVP

**Goal**: All six TR gates (TR0–TR6) can be validated and recorded through the toolchain, with substantive content validation

**Independent Test**: Run `gate-check.ps1 -Gate TR6` on a feature with all prior gates passed; verify it checks deployment verification evidence. Run `gate-check.ps1 -Gate TR1` on a spec with only a "TR Gate Assessment" heading; verify it fails with specific "Must-Meet criterion not met" messages.

### Implementation for User Story 1

- [x] T021 [US1] Integrate TR6 `Check-TR6` into gate validation flow in `.specify/scripts/powershell/gate-check.ps1` — add TR6 to the `$gateOrder` array so it is validated when requested, including recursive prior-gate checks (TR0 through TR5 must all pass before TR6 can be checked)
- [x] T022 [P] [US1] Integrate TR6 into Bash gate validation flow in `.specify/scripts/bash/gate-check.sh` — add `check_tr6` to the gate order and prior-gate loop, mirroring the PS1 change
- [x] T023 [US1] Verify depth validation integration in all TR gate checks — ensure each `Check-TR*` function now calls `Test-DepthValidation` and reports Must-Meet pattern results in the JSON output under `must_meet_details` and `depth_validated` fields
- [x] T024 [US1] Verify `gate-record.ps1` out-of-order blocking — test that recording TR4 before TR1 fails with a clear error message listing which prerequisites have not passed
- [x] T025 [US1] Verify `gate-record.ps1` audit trail — test that recording a gate status appends to the `history` array rather than overwriting, and that each transition includes `from`, `to`, `date`, and `evidence` fields

**Checkpoint**: User Story 1 complete — full TR0–TR6 gate lifecycle with depth validation, ordering, and audit trail

---

## Phase 4: User Story 2 — Gate Depth of Validation (Priority: P1)

**Goal**: Gate checks validate substantive content, not just section headers. Should-Meet criteria are reported as advisory results.

**Independent Test**: Create a spec.md with just a "TR Gate Assessment" heading — the current system passes TR1; the improved system should fail TR1 with specific feedback about missing user stories and acceptance criteria.

### Implementation for User Story 2

- [x] T026 [P] [US2] Add Must-Meet depth validation patterns for TR1 in `.specify/scripts/powershell/gate-check.ps1` — the `Check-TR1` function must require at least 3 of 4 patterns: user story headings, Given/When/Then scenarios, TR Gate Assessment section, feasibility assessment
- [x] T027 [P] [US2] Add Must-Meet depth validation patterns for TR2_TR3, TR4, TR4A, TR5, TR6 in `.specify/scripts/powershell/gate-check.ps1` — each Check-TR* function must validate substantive content per the patterns in `data-model.md` and `contracts/gate-check-depth-contract.md`
- [x] T028 [P] [US2] Mirror all depth validation patterns in `.specify/scripts/bash/gate-check.sh` — ensure Bash script has equivalent patterns for all gates
- [x] T029 [US2] Ensure Should-Meet advisory output is included in gate-check JSON — verify that every gate check includes a `should_meet` array with criterion, status, and score for advisory criteria per the contract

**Checkpoint**: User Story 2 complete — gates validate substantive content, Should-Meet criteria reported as advisory

---

## Phase 5: User Story 3 — Gate Enforcement Integration (Priority: P1)

**Goal**: Python CLI commands invoke gate checks before executing and block on failure (hard gate model).

**Independent Test**: Run `vipd-plan` without TR1 passed — it should block with a clear error message. Run `vipd-tasks` with all prior gates passed — it should proceed without warnings.

### Implementation for User Story 3

- [x] T030 [US3] Add `@require_gate("TR1")` decorator to `vipd-plan` command in `src/specify_cli/__init__.py` or the appropriate command module — blocking execution if TR1 is not passed, displaying the error format from the gate enforcement contract
- [x] T031 [P] [US3] Add `@require_gate("TR2_TR3")` decorator to `vipd-tasks` command
- [x] T032 [P] [US3] Add `@require_gate("TR4")` decorator to `vipd-implement` command
- [x] T033 [P] [US3] Add `@require_gate("TR5")` decorator to `vipd-analyze` command
- [x] T034 [US3] Add gate prerequisite validation to `.specify/scripts/powershell/check-prerequisites.ps1` — call `gate-check.ps1` for the appropriate gate before allowing setup-plan or setup-tasks to proceed
- [x] T035 [P] [US3] Add gate prerequisite validation to `.specify/scripts/powershell/setup-plan.ps1` — verify TR1 has passed before allowing plan creation
- [x] T036 [P] [US3] Add gate prerequisite validation to `.specify/scripts/powershell/setup-tasks.ps1` — verify TR2_TR3 has passed before allowing tasks creation
- [x] T037 [US3] Update error messages in `.specify/scripts/powershell/check-prerequisites.ps1`, `setup-plan.ps1`, and `setup-tasks.ps1` to use `/vipd-speckit-*` command names instead of `/speckit-*` (FR-021, cosmetic fix alongside functional change)
- [x] T038 [US3] Add `gate-status.json` invalidation on artifact modification — when a spec, plan, or tasks file is modified, reset the corresponding gate status to `pending` in the per-feature gate-status.json (FR-003b). Implement in `_gate_utils.py` as a file-watcher or called explicitly after command execution
- [x] T039 [US3] Handle corrupted or missing gate-status.json gracefully — in `_gate_utils.py`, if gate-status.json is corrupted or missing, reinitialize it with all gates set to `pending` and continue with the appropriate gate check (Edge Case from spec)

**Checkpoint**: User Story 3 complete — all VIPD commands enforce gates, block on failure, and handle edge cases

---

## Phase 6: User Story 4 — SW E2E Integration (Priority: P2)

**Goal**: Workflow engine GatewayStep is IPD-aware and `specify check --gate-status` reports per-feature gate status.

**Independent Test**: Run a VIPD workflow end-to-end and verify that each phase transition triggers an appropriate gate check. Run `specify check --gate-status` and verify it shows a human-readable gate status table.

### Implementation for User Story 4

- [x] T040 [US4] Extend `GatewayStep` in `src/specify_cli/workflows/steps/gate/__init__.py` — add IPD-aware behavior: detect IPD mode, call `_gate_utils.check_gate()` before prompting user, add `Go/Kill/Hold/Recycle` options when IPD mode is active, record gate result to per-feature gate-status.json after user decision (FR-005)
- [x] T041 [US4] Create `.specify/workflows/vipd/workflow.yml` — migrate from `.specify/workflows/speckit/workflow.yml`, update command references to `vipd.speckit.*` prefixes, update gate steps to use IPD-specific outcomes `[go, kill, hold, recycle]` instead of `[approve, reject]`, and map review steps to TR gates (FR-005, FR-019)
- [x] T042 [US4] Update `.specify/workflows/workflow-registry.json` to register the `vipd` workflow alongside the existing `speckit` entry — maintain backward compatibility by keeping the `speckit` entry with a deprecation notice (FR-019)

**Checkpoint**: User Story 4 complete — workflow engine is IPD-aware and VIPD workflow is registered

---

## Phase 7: User Story 5 — Product Trio Review Enforcement (Priority: P2)

**Goal**: TR1 gate evidence includes Product Trio review verdict from Desirability, Feasibility, and Viability perspectives.

**Independent Test**: Run `vipd-specify` or `vipd-clarify` in IPD mode and verify that TR1 gate evidence includes a Product Trio verdict section.

### Implementation for User Story 5

- [x] T043 [US5] Update `.specify/templates/constitution-template.md`
- [x] T044 [US5] Update `.claude/skills/vipd-specify/SKILL.md`
- [x] T045 [US5] Update `.claude/skills/vipd-clarify/SKILL.md`
- [x] T046 [P] [US5] Create `.specify/templates/guides/trio-review-template.md`

**Checkpoint**: User Story 5 complete — Product Trio review is part of TR1 gate evidence

---

## Phase 8: User Story 6 — CBB Reuse and WSJF Prioritization (Priority: P2)

**Goal**: CBB catalog template exists and WSJF scoring is structured in plan and PO skills.

**Independent Test**: Run `vipd-plan` in IPD mode and verify the plan includes a WSJF scoring section. Check that `.specify/memory/cbb-catalog.md` exists as a template.

### Implementation for User Story 6

- [x] T047 [US6] Create `.specify/memory/cbb-catalog.md` template
- [x] T048 [US6] Update `.specify/templates/plan-template.md` — add CBB Reuse Assessment section
- [x] T049 [P] [US6] Update `.claude/skills/vipd-agent-assign-po/SKILL.md` — add a WSJF scoring rubric section that guides the AI through the four dimensions (Value, Time Criticality, Risk Reduction, Job Size) with concrete scoring criteria (1-10 scale) and the standard formula. Include in the gate review template (FR-008)

**Checkpoint**: User Story 6 complete — CBB catalog exists and WSJF scoring is structured

---

## Phase 9: User Story 7 — Agent-Assignment IPD Role Awareness (Priority: P2)

**Goal**: Agent assignment skills understand IPD PDT roles and respect the RACI matrix.

**Independent Test**: Run `vipd-agent-assign-assign` on a tasks.md with tagged roles and verify assignments match PDT roles.

### Implementation for User Story 7

- [x] T050 [US7] Update `.claude/skills/vipd-agent-assign-assign/SKILL.md` — rename frontmatter `name:` from `speckit-agent-assign-assign` to `vipd-agent-assign-assign`, add IPD Role Definition section mapping to the PDT roles (PO, Architect, QA Lead, DevOps Lead, LPDT), add RACI Context table, add Decision Authority table, and update the scanning logic to detect IPD role tags `[QA]`, `[Architecture]`, `[DevOps]`, etc. (FR-009, FR-018)
- [x] T051 [US7] Update `.claude/skills/vipd-agent-assign-execute/SKILL.md` — rename frontmatter `name:` from `speckit-agent-assign-execute` to `vipd-agent-assign-execute`, add IPD Gate Check section with TR4 gate validation before task execution (FR-010, FR-018)
- [x] T052 [P] [US7] Update `.claude/skills/vipd-agent-assign-validate/SKILL.md` — rename frontmatter `name:` from `speckit-agent-assign-validate` to `vipd-agent-assign-validate`, add IPD RACI Role Assignment Compliance check (Check 6) for IPD-mode projects (FR-018)

**Checkpoint**: User Story 7 complete — agent assignment skills have IPD role awareness

---

## Phase 10: User Stories 8 & 9 — Gate Reporting & Documentation (Priority: P3)

**Goal**: `vipd-analyze` shows gate status across features. README and templates reflect IPD workflows.

### Implementation for User Story 8 — Gate Compliance Reporting

- [x] T053 [US8] Update `.claude/skills/vipd-analyze/SKILL.md` — add a Gate Status Summary section in IPD mode that reads all `specs/*/gate-status.json` files and produces a consolidated table showing per-feature, per-TR-gate status (passed/pending/failed/hold/recycled). Highlight blockers and recommend next actions. Mark features with all gates passed as "Launch Ready" with TR5 passage date (FR-011)

### Implementation for User Story 9 — Documentation & Template IPD Completeness

- [x] T054 [P] [US9] Update `README.md` — replace Speckit/SSDD-only content with IPD-enhanced workflow description including: Agile-Stage-Gate overview, TR gates (TR0–TR6), PDT roles, vipd-speckit-* command reference, and a link to `docs/ipd-transformation/` (FR-015)
- [x] T055 [US9] Update `.specify/templates/tasks-template.md` — add IPD-specific sections: (1) When IPD mode is active, testing tasks are MANDATORY not optional — change the "Tests are OPTIONAL" note to "Tests are MANDATORY when IPD mode is active per Principle V". (2) Add RACI annotation tags `[PO]`, `[Architect]`, `[QA]`, `[DevOps]`, `[LPDT]` to task format. (3) Add a "Gate Review Phase: TR5 Validation" section with quality verification tasks. (4) Add "Gate Completion Verification" checkpoints per phase with TR gate references (FR-012, FR-017)
- [x] T056 [US9] Update `.specify/templates/checklist-template.md` — add IPD sections: Gate Readiness section (TR gate must-meet criteria check), PDT Role Verification section (PO/Architect/QA/DevOps/LPDT confirmation), and change the category structure to IPD-relevant categories (Content Quality, Requirement Completeness, Gate Readiness, Role Verification, Risk Assessment) when IPD mode is active (FR-016)
- [x] T057 [P] [US9] Update `.specify/templates/plan-template.md` — add CBB Reuse Assessment section (FR-007, already partially present). Update gate-status reference to per-feature path. Add Product Trio Review reference for TR1 evidence (FR-006)
- [x] T058 [P] [US9] Update `.specify/scripts/powershell/setup-tasks.ps1` and `setup-plan.ps1` — replace remaining `/speckit-*` command references with `/vipd-speckit-*` (FR-021 cosmetic fix)
- [x] T059 [US9] Update `.specify/memory/constitution.md` — bump version to 1.3.0 and add note about per-feature gate status: "Gate status is tracked per feature in `specs/NNN-feature-name/gate-status.json`, recording which TR gates have passed with audit trail evidence"
- [x] T060 [P] [US9] Update `.claude/skills/vipd-agent-assign-lpdt/SKILL.md` — replace abstract placeholders in the Gate Review Template with concrete Must-Meet criteria from the constitution's Gate Criteria Reference table (TR1: "Spec created with user stories, feasibility assessed"; TR5: "Blocker/critical bugs = 0"; etc.) (FR-023)
- [x] T061 [P] [US9] Update `.claude/skills/vipd-agent-assign-lpdt-po/SKILL.md` — add a section acknowledging the conflict of interest inherent in the combined LPDT+PO role and recommending mitigation: "When assessing gate readiness for your own feature priorities, consider delegating the gate decision to another PDT lead or using an automated gate checklist to reduce bias." (FR-024)

**Checkpoint**: User Stories 8 and 9 complete — gate reporting and IPD documentation are in place

---

## Phase 11 Additional FRs — Gate Decisions, Misc Fixes

**Purpose**: Remaining FRs not covered by user stories (FR-022, FR-025, naming fixes)

- [x] T062 [P] Update `.claude/skills/vipd-taskstoissues/SKILL.md` — add TR4 gate validation before creating GitHub issues: detect IPD mode, run gate check, and warn or block if TR4 hasn't passed (FR-022)
- [x] T063 [P] Update `.claude/skills/vipd-tasks/SKILL.md` — in IPD mode, when generating tasks, ensure testing tasks are marked as mandatory (not optional) and include a comment referencing Principle V (FR-012)
- [x] T064 [P] Update `.claude/skills/vipd-agent-context-update/SKILL.md` — rename frontmatter `name:` from `speckit-agent-context-update` to `vipd-agent-context-update` (FR-018, naming fix)
- [x] T065 [P] Update gate scripts to support Go/Kill/Hold/Recycle decisions — in `gate-record.ps1`, add `-Decision` parameter accepting `Go`, `Kill`, `Hold`, `Recycle`. In `gate-check.ps1`, update JSON output to include `decision` field in `current_gate` (FR-025)

---

## Phase 12 Polish & Cross-Cutting Concerns

**Purpose**: Verification, cleanup, and validation

- [x] T066 Run all gate scripts end-to-end — verify TR0 through TR6 checks work correctly with depth validation, Should-Meet advisory, ordering enforcement, and Go/Kill/Hold/Recycle decisions
- [x] T067 Run quickstart.md validation — follow the quickstart guide to verify all commands work as documented
- [x] T068 Verify per-feature gate status migration — confirm that the legacy `.specify/memory/gate-status.json` data is preserved in the new per-feature path and that scripts read from the per-feature location
- [x] T069 Verify `_gate_utils.py` integration — test `detect_ipd_mode()`, `check_gate()`, `record_gate()`, `get_gate_status()`, and `enforce_gate()` with both IPD-mode and non-IPD-mode projects
- [x] T070 Verify `specify check --gate-status` output — confirm the human-readable gate status table shows all TR gates, status, evidence, and Should-Meet advisory results
- [x] T071 Verify backward compatibility — run the existing `.specify/workflows/speckit/workflow.yml` and confirm it still works alongside the new `vipd/workflow.yml`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 — BLOCKS all user stories
- **User Stories (Phases 3–10)**: All depend on Phase 2 completion
  - US1 (Phase 3) → depends on Phase 2 for gate scripts and Python utilities
  - US2 (Phase 4) → depends on Phase 1 for depth validation functions
  - US3 (Phase 5) → depends on Phase 2 for `_gate_utils.py`
  - US4 (Phase 6) → depends on Phase 2 for `_gate_utils.py` and Phase 3 for TR6
  - US5 (Phase 7) → depends on Phase 1 for TR6 support
  - US6 (Phase 8) → no hard dependency, but templates should reference TR6
  - US7 (Phase 9) → no hard dependency, can start after Phase 2
  - US8 & US9 (Phase 10) → US8 depends on Phase 2 for gate status reading; US9 has no hard dependency
- **Additional FRs (Phase 11)**: Can start after Phase 2
- **Polish (Phase 12)**: Depends on all prior phases being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2 — gate lifecycle completeness
- **US2 (P1)**: Can start after Phase 1 — depth validation (only needs enhanced gate scripts, not Python)
- **US3 (P1)**: Can start after Phase 2 — CLI gate enforcement
- **US4 (P2)**: Can start after Phase 2 + US1 — workflow integration needs TR6
- **US5 (P2)**: Can start after Phase 1 — Trio review (template changes only)
- **US6 (P2)**: Can start after Phase 1 — CBB and WSJF (template and skill changes)
- **US7 (P2)**: Can start after Phase 2 — agent role awareness
- **US8 (P3)**: Can start after Phase 2 — needs gate status reading
- **US9 (P3)**: Can start after Phase 1 — documentation and templates

### Parallel Opportunities

- Phase 3 (US1) and Phase 4 (US2) can run in parallel — PS1 and Bash changes are independent files
- Phase 7 (US5), Phase 8 (US6), Phase 9 (US7) can all run in parallel — different files
- Phase 10 tasks (US8, US9) can run in parallel — analyze vs templates/docs

### Within Each User Story

- Tasks marked [P] within a phase can run in parallel
- Sequential tasks follow the dependency chain

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (gate scripts foundation)
2. Complete Phase 2: Foundational (per-feature gate status + Python utilities)
3. Complete Phase 3: User Story 1 (TR6 + depth validation + ordering + audit)
4. **STOP and VALIDATE**: Test that all 6 TR gates can be validated end-to-end
5. Gate scripts are now fully functional — this is the minimum viable product

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 → Gate lifecycle complete (MVP!)
3. Add US2 → Gate depth validation (deeper quality)
4. Add US3 → CLI enforcement (hard gates)
5. Add US4 → Workflow integration
6. Add US5 → Product Trio review
7. Add US6 → CBB and WSJF
8. Add US7 → Agent role awareness
9. Add US8 + US9 → Reporting and documentation
10. Additional FRs + Polish → Complete

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Gate scripts (PS1/Bash) changes must be tested on both platforms
- Python CLI changes follow the SpecKit subprocess pattern — no gate logic reimplemented in Python
- Hard gate model (FR-003a) means no bypass — if a gate fails, the command blocks