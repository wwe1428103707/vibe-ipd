# Data Model: IPD Migration Functional Gaps

**Feature**: 009-ipd-migration-gaps | **Date**: 2026-06-07

## Entities

### GateStatus (per-feature)

The top-level document stored at `specs/NNN-feature-name/gate-status.json`.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `ipd_mode` | boolean | yes | Whether IPD mode is active (mirrors constitution presence) |
| `feature` | string | yes | Feature directory name (e.g., `"009-ipd-migration-gaps"`) |
| `last_updated` | string (ISO date) | yes | Date of last gate status change |
| `gates` | map<GateID, GateEntry> | yes | Map of gate ID to gate entry |

**Migration note**: The project-level `.specify/memory/gate-status.json` will be migrated to per-feature files. The migration script will copy the existing gate status to the current active feature's directory.

### GateEntry

A single gate's status and history.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `status` | GateStatus | yes | Current status: `pending`, `passed`, `failed`, `hold`, `recycled` |
| `decision` | GateDecision | conditional | Go/Kill/Hold/Recycle decision; required when `status` is `passed` |
| `evidence` | string | conditional | Evidence text; required when `status` is `passed` or `failed`; max 2000 chars |
| `decision_maker` | string | conditional | Role or person who made the decision; optional |
| `decision_rationale` | string | conditional | Why the decision was made; optional |
| `date` | string (ISO date) | yes | Date of last status change |
| `history` | array<GateTransition> | yes | Audit trail of all status changes (at least 1 entry) |

### GateTransition

A record of a single gate status change.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `from` | GateStatus | yes | Previous status |
| `to` | GateStatus | yes | New status |
| `date` | string (ISO datetime) | yes | ISO 8601 datetime of the transition |
| `evidence` | string | yes | Evidence summary at time of transition |

### GateID (enum)

Extended to include TR6.

| Value | Description |
|-------|-------------|
| `TR0` | Constitution approval |
| `TR1` | Concept gate |
| `TR2_TR3` | Plan gate (merged) |
| `TR4` | Development gate |
| `TR4A` | Gray release / quality gate |
| `TR5` | Validation gate |
| `TR6` | Launch gate (NEW) |

### GateStatus (enum)

Extended to support Hold and Recycle.

| Value | Description |
|-------|-------------|
| `pending` | Not yet evaluated |
| `passed` | All Must-Meet criteria satisfied |
| `failed` | One or more Must-Meet criteria not satisfied |
| `hold` | Decision deferred (NEW) |
| `recycled` | Sent back for rework (NEW) |

### GateDecision (enum)

| Value | Description |
|-------|-------------|
| `Go` | Proceed to next phase |
| `Kill` | Cancel the feature |
| `Hold` | Delay decision pending more information |
| `Recycle` | Send back for rework |

### GateCheckResult

Output from gate-check.ps1/.sh (subprocess JSON).

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `gate` | GateID | yes | Requested gate |
| `status` | `"passed"` \| `"failed"` | yes | Overall result |
| `prior_gates` | array<GateCheckDetail> | yes | Status of all prerequisite gates |
| `current_gate` | GateCheckDetail | yes | Status of the requested gate |
| `errors` | array<string> | yes | Accumulated error messages |
| `should_meet` | array<ShouldMeetResult> | no | Advisory Should-Meet results (NEW) |

### ShouldMeetResult (NEW)

Advisory result for Should-Meet criteria evaluation.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `criterion` | string | yes | Description of the Should-Meet criterion |
| `status` | `"met"` \| `"not_met"` \| `"not_assessed"` | yes | Whether the criterion was met |
| `score` | string | no | Numeric score if applicable (e.g., "8/10") |

### GateCheckDetail (extended)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `gate` | GateID | yes | Gate ID |
| `status` | `"passed"` \| `"failed"` | yes | Result |
| `evidence` | string | yes | Evidence description |
| `errors` | array<string> | yes | Specific failure reasons |
| `must_meet_details` | array<MustMeetResult> | no | Detailed Must-Meet criteria results (NEW) |
| `depth_validated` | boolean | no | Whether depth validation was performed (NEW) |

### MustMeetResult (NEW)

Detailed result for each Must-Meet criterion.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `criterion` | string | yes | The Must-Meet criterion text |
| `pattern` | string | yes | The regex pattern used for validation |
| `matched` | boolean | yes | Whether the pattern was found in the artifact |
| `artifact_path` | string | yes | Path to the artifact file that was checked |

## Relationships

```
GateStatus 1──* GateEntry (one per GateID)
GateEntry 1──* GateTransition (audit trail)
GateCheckResult *──1 GateID (per check invocation)
ShouldMeetResult *──1 GateCheckResult (advisory results)
MustMeetResult *──1 GateCheckDetail (detailed criteria)
```

## Storage Paths

| Artifact | Path | Format |
|----------|------|--------|
| Per-feature gate status | `specs/NNN-feature-name/gate-status.json` | JSON |
| Project-level gate status (legacy) | `.specify/memory/gate-status.json` | JSON (to be migrated) |
| Feature pointer | `.specify/feature.json` | JSON |
| Constitution | `.specify/memory/constitution.md` | Markdown |
| CBB catalog | `.specify/memory/cbb-catalog.md` | Markdown (NEW) |

## Depth Validation Patterns

Per-gate regex patterns for substantive content validation:

| Gate | Pattern 1 | Pattern 2 | Pattern 3 |
|------|-----------|-----------|-----------|
| TR1 | `### User Story` or `### User Story \d+` | `Given.*When.*Then` | `TR Gate Assessment` |
| TR2_TR3 | `Gate Readiness` | `Architecture Decision` or `Data Model` or `API Contract` | `Constitution Check` or `WSJF` |
| TR4 | `- \[.\] T\d{3,4}` (task checkboxes) | `Gate Completion Verification` | `Phase \d+` (phase structure) |
| TR4A | `- \[x\] T\d{3,4}` (completed tasks) | Completion ratio ≥ threshold | `Quality Summary` or `Quality Report` |
| TR5 | All prior gates `passed` in gate-status.json | `Cross-artifact` or `Consistency` | `Test Report` or `Validation` |
| TR6 | `Deployment Verification` or `Deploy.*verified` | `Ops Handover` or `Operations.*Handover` | `Training.*Pass` or `Training.*100%` |