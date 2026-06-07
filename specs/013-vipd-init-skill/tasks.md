---

description: "Task list for vipd-init Skill feature"
---

# Tasks: vipd-init Skill

**Input**: Design documents from `specs/013-vipd-init-skill/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the skill directory and study existing patterns

- [X] T001 Create `.claude/skills/vipd-init/` directory structure
- [X] T002 [P] Review existing `vipd-*` skills for frontmatter patterns (name, description, argument-hint, metadata) in `.claude/skills/vipd-specify/SKILL.md`
- [X] T002 [P] Review `vipd-*` skill conventions for Pre-Execution Checks, hook dispatch, and completion reporting patterns in `.claude/skills/vipd-specify/SKILL.md`
- [X] T004 Review `.specify/integrations/claude.manifest.json` to understand what `specify init --integration claude` produces

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure knowledge that MUST be complete before any user story

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T005 Document the `uvx` invocation pattern: `uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>`
- [X] T006 Document the `pipx` fallback pattern: `pipx install git+https://github.com/github/spec-kit.git && specify init <PROJECT_NAME>`
- [X] T007 Determine edge cases to handle (no uvx/pipx, existing .specify/, network errors)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel
> **Gate Completion Verification**: All setup and foundational tasks [X] completed / [X] verified

---

## Phase 3: User Story 1 — Project Scaffolding via /vipd-init (Priority: P1) 🎯 MVP

**Goal**: Users can run `/vipd-init my-project --integration claude` to scaffold a new vibe-ipd project, without needing to know the underlying `specify init` CLI.

**Independent Test**: Run `/vipd-init test-project --integration claude` and verify a `test-project/` directory is created with `.specify/` structure and `.claude/skills/` containing integration files.

### Implementation for User Story 1

- [X] T008 [P] [US1] Write YAML frontmatter for `.claude/skills/vipd-init/SKILL.md` with name `vipd-init`, description, argument-hint, and metadata
- [X] T009 [US1] Write "User Input" section in SKILL.md — parse `<PROJECT_NAME>` and `--integration` from `$ARGUMENTS`
- [X] T010 [US1] Write tool detection logic — check for `uvx` availability first, fall back to `pipx`, provide clear error if neither found
- [X] T011 [US1] Write core scaffolding delegation — construct and execute `uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>` (or pipx equivalent)
- [X] T012 [US1] Write existing-directory guard — detect if target already has `.specify/`, prompt for confirmation before re-initializing
- [X] T013 [US1] Write error handling section — network timeout, command failure, graceful degradation with manual setup instructions
- [X] T014 [US1] Write completion reporting section — output scaffold result summary, next steps, and quickstart commands

**Checkpoint**: US1 complete — `/vipd-init my-project --integration claude` scaffolds a working project

---

## Phase 4: User Story 2 — Vibe-IPD Post-Init Branding (Priority: P1)

**Goal**: After scaffolding, optionally apply vibe-ipd branding to replace `speckit-*` skills with `vipd-*` equivalents, providing a consistent user experience.

**Independent Test**: Run `/vipd-init test-project --integration claude` and verify the scaffolded `.claude/skills/` contains `vipd-*` names (or at minimum the project uses vibe-ipd skills consistently).

### Implementation for User Story 2

- [X] T015 [P] [US2] Write post-init branding check — after scaffolding, inventory `.claude/skills/` for `speckit-*` skill files
- [X] T016 [US2] Write branding override section — option to rename/copy `speckit-*` skills to `vipd-*` equivalents (or reference existing vipd-* skills if already present)
- [X] T017 [US2] Write user feedback for branding step — inform user of what was renamed and recommend running `/vipd-constitution` next

**Checkpoint**: US2 complete — scaffolded project shows consistent vibe-ipd branding

---

## Phase 5: User Story 3 — Integration Option Selection (Priority: P2)

**Goal**: Support `--integration` flag passthrough to `specify init`, allowing users to choose their AI coding agent.

**Independent Test**: Run `/vipd-init test-project --integration copilot` and verify the correct integration-specific files are generated.

### Implementation for User Story 3

- [X] T018 [P] [US3] Write `--integration` flag passthrough — forward all `--integration` values directly to `specify init` without validation
- [X] T019 [US3] Write default behavior — when `--integration` is omitted, inform user and scaffold without integration-specific files
- [X] T020 [US3] Write `--script` flag passthrough — forward `--script ps|sh` to `specify init` for explicit script type selection

**Checkpoint**: US3 complete — all flags from `specify init` are transparently passthrough-capable

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and final validation

- [X] T021 [P] Add "Troubleshooting" section to SKILL.md — common errors and solutions
- [X] T022 [P] Add "Related Commands" section to SKILL.md — references to `/vipd-constitution`, `/vipd-specify`, `/vipd-plan`
- [X] T023 Review and validate all edge cases in SKILL.md (missing tools, existing dirs, invalid names)
- [X] T024 Run `/vipd-init --help` or equivalent input check — verify skill responds correctly to help/incomplete input
- [X] T025 Update `CLAUDE.md` agent context if needed (already done in plan phase)
- [ ] T026 Manual verification: full end-to-end test of `/vipd-init` workflow

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Phase 1 + Phase 2 — primary MVP
- **US2 (Phase 4)**: Depends on US1 (adds post-processing after scaffolding)
- **US3 (Phase 5)**: Depends on US1 (extends the scaffolding argument handling)
- **Polish (Phase 6)**: Depends on US1 + US2 + US3

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Setup + Foundational — No dependencies on other stories
- **User Story 2 (P1)**: Depends on US1 — adds post-processing to the scaffold result
- **User Story 3 (P2)**: Depends on US1 — extends the argument parsing section; independent of US2

### Within Each User Story

- Frontmatter before content sections
- Core logic before error handling
- Implementation complete before polish

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All US1 tasks marked [P] can run in parallel (T008 is independent from T009–T014 sequence)
- All US2 tasks can run sequentially (small phase)
- US3 can run in parallel with US2 (both extend US1 independently)
- All Polish tasks marked [P] can run in parallel

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1 (core scaffolding)
4. **STOP and VALIDATE**: Test `/vipd-init` with `--integration claude`
5. Deploy MVP — users can scaffold projects

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 (core scaffolding) → MVP!
3. Add User Story 2 (branding) → Consistent user experience
4. Add User Story 3 (full flag passthrough) → Feature parity with speckit CLI

### Parallel Team Strategy

1. Team completes Setup + Foundational together
2. Once US1 is done:
   - Developer A: User Story 2 (branding)
   - Developer B: User Story 3 (flag passthrough)
3. Both complete independently without conflicts (different sections of same SKILL.md)

---

## Notes

- This feature creates ONE file: `.claude/skills/vipd-init/SKILL.md`
- The skill wraps the existing speckit CLI — it does NOT reimplement scaffolding logic
- All `vipd-*` skills follow the same SKILL.md format — use `vipd-specify`/`vipd-constitution` as reference
- No automated tests needed — the deliverable is an AI agent instruction file, not executable code
- Manual verification is done by invoking `/vipd-init` and checking the output
