#!/usr/bin/env pwsh
# gate-check.ps1 — Validate whether a specific TR gate has passed
# Usage: .specify/scripts/powershell/gate-check.ps1 -Gate TR1 [-Json]
# Returns structured JSON: {gate, status, prior_gates, current_gate, errors}

param(
    [Parameter(Mandatory = $true)][string]$Gate,
    [string]$FeatureDir,
    [switch]$Json
)

. "$PSScriptRoot/gate-common.ps1"

$repoRoot = Get-RepoRoot
$errors = @()
$priorGates = @()

# Validate gate ID
if (-not (Test-ValidGateId $Gate)) {
    $errors += "Invalid gate ID: $Gate. Valid: TR0, TR1, TR2_TR3, TR4, TR4A, TR5, TR6"
    $result = @{ gate = $Gate; status = "failed"; prior_gates = @(); current_gate = $null; errors = $errors }
    Write-GateJson $result -Json:$Json
    exit 1
}

# Resolve file paths — use -FeatureDir override if provided, otherwise read .specify/feature.json
if ($FeatureDir) {
    $featureDir = if (Test-Path $FeatureDir -PathType Container) { $FeatureDir } else { Join-Path $repoRoot $FeatureDir }
} else {
    $featureDir = & {
        $fj = Join-Path $repoRoot '.specify/feature.json'
        if (Test-Path $fj) { $fc = Get-Content $fj -Raw | ConvertFrom-Json; if ($fc.feature_directory) { Join-Path $repoRoot $fc.feature_directory } else { $null } } else { $null }
    }
}

$constitution = Join-Path $repoRoot '.specify/memory/constitution.md'
$spec = if ($featureDir) { Join-Path $featureDir 'spec.md' } else { $null }
$plan = if ($featureDir) { Join-Path $featureDir 'plan.md' } else { $null }
$tasks = if ($featureDir) { Join-Path $featureDir 'tasks.md' } else { $null }

# ============================================================
# Depth Validation — checks Must-Meet content patterns per gate
# Returns array of MustMeetResult objects:
#   { criterion (string), pattern (string), matched (bool), artifact_path (string) }
# ============================================================
function Test-DepthValidation {
    param(
        [Parameter(Mandatory = $true)][string]$GateId,
        [Parameter(Mandatory = $true)][string]$Path,
        [double]$Threshold = 1.0
    )

    $results = @()
    $artifactExists = Test-Path -LiteralPath $Path -PathType Leaf

    switch ($GateId) {
        "TR0" {
            # TR0 has no Must-Meet content patterns defined
        }
        "TR1" {
            $results += @{criterion="User Story Present"; pattern="### User Story|### User Story \d+"; matched=($artifactExists -and (Test-FileContains $Path "### User Story|### User Story \d+")); artifact_path=$Path}
            $results += @{criterion="Given/When/Then Format"; pattern="Given.*When.*Then"; matched=($artifactExists -and (Test-FileContains $Path "Given.*When.*Then")); artifact_path=$Path}
            $results += @{criterion="TR Gate Assessment"; pattern="TR Gate Assessment"; matched=($artifactExists -and (Test-FileContains $Path "TR Gate Assessment")); artifact_path=$Path}
            $results += @{criterion="Feasibility/Risk Assessment"; pattern="Feasibility|Risk Register"; matched=($artifactExists -and (Test-FileContains $Path "Feasibility|Risk Register")); artifact_path=$Path}
        }
        "TR2_TR3" {
            $results += @{criterion="Gate Readiness"; pattern="Gate Readiness"; matched=($artifactExists -and (Test-FileContains $Path "Gate Readiness")); artifact_path=$Path}
            $results += @{criterion="Architecture/Data/API Contract"; pattern="Architecture Decision|Data Model|API Contract|Contracts"; matched=($artifactExists -and (Test-FileContains $Path "Architecture Decision|Data Model|API Contract|Contracts")); artifact_path=$Path}
            $results += @{criterion="Constitution/WSJF Check"; pattern="Constitution Check|WSJF"; matched=($artifactExists -and (Test-FileContains $Path "Constitution Check|WSJF")); artifact_path=$Path}
        }
        "TR4" {
            $results += @{criterion="Task IDs Present"; pattern="- \[.\] T\d{3,4}"; matched=($artifactExists -and (Test-FileContains $Path "- \[.\] T\d{3,4}")); artifact_path=$Path}
            $results += @{criterion="Gate Completion Verification"; pattern="Gate Completion Verification"; matched=($artifactExists -and (Test-FileContains $Path "Gate Completion Verification")); artifact_path=$Path}
            $results += @{criterion="Phase Definition"; pattern="Phase \d+|Phase 0|Phase 1"; matched=($artifactExists -and (Test-FileContains $Path "Phase \d+|Phase 0|Phase 1")); artifact_path=$Path}
            $results += @{criterion="Definition of Done"; pattern="Definition of Done|DoD"; matched=($artifactExists -and (Test-FileContains $Path "Definition of Done|DoD")); artifact_path=$Path}
        }
        "TR4A" {
            # Completed tasks pattern
            $results += @{criterion="Completed Tasks Present"; pattern="- \[[xX]\] T\d{3,4}"; matched=($artifactExists -and (Test-FileContains $Path "- \[[xX]\] T\d{3,4}")); artifact_path=$Path}
            # Completion ratio >= threshold
            $ratio = 0.0
            if ($artifactExists) {
                $total = 0; $completed = 0
                Get-Content $Path | ForEach-Object {
                    if ($_ -match '^\s*-\s+\[\s*\]\s+T\d{3,4}') { $total++ }
                    if ($_ -match '^\s*-\s+\[[xX]\]\s+T\d{3,4}') { $completed++; $total++ }
                }
                if ($total -gt 0) { $ratio = $completed / $total }
            }
            $results += @{criterion="Task Completion Ratio >= $Threshold"; pattern="completion_ratio: $ratio >= $Threshold"; matched=($ratio -ge $Threshold); artifact_path=$Path}
            # Quality documentation
            $results += @{criterion="Quality Documentation"; pattern="Quality Summary|Quality Report"; matched=($artifactExists -and (Test-FileContains $Path "Quality Summary|Quality Report")); artifact_path=$Path}
        }
        "TR5" {
            # Prior gates check (TR0-TR4A)
            $gs = Get-GateStatus
            $priorAllPassed = $false
            $gsPath = "gate-status.json"
            if ($gs) {
                $failedPrior = @()
                @('TR0','TR1','TR2_TR3','TR4','TR4A') | ForEach-Object {
                    if ($gs.gates.$_.status -ne 'passed') { $failedPrior += $_ }
                }
                $priorAllPassed = ($failedPrior.Count -eq 0)
                $resolvedGsPath = Get-RepoRelativePath '.specify/memory/gate-status.json'
                if ($resolvedGsPath -and (Test-Path $resolvedGsPath)) { $gsPath = $resolvedGsPath }
            }
            $results += @{criterion="All Prior Gates Passed"; pattern="TR0-TR4A passed in gate-status.json"; matched=$priorAllPassed; artifact_path=$gsPath}
            # Cross-artifact consistency
            $results += @{criterion="Cross-artifact Consistency"; pattern="Cross-artifact|Consistency|Analyze"; matched=($artifactExists -and (Test-FileContains $Path "Cross-artifact|Consistency|Analyze")); artifact_path=$Path}
            # Test/Validation evidence
            $results += @{criterion="Test/Validation Evidence"; pattern="Test Report|Validation|Verification"; matched=($artifactExists -and (Test-FileContains $Path "Test Report|Validation|Verification")); artifact_path=$Path}
        }
        "TR6" {
            # Prior gates check (TR0-TR5)
            $gs = Get-GateStatus
            $priorAllPassed = $false
            $gsPath = "gate-status.json"
            if ($gs) {
                $failedPrior = @()
                @('TR0','TR1','TR2_TR3','TR4','TR4A','TR5') | ForEach-Object {
                    if ($gs.gates.$_.status -ne 'passed') { $failedPrior += $_ }
                }
                $priorAllPassed = ($failedPrior.Count -eq 0)
                $resolvedGsPath = Get-RepoRelativePath '.specify/memory/gate-status.json'
                if ($resolvedGsPath -and (Test-Path $resolvedGsPath)) { $gsPath = $resolvedGsPath }
            }
            $results += @{criterion="All Prior Gates Passed"; pattern="TR0-TR5 passed in gate-status.json"; matched=$priorAllPassed; artifact_path=$gsPath}
            # Deployment verification
            $results += @{criterion="Deployment Verification"; pattern="Deployment Verif|Deploy.*verified|Release Notes"; matched=($artifactExists -and (Test-FileContains $Path "Deployment Verif|Deploy.*verified|Release Notes")); artifact_path=$Path}
            # Ops handover
            $results += @{criterion="Ops Handover"; pattern="Ops Handover|Operations.*Handover|Operational Readiness"; matched=($artifactExists -and (Test-FileContains $Path "Ops Handover|Operations.*Handover|Operational Readiness")); artifact_path=$Path}
        }
    }

    return $results
}

# ============================================================
# Should-Meet Evaluation — checks Should-Meet criteria per gate
# Returns array of ShouldMeetResult objects:
#   { criterion (string), status ("met"|"not_met"|"not_assessed"), score (string|null) }
# ============================================================
function Test-ShouldMeet {
    param(
        [Parameter(Mandatory = $true)][string]$GateId,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $results = @()
    $artifactExists = Test-Path -LiteralPath $Path -PathType Leaf

    switch ($GateId) {
        "TR1" {
            $found = $artifactExists -and (Test-FileContains $Path "Market attractiveness|Market.*score")
            $results += @{criterion="Market Attractiveness Score"; status=if($found){"met"}else{"not_assessed"}; score=$null}
        }
        "TR2_TR3" {
            $found = $artifactExists -and (Test-FileContains $Path "Effort variance|variance.*15")
            $results += @{criterion="Effort Variance within 15%"; status=if($found){"met"}else{"not_assessed"}; score=$null}
        }
        "TR4" {
            $found = $artifactExists -and (Test-FileContains $Path "Velocity|velocity variance")
            $results += @{criterion="Velocity Variance Tracked"; status=if($found){"met"}else{"not_assessed"}; score=$null}
        }
        "TR5" {
            $found = $artifactExists -and (Test-FileContains $Path "NPS|Beta.*feedback|beta NPS")
            $results += @{criterion="Beta NPS / Feedback"; status=if($found){"met"}else{"not_assessed"}; score=$null}
        }
        "TR6" {
            $found = $artifactExists -and (Test-FileContains $Path "Training.*pass|Training.*100")
            $results += @{criterion="Training Pass Rate 100%"; status=if($found){"met"}else{"not_assessed"}; score=$null}
        }
        default {
            $results += @{criterion="No Should-Meet criteria for $GateId"; status="not_assessed"; score=$null}
        }
    }

    return $results
}

# Helper: check a single gate and return {gate, status, evidence, errors?}
function Check-TR0 {
    $errs = @()
    $evidence = $null
    if (-not (Test-Path $constitution)) { $errs += "Constitution not found at $constitution" }
    elseif (-not (Test-FileContains $constitution "Gate Criteria Reference")) { $errs += "Constitution missing 'Gate Criteria Reference' section" }
    else { $evidence = "Constitution exists with Gate Criteria Reference section" }

    $mmDetails = @()
    $depthValidated = $true

    return @{ gate = "TR0"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs; must_meet_details = $mmDetails; depth_validated = $depthValidated }
}

function Check-TR1 {
    $errs = @()
    $evidence = $null
    if (-not $spec) { $errs += "No feature directory found — run /vipd-specify first" }
    elseif (-not (Test-Path $spec)) { $errs += "Spec not found at $spec" }
    elseif (-not (Test-FileContains $spec "TR Gate Assessment")) { $errs += "Spec missing 'TR Gate Assessment' section" }
    else { $evidence = "Spec exists with TR Gate Assessment section" }

    $mmDetails = @()
    if ($spec -and (Test-Path $spec)) {
        $mmDetails = Test-DepthValidation -GateId "TR1" -Path $spec
    }
    $depthValidated = ($mmDetails.Count -eq 0) -or (($mmDetails | Where-Object { -not $_.matched }).Count -eq 0)

    return @{ gate = "TR1"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs; must_meet_details = $mmDetails; depth_validated = $depthValidated }
}

function Check-TR2_TR3 {
    $errs = @()
    $evidence = $null
    if (-not $plan) { $errs += "No feature directory found" }
    elseif (-not (Test-Path $plan)) { $errs += "Plan not found at $plan" }
    elseif (-not (Test-FileContains $plan "Gate Readiness")) { $errs += "Plan missing 'Gate Readiness' section" }
    else { $evidence = "Plan exists with Gate Readiness section" }

    $mmDetails = @()
    if ($plan -and (Test-Path $plan)) {
        $mmDetails = Test-DepthValidation -GateId "TR2_TR3" -Path $plan
    }
    $depthValidated = ($mmDetails.Count -eq 0) -or (($mmDetails | Where-Object { -not $_.matched }).Count -eq 0)

    return @{ gate = "TR2_TR3"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs; must_meet_details = $mmDetails; depth_validated = $depthValidated }
}

function Check-TR4 {
    $errs = @()
    $evidence = $null
    if (-not $tasks) { $errs += "No feature directory found" }
    elseif (-not (Test-Path $tasks)) { $errs += "Tasks not found at $tasks" }
    elseif (-not (Test-FileContains $tasks "Gate Completion Verification")) { $errs += "Tasks missing 'Gate Completion Verification' checkpoint" }
    else { $evidence = "Tasks exist with Gate Completion Verification checkpoint" }

    $mmDetails = @()
    if ($tasks -and (Test-Path $tasks)) {
        $mmDetails = Test-DepthValidation -GateId "TR4" -Path $tasks
    }
    $depthValidated = ($mmDetails.Count -eq 0) -or (($mmDetails | Where-Object { -not $_.matched }).Count -eq 0)

    return @{ gate = "TR4"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs; must_meet_details = $mmDetails; depth_validated = $depthValidated }
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

    $mmDetails = @()
    if ($tasks -and (Test-Path $tasks)) {
        $mmDetails = Test-DepthValidation -GateId "TR4A" -Path $tasks
    }
    $depthValidated = ($mmDetails.Count -eq 0) -or (($mmDetails | Where-Object { -not $_.matched }).Count -eq 0)

    return @{ gate = "TR4A"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs; must_meet_details = $mmDetails; depth_validated = $depthValidated }
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

    $mmDetails = @()
    if ($tasks -and (Test-Path $tasks)) {
        $mmDetails = Test-DepthValidation -GateId "TR5" -Path $tasks
    }
    $depthValidated = ($mmDetails.Count -eq 0) -or (($mmDetails | Where-Object { -not $_.matched }).Count -eq 0)

    return @{ gate = "TR5"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs; must_meet_details = $mmDetails; depth_validated = $depthValidated }
}

function Check-TR6 {
    $errs = @()
    $evidence = $null

    # Check prior gates (TR0 through TR5)
    $gs = Get-GateStatus
    if (-not $gs) { $errs += "Gate status file not found or corrupt" }
    else {
        $failedGates = @()
        @('TR0','TR1','TR2_TR3','TR4','TR4A','TR5') | ForEach-Object {
            if ($gs.gates.$_.status -ne 'passed') { $failedGates += $_ }
        }
        if ($failedGates.Count -gt 0) {
            $errs += "Prior gates not all passed: $($failedGates -join ', ')"
        }
    }

    # Collect candidate artifacts for content scanning
    $artifacts = @()
    if ($spec -and (Test-Path $spec)) { $artifacts += $spec }
    if ($tasks -and (Test-Path $tasks)) { $artifacts += $tasks }
    $primaryArtifact = if ($artifacts.Count -gt 0) { $artifacts[0] } else { $null }

    # Must-Meet: Test-DepthValidation
    $mmDetails = @()
    if ($primaryArtifact) {
        $mmDetails = Test-DepthValidation -GateId "TR6" -Path $primaryArtifact
    }
    $depthValidated = ($mmDetails.Count -eq 0) -or (($mmDetails | Where-Object { -not $_.matched }).Count -eq 0)

    # Should-Meet: Test-ShouldMeet
    $shouldMeetResults = @()
    if ($primaryArtifact) {
        $shouldMeetResults = Test-ShouldMeet -GateId "TR6" -Path $primaryArtifact
    }

    # Build evidence summary string
    $matchedMustMeet = ($mmDetails | Where-Object { $_.matched }).Count
    $evidence = "Must-Meet: depth_validated=$depthValidated ($matchedMustMeet/$($mmDetails.Count) patterns matched)"
    if ($shouldMeetResults.Count -gt 0) {
        $metCount = ($shouldMeetResults | Where-Object { $_.status -eq "met" }).Count
        $evidence += " | Should-Meet: $metCount/$($shouldMeetResults.Count) criteria met"
    }

    return @{ gate = "TR6"; status = if ($errs.Count -eq 0) { "passed" } else { "failed" }; evidence = $evidence; errors = $errs; must_meet_details = $mmDetails; depth_validated = $depthValidated; should_meet = $shouldMeetResults }
}

# Gate ordering for recursive check
$gateOrder = @('TR0', 'TR1', 'TR2_TR3', 'TR4', 'TR4A', 'TR5', 'TR6')
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

# Compute Should-Meet for the requested gate
$shouldMeetArtifact = $null
switch ($Gate) {
    "TR0" { $shouldMeetArtifact = $constitution }
    "TR1" { $shouldMeetArtifact = $spec }
    "TR2_TR3" { $shouldMeetArtifact = $plan }
    "TR4" { $shouldMeetArtifact = $tasks }
    "TR4A" { $shouldMeetArtifact = $tasks }
    "TR5" { $shouldMeetArtifact = $tasks }
    "TR6" { $shouldMeetArtifact = if ($spec -and (Test-Path $spec)) { $spec } elseif ($tasks -and (Test-Path $tasks)) { $tasks } else { $null } }
}
$shouldMeetResults = @()
if ($shouldMeetArtifact -and (Test-Path $shouldMeetArtifact)) {
    $shouldMeetResults = Test-ShouldMeet -GateId $Gate -Path $shouldMeetArtifact
}

$output = @{
    gate = $Gate
    status = $overallStatus
    prior_gates = $priorGates
    current_gate = $currentGate
    errors = $errors
    should_meet = $shouldMeetResults
}

Write-GateJson $output -Json:$Json
if ($overallStatus -eq "failed") { exit 1 }
exit 0
