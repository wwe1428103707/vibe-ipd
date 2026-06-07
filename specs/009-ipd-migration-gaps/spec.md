# Feature Specification: IPD Migration Functional Gaps — Remnant Issues Inventory

**Feature Branch**: `009-ipd-migration-gaps`

**Created**: 2026-06-07

**Status**: Draft

**Input**: User description: "请根据code graph和项目内容，检查还有哪些内容需要进行迁移改造，主要不是名称的重命名，而是功能上的改造，看哪些地方还缺少IPD的适应性修改，请生成一份遗留问题清单。"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Gate Lifecycle Completeness (Priority: P1)

As a PDT manager (LPDT role), I need all six TR gates (TR0–TR6) to be enforceable through the toolchain so that I can track a feature from concept through launch with full gate coverage. Currently, TR6 (Launch gate) cannot be validated or recorded — the gate system ends at TR5, leaving the launch phase ungoverned.

**Why this priority**: Without TR6, the IPD lifecycle is incomplete. No feature can be formally cleared for production deployment, violating Principle III (Agile-Stage-Gate Governance) which mandates "No feature MAY transition to the next stage without passing its current stage gate."

**Independent Test**: Can be validated by running `gate-check.ps1 -Gate TR6` and `gate-record.ps1 -Gate TR6` and verifying they succeed. Also verify that the Product Trio review template includes TR6 criteria.

**Acceptance Scenarios**:

1. **Given** a feature with all prior gates (TR0–TR5) passed, **When** the LPDT runs gate validation for TR6, **Then** the system checks deployment verification and ops handover evidence and records the result in gate-status.json
2. **Given** a feature without TR5 passed, **When** the LPDT attempts TR6 validation, **Then** the system rejects the request and lists TR5 as a prerequisite that has not passed
3. **Given** the constitution Gate Criteria Reference table, **When** a gate check runs for any TR gate, **Then** it validates both Must-Meet and Should-Meet criteria, not just section header existence

---

### User Story 2 - Gate Depth of Validation (Priority: P1)

As a PDT quality lead, I need gate checks to validate substantive content — not just the existence of section headers — so that passing a gate actually means the required artifacts are complete and correct. Currently, all gate checks (TR1–TR5) only verify that a document contains a section heading; none verify that the section contains substantive, criteria-matching content.

**Why this priority**: Superficial gate checks undermine IPD governance. The constitution defines specific Must-Meet criteria for each gate (e.g., TR1: "Spec created with user stories, feasibility assessed"), but the validation only checks for the string "TR Gate Assessment" in the spec file. This creates a false sense of compliance.

**Independent Test**: Can be tested by creating a spec.md with a "TR Gate Assessment" section containing only placeholder text. The current system passes TR1; the improved system should require at least one user story with acceptance criteria.

**Acceptance Scenarios**:

1. **Given** a spec.md with a "TR Gate Assessment" section but no user stories, **When** TR1 gate check runs, **Then** validation fails with specific feedback: "Spec must contain at least one user story with acceptance criteria"
2. **Given** a spec.md with user stories but no feasibility assessment, **When** TR1 gate check runs, **Then** validation reports a Must-Meet criterion gap and prompts the user to address it
3. **Given** Should-Meet criteria defined in the constitution, **When** any gate check runs, **Then** the system evaluates Should-Meet criteria and reports them as advisory (non-blocking) results alongside the Must-Meet pass/fail

---

### User Story 3 - Gate Enforcement Integration (Priority: P1)

As a product developer using the VIPD toolchain, I need command-level gate checks so that I cannot accidentally proceed to plan, tasks, or implementation before prior gates have passed. Currently, no Python CLI command or agent skill validates gate status before executing — gates are only checked via PowerShell scripts that are never invoked by the application layer.

**Why this priority**: The constitution mandates "Each `/vipd-speckit-*` command performs deep content validation before proceeding, ensuring prior TR gate criteria are satisfied," but this is not implemented anywhere in the actual command execution path. This is the most fundamental gap between IPD governance intent and toolchain reality.

**Independent Test**: Can be tested by running any vipd command without having passed the prerequisite gate, and verifying that the command warns or blocks execution.

**Acceptance Scenarios**:

1. **Given** a feature where TR1 has not been recorded as passed, **When** the user runs `vipd-plan`, **Then** the system detects the missing gate passage and prompts: "TR1 gate has not been passed. Proceed anyway? (yes/no)"
2. **Given** a feature where all prior gates have passed, **When** the user runs `vipd-tasks`, **Then** the command proceeds without gate warnings
3. **Given** gate-status.json does not exist for a feature, **When** any vipd command runs, **Then** the system initializes gate-status.json with all gates set to "pending" and continues with the appropriate gate check

---

### User Story 4 - SW E2E Integration (Priority: P2)

As a software architect, I need the workflow engine and Python CLI to be IPD-aware so that gate validation occurs at every phase transition, not just in standalone scripts. Currently, the workflow engine's gate step (`GatewayStep`) is a generic human-approval gate with no IPD criteria, and no Python module references gate scripts at all.

**Why this priority**: The workflow engine and CLI are the primary execution paths. Without integration, gate checks are invisible to automated workflows and developer tooling, making IPD governance optional rather than mandatory.

**Independent Test**: Can be tested by running a VIPD workflow end-to-end and verifying that each phase transition triggers an appropriate gate check via the workflow engine.

**Acceptance Scenarios**:

1. **Given** an IPD-mode project with an active workflow, **When** the workflow reaches a gate step, **Then** the gate step invokes gate-check.ps1 (or equivalent) and validates the appropriate TR gate criteria
2. **Given** the `specify check` CLI command, **When** run in an IPD-mode project, **Then** it reports gate status for the current feature (which gates have passed, which are pending)
3. **Given** the workflow engine, **When** IPD mode is active, **Then** gate decisions use IPD-specific outcomes (Go/Kill/Hold/Recycle) rather than generic approve/reject

---

### User Story 5 - Product Trio Review Enforcement (Priority: P2)

As a product owner, I need the concept phase (TR1) to require a Product Trio review verdict as gate evidence, so that desirability, feasibility, and viability are formally validated before committing delivery resources. Currently, TR1 evidence is just a risk level and open risk count — there is no check that the Product Trio (PO + Architect + UX) has completed their assessment.

**Why this priority**: Principle II (Dual-Track Agile) requires Product Trio validation before features enter delivery. Without Trio enforcement, concept-phase features can skip discovery validation, violating the core IPD principle.

**Independent Test**: Can be tested by running `vipd-specify` or `vipd-clarify` and verifying that the TR1 gate evidence includes a Product Trio verdict section.

**Acceptance Scenarios**:

1. **Given** a feature spec in IPD mode, **When** TR1 gate evidence is generated, **Then** the evidence includes a Product Trio verdict (Go/Kill/Hold/Recycle) from each perspective (Desirability/Feasibility/Viability)
2. **Given** a feature spec without a Trio review, **When** the `vipd-clarify` command completes, **Then** the system marks TR1 as conditionally passed and notes that Product Trio review is still required
3. **Given** the Trio review template, **When** used in a TR1 gate check, **Then** it includes structured assessment fields for all three perspectives with scoring rubrics

---

### User Story 6 - CBB Reuse and WSJF Prioritization (Priority: P2)

As a Product Owner managing the backlog, I need the toolchain to support WSJF-based prioritization and CBB (Common Building Block) reuse assessment so that delivery resources are allocated using data-driven methods as required by Principles IV and V. Currently, WSJF scores are manually written by the AI with no calculation framework, and there is no CBB catalog or reuse check.

**Why this priority**: WSJF (Weighted Shortest Job First) is mandated by Principle V and CBB reuse is mandated by Principle IV. Without toolchain support, these are aspirational rather than operational practices.

**Independent Test**: Can be tested by creating a plan with a CBB reuse assessment section and verifying that WSJF scores follow the standard formula (Value + Time Criticality + Risk Reduction) / Job Size).

**Acceptance Scenarios**:

1. **Given** a feature in the planning phase, **When** the PO generates a plan, **Then** the plan includes a structured WSJF scoring section with Value, Time Criticality, Risk Reduction, and Job Size dimensions
2. **Given** an existing CBB catalog, **When** the architect assesses a new feature plan, **Then** the plan includes a CBB reuse assessment that references existing building blocks
3. **Given** no CBB catalog exists, **When** VIPD initializes a project, **Then** it creates a `.specify/memory/cbb-catalog.md` template for the team to populate

---

### User Story 7 - Agent-Assignment IPD Role Awareness (Priority: P2)

As a development lead assigning tasks to agents, I need the assignment skill to understand IPD PDT roles so that test tasks go to QA Lead agents, architecture tasks go to Architect agents, and assignments respect the RACI matrix. Currently, the generic assignment skill (`vipd-agent-assign-assign`) matches by file patterns only, with no IPD role context.

**Why this priority**: IPD's cross-functional PDT model (Principle IV) requires role-appropriate task assignment. Without it, tasks may be assigned to agents that lack the correct decision authority or competency, reducing delivery quality.

**Independent Test**: Can be tested by running `vipd-agent-assign-assign` on a tasks.md with explicitly tagged test/architecture tasks and verifying that assignments match PDT roles.

**Acceptance Scenarios**:

1. **Given** a tasks.md with tasks tagged by role (e.g., `[QA]`, `[Architecture]`, `[DevOps]`), **When** agent assignment runs, **Then** tasks are assigned to the corresponding IPD role agents
2. **Given** an IPD-mode project with multiple available agents, **When** agent assignment runs, **Then** it checks the RACI matrix and prevents assigning Responsible work to an Informed-only role
3. **Given** a small team using the `lpdt-po` combined role, **When** agent assignment runs, **Then** the combined role agent receives tasks for both LPDT and PO responsibilities

---

### User Story 8 - Gate Compliance Reporting and Dashboard (Priority: P3)

As a PDT manager, I need a single view of gate compliance across all features so that I can see which features are on track and which have gates that need attention. Currently, gate-status.json tracks per-gate status but no skill or command reads and reports this information in a human-readable format.

**Why this priority**: The constitution requires "persistent evidence of TR gate progression across the project lifecycle," but without a reporting mechanism, this evidence is buried in JSON and not accessible for decision-making.

**Independent Test**: Can be tested by running `vipd-analyze` in IPD mode and verifying that the output includes a gate compliance summary table.

**Acceptance Scenarios**:

1. **Given** a project with multiple features in gate-status.json, **When** `vipd-analyze` runs in IPD mode, **Then** the analysis report includes a Gate Status Summary section showing each TR gate, its status, and evidence summary
2. **Given** a feature where TR2_TR3 is pending, **When** the analysis report is generated, **Then** the report highlights TR2_TR3 as a blocker for the development phase and recommends running `vipd-checklist` to prepare
3. **Given** gate-status.json with all gates passed for a feature, **When** the analysis report is generated, **Then** the feature is marked as "Launch Ready" with the date of TR5 passage

---

### User Story 9 - Documentation and Template IPD Completeness (Priority: P3)

As a new team member onboarding to VIPD, I need the README, templates, and documentation to reflect the IPD-enhanced workflow so that I understand the full lifecycle from concept to launch. Currently, the README describes only Speckit/SSDD workflow, several templates lack IPD sections, and the main docs site is Speckit-oriented.

**Why this priority**: Onboarding and daily reference depend on accurate documentation. Speckit-only documentation creates confusion about which workflow to follow and which commands to use.

**Independent Test**: Can be tested by reading README.md and verifying that it describes the IPD lifecycle, TR gates, and vipd-speckit-* commands.

**Acceptance Scenarios**:

1. **Given** the project README, **When** a new team member reads it, **Then** they see a description of the Agile-Stage-Gate workflow, TR gates, PDT roles, and vipd-speckit-* commands — not just Speckit/SSDD
2. **Given** the checklist template, **When** used in IPD mode, **Then** it includes gate readiness checks and role verification sections
3. **Given** the tasks template, **When** used in IPD mode, **Then** it includes RACI annotations per task, IPD quality gate checkpoints per phase, and mandatory (non-optional) testing tasks

---

### Clarifications

### Session 2026-06-07

- Q: 关卡检查失败时应如何处理？ → A: 硬关卡 — 关卡检查未通过时完全阻止命令执行，必须先通过关卡才能继续
- Q: gate-status.json 多特性隔离模型？ → B: 每特性子目录 — gate-status.json 移入 specs/NNN-feature-name/，每个特性有独立的状态文件
- Q: Python CLI 关卡集成架构？ → B: Python 子进程调用 — 遵循 SpecKit 现有模式，通过 subprocess 调用 PS1/Bash 关卡脚本并解析 JSON 输出，不在 Python 中重写关卡逻辑

## Edge Cases

- What happens when gate-status.json is corrupted or contains invalid JSON? The system should handle this gracefully and reinitialize.
- What happens when a user runs `vipd-implement` in a non-IPD-mode project? The system should skip gate checks and proceed normally (dual-mode support).
- What happens when two features share the same gate-status.json? Each feature has its own `specs/NNN-feature-name/gate-status.json` file, so this is not possible — features are automatically isolated by directory structure.
- What happens when a gate is recorded as "passed" but the underlying artifacts are later modified? The gate status MUST be invalidated (set to "pending") and the user MUST re-run the gate check before proceeding to the next phase.

**Gate enforcement model (hard gate)**: When a gate check fails, the command MUST be blocked entirely — the user cannot proceed to the next phase until the prior gate has passed. This aligns with Constitution Principle III: "No feature MAY transition to the next stage without passing its current stage gate." There is no bypass mechanism; Go/Kill/Hold/Recycle decisions are made at gate review time, not as override options when a gate fails. If a project legitimately needs to skip a gate, the constitution must be amended first.

## TR Gate Assessment *(IPD only)*

- **Applicable TR gates**: TR1–TR6 (concept through launch)
- **Risk Level**: Medium — the gaps are well-defined and most can be addressed incrementally without architectural changes
- **Gate Evidence Required**:
  - TR1: Spec with all gaps documented and prioritized; feasibility assessment of remediation effort
  - TR2/TR3: Architecture plan showing how gaps will be addressed in phases; dependency analysis
  - TR5: Validation that each gap remediation is tested and verified

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The gate system MUST support all six TR gates (TR0–TR6) including validation and recording, matching the constitution's Gate Criteria Reference table
- **FR-002**: Each gate check MUST validate substantive Must-Meet criteria content, not just section header existence — at minimum verifying that key artifact sections contain recognizable content patterns (user stories, acceptance criteria, architecture decisions, etc.)
- **FR-003**: Each gate check MUST evaluate and report Should-Meet criteria as non-blocking advisory results alongside Must-Meet pass/fail
- **FR-003a**: Gate enforcement MUST use a hard gate model — when a gate check fails (Must-Meet criteria not met), the command MUST be blocked entirely with a clear error message identifying which criteria failed and what artifacts need to be completed. No bypass or override mechanism is provided. If a project requires gate skipping, the constitution must be amended first.
- **FR-003b**: When artifacts underlying a passed gate are modified, the gate status MUST be automatically invalidated (reset to "pending") and the user MUST re-run the gate check before proceeding to the next phase
- **FR-004**: The Python CLI layer MUST invoke gate checks before proceeding with phase-specific commands (`vipd-plan`, `vipd-tasks`, `vipd-implement`, `vipd-analyze`), reading gate status from the feature's own `specs/NNN-feature-name/gate-status.json`. Integration follows the SpecKit subprocess pattern — calling PS1/Bash gate scripts via `subprocess.run()` and parsing JSON output
- **FR-005**: The workflow engine's `GatewayStep` MUST be extended to invoke PS1/Bash gate scripts via subprocess (following the SpecKit ShellStep pattern), validate IPD gate criteria, enforce role-based decision authority, and support Go/Kill/Hold/Recycle outcomes
- **FR-006**: TR1 gate evidence MUST include a Product Trio review verdict (Go/Kill/Hold/Recycle per perspective: Desirability, Feasibility, Viability)
- **FR-007**: A CBB catalog template MUST be created at `.specify/memory/cbb-catalog.md` and a CBB reuse assessment MUST be included in `vipd-plan` when IPD mode is active
- **FR-008**: WSJF scoring MUST be available as structured input in `vipd-plan` and `vipd-agent-assign-po`, with the standard formula (Value + Time Criticality + Risk Reduction) / Job Size
- **FR-009**: The `vipd-agent-assign-assign` skill MUST incorporate IPD PDT role awareness, preferring role-matched agents and respecting the RACI matrix
- **FR-010**: The `vipd-agent-assign-execute` skill MUST include TR4 gate validation before task execution, mirroring the gate check in `vipd-implement`
- **FR-011**: `vipd-analyze` MUST include a Gate Status Summary section in IPD mode, reading all feature-level `specs/*/gate-status.json` files and showing each TR gate status per feature
- **FR-012**: In IPD mode, the tasks template MUST make testing mandatory (not optional) per Principle V (Quality Built-In)
- **FR-013**: The `gate-record.ps1` script MUST prevent out-of-order gate recording (recording TR4 before TR1 is passed MUST fail)
- **FR-014**: The `gate-record.ps1` script MUST maintain an audit trail of gate status transitions, not overwrite previous statuses
- **FR-015**: README.md MUST describe the IPD-enhanced workflow, TR gates, PDT roles, and vipd-speckit-* commands
- **FR-016**: The checklist template MUST include IPD-specific sections (gate readiness, role verification) when used in IPD mode
- **FR-017**: The tasks template MUST include per-phase IPD quality gates and RACI annotations when used in IPD mode
- **FR-018**: Three agent-assign SKILL.md files (assign, execute, validate) MUST be renamed from `speckit-` to `vipd-` prefix in their frontmatter
- **FR-019**: The workflow directory MUST be migrated from `speckit` to `vipd` naming, and workflow command references MUST use `vipd.speckit.*` prefixes
- **FR-020**: The `gate-check.sh` Bash script MUST fix the double-invocation bug (lines 109-113) where each gate check function is called twice
- **FR-021**: Gate checks in Python scripts (`check-prerequisites.ps1`, `setup-plan.ps1`, `setup-tasks.ps1`) SHOULD validate that prior TR gates have passed before allowing phase entry
- **FR-022**: `vipd-taskstoissues` SHOULD validate TR4 gate before creating GitHub issues for committed work
- **FR-023**: The `vipd-agent-assign-lpdt` gate template SHOULD include concrete Must-Meet criteria from the constitution's Gate Criteria Reference table, not abstract placeholders
- **FR-024**: The `vipd-agent-assign-lpdt-po` skill SHOULD acknowledge the conflict of interest inherent in a combined LPDT+PO role and recommend mitigation strategies
- **FR-025**: IPD-mode gate decisions MUST use the Go/Kill/Hold/Recycle framework mandated by the constitution, not just pass/fail

### Key Entities

- **TR Gate**: A governance checkpoint at a phase boundary with Must-Meet (veto) and Should-Meet (scorecard) criteria, decided as Go/Kill/Hold/Recycle
- **Gate Status Record**: An entry in `specs/NNN-feature-name/gate-status.json` containing gate ID, status (pending/passed/failed/hold/recycled), evidence text, and timestamp. Each feature has its own independent gate status file within its spec directory.
- **Product Trio Review**: A structured assessment from three perspectives (Desirability, Feasibility, Viability) that produces a verdict for TR1 gate evidence
- **CBB Catalog**: A document listing existing Common Building Blocks available for reuse, stored at `.specify/memory/cbb-catalog.md`
- **WSJF Score**: A prioritization score calculated as (Value + Time Criticality + Risk Reduction) / Job Size, used for backlog ordering
- **PDT Role Mapping**: The explicit mapping of IPD roles (LPDT, PM, Dev Lead, Test Lead, Ops Lead) to Agile equivalents (RTE, PO, Architect, QA Lead, DevOps Lead)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All six TR gates (TR0–TR6) can be validated and recorded through the toolchain, with TR6 validating "Deployment verified, ops handover complete" as Must-Meet
- **SC-002**: Gate checks validate substantive content (at least 3 content patterns per gate) rather than just section header existence — a spec with only a "TR Gate Assessment" heading and no user stories fails TR1
- **SC-003**: Running any vipd command that requires a prior gate (plan, tasks, implement, analyze) without that gate passed results in a hard block with a clear error message identifying which criteria failed
- **SC-004**: The Product Trio review template is completed with verdicts from all three perspectives before TR1 can be recorded as passed
- **SC-005**: The `vipd-analyze` command in IPD mode produces a Gate Status Summary showing all TR gate statuses, with actionable recommendations for any gate not passed
- **SC-006**: A new team member reading only README.md can understand the IPD workflow, TR gates, PDT roles, and available commands within 5 minutes
- **SC-007**: Gate status transitions are auditable — every transition (including Hold and Recycle) is recorded with a timestamp and evidence summary
- **SC-008**: Out-of-order gate recording is blocked — attempting to record TR4 pass before TR1 results in an error message

## Assumptions

- The PowerShell and Bash gate scripts remain the canonical mechanism for gate validation; Python CLI integration follows the SpecKit pattern of subprocess invocation — calling PS1/Bash scripts via `subprocess.run()` and parsing their JSON output, consistent with how ShellStep and other integrations work in the existing codebase
- Gate status is tracked per feature in `specs/NNN-feature-name/gate-status.json`, replacing the current project-level `.specify/memory/gate-status.json`. The migration must preserve existing gate status data.
- CBB catalog will initially be a template that teams populate manually; automated CBB discovery is a future enhancement
- WSJF scoring will be a structured questionnaire/rubric in the skills, not a computational script — the AI fills in the scores based on team input
- The Product Trio review will be enforced as a gate evidence requirement rather than a blocking workflow step, to maintain flexibility for solo developers
- Gate depth of validation (FR-002, FR-003) will use regex-based content pattern matching to verify substantive section content, not AI-based semantic analysis
- Workflow naming migration (FR-019) will update references but maintain backward compatibility aliases for the `speckit` path
- Hard gate enforcement (FR-003a) means no override mechanism exists — if a gate fails, the command is blocked until artifacts are corrected and the gate is re-validated. This is a deliberate decision aligned with Constitution Principle III.

## Risk Register *(IPD only)*

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Deep gate validation may produce false negatives (rejecting valid but unconventional content patterns) | M | M | Use broad content patterns; allow override with explicit "proceed anyway" option |
| Product Trio enforcement may be too heavy for solo developers or small teams | M | H | Make Trio review a strong recommendation with override; use combined LPDT+PO role for small teams |
| CBB catalog may be empty or stale if teams don't maintain it | L | M | Provide a populated template with common patterns; auto-generate from code analysis in future |
| Gate ordering enforcement may feel restrictive for experienced teams | L | M | Hard gate model chosen — no override mechanism. If a project needs gate skipping, the constitution must be amended first |
| Migrating workflow naming may break existing CI/CD pipelines | H | L | Maintain backward-compatible aliases during transition; deprecate after one major version |