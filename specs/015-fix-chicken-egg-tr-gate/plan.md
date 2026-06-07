# Implementation Plan: Fix TR Gate Chicken-Egg Dependency

**Branch**: `015-fix-chicken-egg-tr-gate` | **Date**: 2026-06-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/015-fix-chicken-egg-tr-gate/spec.md`

## Summary

The chicken-and-egg problem between the Plan phase (TR2/TR3 gate) and the Task phase occurs because gate criteria lack explicit phase ownership, creating circular validation dependencies. This plan implements: (1) a phase-ownership mapping for all TR2/TR3 gate criteria stored in `.specify/gates/tr-criteria.yml`, (2) a deferred-items mechanism with per-feature persistence (`deferred-items.json`), (3) a `conditional-pass` gate verdict to allow partial gate passage, (4) a `--check-cycles` mode for proactive circular-dependency detection, and (5) a comprehensive audit log for all gate state changes.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS
- **TR Gates Passed**: TR0, TR1
- **Next Gate**: TR2/TR3

## Technical Context

**Language/Version**: PowerShell 7+ (Core) for gate scripts; Python 3.11+ for utility scripts if needed

**Primary Dependencies**: Existing gate scripts (`gate-check.ps1`, `gate-record.ps1`, `gate-detect-ipd-mode.ps1`); no new external packages

**Storage**: YAML (`.specify/gates/tr-criteria.yml`) for criteria definitions; JSON (`deferred-items.json` per feature, `gate-status.json` shared) for runtime state; JSON Lines (`.specify/gates/audit.log`) for audit trail

**Testing**: Pester (PowerShell test framework) for gate script testing; JSON schema validation (`jsonschema` Python lib) for artifact format conformance

**Target Platform**: Cross-platform (Windows with PowerShell 7+, Linux/macOS with PowerShell Core)

**Project Type**: Meta — IPD gate tooling enhancements within the Spec Kit framework

**Performance Goals**: Gate check operations complete in < 2 seconds on typical feature directory; `--check-cycles` completes in < 1 second for < 50 criteria

**Constraints**: Must maintain backward compatibility with existing `gate-status.json` format; all additions must be optional/opt-in for existing features

**Scale/Scope**: 5-15 gate criteria per TR gate; 1-10 features in parallel; single-user CLI tooling

**WSJF Priority Score**: Not calculated — this is infrastructure improvement with direct schedule impact; no alternative investment tradeoff at this stage

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Verification against 5 Core Principles:**

| Principle | Aligned | Evidence |
|-----------|---------|----------|
| I. Spec-First, SDD Core | ✅ | This feature was spec-first; the plan implements spec intent |
| II. Dual-Track Agile | ✅ | Feature was validated through spec/clarify before planning; no dev commits yet |
| III. Agile-Stage-Gate | ✅ | This feature directly strengthens TR2/TR3 gate mechanics — the spec is the fix for the gate itself |
| IV. Cross-Functional PDT | ✅ | Roles mapped (LPDT, Architect, QA Lead, PO) are consistent with PDT framework |
| V. Quality Built-In | ✅ | Audit logging (FR-009), regression test suite (Risk Register), and backward compatibility requirements ensure quality |

**Verdict**: PASS — all 5 principles satisfied. No violations requiring Complexity Tracking.

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: [`.specify/memory/cbb-catalog.md`](../../.specify/memory/cbb-catalog.md)
- **Reusable blocks identified**:
  - `gate-check.ps1` — gate validation logic (extend rather than replace)
  - `gate-record.ps1` — gate status persistence (extend for new verdicts)
  - `gate-status.json` format — reuse for the new deferred-items tracker (as a separate file)
  - PowerShell `-Json` pattern — consistent I/O convention across all gate scripts
- **New components needed**:
  - `.specify/gates/tr-criteria.yml` — criteria definition config file
  - `deferred-items.json` — per-feature deferred item storage (schema)
  - `--check-cycles` flag on `gate-check.ps1` — cycle detection mode
  - `.specify/gates/audit.log` — audit trail file (JSON Lines)
- **Reuse justification**: Existing gate scripts are extended rather than replaced, maintaining consistency across the tooling suite while adding new capabilities

## Project Structure

### Documentation (this feature)

```text
specs/015-fix-chicken-egg-tr-gate/
├── spec.md                # Feature specification
├── plan.md                # This file
├── research.md            # Phase 0 output — technical decisions
├── data-model.md          # Phase 1 output — artifact schemas
├── quickstart.md          # Phase 1 output — implementation guide
└── contracts/             # Phase 1 output — formal schemas
    ├── tr-criteria.schema.json
    ├── deferred-items.schema.json
    └── audit-log.schema.json
```

### Source Code (repository root)

```text
.specify/
├── gates/                          # NEW directory for gate tooling
│   ├── tr-criteria.yml             # Gate criteria with phase ownership
│   └── audit.log                   # Audit trail (JSON Lines format)
├── scripts/powershell/
│   ├── gate-check.ps1              # EXTEND: support --check-cycles, conditional-pass, phase-scoped validation
│   ├── gate-record.ps1             # EXTEND: support conditional-pass, deferred items, audit log
│   └── gate-detect-ipd-mode.ps1    # unchanged
├── memory/
│   ├── constitution.md             # unchanged
│   └── gate-status.json            # EXTEND: support conditional-pass as a verdict value

specs/
└── NNN-feature/
    └── deferred-items.json         # NEW: per-feature deferred items
```

**Structure Decision**: The gate tooling follows the existing `.specify/` layout convention. The new `.specify/gates/` directory parallels `.specify/memory/` and `.specify/scripts/` as a dedicated home for gate configuration. Deferred items are per-feature (in feature directories) to maintain isolation.

## Complexity Tracking

No violations — the Constitution Check passes on all 5 principles. This section is intentionally left blank.

---

## Phase 0: Research

Research will determine detailed schema and algorithm choices for the implementation. All items are low-risk decisions with clear defaults based on PowerShell project conventions.

### Research Tasks

| Task | Description | Resolution Approach |
|------|-------------|-------------------|
| R1 | `tr-criteria.yml` schema design | JSON Schema defined in contracts/; YAML format compatible with existing PS patterns |
| R2 | Cycle detection algorithm | Simple DFS-based with visited set tracking — sufficient for < 50 criteria nodes |
| R3 | Audit log format | JSON Lines with standard fields per entry; single-file append-only |
| R4 | Configuration validation | YAML parsed via `ConvertFrom-Json` (after `ConvertTo-Json` pass); JSON validated natively in PS |

### Research output

Written to `research.md` (below).

---

## Phase 1: Design & Contracts

### Entities to model (→ `data-model.md`)

- `GateCriterion` — individual checkable criterion with ID, gate reference, description, type (Must-Meet/Should-Meet), owning phase, status, evidence, depends_on list
- `DeferredItem` — deferred criterion with originating gate, target gate, owner, due-by phase, status, justification
- `GateReviewReport` — gate verdict with per-criteria results, deferred items, cycle detection results, timestamp
- `AuditEntry` — single audit event with timestamp, actor, event type, before/after state, rationale

### Contracts (→ `contracts/`)

- `tr-criteria.schema.json` — JSON Schema for validating `.specify/gates/tr-criteria.yml`
- `deferred-items.schema.json` — JSON Schema for validating per-feature `deferred-items.json`
- `audit-log.schema.json` — JSON Schema for audit log entries

### Quickstart (→ `quickstart.md`)

Step-by-step implementation guide covering modifications to existing gate scripts and creation of new artifacts.

### Agent Context

Update `CLAUDE.md` SPECKIT markers to reference this plan file.
