---

description: "Task list for VIPD Init Language Option — adding --lang flag to vipd init, config persistence, and language-aware CLI output"

---

# Tasks: VIPD Init Language Option

**Input**: Design documents from `specs/016-vipd-init-language/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: IPD mode is ACTIVE — tests are MANDATORY per Constitution Principle V (Quality Built-In).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Language resources**: `lang/` (new directory at repo root)
- **Config files**: `.vipd/config.yml` (project-level), `~/.vipd/config.yml` (user-level)
- **SKILL.md**: `.claude/skills/vipd-init/SKILL.md` (extend for --lang)
- **Tests**: `tests/` for Python tests, or `.specify/tests/` for Pester tests

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create directories and basic file structure for language support

- [x] T001 Create `lang/`, `.vipd/`, and `~/.vipd/` directories if they don't exist
- [x] T002 [P] Create `.vipd/config.yml` with default `language: en` setting

---

## Phase 2: Foundational (Blocking Prerequisites)

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

**Purpose**: Create language resource files and config read/write infrastructure

- [x] T003 Create `lang/en.yml` with all English string resources: `_meta`, `init.welcome`, `init.project_name`, `init.language_select`, `init.complete`, `init.usage`, `error.network`, `error.no_tool`, `error.invalid_lang`, `error.missing_project`, `help.lang_flag`
- [x] T004 [P] Create `lang/zh.yml` with Chinese translations matching all keys from `lang/en.yml`
- [x] T005 [P] Create `.vipd/resolve_language.sh` — Bash script that resolves the effective language via priority chain: CLI `--lang` > `.vipd/config.yml` > `~/.vipd/config.yml` > `en` default
- [x] T006 [P] Create `.vipd/load_strings.sh` — Bash script that sources a language file and provides `t()` function for key lookup with English fallback for missing keys

**Checkpoint**: Foundation ready — user story implementation can now begin
> **Gate Completion Verification**: All setup and foundational tasks [ ] completed / [ ] verified

---

## Phase 3: User Story 1 - Select Language During vipd Init (Priority: P1) 🎯 MVP

**Goal**: Users can pass `--lang zh` (or `en`, `ja`) to `vipd init` and see all initialization output in the chosen language.

**Independent Test**: Run `vipd init --lang zh my-project` — all prompts and messages should be in Chinese. Run `vipd init --lang en my-project` — all prompts should be in English.

### Tests for User Story 1 (MANDATORY — IPD mode) ⚠️

- [x] T007 [P] [US1] Pytest: language resolution with `--lang zh` returns `zh` as effective language — in `tests/test_language_resolution.py`
- [x] T008 [P] [US1] Pytest: language resolution without any config or flag returns `en` (default) — in `tests/test_language_resolution.py`

### Implementation for User Story 1

- [x] T009 [US1] Extend `.claude/skills/vipd-init/SKILL.md` to parse `--lang <CODE>` argument and pass it to language resolution
- [x] T010 [US1] Update all hardcoded English output strings in `SKILL.md` to use the language-aware `t("section.key")` pattern (welcome, prompts, errors, help text)
- [x] T011 [US1] Add language selection prompt during init flow: ask user to choose language if `--lang` not provided, with a numbered menu of available languages from the registry

**Checkpoint**: At this point, User Story 1 should be fully functional — `vipd init --lang zh` runs entirely in Chinese.

---

## Phase 4: User Story 2 - Language Persistence Across Sessions (Priority: P1)

**Goal**: Language choice from init persists to `.vipd/config.yml`, so subsequent commands automatically use the configured language.

**Independent Test**: Run `vipd init --lang zh my-project`, check `.vipd/config.yml` has `language: zh`. Run another vipd command without `--lang` — output should be in Chinese.

### Tests for User Story 2 (MANDATORY — IPD mode) ⚠️

- [x] T012 [P] [US2] Pytest: config file is written with correct `language: zh` after init with `--lang zh` — in `tests/test_language_config.py`
- [x] T013 [P] [US2] Pytest: resolution reads `language` from `.vipd/config.yml` when no `--lang` flag — in `tests/test_language_config.py`

### Implementation for User Story 2

- [x] T014 [US2] Add config file write logic to the init flow: after language selection, write `language: <code>` to `.vipd/config.yml`
- [x] T015 [US2] Add config file read logic to the language resolver: check `.vipd/config.yml` before falling back to default
- [x] T016 [US2] Add `~/.vipd/config.yml` (user-level) read support: resolve against user config if project config has no `language` key

**Checkpoint**: At this point, User Story 2 should be fully functional — language preference persists across sessions.

---

## Phase 5: User Story 3 - Manual Language Override in Conversation (Priority: P2)

**Goal**: Users can temporarily override the config language with `--lang` on any vipd command, without modifying the config file.

**Independent Test**: With config set to `language: zh`, run a command with `--lang en` — output in English. Run same command without `--lang` — output reverts to Chinese.

### Tests for User Story 3 (MANDATORY — IPD mode) ⚠️

- [x] T017 [P] [US3] Pytest: `--lang en` overrides config `zh` for that invocation only — in `tests/test_language_override.py`
- [x] T018 [P] [US3] Pytest: after override, subsequent resolution (without `--lang`) still reads config value — in `tests/test_language_override.py`

### Implementation for User Story 3

- [x] T019 [US3] Ensure `--lang` flag is accepted and processed by ALL vipd command SKILL.md files (vipd-init, vipd-constitution, vipd-specify, vipd-plan, vipd-tasks, vipd-implement)
- [x] T020 [US3] Implement CLI-flag precedence in the language resolver: `--lang` takes priority over config without modifying the config file
- [x] T021 [US3] Add `help.lang_flag` display to `--help` output of all vipd commands

**Checkpoint**: At this point, User Story 3 should be fully functional — `--lang` overrides on any command work correctly.

---

## Phase 6: User Story 4 - Edit Language in Configuration File (Priority: P2)

**Goal**: Users can change the language by editing a single line in the config file. Invalid values fall back gracefully.

**Independent Test**: Manually change `.vipd/config.yml` from `language: en` to `language: zh`. Run any vipd command — output is in Chinese. Change to `language: xyz` — output in English with a warning.

### Tests for User Story 4 (MANDATORY — IPD mode) ⚠️

- [x] T022 [P] [US4] Pytest: config file with `language: ja` resolves to `ja` when lang files exist — in `tests/test_language_config.py`
- [x] T023 [P] [US4] Pytest: config file with invalid language `xyz` falls back to `en` with warning — in `tests/test_language_config.py`

### Implementation for User Story 4

- [x] T024 [US4] Implement language code validation: whitelist-based (check `lang/<code>.yml` exists); log warning and fall back to `en` for invalid codes
- [x] T025 [US4] Add config file watcher or reload mechanism: detect config file changes without requiring shell restart (re-read on each command invocation)

**Checkpoint**: At this point, User Story 4 should be fully functional — config edits take effect immediately.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Documentation, edge case handling, and final validation

- [x] T026 [P] Update `CLAUDE.md` SPECKIT section and README to document the new `--lang` flag and config file `language` option
- [x] T027 Run end-to-end validation: `vipd init --lang zh` → verify Chinese output → verify `.vipd/config.yml` → run another command without `--lang` → verify Chinese → run with `--lang en` → verify English → edit config to `xyz` → verify fallback
- [x] T028 Add terminal encoding detection: warn if the selected language (e.g., Chinese) may not render correctly in the current terminal charset

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational (lang files must exist) — BLOCKS US2
- **US2 (Phase 4)**: Depends on US1 (config write after init) — BLOCKS US3
- **US3 (Phase 5)**: Depends on US2 (config read for override baseline) — BLOCKS US4
- **US4 (Phase 6)**: Depends on US2 (config validation on read) — independent of US3
- **Polish (Phase 7)**: Depends on US1, US2, US4 being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Foundational — No dependencies on other stories
- **US2 (P1)**: Depends on US1 (config write during init) — integrates with US1
- **US3 (P2)**: Can start after US2 (needs config read/write infrastructure)
- **US4 (P2)**: Can start after US2 (needs config read infrastructure) — independent of US3

### Parallel Opportunities

- T002, T003, T004: parallel (different lang files and config)
- T005, T006: parallel (different helper scripts)
- T007, T008: parallel (different test cases)
- T012, T013: parallel (different test cases)
- T017, T018: parallel (different test cases)
- T022, T023: parallel (different test cases)
- US3 and US4: partially parallel after US2 complete

---

## Parallel Example: User Story 1

```bash
# Tests in parallel:
Task: "Pytest: --lang zh resolution"
Task: "Pytest: default resolution"

# Implementation:
Task: "Parse --lang in SKILL.md"
Task: "Replace strings with t() calls"
Task: "Add language selection prompt"
```

## Parallel Example: User Stories 3 + 4

```bash
# Developer A — User Story 3:
Task: "Add --lang to all command SKILL.md files"
Task: "Implement CLI-flag precedence in resolver"
Task: "Add --lang to --help output"

# Developer B — User Story 4:
Task: "Implement language code validation with whitelist"
Task: "Add config file reload mechanism"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (lang/en.yml, lang/zh.yml, resolver scripts)
3. Complete Phase 3: User Story 1 (--lang in vipd init + language-aware output)
4. **STOP and VALIDATE**: Test `vipd init --lang zh` independently
5. MVP achieved — users can now use `--lang` during init

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 (init --lang) → **MVP!**
3. Add US2 (config persistence) → Language persists across sessions
4. Add US3 (override) + US4 (config edit) in parallel
5. Polish phase

### Parallel Team Strategy

1. Team completes Setup + Foundational together
2. Developer A: US1 → US2
3. Developer B: US4 (config validation) after US2 complete
4. Developer C: US3 (override) after US2 complete
5. Polish as group effort

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Tests are MANDATORY in IPD mode — write them first, verify they fail, then implement
- Language code convention (`en`, `zh`, `ja`) follows feature 011 (hello.sh --lang)
- English fallback for missing translation keys prevents incomplete translations from breaking the CLI
- All VIPD command SKILL.md files need `--lang` support for US3 (not just vipd-init)
