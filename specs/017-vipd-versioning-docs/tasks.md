---

description: "Task list for VIPD Versioning & Docs Preparation — independent version management for vipd, README/CHANGELOG update for v1.0.0 release"

---

# Tasks: VIPD Versioning & Docs Preparation

**Input**: Design documents from `specs/017-vipd-versioning-docs/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: IPD mode is ACTIVE. This is primarily a documentation and config feature — tests are included where appropriate.

**Organization**: Tasks are grouped by user story to enable independent implementation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Version file**: `.vipd/version.yml`
- **CLI script**: `vipd` (executable at repo root)
- **Documentation**: `README.md`, `README.zh.md`, `CHANGELOG.md`, `VERSION_BUMP.md`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Verify project structure is ready for versioning and docs

- [x] T001 Verify `.vipd/` directory exists; create if needed
- [x] T002 [P] Check existing README.md content for sections to preserve before rewrite

---

## Phase 2: Foundational (Blocking Prerequisites)

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

**Purpose**: Create the version file — single source of truth for all subsequent tasks

- [x] T003 Create `.vipd/version.yml` with `vipd_version: "1.0.0"` and `speckit_version: "0.9.3.dev0"`; validate against `contracts/version-schema.json`
- [x] T004 [P] Create `.vipd/bump_version.sh` — bash script that reads version.yml, parses current version, and writes the bumped version back; supports `major`, `minor`, `patch` arguments

**Checkpoint**: Foundation ready — version file and bump script exist
> **Gate Completion Verification**: All setup and foundational tasks [ ] completed / [ ] verified

---

## Phase 3: User Story 1 - Track VIPD and Speckit Versions Separately (Priority: P1) 🎯 MVP

**Goal**: Project has a version file with independent `vipd_version` and `speckit_version` fields. The speckit version matches the actual speckit version used by the project.

**Independent Test**: Read `.vipd/version.yml` — the `vipd_version` and `speckit_version` fields exist and have different values.

### Implementation for User Story 1

- [x] T005 [US1] Extract current speckit version from `.specify/init-options.json` (`speckit_version` field) and verify it matches `0.9.3.dev0`
- [x] T006 [US1] Add version file validation to the regular workflow: verify `.vipd/version.yml` exists and is valid on critical commands

**Checkpoint**: At this point, the version file is the single source of truth.

---

## Phase 4: User Story 2 - Version Display and Verification (Priority: P1)

**Goal**: `vipd --version` displays both vipd and speckit versions. `vipd --help` shows usage.

**Independent Test**: Run `vipd --version` — output is `vipd 1.0.0 (speckit 0.9.3.dev0)`.

### Implementation for User Story 2

- [x] T007 [US2] Create `vipd` (executable bash script at repo root) with `--version` flag that reads `.vipd/version.yml` and outputs `vipd X.Y.Z (speckit A.B.C)`
- [x] T008 [US2] Add `--help` / `-h` flag to `vipd` script showing usage summary and link to README
- [x] T009 [US2] Make `vipd` executable (`chmod +x vipd`) and add `.vipd/version.yml` reading with fallback to "unknown" if file is missing

**Checkpoint**: At this point, `vipd --version` and `vipd --help` work correctly.

---

## Phase 5: User Story 3 - Documentation Ready for First Release (Priority: P1)

**Goal**: README.md is updated with full project description, prerequisites, quickstart, and feature catalog for v1.0.0.

**Independent Test**: A new user can read the README and follow the quickstart to set up the project and run their first command.

### Implementation for User Story 3

- [x] T010 [US3] Rewrite `README.md` with: project title + vipd version badge, description, prerequisites (uv/pipx, git, Claude Code), quick install, quickstart workflow example
- [x] T011 [US3] Add feature catalog table to `README.md` listing all 17 specs (001-017) with numbers, names, and status indicators
- [x] T012 [US3] Add IPD gate reference section to `README.md` (TR0-TR6 overview table)
- [x] T013 [US3] Add versioning policy section to `README.md` explaining vipd vs speckit version distinction
- [x] T014 [US3] Create `CHANGELOG.md` with v1.0.0 entry grouping all 17 features
- [x] T015 [US3] Create `VERSION_BUMP.md` documenting the bump process (MAJOR/MINOR/PATCH rules, commands, tagging)

**Checkpoint**: At this point, README.md, CHANGELOG.md, and VERSION_BUMP.md cover v1.0.0 release.

---

## Phase 6: User Story 4 - Version Bump Workflow (Priority: P2)

**Goal**: The version bump process is documented and scripted. A maintainer can bump the version in under 1 minute.

**Independent Test**: Run `.vipd/bump_version.sh minor` and verify `vipd_version` changed from `1.0.0` to `1.1.0`.

### Implementation for User Story 4

- [x] T016 [US4] Finalize `.vipd/bump_version.sh` — ensure `major`, `minor`, `patch` arguments all work correctly; validate output against `contracts/version-schema.json`
- [x] T017 [US4] Add release checklist to `VERSION_BUMP.md`: update version.yml → update CHANGELOG.md → commit → tag → push tags

**Checkpoint**: At this point, the bump workflow is complete.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Chinese translation, .gitignore update, final validation

- [x] T018 [P] Translate updated `README.md` to `README.zh.md` — all sections including feature catalog and IPD gate reference
- [x] T019 Add `.vipd/version.yml` and `vipd` (script) to `.gitignore` if needed, or ensure they are tracked (version file SHOULD be tracked)
- [x] T020 Run end-to-end validation: run `vipd --version` → verify output → run `vipd --help` → verify → read `.vipd/version.yml` → verify both versions → bump patch → verify new version
- [x] T021 Update `CLAUDE.md` SPECKIT section and any skill metadata to reference the new versioning

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all stories
- **US1 (Phase 3)**: Depends on Foundational (version file) — BLOCKS US2
- **US2 (Phase 4)**: Depends on US1 (version file must exist for display)
- **US3 (Phase 5)**: Depends on US2 (version for README badge reference)
- **US4 (Phase 6)**: Depends on US1 (version file for bumping)
- **Polish (Phase 7)**: Depends on US3, US4

### User Story Dependencies

- **US1 (P1)**: Version file only — independent of other stories
- **US2 (P1)**: Depends on US1 (needs version file to read)
- **US3 (P1)**: Starts after US1 (can start in parallel with US2)
- **US4 (P2)**: Depends on US1 (needs version file)

### Parallel Opportunities

- T001, T002: parallel
- T003, T004: parallel (version file and bump script)
- T010-T015: all can run in parallel (different doc files)
- T018 parallel with T019-T021
- US3 doc tasks (T010-T015) can start immediately after Phase 2

---

## Parallel Example: User Stories 3 + 4

```bash
# Developer A — User Story 3 (documentation):
Task: "Rewrite README.md with full documentation"
Task: "Add feature catalog table"
Task: "Add IPD gate reference"
Task: "Create CHANGELOG.md"
Task: "Create VERSION_BUMP.md"

# Developer B — User Story 4 (bump workflow):
Task: "Finalize bump_version.sh"
Task: "Add release checklist"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Phase 1: Setup
2. Phase 2: Foundational (version.yml, bump script)
3. Phase 3: US1 (verify speckit version, validation)
4. **MVP achieved** — version tracking exists

### Incremental Delivery

1. Version file + bump script → Foundation ready
2. `vipd --version` script → **MVP!**
3. README + CHANGELOG + bump docs → Release ready
4. Chinese translation → Bilingual ready
5. Final validation → Ship v1.0.0

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- Version file is the single source of truth — do NOT hardcode versions in scripts
- `speckit_version` should match the actual installed speckit version
- README updates should be bilingual (EN + ZH) per feature 014 pattern
- CHANGELOG follows Keep a Changelog format
