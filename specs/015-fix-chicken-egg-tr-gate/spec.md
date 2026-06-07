# Feature Specification: Fix TR Gate Chicken-Egg Dependency

**Feature Branch**: `015-fix-chicken-egg-tr-gate`

**Created**: 2026-06-08

**Status**: Draft

**Input**: User description: "解决plan和task阶段出现的因为chicken-and-egg情况导致的TR评审未通过问题"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Break the Circular Validation Dependency Between Plan and Task Phases (Priority: P1)

As a **PDT Manager (LPDT)**, I want to pass TR2/TR3 gate review without being blocked by circular dependencies between the Plan phase (architecture design) and the Task phase (task breakdown), so that the feature development process flows smoothly without artificial gate stalls.

**Why this priority**: This is the core issue — the chicken-and-egg loop is the root cause of all TR gate failures in the plan/task stages. Without breaking it, no other improvement matters.

**Independent Test**: Can be validated by running a complete `/vipd-speckit-plan` → `/vipd-speckit-tasks` cycle end-to-end with a representative feature and confirming TR2/TR3 gate passes without requiring manual override.

**Acceptance Scenarios**:

1. **Given** a feature spec that has passed TR1, **When** the Plan phase completes, **Then** the TR2/TR3 gate assessment does not depend on task-level detail that can only exist after task generation
2. **Given** a feature spec with a completed Plan, **When** the Task phase runs, **Then** it does not require gate items from TR2/TR3 that can only be satisfied after implementation
3. **Given** a complete Plan → Task cycle, **When** the TR2/TR3 gate is evaluated, **Then** no "circular dependency" error causes the gate to fail

---

### User Story 2 - Explicit Gate Dependency Mapping (Priority: P1)

As a **System Architect**, I want a clear mapping of which TR2/TR3 gate criteria belong to the Plan phase vs. the Task phase, so I know exactly what each phase must deliver without waiting for the other phase to complete first.

**Why this priority**: The ambiguity of which phase owns which gate criterion is the direct cause of the chicken-and-egg confusion. Making ownership explicit eliminates the deadlock.

**Independent Test**: A reviewer can examine the gate dependency map and verify that no criterion depends on output from a phase that hasn't run yet.

**Acceptance Scenarios**:

1. **Given** a set of TR2/TR3 gate criteria, **When** each criterion is assigned to either Plan or Task phase, **Then** no criterion assigned to Plan requires data from the Task phase
2. **Given** the dependency map, **When** a phase completes, **Then** all gate criteria assigned to that phase are verifiable immediately (no pending cross-phase dependencies)
3. **Given** a cross-phase dependency (e.g., effort estimation), **When** the dependency map identifies it, **Then** a specific phase owns the responsibility and the dependent phase has an "expected" placeholder with validation rules

---

### User Story 3 - Graceful Gate Degradation with Partial Evidence (Priority: P2)

As a **QA Lead / Gate Reviewer**, I want the TR2/TR3 gate to pass with partial evidence when certain criteria can only be fully verified after the downstream phase, so that the gate does not block progress while still tracking completeness.

**Why this priority**: Chicken-and-egg problems often mean some evidence cannot exist until later phases. A "fail all or nothing" approach creates unnecessary deadlocks.

**Independent Test**: Can be tested by running a gate review on a plan where 80% of criteria are met and 20% are deferred to the task phase, confirming the gate passes with a "conditional pass + deferred items" status.

**Acceptance Scenarios**:

1. **Given** a gate criteria item that depends on task-level detail, **When** the Plan phase gate review runs, **Then** the criterion accepts a "deferred — to be confirmed at TR4" status instead of failing
2. **Given** a gate review with deferred items, **When** the review completes, **Then** a clear deferred-items list is recorded alongside the pass verdict
3. **Given** a subsequent phase (e.g., Development / TR4), **When** it completes, **Then** the system verifies that previously deferred items are now satisfied

---

### User Story 4 - Automated Detection of Circular Gate Dependencies (Priority: P2)

As a **Product Owner (PO)**, I want the gate validation tooling to automatically detect potential circular dependencies between phases before the gate review, so we can address them proactively rather than reactively during review.

**Why this priority**: Prevention is better than fixing review failures. Automated detection raises awareness early.

**Independent Test**: A cycle-detection scan against known gate criteria can produce a circular-dependency report without running the full gate review.

**Acceptance Scenarios**:

1. **Given** a set of gate criteria for TR2/TR3, **When** the system scans for circular dependencies, **Then** any pair of criteria that mutually reference each other across phases is flagged as a cycle
2. **Given** a flagged cycle, **When** the system reports it, **Then** it suggests which phase should own each criterion to break the cycle
3. **Given** a dependency graph with no cycles, **When** scanned, **Then** a "no circular dependencies found" confirmation is produced

---

### Edge Cases

- What happens when a plan is incomplete due to insufficient specification detail? (The gate should fail explicitly with clear reasons, not produce a chicken-and-egg error)
- How does the system handle a feature where plan and task truly cannot be separated? (Fallback: allow combined "plan + task" phase delivery with a single TR2/TR3+ gate)
- What about features that skip the Plan phase entirely (e.g., trivial config changes)? (Gate should auto-pass with no dependencies to check)
- How are manually overridden gate blocks tracked? (Override decisions must be logged with rationale and an owner)

## TR Gate Assessment *(IPD only)*

- **Applicable TR Gates**: TR2/TR3 (directly affected), TR1 (the spec must include gate criteria ownership), TR4 (deferred items from TR2/TR3 must be verified)
- **Risk Level**: High — the chicken-and-egg problem currently blocks the entire feature pipeline; without resolution, every feature with non-trivial plan/task separation will hit this wall
- **Gate Evidence Required**:
  - Gate dependency ownership matrix (which criteria belong to which phase)
  - Deferred-items tracking mechanism design
  - Circular-dependency detection rules (validation logic)
  - Updated TR gate scripting to support conditional/partial pass
  - Audit log format and storage specification

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST define an explicit ownership mapping assigning each TR2/TR3 gate criterion to either the **Plan phase** or the **Task phase**, with no criterion assigned to both. The mapping SHALL be stored as a machine-readable YAML config file (`.specify/gates/tr-criteria.yml`) that is version-controlled alongside the constitution.
- **FR-002**: The gate validation logic MUST NOT require Task-phase criteria to be satisfied during the Plan-phase gate review (TR2/TR3). Plan-phase review SHALL only evaluate Plan-phase-owned criteria.
- **FR-003**: When a gate criterion depends on information that only exists after the downstream phase, the system MUST support a "Deferred — TBD at [Next Gate]" status as a valid gate check result without causing a gate failure. Deferred items SHALL be persisted to a per-feature JSON file (`deferred-items.json` in the feature directory) for cross-session durability.
- **FR-004**: The system MUST generate a gate review report that includes:
  - Criteria passed (with evidence)
  - Criteria deferred (with target gate for verification)
  - Criteria failed (with specific reason)
  - Any detected circular dependencies (if cycle detection was run)
- **FR-005**: When generating tasks from a plan (`/vipd-speckit-tasks`), the system MUST NOT re-validate TR2/TR3 gate criteria that were already satisfied during the Plan phase. Only new criteria specific to task readiness SHALL be validated.
- **FR-006**: The gate validation tooling MUST provide a `--check-cycles` mode that scans the gate criteria dependency graph for circular references and reports any cycles found, without running the full gate review.
- **FR-007**: TR2/TR3 gate status SHALL support the following verdicts: `passed`, `conditional-pass` (with deferred items), `failed`, `recycle` (with revision instructions).
- **FR-008**: Deferred items from a `conditional-pass` TR2/TR3 MUST be automatically re-verified at the next applicable gate (TR4/TR4A), and failure to satisfy them there SHALL be reported as new gate failures.
- **FR-009**: The system MUST maintain an audit log of all gate-relevant state changes, including: gate criteria status transitions (passed/failed/deferred/recycle), dependency map config edits, and manual gate overrides. Each audit entry SHALL record: timestamp, actor identity, change type, before/after values, and rationale.

### Key Entities *(include if feature involves data)*

- **Gate Criteria**: A single checkable condition at a TR gate. Each criterion is identified by a sequential ID (`TR{Gate}-{Type}-{NNN}`, e.g., `TR2-MM-001` for TR2 Must-Meet #1). Key attributes: owning phase (Plan/Task), status (passed/failed/deferred/not-applicable), evidence reference, dependent criteria list (referenced by ID).
- **Gate Dependency Map**: A directed graph of gate criteria and their cross-phase dependencies. Each edge represents "criterion A depends on criterion B." Cycles in this graph are the chicken-and-egg problem.
- **Gate Review Report**: The output artifact of a gate review containing: verdict, per-criteria results, deferred items list, detected cycles (if any), reviewer notes, timestamp.
- **Deferred Item Tracker**: A registry of gate criteria deferred from a prior gate to a future gate. Each entry has: criterion ID, originating gate, target verification gate, owner, due-by phase, status.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of TR2/TR3 gate criteria are unambiguously assigned to either the Plan phase or the Task phase (zero criteria in the "unsure/unassigned" category).
- **SC-002**: A representative feature with non-trivial architecture can complete the entire Plan → Task → TR2/TR3 gate cycle without any "circular dependency" gate failure.
- **SC-003**: Gate review cycle time for TR2/TR3 is reduced by at least 40% (measured from start of gate review to final verdict) compared to pre-fix baseline where chicken-and-egg blockages caused review loops.
- **SC-004**: The `--check-cycles` mode can detect 100% of artificially introduced circular dependencies in a test gate criteria set (no false negatives).
- **SC-005**: Zero manual gate overrides are required for chicken-and-egg-related issues after the fix is deployed (overrides may still occur for legitimate business reasons, but not for this specific failure mode).

## Assumptions

- The TR2/TR3 gate criteria as defined in the constitution (`CLAUDE.md` Gate Criteria Reference) are the authoritative list — no new criteria are being added by this feature, only re-assigned by phase ownership.
- The 014 feature (Chinese Documentation Translation) is assumed to have completed its normal flow; this feature operates on the Spec Kit core workflow itself.
- The existing gate validation scripts (`gate-check.ps1`, `gate-record.ps1`) provide the foundation — this feature extends rather than replaces them.
- Gate criteria definitions and phase ownership are stored in a dedicated config file (`.specify/gates/tr-criteria.yml`), separate from the constitution prose.
- Deferred items are stored per-feature in `deferred-items.json` within the feature directory, separate from the shared `gate-status.json`.
- Team members (PDT roles) already understand the IPD gate framework — this feature only addresses the mechanical circular-dependency issue, not retraining.
- The `conditional-pass` verdict does not weaken gate rigor — it merely acknowledges that certain criteria have a natural temporal dependency across phases.
- Manual gate overrides will continue to exist for exceptional cases; this feature aims to make them unnecessary for the specific chicken-and-egg failure mode.

## Clarifications

### Session 2026-06-08

- Q: Deferred items storage mechanism → A: Persistent JSON file per feature (`deferred-items.json` in the feature directory)
- Q: Gate criteria identity scheme → A: Sequential IDs (`TR{Gate}-{Type}-{NNN}`, e.g., `TR2-MM-001`)
- Q: Gate dependency matrix source → A: Dedicated YAML config file (`.specify/gates/tr-criteria.yml`)
- Q: Audit trail scope → A: Comprehensive — all status transitions + dependency map config changes (beyond override-only)

## Risk Register *(IPD only)*

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Adding "conditional-pass" weakens gate discipline — teams may overuse deferrals | H | M | Require explicit TBD-gate assignment for each deferred item; auto-escalate if > 3 deferred items per gate |
| Existing features already in flight may need retrofitting | M | M | Apply only to new features starting post-this-feature; provide opt-in migration path for in-flight features |
| Cycle detection produces false positives for legitimate cross-phase dependencies | M | L | Use manual review of flagged cycles before acting; allow explicit "acknowledged cycle" annotations |
| Changes to gate logic break existing gate scripts or recordings | H | L | Full regression test suite on all gate scripts before deployment; maintain backward compatibility with existing gate-status.json format |
