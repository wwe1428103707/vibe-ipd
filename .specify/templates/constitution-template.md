# [PROJECT_NAME] Constitution
<!-- Example: Spec Constitution, TaskFlow Constitution, etc. -->

## Core Principles

### [PRINCIPLE_1_NAME]
<!-- Example: I. Library-First -->
[PRINCIPLE_1_DESCRIPTION]
<!-- Example: Every feature starts as a standalone library; Libraries must be self-contained, independently testable, documented; Clear purpose required - no organizational-only libraries -->

### [PRINCIPLE_2_NAME]
<!-- Example: II. CLI Interface -->
[PRINCIPLE_2_DESCRIPTION]
<!-- Example: Every library exposes functionality via CLI; Text in/out protocol: stdin/args → stdout, errors → stderr; Support JSON + human-readable formats -->

### [PRINCIPLE_3_NAME]
<!-- Example: III. Test-First (NON-NEGOTIABLE) -->
[PRINCIPLE_3_DESCRIPTION]
<!-- Example: TDD mandatory: Tests written → User approved → Tests fail → Then implement; Red-Green-Refactor cycle strictly enforced -->

### [PRINCIPLE_4_NAME]
<!-- Example: IV. Integration Testing -->
[PRINCIPLE_4_DESCRIPTION]
<!-- Example: Focus areas requiring integration tests: New library contract tests, Contract changes, Inter-service communication, Shared schemas -->

### [PRINCIPLE_5_NAME]
<!-- Example: V. Observability, VI. Versioning & Breaking Changes, VII. Simplicity -->
[PRINCIPLE_5_DESCRIPTION]
<!-- Example: Text I/O ensures debuggability; Structured logging required; Or: MAJOR.MINOR.BUILD format; Or: Start simple, YAGNI principles -->

### VI. Agile-Stage-Gate Governance

A hybrid model combining IPD Technology Review (TR) gates for macro governance
with Agile methods for micro execution. Every phase MUST pass its TR gate
before the next phase begins.

- MUST define TR gates at phase boundaries (Concept → Plan → Development →
  Validation → Launch)
- Each gate MUST apply Must-Meet (veto) and Should-Meet (scorecard) criteria
- No feature MAY transition to the next stage without passing its gate
- Gate decisions MUST be explicitly one of: Go / Kill / Hold / Recycle

**Rationale**: Ensures strategic alignment without sacrificing delivery velocity.

## [SECTION_2_NAME]
<!-- Example: Additional Constraints, Security Requirements, Performance Standards, etc. -->

[SECTION_2_CONTENT]
<!-- Example: Technology stack requirements, compliance standards, deployment policies, etc. -->

## [SECTION_3_NAME]
<!-- Example: Development Workflow, Review Process, Quality Gates, etc. -->

[SECTION_3_CONTENT]
<!-- Example: Code review requirements, testing gates, deployment approval process, etc. -->

## Governance
<!-- Example: Constitution supersedes all other practices; Amendments require documentation, approval, migration plan -->

[GOVERNANCE_RULES]

## Gate Criteria Reference

This section defines the Must-Meet and Should-Meet criteria for each TR gate.
IPD mode is activated when this section exists in the constitution.

| TR Gate | Phase | Must-Meet (Veto) | Should-Meet (Scorecard) |
|---------|-------|------------------|------------------------|
| TR1 | Concept | Spec created, feasibility assessed; Product Trio review verdict (Go/Kill/Hold/Recycle) | Market attractiveness > 8/10 |
| TR2/TR3 | Plan | Architecture reviewed, deps locked | Effort variance < 15% |
| TR4 | Dev Baseline | DoD defined, CI configured | Velocity variance < 15% |
| TR5 | Validation | Blocker/critical bugs = 0 | Beta NPS >= 8 |
| TR6 | Launch | Deployment verified, ops handover | Training pass rate = 100% |

**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]
<!-- Example: Version: 2.1.1 | Ratified: 2025-06-13 | Last Amended: 2025-07-16 -->
