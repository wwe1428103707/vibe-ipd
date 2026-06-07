---

description: "Task list for document-state gate utility implementation"
---

# Tasks: Document-State Tooling Implementation

**Input**: Design documents from `/specs/006-implement-docstate-tools/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/gate-utility-interface.md

**Tests**: Not applicable (PowerShell scripts — validate via CLI invocation)

**Organization**: Tasks are grouped by user story to enable independent implementation of each utility.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- PowerShell scripts live under `.specify/scripts/powershell/`
- Reference gate utility interface contract at `specs/006-implement-docstate-tools/contracts/gate-utility-interface.md`
- All scripts follow patterns in `.specify/scripts/powershell/common.ps1`

---

## Phase 1: Setup

**Purpose**: Create script directory structure (already exists)

- [x] T001 Verify `.specify/scripts/powershell/` directory exists and contains `common.ps1`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared helper functions used by all three gate utilities

**⚠️ CRITICAL**: No utility script work can begin until shared helpers are established

- [x] T002 Create JSON output helper function in `.specify/scripts/powershell/gate-common.ps1` — `Write-GateJson` that emits consistent JSON with exit code handling
- [x] T003 Create file/content validation helper in `gate-common.ps1` — `Test-FileContains` wrapping `Select-String` for content pattern matching with error handling for missing files

**Checkpoint**: Shared helpers available — all 3 utilities can use `Write-GateJson` and `Test-FileContains`

---

## Phase 3: User Story 3 - IPD Mode Detection (Priority: P2) 🔧

**Goal**: A standalone `detect-ipd-mode` script that checks whether the project has an IPD-enhanced constitution

**Independent Test**: Running `.specify/scripts/powershell/gate-detect-ipd-mode.ps1 -Json` returns `{"ipd_mode": true/false}`

### Implementation for User Story 3

- [x] T004 [P] [US3] Create `gate-detect-ipd-mode.ps1` at `.specify/scripts/powershell/gate-detect-ipd-mode.ps1` — checks constitution existence + "Gate Criteria Reference" heading; supports `-Json` flag; exit code 0 on success
- [x] T005 [P] [US3] Create Bash equivalent `gate-detect-ipd-mode.sh` at `.specify/scripts/bash/gate-detect-ipd-mode.sh` — same logic using `grep` and `test -f`
- [x] T006 [US3] Test detect-ipd-mode: run against current project (should return `{"ipd_mode": true}`), then against a temp dir without constitution (should return `{"ipd_mode": false}`)

**Checkpoint**: `detect-ipd-mode` correctly distinguishes IPD vs SDD-only projects

---

## Phase 4: User Story 1 - Automated Gate Check (Priority: P1) 🎯 MVP

**Goal**: A reusable `check-gate` script that validates a TR gate with recursive prior-gate checking

**Independent Test**: `.specify/scripts/powershell/gate-check.ps1 -Gate TR1 -Json` returns `{"status": "passed"}` with prior gate evidence

### Implementation for User Story 1

- [x] T007 [US1] Create `gate-check.ps1` at `.specify/scripts/powershell/gate-check.ps1` — implements all TR gate validation rules defined in the contract (recursive prior-gate checks, document content validation)
- [x] T008 [US1] Create Bash equivalent `gate-check.sh` at `.specify/scripts/bash/gate-check.sh` — same logic using bash test + grep
- [x] T009 [US1] Test gate-check: run `gate-check.ps1 -Gate TR1 -Json` and verify prior TR0 check, then `gate-check.ps1 -Gate TR5 -Json` to verify full chain

**Checkpoint**: `check-gate` correctly validates any TR gate with recursive prior checks

---

## Phase 5: User Story 2 - Gate Status Manager (Priority: P1)

**Goal**: A centralized `record-gate` utility for atomic gate status updates

**Independent Test**: `.specify/scripts/powershell/gate-record.ps1 -Gate TR0 -Status passed -Evidence "Test"` updates `gate-status.json` correctly

### Implementation for User Story 2

- [x] T010 [US2] Create `gate-record.ps1` at `.specify/scripts/powershell/gate-record.ps1` — atomic JSON read/validate/write with temp-file pattern; supports `-Gate`, `-Status`, `-Evidence` params; creates file if missing
- [ ] T011 [US2] Create Bash equivalent `gate-record.sh` at `.specify/scripts/bash/gate-record.sh` — deferred (PowerShell primary, Bash when cross-platform needed)
- [x] T012 [US2] Test record-gate: backup current `gate-status.json`, run record with test evidence, verify update, restore original

**Checkpoint**: `record-gate` atomically updates gate status with evidence

---

## Phase 6: Refactor Skill Files

**Purpose**: Update all 8 `vipd-*` skill files to use the centralized gate utilities instead of inline logic

**⚠️ Note**: Each skill has its own inline IPD Gate Check section (mode detection, deep validation, gate recording). Replace inline logic with `EXECUTE_COMMAND` calls to the three utilities.

### Implementation for Refactoring

- [x] T013 [P] Refactor `vipd-constitution` skill at `.claude/skills/vipd-constitution/SKILL.md` — replace inline TR0 gate check with `gate-detect-ipd-mode` + `gate-check` + `gate-record` calls
- [x] T014 [P] Refactor `vipd-specify` skill at `.claude/skills/vipd-specify/SKILL.md` — replace inline TR1 gate check with utility calls
- [x] T015 [P] Refactor `vipd-clarify` skill at `.claude/skills/vipd-clarify/SKILL.md` — replace inline TR1 gate check + risk assessment evidence with utility calls
- [x] T016 [P] Refactor `vipd-checklist` skill at `.claude/skills/vipd-checklist/SKILL.md` — replace inline TR2 gate check with utility calls
- [x] T017 [P] Refactor `vipd-plan` skill at `.claude/skills/vipd-plan/SKILL.md` — replace inline TR2/TR3 gate check with utility calls
- [x] T018 [P] Refactor `vipd-tasks` skill at `.claude/skills/vipd-tasks/SKILL.md` — replace inline TR4 gate check with utility calls
- [x] T019 [P] Refactor `vipd-implement` skill at `.claude/skills/vipd-implement/SKILL.md` — replace inline TR4/TR4A gate check with utility calls
- [x] T020 [P] Refactor `vipd-analyze` skill at `.claude/skills/vipd-analyze/SKILL.md` — replace inline TR5 gate check with utility calls

**Checkpoint**: All 8 skill files delegate gate validation to centralized utilities

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Validation and documentation updates

- [ ] T021 Run `/reload-skills` to register any updated skill names (manual step)
- [x] T022 Run end-to-end validation: invoke each gate utility individually and verify correct behavior
- [x] T023 Update `CLAUDE.md` agent context to reflect completed 006 feature
- [x] T024 Run `check-prerequisites.ps1` on the project to verify no regressions (all gates TR0-TR5 passed via gate-check)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all utility scripts
- **US3 (Phase 3)**: Depends on Phase 2 — detect-ipd-mode is the foundation for other gates
- **US1 (Phase 4)**: Depends on Phase 3 (check-gate calls detect-ipd-mode for TR0 prior check)
- **US2 (Phase 5)**: Depends on Phase 2 (record-gate only needs common helpers, not mode detection)
- **Refactor (Phase 6)**: Depends on Phase 3 + Phase 4 + Phase 5 (all utilities must exist before skill refactoring)
- **Polish (Phase 7)**: Depends on all phases completed

### Parallel Opportunities

- T004 and T005 (PowerShell + Bash detect-ipd-mode) can run in parallel
- T007 and T008 (PowerShell + Bash check-gate) can run in parallel
- T010 and T011 (PowerShell + Bash record-gate) can run in parallel
- T013-T020 (skill refactors) can all run in parallel — different files, no cross-dependencies
- US3 (detect-ipd-mode) and US2 (record-gate) have no mutual dependency and can overlap

---

## Parallel Example: Skill Refactoring

```bash
# Launch all 8 skill refactors in parallel:
Task: "Refactor vipd-constitution" → .claude/skills/vipd-constitution/SKILL.md
Task: "Refactor vipd-specify"    → .claude/skills/vipd-specify/SKILL.md
...
Task: "Refactor vipd-analyze"    → .claude/skills/vipd-analyze/SKILL.md

# No conflicts — each writes to a different file
```

---

## Implementation Strategy

### MVP First (US1 Only)

1. Complete Phase 2: Foundational (gate-common.ps1)
2. Complete Phase 3: detect-ipd-mode (foundation)
3. Complete Phase 4: check-gate (core functionality)
4. **MVP reached**: Basic gate checking works via CLI

### Incremental Delivery

1. Phase 1-2: Helpers ready
2. Phase 3: detect-ipd-mode → can detect IPD mode
3. Phase 4: check-gate → can validate any gate (MVP!)
4. Phase 5: record-gate → can record gate status
5. Phase 6: Skill refactoring → all 8 skills use centralized utilities
6. Phase 7: Validation complete

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- Bash equivalents are deferred if jq/bash not available in Windows environment
- Testing: always validate with `-Json` flag for machine-parseable output
- Each utility must handle missing/corrupt files gracefully (no crashes)
- Atomic writes for record-gate: write to temp file → rename over target
