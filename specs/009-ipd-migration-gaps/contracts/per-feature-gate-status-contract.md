# Contract: Per-Feature Gate Status Migration

**Feature**: 009-ipd-migration-gaps | **Date**: 2026-06-07

## Purpose

Defines the migration path from project-level `.specify/memory/gate-status.json` to per-feature `specs/NNN-feature-name/gate-status.json`, including backward compatibility, schema evolution, and the audit trail addition.

## Migration Strategy

### Phase 1: Dual-Path Read (Backward Compatible)

Both the old project-level and new per-feature paths are read. Resolution order:
1. Check `specs/NNN-feature-name/gate-status.json` (new per-feature path)
2. If not found, fall back to `.specify/memory/gate-status.json` (legacy path)
3. If neither exists, create a default per-feature file in the feature directory

### Phase 2: Migration Script

A one-time migration copies the project-level gate-status.json to the current active feature's per-feature path, then adds the `feature` field and `history` array to each gate entry.

### Phase 3: Deprecation Warning

After migration, the legacy path `.specify/memory/gate-status.json` still exists but is no longer read by the gate scripts. A deprecation warning is added if the legacy file is found.

## Gate Script Changes

### `gate-common.ps1` — New Functions

```powershell
function Get-FeatureGateStatusPath {
    <#
    .SYNOPSIS
    Returns the per-feature gate-status.json path.

    .DESCRIPTION
    Resolves the feature directory from .specify/feature.json, then returns
    the path to specs/NNN-feature-name/gate-status.json. Falls back to the
    legacy .specify/memory/gate-status.json if no feature directory is found.
    #>
    param(
        [switch]$LegacyFallback = $true
    )
    # ...
}

function Test-GateOrder {
    <#
    .SYNOPSIS
    Validates that gate recording follows the required order.

    .DESCRIPTION
    Checks that all prerequisite gates for the requested gate have status "passed"
    before allowing the recording. Returns $true if ordering is valid, $false otherwise.
    Implements FR-013: out-of-order recording is blocked.
    #>
    param(
        [string]$GateId,
        [hashtable]$CurrentGateStatus
    )
    # Gate dependency chain:
    # TR6 requires TR5
    # TR5 requires TR4A
    # TR4A requires TR4
    # TR4 requires TR2_TR3
    # TR2_TR3 requires TR1
    # TR1 requires TR0
}
```

### `gate-record.ps1` — Enhanced Functions

```powershell
function Write-GateEntry {
    <#
    .SYNOPSIS
    Writes a gate status entry with audit trail.

    .DESCRIPTION
    Instead of overwriting the previous status, appends a GateTransition
    to the history array. Implements FR-014: audit trail of gate status
    transitions.
    Implements FR-025: Go/Kill/Hold/Recycle decision recording.
    #>
    param(
        [string]$GateId,
        [string]$Status,        # passed, pending, failed, hold, recycled
        [string]$Evidence,
        [string]$Decision = "", # Go, Kill, Hold, Recycle
        [string]$DecisionMaker = "",
        [string]$DecisionRationale = ""
    )
    # Appends to history array, preserves previous entries
}
```

### `gate-check.ps1` — New Functions

```powershell
function Check-TR6 {
    <#
    .SYNOPSIS
    Validates TR6 (Launch) gate criteria.

    .DESCRIPTION
    Checks:
    1. All prior gates (TR0-TR5) have status "passed"
    2. Deployment verification evidence exists in spec or tasks
    3. Ops handover documentation exists

    Must-Meet: "Deployment verified, ops handover complete"
    Should-Meet: "Training pass rate = 100%"
    #>
}

function Test-DepthValidation {
    <#
    .SYNOPSIS
    Performs depth validation for a gate using regex patterns.

    .DESCRIPTION
    Implements FR-002: validates that key artifact sections contain
    recognizable content patterns, not just section headers.

    Returns a MustMeetResult array with criterion, pattern, matched, and artifact_path.
    #>
    param(
        [string]$GateId,
        [string]$ArtifactPath
    )
}
```

## Bash Script Changes

### `gate-check.sh` — Bug Fix

Lines 109-113: Remove the redundant first invocation of each check function. The correct code should be:

```bash
# BEFORE (buggy — double invocation):
result=$(check_$(echo "$g" | tr '[:upper:]' '[:lower:]' | tr '_' '_'))  # line 109 — DISCARD
# ... comments ...
fname="check_$(echo "$g" | tr '[:upper:]' '[:lower:]')"  # line 112
result=$($fname)  # line 113 — OVERWRITE

# AFTER (fixed — single invocation):
fname="check_$(echo "$g" | tr '[:upper:]' '[:lower:]')"
result=$($fname)
```

### `gate-record.sh` — New File

Create the missing Bash equivalent of `gate-record.ps1` with the same interface:
- `--gate GATE_ID` — Gate ID to record
- `--status STATUS` — Status value
- `--evidence EVIDENCE` — Evidence text
- `--json` — JSON output mode
- `--feature FEATURE_DIR` — Override feature directory

Output: same JSON structure as the PowerShell version.