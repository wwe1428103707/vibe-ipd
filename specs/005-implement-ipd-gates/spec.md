# Feature Specification: Implement Remaining IPD Gate Checks

**Feature Branch**: `005-implement-ipd-gates`

**Created**: 2026-06-06

**Status**: Draft

**Input**: User description: "基于命令与模板改造指南，对项目中剩余命令进行实际IPD门禁改造"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - TR1 Gate in specify & clarify (Priority: P1)

As a PDT manager, I need `/vipd-speckit-specify` and `/vipd-speckit-clarify`
to enforce TR1 gate pre-flight checks (verify constitution exists with Gate
Criteria Reference), so that no spec is created without IPD governance readiness.

**Independent Test**: Running `/vipd-speckit-specify` without a constitution
produces a clear TR0-failed warning and refuses to proceed in IPD mode.

**Acceptance Scenarios**:

1. **Given** a project in IPD mode with no constitution, **When** a user runs
   `/vipd-speckit-specify`, **Then** the command MUST warn that TR0 has not
   been passed and ask for confirmation before proceeding.
2. **Given** a project in IPD mode during `/vipd-speckit-clarify`, **When**
   clarifications complete, **Then** a risk assessment summary MUST be generated
   as TR1 gate evidence.

---

### User Story 2 - TR2/TR4 Gate in checklist & tasks (Priority: P1)

As a PDT manager, I need `/vipd-speckit-checklist` to enforce TR2 (spec must
exist with TR Gate Assessment) and `/vipd-speckit-tasks` to enforce TR4
(plan must exist with Gate Readiness section) before proceeding.

**Independent Test**: Running `/vipd-speckit-tasks` without a plan containing
"Gate Readiness" produces a clear TR2/TR3 gate-block warning in IPD mode.

**Acceptance Scenarios**:

1. **Given** a spec without "TR Gate Assessment" section, **When** a user runs
   `/vipd-speckit-checklist`, **Then** the command MUST display unmet TR1 criteria.
2. **Given** a plan without "Gate Readiness" section, **When** a user runs
   `/vipd-speckit-tasks`, **Then** the command MUST display unmet TR2/TR3 criteria.

---

### User Story 3 - TR4/TR4A Gate in implement (Priority: P2)

As a PDT manager, I need `/vipd-speckit-implement` to enforce TR4 gate
(tasks must exist with Gate Completion Verification) and generate TR4A
quality evidence post-execution.

**Independent Test**: Running `/vipd-speckit-implement` without completed tasks
produces a TR4 gate warning.

**Acceptance Scenarios**:

1. **Given** tasks without "Gate Completion Verification", **When** implement
   runs in IPD mode, **Then** warn about missing gate checkpoints.
2. **Given** implementation completes in IPD mode, **When** finished,
   **Then** a TR4A quality summary is generated.

### Edge Cases

- What if IPD mode is not active (no Gate Criteria Reference in constitution)?
  All gate checks skip silently. (Handled by IPD detection logic.)
- What if a skill file is invoked via old `speckit-*` name?
  Wrapper redirects to `vipd-speckit-*` which has the gate checks.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `/vipd-speckit-specify` MUST add TR1 pre-flight gate check
  (constitution exists + Gate Criteria Reference section) before spec creation.
- **FR-002**: `/vipd-speckit-clarify` MUST add TR1 post-execution risk
  assessment generation as gate evidence.
- **FR-003**: `/vipd-speckit-checklist` MUST add TR2 pre-flight gate check
  (spec exists + TR Gate Assessment section).
- **FR-004**: `/vipd-speckit-tasks` MUST add TR4 pre-flight gate check
  (plan exists + Gate Readiness section).
- **FR-005**: `/vipd-speckit-implement` MUST add TR4/TR4A gate checks
  (tasks exist + Gate Completion Verification) and post-execution quality report.
- **FR-006**: All gate checks MUST follow the same IPD detection pattern
  (constitution-based) and deep content validation from already-modified skills.

### Key Entities

- **5 VIPD Skill Files** to modify: `vipd-speckit-specify`, `vipd-speckit-clarify`,
  `vipd-speckit-checklist`, `vipd-speckit-tasks`, `vipd-speckit-implement`
- **3 Already-Modified Skills** to verify: `vipd-speckit-constitution`,
  `vipd-speckit-plan`, `vipd-speckit-analyze`

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 8 VIPD command skills (constitution, specify, clarify,
  checklist, plan, tasks, implement, analyze) have consistent IPD gate
  pre-flight checks following the same pattern.
- **SC-002**: All gate checks share the same IPD detection logic
  (constitution-based) and deep content validation approach.

## Assumptions

- The IPD gate check pattern from already-modified skills
  (constitution, plan, analyze) serves as the template for new modifications.
- The `vipd-speckit-*` skill files are the ones to modify (not the
  `speckit-*` wrappers).
- No new commands or templates are needed — only modifications to existing
  5 skill files.
