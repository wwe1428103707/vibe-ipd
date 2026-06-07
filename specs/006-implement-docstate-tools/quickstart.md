# Quickstart: Document-State Gate Utilities

## Overview

Three utility scripts centralize the IPD gate check logic that was previously duplicated across skill files. Run them from the repository root.

## detect-ipd-mode

Check whether the project has IPD mode activated:

```powershell
# PowerShell
.specify/scripts/powershell/gate-detect-ipd-mode.ps1
.specify/scripts/powershell/gate-detect-ipd-mode.ps1 -Json
```

**Output** (normal):
```
IPD mode: ACTIVE
```

**Output** (`-Json`):
```json
{"ipd_mode": true}
```

## check-gate

Validate whether a specific TR gate has passed:

```powershell
# Check TR1 (also validates TR0)
.specify/scripts/powershell/gate-check.ps1 -Gate TR1

# Machine-readable output
.specify/scripts/powershell/gate-check.ps1 -Gate TR2_TR3 -Json
```

**Output** (`-Json`):
```json
{"gate":"TR2_TR3","status":"passed","prior_gates":[...],"current_gate":{...},"errors":[]}
```

## record-gate

Record a gate decision with evidence:

```powershell
.specify/scripts/powershell/gate-record.ps1 -Gate TR1 -Status passed -Evidence "Spec created with TR Gate Assessment"
```

## Usage in Skill Files

After refactoring, skill files use these utilities instead of inline logic:

```markdown
## IPD Gate Check
1. **Detect mode**: `EXECUTE_COMMAND: .specify/scripts/powershell/gate-detect-ipd-mode.ps1 -Json`
2. **Check gate**: `EXECUTE_COMMAND: .specify/scripts/powershell/gate-check.ps1 -Gate TR1 -Json`
3. **Record gate**: `EXECUTE_COMMAND: .specify/scripts/powershell/gate-record.ps1 -Gate TR1 -Status passed -Evidence "..."` 
```

## Gate Reference

| Gate | Command | Check |
|------|---------|-------|
| TR0 | `check-gate TR0` | Constitution + Gate Criteria Reference |
| TR1 | `check-gate TR1` | Spec + TR Gate Assessment |
| TR2_TR3 | `check-gate TR2_TR3` | Plan + Gate Readiness |
| TR4 | `check-gate TR4` | Tasks + Gate Completion Verification |
| TR4A | `check-gate TR4A` | Tasks checkbox completion |
| TR5 | `check-gate TR5` | All prior gates passed in gate-status.json |
