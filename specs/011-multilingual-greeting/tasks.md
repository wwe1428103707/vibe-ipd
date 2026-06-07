---

description: "Task list for Multilingual Greeting feature"
---

# Tasks: Multilingual Greeting

**Input**: Design documents from `/specs/011-multilingual-greeting/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup (Shared Infrastructure)

- [X] T001 Read current `samples/e2e-validate-hello/hello.sh` to understand existing argument parsing structure
- [X] T002 [P] Back up current hello.sh to `samples/e2e-validate-hello/hello.sh.bak`

## Phase 2: Foundational (Blocking Prerequisites)

- [X] T003 [P] Verify UTF-8 terminal support by testing Chinese characters: `echo "你好"`
- [X] T004 Verify bash version: `bash --version`

## Phase 3: User Story 1 — Greet in English (P1) 🎯 MVP

**Goal**: Support `--lang en` (default) with proper English greeting

- [X] T005 [P] [US1] Add `--lang` argument parsing to hello.sh in `samples/e2e-validate-hello/hello.sh`
- [X] T006 [US1] Implement English greeting template and default-to-English fallback in `samples/e2e-validate-hello/hello.sh`
- [X] T007 [US1] Update `--help` output to document `--lang` option in `samples/e2e-validate-hello/hello.sh`

## Phase 4: User Story 2 — Greet in Chinese (P1)

**Goal**: Support `--lang zh` with Chinese greeting

- [X] T008 [P] [US2] Add Chinese greeting template in `samples/e2e-validate-hello/hello.sh`
- [X] T009 [US2] Implement unsupported language fallback with stderr notice in `samples/e2e-validate-hello/hello.sh`

## Phase 5: User Story 3 — Greet in Japanese (P2)

**Goal**: Support `--lang ja` with Japanese greeting

- [X] T010 [P] [US3] Add Japanese greeting template in `samples/e2e-validate-hello/hello.sh`
- [X] T011 [US3] Test --lang ja with name containing special characters in `samples/e2e-validate-hello/hello.sh`

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T012 Run full test suite: test all 3 languages + error cases + backward compatibility
- [X] T012a [P] Validate `--lang` without value exits with code 1: `bash hello.sh --name Alice --lang`
- [X] T012b [P] Validate `--lang` combined with `--version` and `--help` does not interfere
- [X] T013 Update `samples/e2e-validate-hello/README.md` with --lang usage examples
- [X] T014 Verify all existing features (--name, --help, --version) still work

## Dependencies & Execution Order

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Can run in parallel with Setup
- **US1 (Phase 3)**: Depends on Setup + Foundational — core --lang parsing
- **US2 (Phase 4)**: Depends on US1 (needs --lang parsing to work)
- **US3 (Phase 5)**: Depends on US1 (needs --lang parsing to work), independent of US2
- **Polish (Phase 6)**: Depends on US1 + US2 + US3
