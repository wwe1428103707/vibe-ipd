---

description: "Task list for IPD Toolkit Transformation Plan document creation"
---

# Tasks: IPD Toolkit Transformation Plan

**Input**: Design documents from `specs/001-ipd-toolkit/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: N/A — this is a documentation feature with no code or automated tests.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

- **Document output directory**: `docs/ipd-transformation/`
- **Component files**: `docs/ipd-transformation/0N-*.md` (numeric prefix per story order)
- **Contract templates**: `specs/001-ipd-toolkit/contracts/*.md` (referenced for section structure)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the output directory, shared conventions, and index file

- [x] T001 Create `docs/ipd-transformation/` target directory
- [x] T002 [P] Create shared glossary document at `docs/ipd-transformation/glossary.md` with all IPD and Agile terms (TR, PDT, LPDT, RTE, DoD, WSJF, CBB, Product Trio, Agile-Stage-Gate, Dual-Track)
- [x] T003 [P] Create document formatting conventions guide at `docs/ipd-transformation/CONTRIBUTING.md` covering heading hierarchy, cross-reference syntax, terminology rules, and metadata frontmatter

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Research and reference material that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Review IPD fusion guide at `docs/IPD与敏捷开发深度融合的软件产品开发流程与研发管理平台搭建指南.md` to ensure full understanding of TR gate criteria, role mappings, and tooling requirements
- [x] T005 [P] Review existing SDD skills at `.claude/skills/speckit-*/skill.md` and catalog current command behavior (for US2 before/after comparison)
- [x] T006 [P] Review research findings at `specs/001-ipd-toolkit/research.md` and extract decisions into a working reference

**Checkpoint**: Foundation ready — all 4 document creation tasks can now begin

---

## Phase 3: User Story 1 - IPD Transformation Roadmap (Priority: P1) 🎯 MVP

**Goal**: Create a phased transformation roadmap that breaks down the SDD-to-IPD evolution into actionable milestones

**Independent Test**: Stakeholders can review the roadmap and identify all 3 phases, their dependencies, and effort estimates

### Implementation for User Story 1

- [x] T007 [US1] Create transformation roadmap at `docs/ipd-transformation/01-transformation-roadmap.md` with Overview & Scope section defining the SDD-only baseline and IPD-enhanced target state
- [x] T008 [P] [US1] Write Phase 1: Foundation section with entrance/exit criteria, deliverables list, and effort estimate per `contracts/01-roadmap-contract.md`
- [x] T009 [P] [US1] Write Phase 2: Integration section with entrance/exit criteria (referencing Phase 1 completion), deliverables list, and effort estimate
- [x] T010 [P] [US1] Write Phase 3: Optimization section with entrance/exit criteria (referencing Phase 2 completion), deliverables list, and effort estimate
- [x] T011 [P] [US1] Create dependency graph (Mermaid flowchart) showing inter-phase dependencies in `docs/ipd-transformation/01-transformation-roadmap.md`
- [x] T012 [P] [US1] Create timeline summary table with phase durations and effort estimates
- [x] T013 [US1] Add cross-references to US2, US3, and US4 document files at end of roadmap

**Checkpoint**: The Transformation Roadmap can be reviewed independently. All 3 phases, their dependencies, and effort estimates are documented.

---

## Phase 4: User Story 2 - Command & Template Redesign Guide (Priority: P1)

**Goal**: Create a precise specification for how each SDD command and template must incorporate IPD gate awareness

**Independent Test**: A command maintainer can take this guide and implement all 7 command updates without further clarification

### Implementation for User Story 2

- [x] T014 [US2] Create command redesign guide at `docs/ipd-transformation/02-command-template-redesign-guide.md` with Overview section defining the SDD-to-IPD integration approach
- [x] T015 [P] [US2] Write `/speckit-constitution` redesign section: current behavior → TR0 gate integration → new behavior per `contracts/02-command-template-contract.md`
- [x] T016 [P] [US2] Write `/speckit-specify` redesign section: current behavior → TR1 gate integration → new behavior
- [x] T017 [P] [US2] Write `/speckit-clarify` redesign section: current behavior → TR1 gate integration → new behavior
- [x] T018 [P] [US2] Write `/speckit-plan` redesign section: current behavior → TR2/TR3 gate integration → new behavior
- [x] T019 [P] [US2] Write `/speckit-tasks` redesign section: current behavior → TR4 gate integration → new behavior
- [x] T020 [P] [US2] Write `/speckit-implement` redesign section: current behavior → TR4/TR4A gate integration → new behavior
- [x] T021 [P] [US2] Write `/speckit-analyze` redesign section: current behavior → TR5 gate integration → new behavior
- [x] T022 [P] [US2] Write template redesign sections for all 4 templates (constitution, spec, plan, tasks) with new IPD-aligned fields per FR-006
- [x] T023 [US2] Write backward compatibility notes section and implementation sequence recommendation

**Checkpoint**: The Command & Template Redesign Guide can be used independently to plan SDD command updates. All 7 commands and 4 templates are covered.

---

## Phase 5: User Story 3 - Tooling Integration Blueprint (Priority: P2)

**Goal**: Create a blueprint for configuring the project management platform to support the Agile-Stage-Gate workflow

**Independent Test**: A platform engineer can configure a working Agile-Stage-Gate instance in under 4 hours using this blueprint

### Implementation for User Story 3

- [x] T024 [US3] Create tooling blueprint at `docs/ipd-transformation/03-tooling-integration-blueprint.md` with Overview section defining platform requirements per `contracts/03-tooling-blueprint-contract.md`
- [x] T025 [US3] Write issue hierarchy configuration section: Initiative → Feature → Story → Sub-Task mapping with Jira settings steps
- [x] T026 [US3] Write workflow states and TR gate transitions table: Draft → Feasibility → Concept Approved → Business Case Ready → In Development → Testing → GA Release
- [x] T027 [P] [US3] Write automation rules for Gate 1 (Concept Approval) with conditions and auto-creation actions
- [x] T028 [P] [US3] Write automation rules for Gate 2 (Development Readiness) with validation criteria
- [x] T029 [P] [US3] Write automation rules for Gate 3 (Release Ready/TR6) with DoD enforcement
- [x] T030 [US3] Write Advanced Roadmaps dependency management configuration section with red-line alert setup
- [x] T031 [US3] Write CI/CD integration section covering webhook triggers and automated quality gate verification
- [x] T032 [US3] Write platform alternatives section for teams without Jira Advanced Roadmaps

**Checkpoint**: The Tooling Integration Blueprint can be used independently to configure a project management platform.

---

## Phase 6: User Story 4 - Role Mapping & PDT Setup Guide (Priority: P2)

**Goal**: Create a guide mapping IPD organizational roles to Agile roles within the Spec Kit context

**Independent Test**: A team lead can assign all PDT roles and produce a RACI matrix in under 1 hour using this guide

### Implementation for User Story 4

- [x] T033 [US4] Create role mapping guide at `docs/ipd-transformation/04-role-mapping-pdt-setup-guide.md` with Overview section per `contracts/04-role-mapping-contract.md`
- [x] T034 [US4] Write complete IPD-to-Agile role mapping table covering LPDT/RTE, Product Manager/PO, System Architect, QA Lead, DevOps Lead with accountabilities
- [x] T035 [P] [US4] Write Product Trio section: composition (PO + Architect + UX), operating cadence, scope of authority
- [x] T036 [P] [US4] Write Feature Team Autonomy vs PDT Manager Coordination boundaries table
- [x] T037 [US4] Create RACI matrix template for key PDT activities: requirement definition, architecture review, development, testing, deployment
- [x] T038 [US4] Write small-team adaptation section for teams of 3–5 with combined roles

**Checkpoint**: The Role Mapping Guide can be used independently to assign roles and structure a PDT.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Cross-reference verification, consistency check, and quality validation across all 4 documents

- [x] T039 [P] Verify all cross-references between the 4 documents are accurate (links resolve to correct files)
- [x] T040 [P] Verify each document references at least one constitutional principle (I–V) per SC-005
- [x] T041 [P] Verify all Must-Meet criteria from constitution's TR gates are addressed by at least one document per SC-006
- [x] T042 [P] Run quality checklist from `specs/001-ipd-toolkit/checklists/requirements.md` and confirm all items pass
- [x] T043 Update `docs/ipd-transformation/README.md` (or verify existing one) with correct document summaries and dependency ordering

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundation — can start as soon as Phase 2 completes
- **US2 (Phase 4)**: Depends on Foundation — independent of US1; can run in parallel
- **US3 (Phase 5)**: Depends on Foundation — independent of US1/US2; can run in parallel
- **US4 (Phase 6)**: Depends on Foundation — independent of US1/US2/US3; can run in parallel
- **Polish (Phase 7)**: Depends on ALL user stories being complete

### User Story Dependencies

- **US1 (P1)**: No dependencies on other stories — fully independent
- **US2 (P1)**: No dependencies on other stories — fully independent
- **US3 (P2)**: May reference US2's gate definitions for alignment
- **US4 (P2)**: May reference US1's team formation timing
- All 4 user stories CAN be written in parallel if resources permit

### Within Each User Story

- Follow the document section order defined in the corresponding contract file under `contracts/`
- Core content before supplementary sections
- Cross-references to other documents added last (after those documents exist)

### Parallel Opportunities

- T002 and T003 (Glossary + Conventions) can run in parallel
- T005 and T006 (SDD review + Research review) can run in parallel
- All 4 user story phases (Phase 3–6) can run in parallel — each is an independent document
- Within each user story, [P]-marked tasks can run in parallel
- All Polish tasks (Phase 7) can run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all [P] tasks together:
Task: "Write Phase 1: Foundation section"
Task: "Write Phase 2: Integration section"
Task: "Write Phase 3: Optimization section"
Task: "Create dependency graph"
Task: "Create timeline summary table"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: US1 (Transformation Roadmap)
4. **STOP and VALIDATE**: Review the roadmap independently with stakeholders
5. Use roadmap to inform remaining document priorities

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Write Roadmap (US1) → Review independently → First deliverable ready
3. Write Redesign Guide (US2) → Review independently → Second deliverable ready
4. Write Tooling Blueprint (US3) → Review independently → Third deliverable ready
5. Write Role Guide (US4) → Review independently → Fourth deliverable ready
6. Final polish pass → Collection complete

### Parallel Team Strategy

With multiple writers:

1. Team completes Setup + Foundational together
2. Once Foundation is done:
   - Writer A: US1 (Roadmap)
   - Writer B: US2 (Redesign Guide)
   - Writer C: US3 (Tooling Blueprint)
   - Writer D: US4 (Role Guide)
3. All documents independently creatable in parallel
4. Polish pass after all documents drafted

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- No automated tests — review against acceptance scenarios from spec.md
- All documents are purely descriptive prose (per clarification Q2)
- Output directory is `docs/ipd-transformation/` (per clarification Q1)
- Verify cross-references point to correct filenames (01- to 04- prefix convention)

---

## Phase 8: Chinese Translation — Setup (Chinese Infrastructure)

**Purpose**: Create the zh/ subdirectory and translated infrastructure files

- [x] T044 Create `docs/ipd-transformation/zh/` target directory
- [x] T045 [P] Translate glossary to `docs/ipd-transformation/zh/glossary.md` — adapt all terms to Chinese with English abbreviations in parentheses on first use
- [x] T046 [P] Translate formatting conventions to `docs/ipd-transformation/zh/CONTRIBUTING.md` — adapt for Chinese conventions

---

## Phase 9: Chinese Translation — Foundational (Terminology Validation)

**Purpose**: Validate terminology consistency against the IPD fusion guide

- [x] T047 Review the IPD fusion guide at `docs/IPD与敏捷开发深度融合的软件产品开发流程与研发管理平台搭建指南.md` to extract authoritative Chinese terms for all IPD/Agile concepts

**Checkpoint**: Terminology validated — all document translations can now begin

---

## Phase 10: Chinese Translation — US1 转化路线图 (Priority: P1)

**Goal**: Create a Chinese translation of the Transformation Roadmap

**Independent Test**: A Chinese-speaking project maintainer can understand the full transformation scope within 30 minutes

- [x] T048 [US1] Translate the Transformation Roadmap to `docs/ipd-transformation/zh/01-转化路线图.md` with all sections, preserving Mermaid dependency graph and timeline table
- [x] T049 [P] [US1] Translate Overview & Scope, ensuring IPD/Agile terms use Chinese primary with English abbreviations in parentheses on first use
- [x] T050 [P] [US1] Translate Phase 1 (Foundation), Phase 2 (Integration), and Phase 3 (Optimization) sections with entrance/exit criteria and effort estimates
- [x] T051 [US1] Update all cross-references to use `zh/` paths and add English original links to `../01-transformation-roadmap.md`

---

## Phase 11: Chinese Translation — US2 命令与模板改造指南 (Priority: P1)

**Goal**: Create a Chinese translation of the Command & Template Redesign Guide

**Independent Test**: A Chinese-speaking command maintainer can implement all 7 command updates using only the Chinese guide

- [x] T052 [US2] Translate the Command & Template Redesign Guide to `docs/ipd-transformation/zh/02-命令与模板改造指南.md`
- [x] T053 [P] [US2] Translate all 7 command redesign sections preserving before/after comparison structure
- [x] T054 [P] [US2] Translate all 4 template redesign sections with new IPD-aligned fields in Chinese
- [x] T055 [US2] Translate backward compatibility notes and implementation sequence
- [x] T056 [US2] Update cross-references to use `zh/` paths and add English original link to `../02-command-template-redesign-guide.md`

---

## Phase 12: Chinese Translation — US3 工具集成蓝图 (Priority: P2)

**Goal**: Create a Chinese translation of the Tooling Integration Blueprint

**Independent Test**: A Chinese-speaking platform engineer can configure a working Agile-Stage-Gate Jira instance using the Chinese blueprint

- [x] T057 [US3] Translate the Tooling Integration Blueprint to `docs/ipd-transformation/zh/03-工具集成蓝图.md`
- [x] T058 [US3] Translate issue hierarchy and Jira configuration sections
- [x] T059 [P] [US3] Translate workflow states and TR gate transitions table with state names in Chinese and English
- [x] T060 [P] [US3] Translate all 3 automation rules sections (Gate 1, Gate 2, Gate 3)
- [x] T061 [US3] Translate dependency management, CI/CD integration, and platform alternatives sections
- [x] T062 [US3] Update cross-references to use `zh/` paths and add English original link to `../03-tooling-integration-blueprint.md`

---

## Phase 13: Chinese Translation — US4 角色映射与PDT组建指南 (Priority: P2)

**Goal**: Create a Chinese translation of the Role Mapping & PDT Setup Guide

**Independent Test**: A Chinese-speaking team lead can assign roles and produce a RACI matrix in under 1 hour

- [x] T063 [US4] Translate the Role Mapping Guide to `docs/ipd-transformation/zh/04-角色映射与PDT组建指南.md`
- [x] T064 [US4] Translate the IPD-to-Agile role mapping table with Chinese role names and English abbreviations
- [x] T065 [P] [US4] Translate Product Trio section (composition, cadence, authority)
- [x] T066 [P] [US4] Translate Feature Team Autonomy vs PDT Manager boundaries table
- [x] T067 [US4] Translate the RACI matrix template
- [x] T068 [US4] Translate the small-team adaptation section
- [x] T069 [US4] Update cross-references to use `zh/` paths and add English original link to `../04-role-mapping-pdt-setup-guide.md`

---

## Phase 14: Chinese Translation — Polish & Cross-Cutting

**Purpose**: Index file, cross-reference validation, and terminology consistency

- [x] T070 [P] Create Chinese README index at `docs/ipd-transformation/zh/README.md` with document summaries and dependency diagram in Chinese
- [x] T071 [P] Verify all cross-references between Chinese documents use correct `zh/` relative paths
- [x] T072 [P] Verify each Chinese document references at least one constitutional principle (I–V)
- [x] T073 [P] Verify terminology consistency across all 7 Chinese documents (all terms match glossary and IPD fusion guide)
- [x] T074 [P] Verify all English original links point to correct files in parent directory
