#!/usr/bin/env pwsh
# gate-record.ps1 — Record gate status with audit trail
# Usage: .specify/scripts/powershell/gate-record.ps1 -Gate TR1 -Status passed -Evidence "Spec created"
#        .specify/scripts/powershell/gate-record.ps1 -Gate TR5 -Status passed -Evidence "Demo complete" -Decision Go -DecisionMaker "PDT" -DecisionRationale "Meets all criteria"
# Features: audit trail (FR-025), prerequisite validation (FR-013), per-feature isolation (FR-003b)

param(
    [Parameter(Mandatory = $true)][string]$Gate,
    [Parameter(Mandatory = $true)][string]$Status,
    [Parameter(Mandatory = $true)][string]$Evidence,
    [string]$Decision = '',
    [string]$DecisionMaker = '',
    [string]$DecisionRationale = '',
    [string]$DeferredItemsPath = '',  # NEW: path to write deferred-items.json (for conditional-pass)
    [string]$DeferredOrigin = '',     # NEW: originating gate for deferred items
    [switch]$Json
)

. "$PSScriptRoot/gate-common.ps1"
. "$PSScriptRoot/_gate_helpers.ps1"

$errors = @()

# Validate inputs
if (-not (Test-ValidGateId $Gate)) { $errors += "Invalid gate: $Gate" }
if (-not (Test-ValidGateStatus $Status)) { $errors += "Invalid status: $Status. Use: passed, pending, failed, skipped, hold, recycled" }
if ($Decision -and -not (Test-ValidGateDecision $Decision)) { $errors += "Invalid decision: $Decision. Use: Go, Kill, Hold, Recycle" }
if ($Evidence.Length -gt 2000) { $Evidence = $Evidence.Substring(0, 1997) + "..." }

if ($errors.Count -gt 0) {
    Write-GateJson @{ gate = $Gate; status = "error"; errors = $errors } -Json:$Json
    exit 1
}

# Determine file path using Get-FeatureGateStatusPath (FR-003b)
$repoRoot = Get-RepoRoot
if (-not $repoRoot) { Write-Error "Not in a spec-kit project"; exit 1 }

$gateFile = Get-FeatureGateStatusPath -LegacyFallback
$gateDir = Split-Path $gateFile -Parent

# Ensure directory exists
if (-not (Test-Path $gateDir)) { New-Item -ItemType Directory -Path $gateDir -Force | Out-Null }

# Read existing gate-status.json from the resolved path (handles per-feature isolation)
$gs = $null
if (Test-Path $gateFile) {
    try {
        $gs = Get-Content -LiteralPath $gateFile -Raw | ConvertFrom-Json
    } catch {
        $gs = $null
    }
}

# Create default skeleton if file doesn't exist
if (-not $gs) {
    $gs = @{
        ipd_mode = $null -ne (Get-RepoRelativePath '.specify/memory/constitution.md')
        last_updated = $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
        gates = @{
            TR0    = @{ status = "pending"; evidence = $null; date = $null }
            TR1    = @{ status = "pending"; evidence = $null; date = $null }
            TR2_TR3 = @{ status = "pending"; evidence = $null; date = $null }
            TR4    = @{ status = "pending"; evidence = $null; date = $null }
            TR4A   = @{ status = "pending"; evidence = $null; date = $null }
            TR5    = @{ status = "pending"; evidence = $null; date = $null }
            TR6    = @{ status = "pending"; evidence = $null; date = $null }
        }
    }
}

# ---------------------------------------------------------------------------
# Write-GateEntry — Append audit-trail entry and update gate main fields
# ---------------------------------------------------------------------------
function Write-GateEntry {
    param(
        $GateStatus,
        [Parameter(Mandatory = $true)][string]$GateId,
        [Parameter(Mandatory = $true)][string]$NewStatus,
        [string]$NewEvidence = '',
        [string]$Decision = '',
        [string]$DecisionMaker = '',
        [string]$DecisionRationale = ''
    )

    $isoDate = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')

    $gateObj = $GateStatus.gates.$GateId
    $prevStatus = if ($gateObj) { $gateObj.status } else { $null }

    # Ensure the gate entry exists (handle both PSCustomObject and hashtable)
    if (-not $gateObj) {
        $newGate = @{ status = $null; evidence = $null; date = $null }
        if ($GateStatus.gates -is [hashtable]) {
            $GateStatus.gates[$GateId] = $newGate
        } else {
            $GateStatus.gates | Add-Member -NotePropertyName $GateId -NotePropertyValue $newGate -Force
        }
        $gateObj = $GateStatus.gates.$GateId
    }

    # Build history entry
    $historyEntry = @{
        from     = $prevStatus
        to       = $NewStatus
        date     = $isoDate
        evidence = $NewEvidence
    }

    # Ensure history array exists on this gate, then append
    if (-not $gateObj.history) {
        if ($gateObj -is [hashtable]) {
            $gateObj.history = @($historyEntry)
        } else {
            $gateObj | Add-Member -NotePropertyName 'history' -NotePropertyValue @($historyEntry) -Force
        }
    } else {
        $gateObj.history += $historyEntry
    }

    # Update main fields
    $gateObj.status   = $NewStatus
    $gateObj.evidence = $NewEvidence
    $gateObj.date     = $isoDate

    # Add decision fields if provided (FR-025)
    if ($Decision) {
        if ($gateObj -is [hashtable]) {
            $gateObj.decision           = $Decision
            $gateObj.decision_maker     = $DecisionMaker
            $gateObj.decision_rationale = $DecisionRationale
        } else {
            $gateObj | Add-Member -NotePropertyName 'decision'           -NotePropertyValue $Decision           -Force
            $gateObj | Add-Member -NotePropertyName 'decision_maker'     -NotePropertyValue $DecisionMaker       -Force
            $gateObj | Add-Member -NotePropertyName 'decision_rationale' -NotePropertyValue $DecisionRationale   -Force
        }
    }
}

# ---------------------------------------------------------------------------
# Validate gate order before recording (FR-013)
# ---------------------------------------------------------------------------

# Build a simple hashtable of gate -> status for Test-GateOrder
$currentStatusHash = @{}
foreach ($g in (Get-GateOrder)) {
    if ($gs.gates.$g) {
        $currentStatusHash[$g] = $gs.gates.$g.status
    }
}

$orderCheck = Test-GateOrder -GateId $Gate -CurrentStatus $currentStatusHash
if (-not $orderCheck.Valid) {
    Write-GateJson @{
        gate   = $Gate
        status = "error"
        errors = @($orderCheck.Message)
    } -Json:$Json
    exit 1
}

# ---------------------------------------------------------------------------
# Record the gate entry with audit trail
# ---------------------------------------------------------------------------

$entryParams = @{
    GateStatus  = $gs
    GateId      = $Gate
    NewStatus   = $Status
    NewEvidence = $Evidence
}
if ($Decision)          { $entryParams.Decision          = $Decision }
if ($DecisionMaker)     { $entryParams.DecisionMaker     = $DecisionMaker }
if ($DecisionRationale) { $entryParams.DecisionRationale = $DecisionRationale }

# Capture previous status before writing for audit log
$prevStatusForAudit = if ($gs.gates.$Gate) { $gs.gates.$Gate.status } else { $null }

Write-GateEntry @entryParams

# ============================================================
# JSONL detailed gate recording (Feature 019)
# ============================================================
$jsonlDir = Join-Path $repoRoot '.specify/memory'
$jsonlFile = Join-Path $jsonlDir 'gate-history.jsonl'
$jsonlTimestamp = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
if (-not $featureName -or $featureName -eq 'unknown') {
    if ($featureDir) { $featureName = Split-Path $featureDir -Leaf }
}
$jsonlRecord = @{
    timestamp = $jsonlTimestamp
    gate = $Gate
    feature = $featureName
    status = $Status
    conditions = @()
    attempt = 1
    max_attempts = 3
    auto_fix_attempted = ($Status -eq 'failed' -or $Status -eq 'degraded')
    auto_fix = $null
    evidence = $Evidence
}
# Attempt to read conditions from gate-check output (if available via pipeline)
$checkOutput = $env:GATE_CHECK_JSON
if ($checkOutput) {
    try { $jsonlRecord.conditions = ($checkOutput | ConvertFrom-Json).current_gate.must_meet_details } catch {}
}
# Append JSONL line
try {
    $jsonlRecord | ConvertTo-Json -Compress -Depth 3 | Add-Content -LiteralPath $jsonlFile -Encoding UTF8
} catch {
    Write-Warning "Failed to write gate-history.jsonl: $_"
}

# ============================================================
# Audit log entry for all gate status changes (T025)
# ============================================================
# Determine feature name from gateFile path
$featureName = 'unknown'
if ($gateFile) {
    $gateDirName = Split-Path (Split-Path $gateFile -Parent) -Leaf
    if ($gateDirName -match '^\d{3}-|specs') {
        $featureName = Split-Path (Split-Path $gateFile -Parent) -Leaf
    } elseif ($gateDirName -eq 'memory') {
        $featureName = 'shared'
    }
}
Write-AuditLog -EventType "gate_verdict" -Feature $featureName -Gate $Gate `
    -FromState $prevStatusForAudit -ToState $Status -Rationale $Evidence

# ============================================================
# Handle conditional-pass: write deferred-items.json
# ============================================================
if ($Status -eq 'conditional-pass' -and $DeferredItemsPath) {
    $deferredDir = Split-Path $DeferredItemsPath -Parent
    if (-not (Test-Path $deferredDir)) {
        New-Item -ItemType Directory -Path $deferredDir -Force | Out-Null
    }

    $origin = if ($DeferredOrigin) { $DeferredOrigin } else { $Gate }
    $item = @{
        criterion_id       = ''
        originating_gate   = $origin
        target_gate        = 'TR4'
        owner              = 'LPDT'
        due_by_phase       = 'Development'
        status             = 'deferred'
        justification      = $Evidence
        deferred_at        = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
    }

    # Use Set-DeferredItems from _gate_helpers.ps1
    try {
        Set-DeferredItems -FeatureDir $deferredDir -Items @($item) -OriginatingGate $origin
    } catch {
        $errors += "Failed to write deferred-items.json: $_"
    }

    # Log audit entry for deferred creation
    Write-AuditLog -EventType "gate_criteria_status_change" -Feature (Split-Path $deferredDir -Leaf) -Gate $Gate `
        -Rationale "Deferred items created via conditional-pass verdict"
}

$gs.last_updated = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')

# Atomic write: temp file -> rename
$tmpFile = [System.IO.Path]::GetTempFileName()
try {
    $gs | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $tmpFile -Encoding UTF8
    Copy-Item -LiteralPath $tmpFile -Destination $gateFile -Force
    Remove-Item -LiteralPath $tmpFile -Force
} catch {
    Write-Error "Failed to write gate status: $_"
    if (Test-Path $tmpFile) { Remove-Item $tmpFile -Force }
    exit 1
}

# Output summary with all fields (history, decision, etc.)
Write-GateJson $gs -Json:$Json
exit 0
