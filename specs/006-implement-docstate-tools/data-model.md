# Data Model: Document-State Tooling

## Core Entities

### GateStatus

| Field | Type | Description |
|-------|------|-------------|
| ipd_mode | boolean | Whether IPD mode is active (constitution has Gate Criteria Reference) |
| last_updated | string (date) | ISO 8601 date of last status change |
| gates | map[GateID → GateEntry] | Per-gate status entries |

### GateEntry

| Field | Type | Description |
|-------|------|-------------|
| status | enum | `passed`, `pending`, `failed`, `skipped` |
| evidence | string | Description of what evidence supports the gate decision |
| date | string (date) | Date of gate decision |

### GateID

Literal values: `TR0`, `TR1`, `TR2_TR3`, `TR4`, `TR4A`, `TR5`

### GateDependency

| Gate | Depends On | Validation |
|------|------------|------------|
| TR0 | — | Constitution exists + "Gate Criteria Reference" heading |
| TR1 | TR0 | Spec exists + "TR Gate Assessment" heading |
| TR2_TR3 | TR0, TR1 | Plan exists + "Gate Readiness" heading |
| TR4 | TR0, TR1, TR2_TR3 | Tasks exist + "Gate Completion Verification" checkpoint |
| TR4A | TR0, TR1, TR2_TR3, TR4 | Tasks checkbox completion |
| TR5 | All prior gates | JSON gate-status field check |

## Utility Script Interface

### detect-ipd-mode

```
Input:  None (uses repo root)
Output: {"ipd_mode": true/false}
Logic:  .specify/memory/constitution.md exists AND contains "Gate Criteria Reference"
```

### check-gate

```
Input:  GateID (e.g., TR1), [-Json] flag
Output: {"gate": "TR1", "status": "passed"|"failed", "evidence": "...", "errors": [...]}
Logic:  Validate all prior gates recursively, then validate current gate
```

### record-gate

```
Input:  GateID, status, evidence
Output: {"gate": "TR1", "status": "passed", "last_updated": "2026-06-06"}
Logic:  Read gate-status.json → update entry → atomic write
```

## File Paths

| Entity | Default Path |
|--------|-------------|
| Constitution | `.specify/memory/constitution.md` |
| Gate status | `.specify/memory/gate-status.json` |
| IPD mode detect | `.specify/scripts/powershell/gate-detect-ipd-mode.ps1` |
| Gate check | `.specify/scripts/powershell/gate-check.ps1` |
| Gate record | `.specify/scripts/powershell/gate-record.ps1` |
