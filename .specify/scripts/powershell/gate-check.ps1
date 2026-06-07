#!/usr/bin/env pwsh
# gate-check.ps1 — Validate whether a specific TR gate has passed
# Usage: .specify/scripts/powershell/gate-check.ps1 -Gate TR1 [-Json]
# Returns structured JSON: {gate, status, prior_gates, current_gate, errors}

param(
    [Parameter(Mandatory = $true)][string]$Gate,
    [switch]$Json
)

. "$PSScriptRoot/gate-common.ps1"

$repoRoot = Get-RepoRoot
$errors = @()
$priorGates = @()

# Validate gate ID
if (-not (Test-ValidGateId $Gate)) {
    $errors += "Invalid gate ID: $Gate. Valid: TR0, TR1, TR2_TR3, TR4, TR4A, TR5"
    $result = @{ gate = $Gate; status = "failed"; prior_gates = @(); current_gate = $null; errors = $errors }
    Write-GateJson $result -Json:$Json
    exit 1
}

# Resolve file paths
$constitution = Join-Path $repoRoot '.specify/memory/constitution.md'
$featureDir = & {
    $fj = Join-Path $repoRoot '.specify/feature.json'
    if (Test-Path $fj) { $fc = Get-Content $fj -Raw | ConvertFrom-Json; if ($fc.feature_directory) { Join-Path $repoRoot $fc.feature_directory } else { $null } } else { $null }
}
$spec = if ($featureDir) { Join-Path $featureDir 'spec.md' } else { $null }
$plan = if ($featureDir) { Join-Path $featureDir 'plan.md' } else { $null }
$tasks = if ($featureDir) { Join-Path $featureDir 'tasks.md' } else { $null }

# Helper: check a single gate and return {gate, status, evidence, errors?}
function Check-TR0 {
    $errs = @()
    $evidence = $null
    if (-not (Test-Path $constitution)) { $errs += "Constitution not found at $constitution" }
    elseif (-not (Test-FileContains $constitution "Gate Criteria Reference")) { $errs += "Constitution missing 'Gate Criteria Reference' section" }
    else { $evidence = "Constitution exists with Gate Criteria Reference section" }
    return @{ gate = "TR0"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs }
}

function Check-TR1 {
    $errs = @()
    $evidence = $null
    if (-not $spec) { $errs += "No feature directory found — run /vipd-specify first" }
    elseif (-not (Test-Path $spec)) { $errs += "Spec not found at $spec" }
    elseif (-not (Test-FileContains $spec "TR Gate Assessment")) { $errs += "Spec missing 'TR Gate Assessment' section" }
    else { $evidence = "Spec exists with TR Gate Assessment section" }
    return @{ gate = "TR1"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs }
}

function Check-TR2_TR3 {
    $errs = @()
    $evidence = $null
    if (-not $plan) { $errs += "No feature directory found" }
    elseif (-not (Test-Path $plan)) { $errs += "Plan not found at $plan" }
    elseif (-not (Test-FileContains $plan "Gate Readiness")) { $errs += "Plan missing 'Gate Readiness' section" }
    else { $evidence = "Plan exists with Gate Readiness section" }
    return @{ gate = "TR2_TR3"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs }
}

function Check-TR4 {
    $errs = @()
    $evidence = $null
    if (-not $tasks) { $errs += "No feature directory found" }
    elseif (-not (Test-Path $tasks)) { $errs += "Tasks not found at $tasks" }
    elseif (-not (Test-FileContains $tasks "Gate Completion Verification")) { $errs += "Tasks missing 'Gate Completion Verification' checkpoint" }
    else { $evidence = "Tasks exist with Gate Completion Verification checkpoint" }
    return @{ gate = "TR4"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs }
}

function Check-TR4A {
    $errs = @()
    $evidence = $null
    if (-not $tasks) { $errs += "No tasks found" }
    else {
        # Check tasks checkbox completion — count [x] vs total
        $total = 0; $completed = 0
        Get-Content $tasks | ForEach-Object {
            if ($_ -match '^\s*-\s+\[\s*\]\s+T\d{3}') { $total++ }
            if ($_ -match '^\s*-\s+\[[xX]\]\s+T\d{3}') { $completed++; $total++ }
        }
        if ($total -eq 0) { $errs += "No tasks found in tasks.md" }
        else { $evidence = "Tasks: $completed/$total completed" }
    }
    return @{ gate = "TR4A"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs }
}

function Check-TR5 {
    $errs = @()
    $evidence = $null
    $gs = Get-GateStatus
    if (-not $gs) { $errs += "Gate status file not found or corrupt" }
    else {
        $failedGates = @()
        @('TR0','TR1','TR2_TR3','TR4','TR4A') | ForEach-Object {
            if ($gs.gates.$_.status -ne 'passed') { $failedGates += $_ }
        }
        if ($failedGates.Count -gt 0) { $errs += "Prior gates not all passed: $($failedGates -join ', ')" }
        else { $evidence = "All prior gates passed in gate-status.json" }
    }
    return @{ gate = "TR5"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs }
}

# Gate ordering for recursive check
$gateOrder = @('TR0', 'TR1', 'TR2_TR3', 'TR4', 'TR4A', 'TR5')
$requestedIdx = [array]::IndexOf($gateOrder, $Gate)
if ($requestedIdx -lt 0) { $errors += "Unknown gate: $Gate"; exit 1 }

# Check all prior gates
$currentGate = $null
for ($i = 0; $i -le $requestedIdx; $i++) {
    $g = $gateOrder[$i]
    $result = & "Check-$g"
    if ($i -lt $requestedIdx) {
        $priorGates += $result
        if ($result.status -ne 'passed') { $errors += "$g failed: $($result.evidence)" }
    } else {
        $currentGate = $result
        if ($result.status -ne 'passed') { $errors += "$g failed: $($result.evidence)" }
    }
}

$overallStatus = if ($errors.Count -eq 0) { "passed" } else { "failed" }

$output = @{
    gate = $Gate
    status = $overallStatus
    prior_gates = $priorGates
    current_gate = $currentGate
    errors = $errors
}

Write-GateJson $output -Json:$Json
if ($overallStatus -eq "failed") { exit 1 }
exit 0
