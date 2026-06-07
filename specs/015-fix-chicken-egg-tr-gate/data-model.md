# Data Model: Fix TR Gate Chicken-Egg Dependency

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## Entities

### GateCriterion

A single checkable condition at a Technology Review gate. Each criterion is identified by a sequential ID with phase ownership to break circular dependencies.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | ✅ | Sequential ID: `TR{Gate}-{MM\|SM}-{NNN}` (e.g., `TR2-MM-001`) |
| `gate` | string | ✅ | Gate identifier (e.g., `TR2/TR3`, `TR4`) |
| `type` | enum | ✅ | `Must-Meet` or `Should-Meet` |
| `title` | string | ✅ | Short human-readable title |
| `owning_phase` | enum | ✅ | `Plan`, `Task`, or `Implementation` — the phase that produces this criterion's evidence |
| `description` | string | ✅ | Detailed description of what passing this criterion requires |
| `depends_on` | string[] | optional | List of criterion IDs that must be evaluated before this one (enables cycle detection) |
| `validation_hint` | string | optional | Guidance for how to validate this criterion at the gate review |

**Valid status values** (runtime, not stored in config): `pending`, `passed`, `failed`, `deferred`, `not-applicable`

**Source**: Defined in `.specify/gates/tr-criteria.yml`, validated against JSON Schema.

### DeferredItem

A gate criterion that was deferred from a prior gate to a future gate (FR-003, FR-008).

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `criterion_id` | string | ✅ | References a `GateCriterion.id` |
| `originating_gate` | string | ✅ | The gate where this was deferred (e.g., `TR2/TR3`) |
| `target_gate` | string | ✅ | The gate where this must be re-verified (e.g., `TR4`) |
| `owner` | string | ✅ | PDT role or person responsible for resolving |
| `due_by_phase` | string | ✅ | Phase by which this must be resolved |
| `status` | enum | ✅ | `deferred`, `resolved`, `escalated` |
| `justification` | string | ✅ | Reason for deferral (why it couldn't be verified at the originating gate) |
| `resolution_evidence` | string | optional | Evidence artifact reference when resolved |
| `deferred_at` | string | ✅ | ISO 8601 timestamp |
| `resolved_at` | string | optional | ISO 8601 timestamp |

**Source**: Per-feature `deferred-items.json`, validated against JSON Schema.

### GateReviewReport

The output artifact produced by a gate review (FR-004).

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `feature` | string | ✅ | Feature directory name |
| `gate` | string | ✅ | Gate identifier |
| `verdict` | enum | ✅ | `passed`, `conditional-pass`, `failed`, `recycle` |
| `reviewed_at` | string | ✅ | ISO 8601 timestamp |
| `reviewer` | string | ✅ | Actor/role who performed the review |
| `criteria_results` | object[] | ✅ | Per-criterion results (see below) |
| `deferred_items` | object[] | optional | Deferred items if verdict is `conditional-pass` |
| `cycles_detected` | string[][] | optional | Cycle paths if `--check-cycles` was run |
| `notes` | string | optional | Free-text reviewer notes |

**Criteria result entry**:

| Field | Type | Description |
|-------|------|-------------|
| `criterion_id` | string | Reference to GateCriterion |
| `status` | string | `passed`, `failed`, `deferred`, `not-applicable` |
| `evidence` | string | Evidence reference or deferral reason |
| `evaluated_at` | string | ISO 8601 timestamp |

**Runtime record** — stored as part of gate review process, not persisted as a standalone file. Key data flows into `gate-status.json` and the audit log.

### AuditEntry

A single audit event recording a gate-relevant state change (FR-009).

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `timestamp` | string | ✅ | ISO 8601 timestamp |
| `actor` | string | ✅ | Operator identity (git user or specified role) |
| `event_type` | enum | ✅ | See event types below |
| `feature` | string | ✅ | Feature directory name |
| `gate` | string | ✅ | Gate identifier |
| `criterion_id` | string | optional | Affected criterion ID (if applicable) |
| `from_state` | string | optional | Previous state/snapshot |
| `to_state` | string | optional | New state/snapshot |
| `rationale` | string | optional | Reason for the change |

**Event types**: `gate_criteria_status_change`, `gate_criteria_config_change`, `gate_manual_override`, `gate_verdict`, `deferred_item_resolved`

**Source**: `.specify/gates/audit.log` (JSON Lines format).

## File Inventory

| File | Format | Location | Purpose |
|------|--------|----------|---------|
| `tr-criteria.yml` | YAML | `.specify/gates/` | Gate criteria definitions with phase ownership |
| `deferred-items.json` | JSON | `specs/NNN-feature/` | Per-feature deferred item registry |
| `gate-status.json` | JSON | `.specify/memory/` | Shared gate progress (extended for new verdicts) |
| `audit.log` | JSON Lines | `.specify/gates/` | Append-only audit trail |
| `tr-criteria.schema.json` | JSON Schema | `contracts/` | Schema for tr-criteria.yml validation |
| `deferred-items.schema.json` | JSON Schema | `contracts/` | Schema for deferred-items.json validation |
| `audit-log.schema.json` | JSON Schema | `contracts/` | Schema for audit log entry validation |

## State Transitions

### GateCriterion Status Flow

```
                    ┌─────────┐
                    │ pending │ (initial state when gate review starts)
                    └────┬────┘
                         │
              ┌──────────┼──────────┐
              ↓          ↓          ↓
          ┌──────┐  ┌────────┐  ┌──────────┐
          │passed│  │ failed │  │ deferred │  (deferred moves to next gate)
          └──────┘  └────────┘  └────┬─────┘
                                     │ (at target gate)
                                     ↓
                               ┌──────────┐
                               │ resolved │
                               └──────────┘

  not-applicable: any state → N/A (when criterion is skipped/out of scope)
```

### Gate Verdict Flow

```
criteria evaluated
       ↓
  ┌────┴────┐
  │ all     │ → passed
  │ passed  │
  └────┬────┘
       │ some deferred
       ↓
  ┌──────────┐
  │conditional│ → passed + deferred items list
  │ -pass    │
  └──────────┘
       │ some failed
       ↓
  ┌────────┬──────┐
  │failed  │recycle│ (recycle = failed + revision instructions)
  └────────┴──────┘
```

### DeferredItem Status Flow

```
deferred (created) → resolved (verified at target gate)
                   → escalated (not resolved by due-by phase)
```
