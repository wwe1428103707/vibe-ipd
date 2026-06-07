---

description: "Task list for Fix TR Gate Chicken-Egg Dependency — resolving circular dependencies between Plan and Task phases in TR2/TR3 gate reviews"

---

# Tasks: Fix TR Gate Chicken-Egg Dependency

**Input**: Design documents from `specs/015-fix-chicken-egg-tr-gate/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: IPD mode is ACTIVE — tests are MANDATORY per Constitution Principle V (Quality Built-In).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Gate tooling**: `.specify/scripts/powershell/` (existing scripts), `.specify/gates/` (new config/audit files)
- **Tests**: `.specify/tests/` (Pester tests for PowerShell scripts)
- **Feature artifacts**: `specs/015-fix-chicken-egg-tr-gate/` (design docs, deferred-items.json)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the new `.specify/gates/` directory structure and prepare extensions

- [x] T001 Create `.specify/gates/` directory and initialize empty `audit.log` with JSON Lines header comment
- [x] T002 [P] Backup existing `gate-check.ps1` and `gate-record.ps1` to `.specify/backups/` with date suffix

---

## Phase 2: Foundational (Blocking Prerequisites)

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

**Purpose**: Create shared helper functions, criteria config, and test infrastructure that ALL user stories depend on

- [x] T003 Create `.specify/gates/tr-criteria.yml` with initial TR2/TR3 criteria: TR2-MM-001 (Architecture reviewed, Plan), TR2-MM-002 (Dependencies locked, Plan), TR2-SM-001 (Effort variance < 15%, Task). Schema per `contracts/tr-criteria.schema.json`
- [x] T004 [P] Create `Write-AuditLog` helper function in `.specify/scripts/powershell/_gate_helpers.ps1` — appends JSON Lines to `.specify/gates/audit.log` with timestamp, actor, event_type, feature, gate, from_state, to_state, rationale
- [x] T005 [P] Create `Get-GateCriteria` helper in `_gate_helpers.ps1` that parses `.specify/gates/tr-criteria.yml` and returns criteria objects with phase ownership and depends_on lists
- [x] T006 [P] Create Pester test infrastructure at `.specify/tests/` with a shared test helper `_test_helpers.ps1` that provides mock gate fixtures and temp directory setup/teardown

**Checkpoint**: Foundation ready — user story implementation can now begin in parallel
> **Gate Completion Verification**: All setup and foundational tasks [ ] completed / [ ] verified

---

## Phase 3: User Story 1 - Break Circular Validation Dependency (Priority: P1) 🎯 MVP

**Goal**: The TR2/TR3 gate assessment no longer depends on task-level detail that can only exist after task generation. Gate validation is split by phase ownership.

**Independent Test**: Run `gate-check.ps1 -Gate TR2_TR3 -Context Plan` against a feature with only plan artifacts; confirm it passes without requiring task-level criteria. Then run `-Context Task` and confirm it validates only Task-phase-owned criteria.

### Tests for User Story 1 (MANDATORY — IPD mode) ⚠️

- [x] T007 [P] [US1] Pester test: `gate-check.ps1 -Gate TR2_TR3 -Context Plan` only evaluates criteria with `owning_phase: Plan` — in `.specify/tests/test-gate-check-phase-scope.Tests.ps1
- [x] T008 [P] [US1] Pester test: `gate-check.ps1 -Gate TR2_TR3 -Context Task` only evaluates criteria with `owning_phase: Task` — in `.specify/tests/test-gate-check-phase-scope.Tests.ps1

### Implementation for User Story 1

- [x] T009 [US1] Add `-Context` parameter (values: Plan, Task) and `-CriteriaConfig` parameter to `gate-check.ps1`; filter criteria by `owning_phase` matching the context
- [x] T010 [US1] Load and parse `.specify/gates/tr-criteria.yml` at gate check time using `Get-GateCriteria` helper; return only criteria whose `owning_phase` matches the provided `-Context`
- [x] T011 [US1] Generate JSON output with phase-filtered criteria results; include `phase_context`, `criteria_count`, `criteria_passed`, `criteria_failed` in the output hash

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently — TR2/TR3 gate reviews are split by phase ownership, eliminating the chicken-and-egg cross-phase criteria dependency.

---

## Phase 4: User Story 2 - Explicit Gate Dependency Mapping (Priority: P1)

**Goal**: System Architect can view and verify that each gate criterion has an unambiguous phase assignment, with no criterion requiring data from a phase that hasn't run yet.

**Independent Test**: Run a validation command that scans `tr-criteria.yml` and reports any criterion whose `depends_on` list includes a criterion from a different phase; confirm zero violations for the initial criteria set.

### Tests for User Story 2 (MANDATORY — IPD mode) ⚠️

- [x] T012 [P] [US2] Pester test: all criteria in `tr-criteria.yml` have valid `owning_phase` values (Plan/Task/Implementation) — in `.specify/tests/test-criteria-config.Tests.ps1
- [x] T013 [P] [US2] Pester test: no criterion's `depends_on` list references a criterion from a different `owning_phase` (cross-phase dependency validation) — in `.specify/tests/test-criteria-config.Tests.ps1

### Implementation for User Story 2

- [x] T014 [US2] Add `-ValidateConfig` switch to `gate-check.ps1` that validates `tr-criteria.yml` against `contracts/tr-criteria.schema.json` and reports any structural issues (missing fields, invalid phase values, malformed IDs)
- [x] T015 [US2] Implement cross-phase dependency scan as a subroutine in `gate-check.ps1`: for each criterion, check that all `depends_on` targets share the same `owning_phase`; report violations with criterion IDs

**Checkpoint**: At this point, User Story 2 should be fully functional — the dependency mapping is explicit, validated, and usable by the System Architect.

---

## Phase 5: User Story 3 - Graceful Gate Degradation with Partial Evidence (Priority: P2)

**Goal**: QA Lead / Gate Reviewer can pass a gate with `conditional-pass` verdict when certain criteria are deferred, with deferred items tracked for re-verification at the next gate.

**Independent Test**: Run a gate review where 1 of 3 criteria is marked deferred; confirm the verdict is `conditional-pass` and a `deferred-items.json` file is created in the feature directory.

### Tests for User Story 3 (MANDATORY — IPD mode) ⚠️

- [x] T016 [P] [US3] Pester test: `gate-check.ps1` with mixed passed/deferred criteria produces verdict `conditional-pass` — in `.specify/tests/test-gate-conditional-pass.Tests.ps1
- [x] T017 [P] [US3] Pester test: `gate-record.ps1 -Status conditional-pass` creates `deferred-items.json` with correct schema per `contracts/deferred-items.schema.json` — in `.specify/tests/test-gate-conditional-pass.Tests.ps1

### Implementation for User Story 3

- [x] T018 [US3] Add `conditional-pass` verdict logic to `gate-check.ps1`: when all criteria are passed-or-deferred (no hard failures), emit verdict `conditional-pass` and include the list of deferred criteria in the output
- [x] T019 [US3] Add `-DeferredItemsPath` parameter to `gate-record.ps1`; when `-Status conditional-pass`, write deferred criteria list to the specified path using `Set-DeferredItems` helper; validate output against `contracts/deferred-items.schema.json`
- [x] T020 [US3] Create `Set-DeferredItems` / `Get-DeferredItems` helpers in `_gate_helpers.ps1` for reading/writing `deferred-items.json` per the `contracts/deferred-items.schema.json` schema, with proper file locking

**Checkpoint**: At this point, User Story 3 should be fully functional — gate reviews can pass conditionally with tracked deferred items.

---

## Phase 6: User Story 4 - Automated Detection of Circular Gate Dependencies (Priority: P2)

**Goal**: PO can run `--check-cycles` to proactively detect circular dependencies between gate criteria before the gate review.

**Independent Test**: Add an intentionally circular dependency to a test `tr-criteria.yml`, run `--check-cycles`, confirm it detects and reports the cycle. Remove the cycle, re-run, confirm "no circular dependencies found."

### Tests for User Story 4 (MANDATORY — IPD mode) ⚠️

- [x] T021 [P] [US4] Pester test: `gate-check.ps1 --check-cycles` detects artificially introduced circular dependency in test criteria set — in `.specify/tests/test-check-cycles.Tests.ps1
- [x] T022 [P] [US4] Pester test: `gate-check.ps1 --check-cycles` on acyclic criteria set returns "no circular dependencies" — in `.specify/tests/test-check-cycles.Tests.ps1

### Implementation for User Story 4

- [x] T023 [US4] Add `--check-cycles` switch to `gate-check.ps1`; implement DFS-based cycle detection per `research.md` R2: build adjacency map from `depends_on`, run DFS with visiting/visited set tracking, return all cycle paths found
- [x] T024 [US4] Output cycle detection results in `gate-check.ps1` JSON: include `cycles_detected` array with each cycle path as an array of criterion IDs, and `has_cycles` boolean; when cycles found, emit a warning and non-zero exit code

**Checkpoint**: At this point, User Story 4 should be fully functional — circular dependencies are detected proactively.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Audit trail integration, validation, and documentation

- [x] T025 [P] Wire `Write-AuditLog` calls into `gate-check.ps1` (log each criteria status change and gate verdict) and `gate-record.ps1` (log each gate status change and config change); ensure audit log is created at `.specify/gates/audit.log` with correct JSON Lines format per `contracts/audit-log.schema.json`
- [x] T026 Run complete end-to-end validation: create a test feature scenario, run through Plan phase gate check with US1+US2, then simulate Task phase, verify US3 deferred items, run US4 cycle detection; ensure all tests pass and audit log contains expected entries
- [x] T027 Update `CLAUDE.md` SPECKIT section and any documentation referencing gate workflow to reflect new `conditional-pass` verdict, `deferred-items.json`, and `--check-cycles` capability

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational (tr-criteria.yml must exist) — BLOCKS US2
- **US2 (Phase 4)**: Depends on US1 (uses gate-check.ps1 phase context) — can start after US1
- **US3 (Phase 5)**: Depends on Foundational (uses gate-record.ps1 helpers) — independent of US1/US2
- **US4 (Phase 6)**: Depends on Foundational (uses tr-criteria.yml parsing) — independent of US1/US2, independent of US3
- **Polish (Phase 7)**: Depends on US1, US3, US4 being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Foundational — No dependencies on other stories
- **US2 (P1)**: Can start after US1 (extends gate-check.ps1) — integrates with US1 but independently testable
- **US3 (P2)**: Can start after Foundational — No dependencies on US1/US2
- **US4 (P2)**: Can start after Foundational — No dependencies on US1/US2/US3

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Helpers before core logic
- Core logic before integration
- Story complete before moving to next priority

### Parallel Opportunities

- T001, T002: parallel (different directories)
- T004, T005, T006: parallel (all in _gate_helpers.ps1 or .specify/tests/)
- T007, T008: parallel (different test files)
- T012, T013: parallel (same test file, different test cases)
- T016, T017: parallel (same test file, different test cases)
- T021, T022: parallel (same test file, different test cases)
- T025: independent of US3/US4 implementation tasks
- US3 and US4: fully parallel after Foundational phase
- Polish: depends on US1+US3+US4 all being complete

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Pester test: phase-scoped gate check Plan context"
Task: "Pester test: phase-scoped gate check Task context"

# After tests pass, launch implementation:
Task: "Add -Context and -CriteriaConfig parameters to gate-check.ps1"
Task: "Load and parse tr-criteria.yml by phase ownership"
Task: "Generate phase-filtered JSON output"
```

## Parallel Example: User Stories 3 + 4 (can run concurrently)

```bash
# Developer A — User Story 3:
Task: "conditional-pass verdict logic"
Task: "gate-record.ps1 deferred items support"
Task: "Get/Set deferred items helpers"

# Developer B — User Story 4:
Task: "--check-cycles switch + DFS algorithm"
Task: "Cycle detection JSON output + exit codes"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks all stories)
3. Complete Phase 3: User Story 1 (phase-scoped gate check)
4. **STOP and VALIDATE**: Test User Story 1 independently
5. MVP achieved — the core chicken-and-egg fix is in place

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 (phase-scoped check) → Test independently → **MVP!**
3. Add US2 (config validation) → Test independently
4. Add US3 (deferred items) + US4 (cycle detection) in parallel → Test independently
5. Polish phase ties everything together

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: US1 (phase-scoped check) → US2 (config validation)
   - Developer B: US3 (deferred items)
   - Developer C: US4 (cycle detection)
3. Developer A completes first (smaller scope), then helps with integration
4. Polish phase as group effort

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Tests are MANDATORY in IPD mode — write them first, verify they fail, then implement
- All PowerShell scripts must use the existing `-Json` convention for machine-readable output
- Backward compatibility: existing gate workflows (without the new flags) must continue to work unchanged
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
