---

description: "Task list for CLI source IPD adaptation (speckit → vipd rename)"
---

# Tasks: CLI Source IPD Adaptation

**Input**: Design documents from `/specs/008-cli-ipd-adaptation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/rename-specification.md

**Tests**: Import verification after rename; grep-based validation

**Organization**: Tasks grouped by file category to enable parallel renaming of independent files.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 = code, US2 = integrations, US3 = metadata)
- Include exact file paths in descriptions

## Path Conventions

- All files under `src/specify_cli/`
- Follow rename rules in `contracts/rename-specification.md`
- Use grep to verify no `speckit` references remain after each phase

---

## Phase 1: Setup

**Purpose**: Backup and baseline measurement

- [ ] T001 Create baseline: `grep -rn "speckit" src/specify_cli/ | wc -l` — record current count (expected: ~298)
- [ ] T002 Create git stash or backup of `src/` for rollback safety

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Rename API-level identifiers that other files depend on — must be done first

**⚠️ CRITICAL**: These files define shared identifiers (`speckit_version`, `speckit_command`, etc.) that other files reference. Rename these first.

### extensions.py (API surface — ~60 changes)

- [ ] T003 [US3] Rename `speckit_version` → `vipd_version` in `src/specify_cli/extensions.py` (function names, class members, error messages)
- [ ] T004 [US3] Rename `speckit_command` → `vipd_command` in `src/specify_cli/extensions.py`
- [ ] T005 [US3] Rename `speckit_manifest` → `vipd_manifest` in `src/specify_cli/extensions.py`
- [ ] T006 [US3] Rename manifest references (`speckit.manifest.json` → `vipd.manifest.json`, `speckit.selftest.extension` → `vipd.selftest.extension`) in `src/specify_cli/extensions.py`

### _assets.py and __init__.py (version + metadata)

- [ ] T007 [US3] Rename `get_speckit_version` → `get_vipd_version` in `src/specify_cli/_assets.py`
- [ ] T008 [US3] Update `src/specify_cli/__init__.py` package metadata to reflect IPD-enhanced version

### init.py (command references)

- [ ] T009 [US3] Update `speckit_version` references and command name strings in `src/specify_cli/commands/init.py`

**Checkpoint**: API-level identifiers renamed. Run `grep -c "speckit_version\|speckit_command\|speckit_manifest" src/` to verify.

---

## Phase 3: User Story 1 - Source Code Naming (Priority: P1) 🎯 MVP

**Goal**: Rename all command/hook references in core infrastructure files

**Independent Test**: `grep -rn "speckit[-.]" src/specify_cli/` returns 0 matches in renamed files

### Core Infrastructure

- [ ] T010 [P] [US1] Rename hook command patterns (`speckit.` → `vipd.speckit.`) in `src/specify_cli/integrations/base.py` (base class hook patterns, ~30 changes)
- [ ] T011 [P] [US1] Rename command names (`speckit-` → `vipd-speckit-`) in `src/specify_cli/integrations/_commands.py` (shared command templates, ~25 changes)
- [ ] T012 [P] [US1] Rename command names in `src/specify_cli/integrations/_install_commands.py`
- [ ] T013 [P] [US1] Rename command names in `src/specify_cli/integrations/_migrate_commands.py`
- [ ] T014 [P] [US1] Rename command registrar config in `src/specify_cli/agents.py` (~20 changes)
- [ ] T015 [P] [US1] Rename command/hook references in `src/specify_cli/shared_infra.py`
- [ ] T016 [P] [US1] Rename preset references in `src/specify_cli/presets.py`
- [ ] T017 [P] [US1] Rename `speckit-` refs in `src/specify_cli/integrations/_helpers.py`
- [ ] T018 [P] [US1] Rename `speckit-` refs in `src/specify_cli/integrations/catalog.py`
- [ ] T019 [P] [US1] Rename step references in `src/specify_cli/workflows/steps/command/__init__.py`
- [ ] T020 [P] [US1] Rename step references in `src/specify_cli/workflows/steps/prompt/__init__.py`

**Checkpoint**: Core infrastructure renamed. All main source files handled.

---

## Phase 4: User Story 2 - Integration Registry Updates (Priority: P1)

**Goal**: Update all 19 AI agent integration modules with renamed command references

**Independent Test**: Each agent's `__init__.py` no longer references `speckit` in command/hook names

### Individual Agent Modules

- [ ] T021 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/claude/__init__.py`
- [ ] T022 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/copilot/__init__.py`
- [ ] T023 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/cursor_agent/__init__.py`
- [ ] T024 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/codex/__init__.py`
- [ ] T025 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/devin/__init__.py`
- [ ] T026 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/forge/__init__.py`
- [ ] T027 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/hermes/__init__.py`
- [ ] T028 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/kimi/__init__.py`
- [ ] T029 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/cline/__init__.py`
- [ ] T030 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/lingma/__init__.py`
- [ ] T031 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/rovodev/__init__.py`
- [ ] T032 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/trae/__init__.py`
- [ ] T033 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/vibe/__init__.py`
- [ ] T034 [P] [US2] Rename speckit refs in `src/specify_cli/integrations/agy/__init__.py`
- [ ] T035 [P] [US2] Rename speckit refs in remaining agent `__init__.py` files (amp, auggie, bob, gemini, generic, goose, iflow, junie, kilocode, kiro_cli, opencode, pi, qodercli, qwen, roo, shai, tabnine, windsurf — check each for speckit references)

**Checkpoint**: All 19 integration modules updated. `grep -rn "speckit" src/specify_cli/integrations/ | grep -v ".pyc"` returns 0.

---

## Phase 5: Verification & Polish

**Purpose**: Verify all renames, test imports, validate no regressions

- [x] T036 Run `grep -rn "speckit" src/specify_cli/ --include="*.py"` — verify remaining refs are only intentional (version history, upstream comments)
- [x] T037 Test Python imports: `cd src && python -c "import specify_cli; print('OK')"` — verify package loads without ImportError (syntax verified; full import requires deps)
- [ ] T038 Run `specify --help` to verify CLI entry point works (requires installed deps — manual step)
- [ ] T039 Update `CLAUDE.md` agent context to reflect completed 008 feature
- [ ] T040 Commit all rename changes

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: MUST complete before US1/US2 — API identifiers are referenced by other files
- **US1 (Phase 3)**: Depends on Phase 2 — core infrastructure rename
- **US2 (Phase 4)**: Depends on Phase 2 only (not Phase 3) — integrations use API identifiers but not core command names
- **Polish (Phase 5)**: Depends on all phases completed

### Parallel Opportunities

- All Phase 3 tasks (T010-T020) can run in parallel — different files, no cross-dependencies
- All Phase 4 tasks (T021-T035) can run in parallel — each agent module is independent
- Phase 3 and Phase 4 could theoretically overlap (US1 and US2 are parallelizable)
- T003-T006 (extensions.py) must be together — same file, sequential

---

## Parallel Example: Agent Modules

```bash
# Launch all agent module renames in parallel:
Task: "Rename claude/__init__.py"  → integrations/claude/__init__.py
Task: "Rename copilot/__init__.py" → integrations/copilot/__init__.py
Task: "Rename cursor_agent/__init__.py" → integrations/cursor_agent/__init__.py
# ... all 19 agents can be processed independently
```

---

## Implementation Strategy

### MVP First (US1 Only)

1. Phase 1: Backup + baseline
2. Phase 2: API identifiers (extensions.py, _assets.py)
3. Phase 3: Core infrastructure (base.py, _commands.py, agents.py)
4. **MVP reached**: Core source code uses vipd-* naming

### Incremental Delivery

1. Phase 1-2: API rename changes foundational identifiers
2. Phase 3: Core infrastructure renamed (MVP!)
3. Phase 4: All integration modules updated
4. Phase 5: Verification + commit

---

## Notes

- Use `sed` or manual find-replace per file — 298 changes across 29 files
- Each file change is mechanical: `speckit` → `vipd`/`vipd-speckit`/`vipd.speckit` per rename rules
- Verify with grep after each phase before moving on
- The `specify` CLI entry point name and `specify_cli` package name remain UNCHANGED
