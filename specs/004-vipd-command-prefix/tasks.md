---

description: "Task list for VIPD Command Prefix Renaming"
---

# Tasks: VIPD Command Prefix Renaming

## Phase 1: Rename Skill Directories

- [x] T001 [P] [US1] Copy `speckit-constitution` → `vipd-speckit-constitution` and update internal refs
- [x] T002 [P] [US1] Copy `speckit-specify` → `vipd-speckit-specify` and update internal refs
- [x] T003 [P] [US1] Copy `speckit-clarify` → `vipd-speckit-clarify` and update internal refs
- [x] T004 [P] [US1] Copy `speckit-plan` → `vipd-speckit-plan` and update internal refs
- [x] T005 [P] [US1] Copy `speckit-tasks` → `vipd-speckit-tasks` and update internal refs
- [x] T006 [P] [US1] Copy `speckit-implement` → `vipd-speckit-implement` and update internal refs
- [x] T007 [P] [US1] Copy `speckit-analyze` → `vipd-speckit-analyze` and update internal refs
- [x] T008 [P] [US1] Copy remaining 11 speckit skills → vipd-speckit-* and update internal refs

## Phase 2: Replace in Documentation

- [x] T009 [US2] Replace all `/vipd-speckit-` with `/vipd-speckit-` in `docs/ipd-transformation/*.md`
- [x] T010 [US2] Replace all `/vipd-speckit-` with `/vipd-speckit-` in `docs/ipd-transformation/zh/*.md`

## Phase 3: Replace in Templates & Constitution

- [x] T011 [US3] Replace all `/vipd-speckit-` with `/vipd-speckit-` in `.specify/templates/*.md`
- [x] T012 [US3] Replace all `/vipd-speckit-` with `/vipd-speckit-` in `.specify/memory/constitution.md`

## Phase 4: Replace in Spec Artifacts

- [x] T013 [P] [US3] Replace all `/vipd-speckit-` in `specs/001-*/**/*.md`
- [x] T014 [P] [US3] Replace all `/vipd-speckit-` in `specs/002-*/**/*.md`
- [x] T015 [P] [US3] Replace all `/vipd-speckit-` in `specs/003-*/**/*.md`
- [x] T016 [P] [US3] Replace all `/vipd-speckit-` in `specs/004-*/**/*.md`

## Phase 5: Configuration & Verification

- [x] T017 Replace `speckit.` with `vipd.speckit.` in `.specify/extensions.yml`
- [x] T018 Verify: `grep -rn "/vipd-speckit-"` returns zero matches across repo
