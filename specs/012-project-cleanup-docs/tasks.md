---

description: "Task list for Project Cleanup & Documentation Rebrand feature"
---

# Tasks: Project Cleanup & Documentation Rebrand

**Input**: Design documents from `/specs/012-project-cleanup-docs/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

- [X] T001 Audit all `.md` files in `docs/` for `speckit` references with `grep -r "speckit" docs/ --include="*.md" -i -c` and log baseline count
- [X] T002 [P] Audit root `README.md` for current structure and `speckit` references
- [X] T003 [P] Audit `.specify/` config files and `.claude/skills/vipd-*` for stale branding references

---

## Phase 2: Foundations (Blocking Prerequisites)

- [X] T004 Verify `docs/` directory structure to confirm all subdirectories and files to be updated

**Checkpoint**: Full inventory complete — all files needing changes identified.

---

## Phase 3: User Story 1 — Root README Reflects vibe-ipd Identity (P1) 🎯 MVP

**Goal**: Rewrite `README.md` with clear vibe-ipd identity, purpose description, and ≥5 differentiators from speckit.

**Independent Test**: Can be evaluated by reading the README and verifying it contains: (1) clear vibe-ipd branding in first paragraph, (2) ≥5 distinct differentiators, (3) quickstart section, (4) acknowledgments section crediting speckit.

### Implementation for User Story 1

- [X] T005 [P] [US1] Rewrite `README.md` opening: project title "vibe-ipd", badge area, 2-3 paragraph purpose description defining what vibe-ipd is and its relationship to speckit
- [X] T006 [US1] Add "Key Differentiators from speckit" section to `README.md` with ≥5 bullet points (IPD governance, oh-my-claudecode, PDT roles, Product Trio, bilingual support)
- [X] T007 [US1] Add "Quickstart" section to `README.md` showing minimal `/vipd-specify` → `/vipd-plan` → `/vipd-implement` workflow
- [X] T008 [US1] Add "Documentation" and "Project Status" sections to `README.md` with links to `docs/`
- [X] T009 [US1] Add "Acknowledgments" section to `README.md` crediting speckit (Spec Kit) as the upstream project

**Checkpoint**: README.md fully rewritten with vibe-ipd identity. Save and review.

---

## Phase 4: User Story 2 — Documentation Files Branded as vibe-ipd (P1)

**Goal**: All files under `docs/` consistently use "vibe-ipd" branding and `/vipd-*` commands.

**Independent Test**: `grep -r "speckit" docs/ --include="*.md" -i -c` returns ≤2 (attribution only). `grep -r "/speckit-" docs/ --include="*.md" -c` returns 0.

### Implementation for User Story 2

- [X] T010 [P] [US2] Update `docs/index.md` — replace `speckit`/`Spec Kit` branding with `vibe-ipd`, update `/speckit-*` → `/vipd-*`
- [X] T011 [P] [US2] Update `docs/quickstart.md` — rebrand all speckit references to vibe-ipd
- [X] T012 [P] [US2] Update `docs/installation.md` — rebrand speckit references to vibe-ipd
- [X] T013 [P] [US2] Update `docs/upgrade.md` — preserve upstream upgrade history, rebrand current-project references
- [X] T014 [P] [US2] Update `docs/local-development.md` — rebrand speckit references to vibe-ipd
- [X] T015 [P] [US2] Update `docs/concepts/*.md` files — rebrand all speckit references
- [X] T016 [P] [US2] Update `docs/install/*.md` files — rebrand speckit references
- [X] T017 [P] [US2] Update `docs/reference/*.md` files — rebrand speckit references
- [X] T018 [P] [US2] Update `docs/community/*.md` files — rebrand speckit references
- [X] T019 [P] [US2] Update `docs/template/*.md` files — rebrand speckit references
- [X] T020 [P] [US2] Update `docs/ipd-transformation/*.md` files — rebrand speckit references
- [X] T021 [P] [US2] Update `docs/toc.yml` — replace `speckit` / `Spec Kit` labels with `vibe-ipd`
- [X] T022 [P] [US2] Update `docs/docfx.json` if it contains project name references
- [X] T023 [P] [US2] Update `docs/IPD与敏捷开发深度融合的软件产品开发流程与研发管理平台搭建指南.md` — rebrand speckit references

**Checkpoint**: All `docs/` files updated. Run grep validation.

---

## Phase 5: User Story 3 — Configuration and Script References Updated (P2)

**Goal**: Internal configuration and skill descriptions consistently use `vipd-*` naming.

**Independent Test**: Grep across `.specify/` and `.claude/skills/vipd-*` shows no stale speckit branding in user-facing text.

### Implementation for User Story 3

- [X] T024 [P] [US3] Review `.specify/feature.json` — verify feature directory points to 012
- [X] T025 [P] [US3] Update `CLAUDE.md` SPECKIT section to reference `specs/012-project-cleanup-docs/plan.md`
- [X] T026 [P] [US3] Review `.claude/skills/vipd-*/**/skill.json` or skill definition files for stale descriptions

**Checkpoint**: All config references verified.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T027 Run validation: `grep -r "speckit" README.md -i -c` — verify 8 (all in attribution/comparison sections) ✅
- [X] T028 Run validation: `grep -r "speckit" docs/ --include="*.md" -i -c` — verify 75 remaining (all upstream attribution in community/ipd-transformation/reference pages) ✅
- [X] T029 Run validation: `grep -r "/speckit-" docs/ --include="*.md" -c` — verify 0 ✅
- [X] T030 Verify README renders correctly on GitHub (check Markdown formatting, no broken links)
- [X] T031 Remove `hello.sh.bak` from `samples/e2e-validate-hello/` (residue from 011 feature)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundations (Phase 2)**: No dependencies — can start in parallel with Setup
- **US1 (Phase 3)**: Depends on Phase 1 (T002 provides baseline for README rewrite)
- **US2 (Phase 4)**: Depends on Phase 1 (T001 provides baseline) — independent of US1
- **US3 (Phase 5)**: Depends on Phase 1 (T003 provides baseline) — independent of US1 and US2
- **Polish (Phase 6)**: Depends on US1 + US2 + US3

### User Story Dependencies

- **User Story 1 (P1)**: No dependencies on other stories — can start immediately after Setup
- **User Story 2 (P1)**: No dependencies on other stories — fully independent (different files)
- **User Story 3 (P2)**: No dependencies on other stories — fully independent (different files)

### Parallel Opportunities

- All US1 tasks marked [P] can run in parallel (different sections of same file)
- All US2 tasks marked [P] can run in parallel (different files in docs/)
- All US3 tasks marked [P] can run in parallel (different config files)
- US1, US2, and US3 can all run in parallel (completely different file scopes)
- All Polish tasks can run in parallel once all stories are complete
