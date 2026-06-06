---

description: "Task list for PDT role skill file implementation"
---

# Tasks: PDT Role Mapping & Agent Setup

**Input**: Design documents from `/specs/007-pdt-role-setup/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/role-skill-interface.md

**Tests**: Not applicable (Markdown skill configuration — no runnable tests)

**Organization**: Tasks are grouped by user story to enable independent implementation of each role.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- Role skill files live under `.claude/skills/vipd-agent-assign-*/SKILL.md`
- Reference role mapping guide at `docs/ipd-transformation/04-role-mapping-pdt-setup-guide.md`
- Reference role skill interface contract at `specs/007-pdt-role-setup/contracts/role-skill-interface.md`

---

## Phase 1: Setup

**Purpose**: Create directory structure for all 7 role skill files

- [ ] T001 Create directory structure for all role skill files (mkdir -p .claude/skills/vipd-agent-assign-{lpdt,po,architect,qa-lead,devops-lead,lpdt-po,devops-qa})

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create the role skill interface contract template that all role skills follow

**⚠️ CRITICAL**: No role skill work can begin until this contract is established

- [ ] T002 Create the role skill interface contract at specs/007-pdt-role-setup/contracts/role-skill-interface.md (already done in plan phase — use as reference)

**Checkpoint**: Contract established — all role skills will follow the same structure

---

## Phase 3: User Story 1 - Configure IPD Roles as Subagents (Priority: P1) 🎯 MVP

**Goal**: 5 individual role-specific skill files that configure Claude Code subagents to adopt IPD personas

**Independent Test**: Each `/vipd-agent-assign-*` command produces a response framed from the correct role perspective

### Implementation for User Story 1

- [x] T003 [P] [US1] Create LPDT/RTE role skill at .claude/skills/vipd-agent-assign-lpdt/SKILL.md — gate facilitation, delivery commitment, escalation authority
- [x] T004 [P] [US1] Create PO role skill at .claude/skills/vipd-agent-assign-po/SKILL.md — backlog prioritization, acceptance criteria, feature value decisions
- [x] T005 [P] [US1] Create Architect role skill at .claude/skills/vipd-agent-assign-architect/SKILL.md — technical feasibility, architecture compliance, CBB management
- [x] T006 [P] [US1] Create QA Lead role skill at .claude/skills/vipd-agent-assign-qa-lead/SKILL.md — test strategy, DoD definition, quality metrics
- [x] T007 [P] [US1] Create DevOps Lead role skill at .claude/skills/vipd-agent-assign-devops-lead/SKILL.md — CI/CD, deployment readiness, operational stability

**Checkpoint**: All 5 individual role skills should be invocable via `/vipd-agent-assign-*` commands

---

## Phase 4: User Story 2 - Product Trio Discovery for Validation (Priority: P2)

**Goal**: Define the Product Trio discovery workflow to validate features before they enter the delivery backlog

**Independent Test**: A Product Trio review can be completed for any existing feature spec in under 15 minutes

### Implementation for User Story 2

- [x] T008 [US2] Create Product Trio discovery workflow guide at docs/ipd-transformation/product-trio-workflow.md — defines step-by-step process for PO+Architect+UX review of a feature spec
- [x] T009 [US2] Create Product Trio review template at .specify/templates/guides/trio-review-template.md — structured output format for trio assessments (go/no-go per role, consolidation)

**Checkpoint**: Product Trio discovery workflow is documented and can be executed against any feature spec

---

## Phase 5: User Story 3 - RACI-Guided Task & Combined Roles (Priority: P3)

**Goal**: Combined role skills for small teams and RACI annotation pattern for task descriptions

**Independent Test**: Combined role skill produces coherent responses covering both role perspectives

### Implementation for User Story 3

- [x] T010 [P] [US3] Create combined LPDT+PO role skill at .claude/skills/vipd-agent-assign-lpdt-po/SKILL.md — with conflict resolution rules (LPDT on gate/decisions, PO on feature value)
- [x] T011 [P] [US3] Create combined DevOps+QA role skill at .claude/skills/vipd-agent-assign-devops-qa/SKILL.md — with conflict resolution rules (QA on quality, DevOps on operations)
- [x] T012 [US3] Add RACI annotation reference to the role skill contract at specs/007-pdt-role-setup/contracts/role-skill-interface.md — defining the RACI field format for tasks.md

**Checkpoint**: Combined roles work for small-team scenarios; RACI format is documented

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validation and documentation updates

- [ ] T013 [P] Run `/reload-skills` to register all new role skills in Claude Code's command palette (manual step)
- [x] T014 [P] Update quickstart.md at specs/007-pdt-role-setup/quickstart.md with usage examples for each role
- [x] T015 Update docs/ipd-transformation/04-role-mapping-pdt-setup-guide.md to reflect that role skills have been implemented
- [x] T016 Run end-to-end validation: invoke each `/vipd-agent-assign-*` command and verify role-appropriate response

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **User Stories (Phase 3+)**: All depend on Phase 1 directory structure
  - US1 (T003-T007) can run entirely in parallel (different files, no cross-dependencies)
  - US2 (T008-T009) independent of US1 but depends on existing spec pattern
  - US3 (T010-T012) depends on US1 skill pattern being established
- **Polish (Phase 6)**: Depends on all user stories completed

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Setup — all 5 tasks independent
- **User Story 2 (P2)**: Can start after Setup — independent of US1
- **User Story 3 (P3)**: Can start after US1 completes (needs role skill pattern as reference)

### Parallel Opportunities

- All US1 role skills marked [P] can be created simultaneously (no file conflicts)
- US1 and US2 can proceed in parallel
- US3 must wait for US1 to establish the role skill pattern

---

## Parallel Example: User Story 1

```bash
# Launch all 5 role skills in parallel:
Task: "Create LPDT role skill" → .claude/skills/vipd-agent-assign-lpdt/SKILL.md
Task: "Create PO role skill"   → .claude/skills/vipd-agent-assign-po/SKILL.md
Task: "Create Architect role"  → .claude/skills/vipd-agent-assign-architect/SKILL.md
Task: "Create QA Lead role"    → .claude/skills/vipd-agent-assign-qa-lead/SKILL.md
Task: "Create DevOps Lead role" → .claude/skills/vipd-agent-assign-devops-lead/SKILL.md

# No conflicts — each writes to a different directory
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (mkdir)
2. Complete Phase 3: All 5 individual role skills (parallel)
3. **STOP and VALIDATE**: Test each `/vipd-agent-assign-*` command

### Incremental Delivery

1. Complete Setup → directories ready
2. Add US1 (5 roles) → all individual roles work (MVP!)
3. Add US2 (Product Trio) → discovery workflow documented
4. Add US3 (combined roles + RACI) → small-team adaptations ready
5. Polish: validate all 7 skills work end-to-end

### Parallel Team Strategy

For a single developer: US1 tasks T003-T007 can be done in any order (parallel). Recommend writing LPDT first as the most foundational role, then do the rest.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each role skill should be independently invocable and testable
- Verify each skill produces correct role perspective after creation
- Commit after each logical group of tasks
- Run `/reload-skills` in Phase 6 to register new commands
- No source code — all files are Markdown with YAML frontmatter
