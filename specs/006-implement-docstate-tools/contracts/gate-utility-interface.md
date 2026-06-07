# Contracts: Gate Utility Script Interface

## detect-ipd-mode (.ps1 / .sh)

### Purpose
Detect whether the project has IPD mode active by checking the constitution.

### Interface

```powershell
# PowerShell
.\gate-detect-ipd-mode.ps1 [-Json]
```

```bash
# Bash
./gate-detect-ipd-mode.sh [--json]
```

### Exit Codes
- `0` — Execution succeeded (check output or JSON for mode)
- `1` — Error (e.g., project not initialized)

### JSON Output (`-Json` flag)

```json
{"ipd_mode": true}
```

### Text Output (no flag)

```
IPD mode: ACTIVE
```

or

```
IPD mode: INACTIVE (constitution not found)
IPD mode: INACTIVE (no Gate Criteria Reference section)
```

### Logic
1. Check `.specify/memory/constitution.md` exists → if not, return false
2. Search for `"Gate Criteria Reference"` heading in constitution
3. Return true if found, false otherwise

---

## check-gate (.ps1 / .sh)

### Purpose
Validate whether a specific TR gate has passed, including recursive prior-gate checks.

### Interface

```powershell
# PowerShell
.\gate-check.ps1 -Gate TR1 [-Json]
```

```bash
# Bash
./gate-check.sh --gate TR1 [--json]
```

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `-Gate` / `--gate` | YES | Gate ID: TR0, TR1, TR2_TR3, TR4, TR4A, TR5 |

### Exit Codes
- `0` — All required gates passed
- `1` — One or more gates failed (check error output)

### JSON Output (`-Json` flag)

```json
{
  "gate": "TR1",
  "status": "passed",
  "prior_gates": [
    {"gate": "TR0", "status": "passed", "evidence": "Constitution ratified..."}
  ],
  "current_gate": {
    "status": "passed",
    "evidence": "Spec exists with TR Gate Assessment section"
  },
  "errors": []
}
```

On failure:

```json
{
  "gate": "TR1",
  "status": "failed",
  "prior_gates": [
    {"gate": "TR0", "status": "passed", "evidence": "..."}
  ],
  "current_gate": {
    "status": "failed",
    "evidence": null,
    "errors": ["Spec does not contain TR Gate Assessment section"]
  },
  "errors": ["TR1 failed: Spec does not contain TR Gate Assessment section"]
}
```

### Gate Validation Rules

| Gate | Prior Checks | Current Check |
|------|-------------|---------------|
| TR0 | — | `.specify/memory/constitution.md` exists + contains "Gate Criteria Reference" |
| TR1 | TR0 passed | `spec.md` exists + contains "TR Gate Assessment" |
| TR2_TR3 | TR0, TR1 passed | `plan.md` exists + contains "Gate Readiness" |
| TR4 | TR0, TR1, TR2_TR3 passed | `tasks.md` exists + contains "Gate Completion Verification" |
| TR4A | TR0, TR1, TR2_TR3, TR4 passed | tasks checkbox completion check |
| TR5 | All prior gates passed | gate-status.json all prior entries have status=passed |

---

## record-gate (.ps1 / .sh)

### Purpose
Update the gate status in `.specify/memory/gate-status.json` with new evidence.

### Interface

```powershell
# PowerShell
.\gate-record.ps1 -Gate TR1 -Status passed -Evidence "Spec created with TR Gate Assessment"
```

```bash
# Bash
./gate-record.sh --gate TR1 --status passed --evidence "Spec created with TR Gate Assessment"
```

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `-Gate` / `--gate` | YES | Gate ID |
| `-Status` / `--status` | YES | `passed`, `pending`, `failed`, `skipped` |
| `-Evidence` / `--evidence` | YES | Description of gate evidence (max 500 chars) |

### Exit Codes
- `0` — Status updated successfully
- `1` — Error (invalid gate ID, status, or file I/O failure)

### JSON Output

```json
{
  "gate": "TR1",
  "status": "passed",
  "last_updated": "2026-06-06",
  "gates": {
    "TR0": {"status": "passed", ...},
    "TR1": {"status": "passed", "evidence": "...", "date": "2026-06-06"},
    ...
  }
}
```

### Atomic Write Pattern

1. Read existing `gate-status.json` (or create default if missing)
2. Validate gate ID is valid
3. Validate status is valid enum value
4. Update the specific gate entry (status, evidence, date)
5. Update `last_updated`
6. Write to temp file, then rename over original (atomic)
