# Architecture Decision Log: Fix TR Gate Chicken-Egg Dependency

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## ADL-001: Gate Criteria Defined in YAML Config File

| Field | Value |
|-------|-------|
| **Context** | FR-001 requires an explicit ownership mapping for each TR2/TR3 gate criterion. The constitution defines criteria only as prose in a table. |
| **Decision** | Store criteria in `.specify/gates/tr-criteria.yml` — a dedicated YAML config file with validated schema. |
| **Rationale** | YAML is human-readable for PDT members, machine-parseable for automation, and version-controlled. Separating from the constitution allows criteria to evolve independently of governance prose. |
| **Alternatives** | In-spec declaration (not reusable), auto-parsed from constitution (fragile), manual document (inconsistent) |
| **Status** | Accepted |

## ADL-002: Per-Feature Deferred Items File

| Field | Value |
|-------|-------|
| **Context** | FR-003 introduces deferred items that persist across sessions. The storage lifetime affects architecture complexity. |
| **Decision** | Store deferred items in per-feature `deferred-items.json` within each feature directory, separate from the shared `gate-status.json`. |
| **Rationale** | Per-feature isolation prevents cross-feature coupling, simplifies cleanup (delete with feature), and enables independent lifecycle management. |
| **Alternatives** | In-memory only (lost on interruption), extended `gate-status.json` (mixes gate history with pending items) |
| **Status** | Accepted |

## ADL-003: Sequential IDs for Gate Criteria

| Field | Value |
|-------|-------|
| **Context** | Each gate criterion needs a stable identifier for the dependency map, deferred tracker, and audit log. |
| **Decision** | Use sequential IDs in the format `TR{Gate}-{Type}-{NNN}` (e.g., `TR2-MM-001`, `TR2-SM-001`). |
| **Rationale** | Human-readable, sortable, extensible, and compact for CLI use. Type prefix (MM/SM) distinguishes Must-Meet from Should-Meet at a glance. |
| **Alternatives** | Descriptive names (prone to drift), TR gate table row references (fragile under reordering) |
| **Status** | Accepted |

## ADL-004: Comprehensive Audit Trail via JSON Lines

| Field | Value |
|-------|-------|
| **Context** | FR-009 requires audit logging. The scope spans override-only vs. comprehensive tracking. |
| **Decision** | Log all gate-relevant state changes (status transitions, config edits, overrides, verdicts) to `.specify/gates/audit.log` in JSON Lines format. |
| **Rationale** | Append-only JSON Lines avoids rewrite costs, supports simple `Get-Content | ForEach-Object` querying, and accommodates all event types uniformly. |
| **Alternatives** | Override-only (insufficient traceability), all-transitions + config changes (more effort but justified for IPD compliance) |
| **Status** | Accepted |

## ADL-005: DFS-Based Cycle Detection

| Field | Value |
|-------|-------|
| **Context** | FR-006 requires a `--check-cycles` mode to detect circular dependencies between gate criteria. |
| **Decision** | Implement simple DFS with visiting/visited tracking. |
| **Rationale** | Linear O(N+E) complexity is sufficient for < 50 criteria nodes in a single-user CLI tool. Produces the cycle path for reporting without Tarjan's SCC overhead. |
| **Alternatives** | Tarjan's algorithm (overkill at this scale), topological sort (does not detect cycles, only orders) |
| **Status** | Accepted |
