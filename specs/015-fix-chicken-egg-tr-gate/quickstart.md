# Quickstart: Fix TR Gate Chicken-Egg Dependency

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md) | **Spec**: [spec.md](spec.md)

## Implementation Steps

### Step 1: Create `.specify/gates/tr-criteria.yml`

Define the initial gate criteria with phase ownership. Based on the constitution's Gate Criteria Reference:

```yaml
gate_criteria:
  # --- TR2/TR3: Plan & Design ---
  - id: "TR2-MM-001"
    gate: "TR2/TR3"
    type: "Must-Meet"
    title: "Architecture reviewed"
    owning_phase: "Plan"
    description: "Architecture design has been reviewed and approved by the System Architect"
    depends_on: []
    validation_hint: "Confirm architecture review meeting minutes or approval in plan.md"

  - id: "TR2-MM-002"
    gate: "TR2/TR3"
    type: "Must-Meet"
    title: "Dependencies locked"
    owning_phase: "Plan"
    description: "All external and cross-team dependencies are identified and committed"
    depends_on: ["TR2-MM-001"]
    validation_hint: "Check that dependency list in plan.md has committed owners/dates"

  - id: "TR2-SM-001"
    gate: "TR2/TR3"
    type: "Should-Meet"
    title: "Effort variance < 15%"
    owning_phase: "Task"
    description: "Effort estimates are within 15% of actuals"
    depends_on: ["TR2-MM-001"]
    validation_hint: "Compare estimated vs actual task hours after task generation"
```

**Note**: These are the initial criteria derived from the constitution. Teams may add more as needed.

---

### Step 2: Extend `gate-check.ps1`

Modify `gate-check.ps1` to:

**2a. Support `--check-cycles` flag:**
```powershell
param(
    [string]$Gate,
    [switch]$Json,
    [switch]$CheckCycles  # NEW
)
```

**2b. Add phase-scoped validation:**
- When `-Gate TR2_TR3` runs without `--check-cycles`, only evaluate criteria whose `owning_phase` matches the current phase context
- Load `tr-criteria.yml` to determine ownership
- Accept a `-Context Phase` parameter: `Plan` or `Task`

**2c. Implement DFS cycle detection:**
```powershell
function Test-CyclicDependency {
    param([array]$Criteria)
    # Build adjacency map from depends_on fields
    # Run DFS with visiting/visited tracking
    # Return @{ HasCycles = $true; Cycles = @(@("A","B","C")) }
}
```

**2d. Return cycle info in JSON output:**
```powershell
# Existing output plus:
"cycles_detected": @(@("TR2-MM-002", "TR2-MM-001"))
```

---

### Step 3: Extend `gate-record.ps1`

Modify `gate-record.ps1` to:

**3a. Accept new verdicts:**
```powershell
param(
    [string]$Gate,
    [string]$Status,  # Now accepts: passed, conditional-pass, failed, recycle
    [string]$Evidence,
    [string]$DeferredItemsPath  # NEW: path to deferred-items.json
)
```

**3b. Create/update `deferred-items.json`:**
When verdict is `conditional-pass`, write deferred items to the per-feature file.

**3c. Write audit log entries:**
Append a JSON line to `.specify/gates/audit.log` for each significant state change:
```powershell
$entry = @{
    timestamp   = (Get-Date -Format "o")
    actor       = git config user.name
    event_type  = "gate_verdict"
    feature     = $feature
    gate        = $Gate
    from_state  = $null
    to_state    = $Status
    rationale   = $Evidence
}
Add-Content -Path ".specify/gates/audit.log" -Value ($entry | ConvertTo-Json -Compress)
```

---

### Step 4: Create `deferred-items.json` reader/writer functions

Add these helper functions to the gate script tooling:

```powershell
function Get-DeferredItems {
    param([string]$FeatureDir)
    $path = Join-Path $FeatureDir "deferred-items.json"
    if (Test-Path $path) {
        return Get-Content $path -Raw | ConvertFrom-Json
    }
    return $null
}

function Set-DeferredItems {
    param([string]$FeatureDir, [object]$Items)
    $path = Join-Path $FeatureDir "deferred-items.json"
    $Items | ConvertTo-Json -Depth 10 | Set-Content $path
}
```

---

### Step 5: Add audit logging to existing gate scripts

Add audit log calls at strategic points:

- `gate-record.ps1`: Log `gate_verdict` event on every status change
- `gate-check.ps1`: Log `gate_criteria_status_change` for each criterion evaluated
- Create a shared function:

```powershell
function Write-AuditLog {
    param([string]$EventType, [string]$Feature, [string]$Gate, [string]$CriterionId,
          [string]$FromState, [string]$ToState, [string]$Rationale)
    $entry = @{
        timestamp    = (Get-Date -Format "o")
        actor        = git config user.name
        event_type   = $EventType
        feature      = $Feature
        gate         = $Gate
        criterion_id = $CriterionId
        from_state   = $FromState
        to_state     = $ToState
        rationale    = $Rationale
    }
    $logPath = ".specify/gates/audit.log"
    Add-Content -Path $logPath -Value ($entry | ConvertTo-Json -Compress)
}
```

---

### Step 6: Update gate-status.json verdict support

Ensure `gate-status.json` accepts `"conditional-pass"` as a valid `status` value alongside `"passed"` and `"failed"`. The existing format is backward-compatible — new verdicts are additional enum values.

---

### Step 7: Validate schemas

Validate all new YAML/JSON files against their JSON Schemas:

```powershell
# Validate tr-criteria.yml (converted to JSON)
$criteria = Get-Content ".specify/gates/tr-criteria.yml" -Raw
# Parse YAML, convert to JSON, validate against tr-criteria.schema.json

# Validate deferred-items.json
$deferred = Get-Content "specs/NNN-feature/deferred-items.json" -Raw
# Validate against deferred-items.schema.json
```

## Verification Checklist

- [ ] `gate-check.ps1 --check-cycles` detects artificially introduced circular dependencies
- [ ] `gate-check.ps1 -Context Plan` only evaluates Plan-phase-owned criteria
- [ ] `gate-record.ps1 -Status conditional-pass` creates deferred-items.json
- [ ] Audit log entries appear in `.specify/gates/audit.log` after gate operations
- [ ] `gate-status.json` accepts and displays `conditional-pass` verdict
- [ ] Backward compatibility: existing `gate-status.json` entries unaffected
- [ ] All JSON Schemas validate their corresponding files
