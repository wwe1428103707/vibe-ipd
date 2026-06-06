<!--
  Sync Impact Report
  ===================
  Version change: 1.1.0 → 1.2.0
  Bump rationale: PATCH — command reference cleanup to reflect completed
  vipd- prefix migration (004) and remaining IPD gate implementation (005).
  
  Modified sections:
    - Development Workflow — all 5 command references use /vipd-speckit-* format
      (fixed mixed dot-notation and hyphens from v1.1.0)
    - Compliance & Review — /speckit.analyze → /vipd-speckit-analyze
  
  Follow-up TODOs: (none)
-->

# Spec Kit Constitution

## Core Principles

### I. Spec-First, Intent-Driven Development (SDD Core)

The specification is the single source of truth. Before any code is written, the
*what* and *why* MUST be fully articulated as an executable specification. The
spec defines intent; code implements intent. IPD alignment: gates TR1–TR3
require spec completeness and feasibility validation as prerequisites.

- MUST write a specification before planning or implementing any feature
- Spec MUST define intent (what & why), deferring technology choices (how) to
  the plan phase
- Every spec MUST contain independently testable user stories with acceptance
  criteria
- Specs are living artifacts — refined iteratively through the discovery track,
  not frozen before development begins

**Rationale**: Prevents wasted implementation effort, ensures shared
understanding, and aligns with IPD's concept-phase feasibility validation (TR1).

### II. Dual-Track Agile: Discovery & Delivery

The Product Trio (PO/Product Manager, System Architect, UX Designer) operates a
continuous discovery track parallel to the delivery track. Discovery validates
desirability, feasibility, and viability before committing development.
Delivery executes confirmed features through iterative sprints.

- Discovery track MUST validate each feature against user need, technical
  feasibility, and business viability before it enters the delivery backlog
- Product Trio MUST collaborate on all pre-development spikes, prototypes, and
  mockups
- Delivery track MUST operate in timeboxed iterations (Sprints) of 2–4 weeks
- Each delivery sprint MUST produce a potentially shippable increment
- Low-fidelity prototypes and technical spikes are preferred over
  full-spec-up-front in the discovery track

**Rationale**: Dual-track prevents "build it and they will come" waste, ensuring
delivery resources are spent only on validated, high-confidence work.

### III. Agile-Stage-Gate Governance

IPD's stage-gate (TR1–TR6) framework provides the macro governance rhythm,
while Agile methods (Scrum/Kanban) govern micro execution within each stage.
This ensures strategic alignment without sacrificing delivery velocity.

- MUST define Technology Review (TR) gates at each major phase boundary:
  TR1 (Concept), TR2/TR3 (Plan), TR4/TR4A (Development), TR5 (Validation),
  TR6 (Launch)
- Each gate MUST apply Must-Meet (red-line veto) and Should-Meet (scorecard)
  criteria — both MUST be documented before the gate review
- Within each stage, teams MAY use Scrum, Kanban, or any Agile method for
  execution
- No feature MAY transition to the next stage without passing its current
  stage gate
- Gate decisions MUST be explicitly one of: Go / Kill / Hold / Recycle — no
  implicit default

**Rationale**: Prevents the "agile without discipline" trap while maintaining
the flexibility and responsiveness that makes Agile effective.

### IV. Cross-Functional PDT with Autonomous Feature Teams

The Product Development Team (PDT) is organized as a full-function,
cross-functional unit mapped to Agile roles. Within a sprint, feature teams
operate with full autonomy over how they deliver assigned work, while the PDT
manager handles cross-team coordination and dependency management.

- PDT MUST include all necessary competencies: product, architecture,
  development, testing, and operations
- Role mapping MUST be explicit:
  - LPDT → Release Train Engineer (RTE)
  - Product Manager → Product Owner (PO)
  - Development Lead → System Architect
  - Test Lead → QA Lead
  - Operations Lead → DevOps Lead
- Feature teams MUST be self-organizing within sprint boundaries
- Cross-team dependencies MUST be visualized and managed via a shared roadmap
  (e.g., Jira Advanced Roadmaps) with automatic conflict detection
- CBB (Common Building Block) reuse MUST be preferred over bespoke solutions
- Team capacity (Velocity/Capacity) MUST be measured and used for sprint
  planning, not estimates based on opinion

**Rationale**: Cross-functional autonomy removes handoff delays; explicit role
mapping avoids responsibility gaps in the IPD-to-Agile translation.

### V. Quality Built-In with Automated Gate Verification

Quality is not inspected at the end — it is engineered into every step. All
quality gates MUST be automated where feasible, and gate passage MUST be
verifiable by data, not subjective opinion.

- MUST enforce shift-left testing: unit tests during development, integration
  tests during feature completion, system tests at release candidates
- Definition of Done (DoD) MUST include at minimum:
  - Static analysis passed with no unaddressed critical issues
  - Unit test coverage meeting the project-defined threshold
  - API documentation updated
  - Security scan passed with no high-severity findings
- CI/CD pipeline MUST automatically enforce DoD checks before merge
- Must-Meet criteria at every TR gate MUST have automated verification where
  technically feasible
- WSJF (Weighted Shortest Job First) MUST be used for backlog prioritization —
  data-driven, not opinion-driven

**Rationale**: In IPD's gated model, subjective gates create bottlenecks.
Automation ensures rigor without slowing delivery, aligning IPD governance with
Agile's continuous delivery ethos.

## Tooling & Platform Requirements

The Agile-Stage-Gate model is enforced primarily through **Spec Kit's native
document-state mode** — AI agent commands perform pre-flight TR gate checks
against the project's own documentation (constitution, spec, plan, tasks).
No external platform is required for core gate enforcement.

- IPD mode is activated automatically when the constitution contains a
  "Gate Criteria Reference" section — no configuration file needed
- Each `/vipd-speckit-*` command performs deep content validation before proceeding,
  ensuring prior TR gate criteria are satisfied
- All artifacts (specs, plans, contracts, test reports) MUST be
  version-controlled alongside code in the repository
- Cross-team dependencies SHOULD be tracked via document cross-references
  (document-state mode) or via an external project management platform if
  available

For teams that require external platform integration (e.g., Jira Cloud
Premium), the platform SHOULD support a multi-level issue hierarchy:
Initiative → Feature → Story → Sub-Task, and automation rules SHOULD
enforce gate transitions consistent with the constitution's criteria.

## Development Workflow (Agile-Stage-Gate Process)

The end-to-end workflow integrates SDD commands with IPD gate reviews. Each row
represents a phase that MUST complete its SDD steps AND pass the corresponding
TR gate before the next phase begins.

| Phase | SDD Commands | IPD Gate | Key Deliverables |
|-------|-------------|----------|-----------------|
| **Concept** | `/vipd-speckit-constitution` → `/vipd-speckit-specify` → `/vipd-speckit-clarify` | TR1 | Constitution, Feature Spec, Feasibility Prototype, OR Log |
| **Plan** | `/vipd-speckit-checklist` → `/vipd-speckit-plan` | TR2/TR3 | Architecture Design, Data Model, API Contracts, Research Doc |
| **Development** | `/vipd-speckit-tasks` → `/vipd-speckit-implement` | TR4/TR4A | Working Software, Automated Tests, CI Quality Reports |
| **Validation** | `/vipd-speckit-analyze` (cross-artifact review) | TR5 | Full Test Report, Beta Feedback, Performance Validation |
| **Launch** | Release automation & deployment | TR6 | Release Notes, Deployment Verification, Ops Handover |
| **Lifecycle** | PCR management & maintenance | Ongoing | Change Logs, Monitoring Dashboards, EOL Plan |

## Gate Criteria Reference

This section defines the Must-Meet and Should-Meet criteria for each TR gate.
The presence of this section activates IPD mode in Spec Kit commands.

| TR Gate | Phase | Must-Meet (Veto) | Should-Meet (Scorecard) |
|---------|-------|------------------|------------------------|
| TR1 | Concept | Spec created with user stories, feasibility assessed | Market attractiveness > 8/10 |
| TR2/TR3 | Plan | Architecture reviewed, dependencies locked | Effort variance < 15% |
| TR4 | Development | DoD defined, CI configured | Velocity variance < 15% |
| TR5 | Validation | Blocker/critical bugs = 0 | Beta NPS >= 8 |
| TR6 | Launch | Deployment verified, ops handover complete | Training pass rate = 100% |

## Governance

The Constitution is the supreme guiding document for all project decisions. It
supersedes all other practices, methodologies, and conventions.

### Amendment Procedure

1. **Proposal**: Submit a GitHub Issue or Pull Request specifying the exact
   change to the constitution text.
2. **Justification**: The proposal MUST include rationale, impact analysis, and
   migration plan (if applicable).
3. **Review**: At least one qualified reviewer not involved in the proposal
   MUST review the amendment.
4. **Approval**: Majority consensus from PDT core members is required.
5. **Versioning**: After approval, the constitution version MUST be bumped
   according to the policy below.

### Versioning Policy

- **MAJOR**: Backward-incompatible governance changes, principle removals, or
  principle redefinitions.
- **MINOR**: New principle added, materially expanded guidance, or a new
  section added.
- **PATCH**: Clarifications, wording improvements, typo fixes, non-semantic
  refinements.

### Compliance & Review

- Every implementation plan MUST include a Constitution Check gate (see
  plan-template.md) that verifies alignment with all five principles before
  Phase 0 research begins and again after Phase 1 design.
- Cross-artifact consistency MUST be verified before implementation via
  `/vipd-speckit-analyze`.
- All PRs and code reviews MUST verify compliance with constitutional
  principles.
- Any complexity that appears to violate the simplicity ethos MUST be
  explicitly justified in the Complexity Tracking section of the plan.
- The constitution MUST be reviewed at least once per major release cycle for
  continued relevance.

**Version**: 1.2.0 | **Ratified**: 2026-06-06 | **Last Amended**: 2026-06-06
