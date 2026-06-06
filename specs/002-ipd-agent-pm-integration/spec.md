# Feature Specification: IPD Agent-Driven Project Management Integration

**Feature Branch**: `002-ipd-agent-pm-integration`

**Created**: 2026-06-06

**Status**: Draft

**Input**: User description: "针对工具集成蓝图文件，需要对文档进行修改，考虑直接在项目中集成，使用Agents配合文档结构进行项目管理"

## Clarifications

### Session 2026-06-06

- Q: What scope of "integration" does the user intend — modifying the existing English/Chinese blueprint documents to include agent-driven project management, or creating new agent skill files that implement the blueprint's guidance? → A: Both — modify the existing blueprint documents to incorporate agent-driven PM workflows, AND create new Spec Kit agent skill/command configurations that implement the blueprint's automation rules within the project.
- Q: Should gate enforcement be simple file-existence checks or deep content validation? → A: Deep content validation — verify that each required document contains the specific IPD gate criteria sections (e.g., constitution must have all 5 principles + Gate Criteria Reference for TR0).
- Q: How does the system detect IPD mode vs SDD-only mode? → A: Constitution-based detection — check if the constitution contains a "Gate Criteria Reference" section. No extra config file needed.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Agent Skill Commands for TR Gate Enforcement (Priority: P1)

As a PDT manager using Spec Kit, I need the existing `/speckit-*` commands to
automatically enforce IPD Technology Review (TR) gate readiness checks before
allowing progression to the next phase, so that gate discipline is "baked in"
rather than relying on manual process compliance.

**Why this priority**: The Tooling Integration Blueprint currently describes external
platform configuration (Jira). Agent skill integration is the Spec Kit-native way
to enforce gates, making it immediately usable by any project without external tooling.

**Independent Test**: Running `/speckit-plan` on a project without a ratified
constitution (TR0 not passed) produces a clear gate-block warning and refuses to
proceed with planning.

**Acceptance Scenarios**:

1. **Given** a project without a ratified constitution, **When** a user runs
   `/speckit-specify`, **Then** the command MUST warn that TR0 (project setup)
   has not been passed and ask for confirmation before proceeding.
2. **Given** a project with TR1 readiness criteria unmet, **When** a user runs
   `/speckit-plan`, **Then** the command MUST display specific unmet TR1 criteria
   and offer to generate a readiness checklist.
3. **Given** a project with all prior gates passed, **When** a user runs
   `/speckit-implement`, **Then** the command proceeds normally without gate
   warnings.

---

### User Story 2 - IPD-Aware Constitution Template (Priority: P1)

As a project maintainer setting up a new IPD-enhanced project, I need the
constitution template to include IPD gate criteria sections (Must-Meet /
Should-Meet per TR gate) so that every new project automatically inherits
the Agile-Stage-Gate governance structure.

**Why this priority**: The constitution is the first document created in any
Spec Kit project. Without IPD-aware constitution sections, no gate enforcement
can work — this is the foundation.

**Independent Test**: Running `/speckit-constitution` on a new project produces
a constitution that includes sections for Agile-Stage-Gate governance,
tooling requirements, and TR gate criteria, in addition to the existing
5 core principles.

**Acceptance Scenarios**:

1. **Given** a new project with no constitution, **When** `/speckit-constitution`
   is run with IPD principles, **Then** the resulting constitution MUST contain
   a "Gate Criteria Reference" section listing Must-Meet and Should-Meet
   definitions for each TR gate (TR1–TR6).
2. **Given** an existing SDD-only constitution, **When** `/speckit-constitution`
   is run again with IPD additions, **Then** the updated constitution MUST
   remain backward-compatible with existing specs, plans, and tasks.

---

### User Story 3 - IPD-Aware Spec & Plan Template Sections (Priority: P2)

As an AI coding agent working on an IPD-enhanced project, I need the spec and
plan templates to include IPD-specific sections (TR gate assessment, risk register,
WSJF scoring, DoD definition) so that every new feature specification and plan
automatically captures gate-relevant information.

**Why this priority**: Templates are the结构性骨架，是每个新功能规格和计划的基础。一旦宪法和命令有了门径感知，模板需要跟上才能让门径信息贯穿整个工作流。

**Independent Test**: Creating a new spec with `/speckit-specify` on an
IPD-enhanced project produces a spec that contains a "TR Gate Assessment"
section and risk register, matching the template redesign guide's specifications.

**Acceptance Scenarios**:

1. **Given** an IPD-enhanced project, **When** `/speckit-specify` creates a new
   feature spec, **Then** the spec template MUST include a "TR Gate Assessment"
   section identifying which TR gates apply to this feature.
2. **Given** an IPD-enhanced project, **When** `/speckit-plan` creates a new
   implementation plan, **Then** the plan template MUST include a "Gate Readiness"
   section and "WSJF Priority Score" field.

### Edge Cases

- What happens when a user tries to skip a TR gate by manually editing the
  constitution to remove gate criteria?
- How should the agent handle projects that want to use only SDD (no IPD) —
  should gate checks be optional/skippable?
- What if an agent is running in an environment without Jira/external tooling —
  should the gate enforcement still work based on document state alone?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The updated Tooling Integration Blueprint MUST include a section on
  Spec Kit agent skill integration, describing how each `/speckit-*` command
  adds TR gate pre-flight checks and post-execution gate evidence generation.
- **FR-002**: Each command's gate integration MUST follow the TR mapping defined
  in the Command & Template Redesign Guide (TR0 for constitution, TR1 for
  specify/clarify, etc.).
- **FR-003**: The constitution template MUST be updated to include IPD gate
  criteria sections: Agile-Stage-Gate Governance principle, Tooling & Platform
  Requirements section, and a Gate Criteria Reference appendix.
- **FR-004**: The spec template MUST be updated to include TR Gate Assessment
  and Risk Register sections as optional IPD additions.
- **FR-005**: The plan template MUST be updated to include Gate Readiness and
  WSJF Priority Score sections as IPD additions.
- **FR-006**: The tasks template MUST be updated to include Gate Completion
  Verification checkpoints at each phase boundary.
- **FR-007**: All template updates MUST be backward-compatible — existing
  projects without IPD MUST continue to work without gate warnings.
- **FR-008**: The Blueprint MUST describe how gate enforcement works in two
  modes: (a) document-state mode (check files in repo) and (b) Jira-integrated
  mode (check external platform status).
- **FR-009**: New or updated agent skill files MUST be created/modified in
  `.claude/skills/` to implement the gate pre-flight checks described in the
  Command & Template Redesign Guide.
- **FR-010**: A new `/speckit-analyze` gate compliance check MUST be added that
  verifies all TR gate evidence exists for the current project phase.
- **FR-011**: The Chinese translation of the Blueprint MUST be updated to
  reflect all changes made to the English version.

### Key Entities

- **Gate-Aware Command Integrations**: Modifications to 7 existing SDD skill files
  that add TR gate pre-flight checks and post-execution evidence generation.
- **IPD-Enhanced Templates**: Updated constitution, spec, plan, and tasks
  templates with new IPD-aligned sections.
- **Gate Compliance Analyzer**: An enhancement to `/speckit-analyze` that
  checks TR gate evidence completeness.
- **Updated Tooling Integration Blueprint**: The existing blueprint document
  with an added section on Spec Kit agent integration.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A PDT manager can run any `/speckit-*` command on an IPD-enhanced
  project and receive appropriate gate status feedback (pass/warn/block) without
  needing external tooling.
- **SC-002**: A project maintainer can create a new IPD-enhanced project
  constitution using `/speckit-constitution` that includes all gate criteria
  sections in under 10 minutes.
- **SC-003**: An existing SDD-only project continues to function identically
  with no gate warnings when upgraded to the latest toolkit version.
- **SC-004**: All 7 commands and 4 templates covered in the Command & Template
  Redesign Guide are implemented as agent skill modifications.
- **SC-005**: The updated Blueprint documents (English and Chinese) correctly
  describe both document-state and Jira-integrated gate enforcement modes.

## Assumptions

- Gate enforcement in "document-state mode" uses **deep content validation**:
  checks verify that each required document contains the specific IPD gate
  criteria sections, not just that the file exists.
- IPD-mode detection is **constitution-based**: if the constitution has a
  "Gate Criteria Reference" section, gate checks are active. Otherwise,
  commands behave as standard SDD-only mode (no gate warnings).
- Projects that do not opt into IPD governance will see no gate warnings —
  the IPD additions are purely additive and backward-compatible.
- The agent skill modifications are implemented as updates to existing skill
  files in `.claude/skills/`, not as new separate commands.
- Jira integration in "Jira-integrated mode" requires the project to have
  Jira Cloud Premium or equivalent — the blueprint already documents this.
- This feature covers both modifying the existing blueprint documents AND
  creating/modifying the agent skill files that implement the described behavior.
- The Chinese translation of the Blueprint will be updated to match the
  English version's additions.