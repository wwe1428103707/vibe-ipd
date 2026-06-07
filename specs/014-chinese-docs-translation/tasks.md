---

description: "Task list for Chinese Documentation Translation feature"
---

# Tasks: Chinese Documentation Translation

**Input**: Design documents from `/specs/014-chinese-docs-translation/`

**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create directory structure and prepare glossary for consistent translations

- [x] T001 Create `docs/zh/` directory structure — `docs/zh/concepts/`, `docs/zh/reference/`, `docs/zh/install/`
- [x] T002 [P] Verify translation glossary from `specs/014-chinese-docs-translation/research.md` — review existing `docs/ipd-transformation/zh/` for consistency with README.zh.md terminology
- [x] T003 Read the link mapping contract at `specs/014-chinese-docs-translation/contracts/link-mapping.md` to understand language toggle and cross-reference patterns

---

## Phase 2: (No blocking foundational tasks — all translations are independent)

> All P1/P2/P3 translations can proceed in any order. The only true dependency is that US5 (README.zh.md link updates) must wait until translations exist.

---

## Phase 3: User Story 1 — Quickstart Guide in Chinese (Priority: P1) 🎯 MVP

**Goal**: Create Chinese translation of `docs/quickstart.md` at `docs/zh/quickstart.md` so Chinese-speaking users can follow the getting-started workflow entirely in Chinese.

**Independent Test**: Open `docs/zh/quickstart.md` and verify it contains all sections from the English original, all code blocks are preserved verbatim, and the language toggle at the top links back to `docs/quickstart.md`.

### Implementation for User Story 1

- [x] T004 [US1] Create `docs/zh/quickstart.md` — translate all prose from `docs/quickstart.md` into Chinese, preserving all headings, code blocks, lists, and link structure per the glossary and contracts
- [x] T005 [US1] Add language toggle at the top of `docs/zh/quickstart.md`: `[English](../quickstart.md) · **[中文](.)**`
- [x] T006 [US1] Add language toggle at the top of `docs/quickstart.md`: `**[English](.)** · [中文](zh/quickstart.md)`
- [x] T007 [US1] Adjust relative links in `docs/zh/quickstart.md` to point to `docs/zh/` equivalents where Chinese translations exist
- [x] T008 [US1] Verify all four workflow steps (init → specify → plan → tasks) display correct CLI commands in the Chinese translation

**Checkpoint**: User Story 1 — Quickstart Guide should be functional and testable independently. Verify by checking all three acceptance scenarios from spec.md.

---

## Phase 4: User Story 2 — Installation Guide in Chinese (Priority: P1)

**Goal**: Create Chinese translation of `docs/installation.md` at `docs/zh/installation.md` so Chinese-speaking developers can install vibe-ipd using instructions in Chinese.

**Independent Test**: Open `docs/zh/installation.md` and verify all prerequisites, installation methods (uv/pipx), and platform-specific notes are accurately translated while shell commands remain executable verbatim.

### Implementation for User Story 2

- [x] T009 [P] [US2] Create `docs/zh/installation.md` — translate all prose from `docs/installation.md` into Chinese, paying special attention to Windows/PowerShell-specific notes
- [x] T010 [US2] Add language toggle at the top of `docs/zh/installation.md`: `[English](../installation.md) · **[中文](.)**`
- [x] T011 [US2] Add language toggle at the top of `docs/installation.md`: `**[English](.)** · [中文](zh/installation.md)`
- [x] T012 [US2] Verify all shell commands, code blocks, and prerequisite tool names are preserved verbatim in the Chinese translation

**Checkpoint**: User Story 2 should work independently. Verify both acceptance scenarios from spec.md.

---

## Phase 5: User Story 3 — Reference Documentation in Chinese (Priority: P2)

**Goal**: Create Chinese translations for all 7 files under `docs/reference/` at `docs/zh/reference/` providing Chinese-speaking users with full reference docs.

**Independent Test**: Navigate to `docs/zh/reference/overview.md` and verify all 7 reference topics are translated and linked correctly from the Chinese index.

### Implementation for User Story 3

- [x] T013 [P] [US3] Create `docs/zh/reference/overview.md` — translate `docs/reference/overview.md` (33 lines)
- [x] T014 [P] [US3] Create `docs/zh/reference/core.md` — translate `docs/reference/core.md` (97 lines)
- [x] T015 [P] [US3] Create `docs/zh/reference/authentication.md` — translate `docs/reference/authentication.md` (181 lines)
- [x] T016 [P] [US3] Create `docs/zh/reference/extensions.md` — translate `docs/reference/extensions.md` (201 lines)
- [x] T017 [P] [US3] Create `docs/zh/reference/integrations.md` — translate `docs/reference/integrations.md` (194 lines)
- [x] T018 [P] [US3] Create `docs/zh/reference/presets.md` — translate `docs/reference/presets.md` (224 lines)
- [x] T019 [P] [US3] Create `docs/zh/reference/workflows.md` — translate `docs/reference/workflows.md` (323 lines)
- [x] T020 [P] [US3] Add language toggle to each Chinese reference doc (relative links back to `../../reference/<file>.md`)
- [x] T021 [P] [US3] Add language toggle to each English reference doc (relative links to `../zh/reference/<file>.md`)
- [x] T022 [US3] Update cross-references within all Chinese reference docs to point to `docs/zh/reference/` equivalents

**Checkpoint**: All 7 reference docs should be independently viewable. Verify by checking all three acceptance scenarios from spec.md.

---

## Phase 6: User Story 4 — Concepts Document in Chinese (Priority: P3)

**Goal**: Create Chinese translation of `docs/concepts/sdd.md` at `docs/zh/concepts/sdd.md` explaining Spec-Driven Development methodology in Chinese.

**Independent Test**: Open `docs/zh/concepts/sdd.md` and verify all four SDD philosophy principles and the spec → plan → tasks → implement workflow are accurately translated.

### Implementation for User Story 4

- [x] T023 [P] [US4] Create `docs/zh/concepts/sdd.md` — translate `docs/concepts/sdd.md` (46 lines) into Chinese, preserving all four philosophy principles and workflow descriptions
- [x] T024 [US4] Add language toggle at the top of `docs/zh/concepts/sdd.md`: `[English](../../concepts/sdd.md) · **[中文](.)**`
- [x] T025 [US4] Add language toggle at the top of `docs/concepts/sdd.md`: `**[English](.)** · [中文](../zh/concepts/sdd.md)`

**Checkpoint**: User Story 4 should be independently functional. Verify both acceptance scenarios.

---

## Phase 7: User Story 5 — README.zh.md Links to Chinese Docs (Priority: P1)

**Goal**: Update `README.zh.md` so all documentation links in the "文档" section point to Chinese versions. This is the glue that makes all translations reachable.

**Independent Test**: Open `README.zh.md`, click every link in the Documentation section — all 5 should resolve to Chinese-language documents.

**⚠️ Dependency**: This phase MUST wait until all translation files from US1–US4 exist.

### Implementation for User Story 5

- [x] T026 [US5] Update `README.zh.md` Documentation section: change `./docs/quickstart.md` link to `./docs/zh/quickstart.md`
- [x] T027 [US5] Update `README.zh.md` Documentation section: change `./docs/installation.md` link to `./docs/zh/installation.md`
- [x] T028 [US5] Update `README.zh.md` Documentation section: change `./docs/concepts/` link to `./docs/zh/concepts/sdd.md`
- [x] T029 [US5] Update `README.zh.md` Documentation section: change `./docs/ipd-transformation/` link to `./docs/ipd-transformation/zh/README.md` (pre-existing translations)
- [x] T030 [US5] Update `README.zh.md` Documentation section: change `./docs/reference/` link to `./docs/zh/reference/overview.md`
- [x] T031 [US5] Remove `./docs/community/` entry from `README.zh.md` Documentation section (out of scope per clarification)
- [x] T032 [US5] Add language toggle to each English source doc that received a Chinese translation (`**[English](.)** · [中文](path)`) — quickstart, installation, concepts/sdd, reference/*.md

**Checkpoint**: All 5 documentation links in README.zh.md point to Chinese documents. Verify by clicking each link.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Verification, nice-to-have translations, and maintenance notes.

- [x] T033 [P] Verify all translated documents preserve code blocks verbatim — run diff of code blocks between English source and Chinese translation for each paired file
- [x] T034 [P] Verify all language toggle links are bidirectional and resolve correctly
- [x] T035 [P] Verify heading hierarchy is identical between each English source and its Chinese translation (same number of H1, H2, H3 tags)
- [ ] T036 [P] If scope permits: create `docs/zh/index.md` — translate `docs/index.md` (154 lines)
- [ ] T037 [P] If scope permits: create `docs/zh/upgrade.md` — translate `docs/upgrade.md` (508 lines)
- [ ] T038 [P] If scope permits: create `docs/zh/local-development.md` — translate `docs/local-development.md` (173 lines)
- [ ] T039 [P] If scope permits: create `docs/zh/README.md` — translate `docs/README.md` (~30 lines)
- [ ] T040 [P] If scope permits: create `docs/zh/install/` — translate `docs/install/uv.md` (60 lines), `docs/install/pipx.md` (37 lines), `docs/install/one-time.md` (32 lines), `docs/install/air-gapped.md` (59 lines)
- [x] T041 Run final cross-artifact consistency check — verify all README.zh.md links work, all language toggles are bidirectional, and no English prose remains in translated docs

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **User Stories (Phases 3–6)**: No dependencies on each other — all translations are independent and can be done in parallel
- **US5 (Phase 7)**: MUST wait until US1–US4 translation files exist before updating README.zh.md links
- **Polish (Phase 8)**: Depends on all desired user stories being complete — verification tasks run last

### User Story Dependencies

- **US1 (P1) Quickstart**: Independent — no dependencies on other stories
- **US2 (P1) Installation**: Independent — no dependencies on other stories
- **US3 (P2) Reference**: Independent — no dependencies on other stories
- **US4 (P3) Concepts**: Independent — no dependencies on other stories
- **US5 (P1) README.zh.md Links**: DEPENDS on US1–US4 — all translations must exist before links are updated

### Within Each User Story

- Translation before verification
- Language toggle added during or immediately after translation
- Cross-reference updates after all related translations exist

### Parallel Opportunities

- **Phase 1 Setup tasks**: T002, T003 can run in parallel
- **US3 Reference translations**: All 7 file translations (T013–T019) can run in parallel with each other
- **US1 through US4**: All can be implemented in parallel by different team members (no dependencies between them)
- **Polish tasks**: T033–T040 are all independent and can run in parallel

---

## Parallel Example: User Story 3 (Reference)

```bash
# All 7 reference file translations can run simultaneously:
Task: "Create docs/zh/reference/overview.md from docs/reference/overview.md"
Task: "Create docs/zh/reference/core.md from docs/reference/core.md"
Task: "Create docs/zh/reference/authentication.md from docs/reference/authentication.md"
Task: "Create docs/zh/reference/extensions.md from docs/reference/extensions.md"
Task: "Create docs/zh/reference/integrations.md from docs/reference/integrations.md"
Task: "Create docs/zh/reference/presets.md from docs/reference/presets.md"
Task: "Create docs/zh/reference/workflows.md from docs/reference/workflows.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 3: User Story 1 — Quickstart Guide (the most visible doc)
3. **STOP and VALIDATE**: Open `docs/zh/quickstart.md` and verify it renders correctly, all links work, all code blocks are preserved
4. Deploy/demo if ready

### Incremental Delivery

1. Setup → Foundation ready
2. Add US1 (Quickstart) → Test independently → Demo (Chinese-speaking users can start here!)
3. Add US2 (Installation) → Test independently → Demo
4. Add US3 (Reference) → Test independently → Full reference available
5. Add US4 (Concepts) → Test independently
6. Add US5 (README.zh.md links) → All Chinese docs reachable from landing page
7. Polish & nice-to-haves

### Parallel Team Strategy

With multiple translators:

1. Translator A: US1 (Quickstart) + US2 (Installation)
2. Translator B: US3 (Reference — all 7 files)
3. Translator C: US4 (Concepts)
4. All three finish → US5 (README.zh.md link updates) + Polish

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story is independently completable and testable
- Use the translation glossary in `research.md` for consistent terminology
- Reference the link mapping contract in `contracts/link-mapping.md` for toggle patterns
- Commit after each logical group of tasks
- Stop at any checkpoint to validate story independently
- No test tasks required — this is a documentation translation feature, not a code feature
