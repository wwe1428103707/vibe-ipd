#!/usr/bin/env pwsh
# gate-check.ps1 — Validate whether a specific TR gate has passed
# Usage: .specify/scripts/powershell/gate-check.ps1 -Gate TR1 [-Json]
# Returns structured JSON: {gate, status, prior_gates, current_gate, errors}

param(
    [Parameter(Mandatory = $true)][string]$Gate,
    [string]$FeatureDir,
    [switch]$Json,
    [string]$Context = '',          # NEW: Phase context — 'Plan' or 'Task' for phase-scoped validation
    [string]$CriteriaConfig = '',   # NEW: Path to tr-criteria.yml (default: .specify/gates/tr-criteria.yml)
    [switch]$CheckCycles,           # NEW: Run cycle detection on criteria dependency graph
    [switch]$ValidateConfig         # NEW: Validate tr-criteria.yml against schema
)

. "$PSScriptRoot/gate-common.ps1"
. "$PSScriptRoot/_gate_helpers.ps1"

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

    # Enrich results with fix_hint (FR-001) and category (FR-010) — Feature 019
    $fixHintMap = @{
        "User Story Present" = @{action="ensure_content"; hint="Add ### User Story section with Given/When/Then"}
        "Given/When/Then Format" = @{action="ensure_content"; hint="Add acceptance scenarios using Given/When/Then"}
        "TR Gate Assessment" = @{action="ensure_content"; hint="Add TR Gate Assessment section"}
        "Feasibility/Risk Assessment" = @{action="ensure_content"; hint="Add Feasibility or Risk Register section"}
        "Gate Readiness" = @{action="ensure_content"; hint="Add Gate Readiness section"}
        "Architecture/Data/API Contract" = @{action="ensure_content"; hint="Add Architecture Decision or Data Model"}
        "Constitution/WSJF Check" = @{action="ensure_content"; hint="Add Constitution Check or WSJF"}
        "Task IDs Present" = @{action="ensure_content"; hint="Add sequential T001/T002 task IDs"}
        "Gate Completion Verification" = @{action="ensure_content"; hint="Add Gate Completion Verification checkpoint"}
        "Phase Definition" = @{action="ensure_content"; hint="Add Phase numbering"}
        "Definition of Done" = @{action="ensure_content"; hint="Add DoD section"}
        "Completed Tasks Present" = @{action="mark_tasks"; hint="Mark tasks with [x]"}
        "Task Completion Ratio" = @{action="mark_tasks"; hint="Complete remaining tasks"}
        "Quality Documentation" = @{action="ensure_content"; hint="Add Quality Summary section"}
        "All Prior Gates Passed" = @{action="run_gates"; hint="Pass prior TR gates"}
        "Cross-artifact Consistency" = @{action="ensure_content"; hint="Add consistency review"}
        "Test/Validation Evidence" = @{action="ensure_content"; hint="Add Test Report evidence"}
        "Deployment Verification" = @{action="ensure_content"; hint="Add Deployment Verification"}
        "Ops Handover" = @{action="ensure_content"; hint="Add Ops Handover section"}
    }
    $categoryMap = @{
        "User Story Present" = "documentation"; "Given/When/Then Format" = "documentation"
        "TR Gate Assessment" = "process"; "Feasibility/Risk Assessment" = "process"
        "Gate Readiness" = "documentation"; "Architecture/Data/API Contract" = "documentation"
        "Constitution/WSJF Check" = "process"; "Task IDs Present" = "documentation"
        "Gate Completion Verification" = "process"; "Phase Definition" = "documentation"
        "Definition of Done" = "process"; "Completed Tasks Present" = "code"
        "Task Completion Ratio" = "code"; "Quality Documentation" = "documentation"
        "All Prior Gates Passed" = "process"; "Cross-artifact Consistency" = "process"
        "Test/Validation Evidence" = "process"; "Deployment Verification" = "process"
        "Ops Handover" = "process"
    }
    $results = $results | ForEach-Object {
        $criterion = $_.criterion
        $obj = @{ criterion=$criterion; pattern=$_.pattern; matched=$_.matched; artifact_path=$_.artifact_path }
        if ($categoryMap.ContainsKey($criterion)) { $obj.category = $categoryMap[$criterion] }
        if (-not $_.matched -and $fixHintMap.ContainsKey($criterion)) { $obj.fix_hint = $fixHintMap[$criterion] }
        [PSCustomObject]$obj
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

# ============================================================
# Cycle Detection — DFS-based algorithm for --check-cycles
# Returns @{ HasCycles = bool; Cycles = string[][]; Error = string }
# ============================================================
function Test-CyclicDependency {
    param([array]$Criteria)

    if ($Criteria.Count -eq 0) {
        return @{ HasCycles = $false; Cycles = @(); Error = '' }
    }

    # Build adjacency map: id -> depends_on array
    $adj = @{}
    $idSet = @{}
    foreach ($c in $Criteria) {
        $id = if ($c.id) { $c.id } else { '' }
        if ($id) {
            $adj[$id] = if ($c.depends_on) { @($c.depends_on) } else { @() }
            $idSet[$id] = $true
        }
    }

    if ($idSet.Keys.Count -eq 0) {
        return @{ HasCycles = $false; Cycles = @(); Error = 'No valid criteria IDs found' }
    }

    $cycles = @()
    $visited = @{}   # fully processed
    $visiting = @{}  # currently on recursion stack (for cycle detection)

    function dfs($node, $path) {
        if ($visiting[$node]) {
            # Cycle found — extract from path
            $cycleStart = [array]::IndexOf($path, $node)
            if ($cycleStart -ge 0) {
                $cyclePath = $path[$cycleStart..($path.Count - 1)] + $node
                $cycles += ,$cyclePath
            }
            return
        }
        if ($visited[$node]) { return }

        $visiting[$node] = $true
        $newPath = $path + $node

        if ($adj.ContainsKey($node)) {
            foreach ($dep in $adj[$node]) {
                if ($dep -and $idSet.ContainsKey($dep)) {
                    dfs $dep $newPath
                }
            }
        }

        $visiting[$node] = $false
        $visited[$node] = $true
    }

    foreach ($id in $idSet.Keys) {
        if (-not $visited[$id]) {
            dfs $id @()
        }
    }

    return @{ HasCycles = ($cycles.Count -gt 0); Cycles = $cycles; Error = '' }
}

# ============================================================
# Config Validation — Validate tr-criteria.yml structure
# Returns array of error strings (empty = valid)
# ============================================================
function Get-ConfigValidationErrors {
    param([array]$Criteria)

    $errors = @()
    if ($Criteria.Count -eq 0) {
        $errors += 'No criteria found in config'
        return $errors
    }

    $validPhases = @('Plan', 'Task', 'Implementation')
    $validTypes = @('Must-Meet', 'Should-Meet')
    $seenIds = @{}

    foreach ($c in $Criteria) {
        $id = if ($c.id) { $c.id.Trim() } else { '' }

        # Check: id is required
        if (-not $id) { $errors += 'Criteria missing id field'; continue }

        # Check: duplicate ids
        if ($seenIds[$id]) { $errors += "Duplicate criterion id: $id"; continue }
        $seenIds[$id] = $true

        # Check: id format
        if ($id -notmatch '^TR\d+(_TR\d+)?-(MM|SM)-\d{3}$') {
            $errors += "Invalid id format: $id (expected format: TR{Gate}-{MM|SM}-{NNN})"
        }

        # Check: gate is required
        if (-not ($c.gate)) { $errors += "${id}: missing 'gate' field" }

        # Check: type is valid
        if ($c.type -and $c.type -notin $validTypes) {
            $errors += "${id}: invalid type '$($c.type)' (valid: $($validTypes -join ', '))"
        }

        # Check: owning_phase is valid
        if ($c.owning_phase -and $c.owning_phase -notin $validPhases) {
            $errors += "${id}: invalid owning_phase '$($c.owning_phase)' (valid: $($validPhases -join ', '))"
        }

        # Check: depends_on references exist
        $deps = if ($c.depends_on) { @($c.depends_on) } else { @() }
        foreach ($dep in $deps) {
            if ($dep -and -not $seenIds[$dep] -and $dep -ne $id) {
                # Dependency may reference a criterion defined later — flag as warning
                $errors += "${id}: depends_on '$dep' references unknown criterion (may be defined later)"
            }
        }
    }

    return $errors
}

# ============================================================
# Phase-scoped criteria filtering
# ============================================================
function Get-PhaseFilteredCriteria {
    param(
        [array]$Criteria,
        [string]$PhaseContext
    )

    if (-not $PhaseContext) { return $Criteria }

    $filtered = $Criteria | Where-Object {
        $_.owning_phase -eq $PhaseContext
    }

    return @($filtered)
}

# ============================================================
# Cross-phase dependency scan
# ============================================================
function Test-CrossPhaseDependency {
    param([array]$Criteria)

    $violations = @()
    $criteriaMap = @{}
    foreach ($c in $Criteria) {
        $id = if ($c.id) { $c.id } else { '' }
        if ($id) { $criteriaMap[$id] = $c }
    }

    foreach ($c in $Criteria) {
        $id = if ($c.id) { $c.id } else { '' }
        if (-not $id -or -not $c.owning_phase) { continue }
        $deps = if ($c.depends_on) { @($c.depends_on) } else { @() }

        foreach ($dep in $deps) {
            if ($dep -and $criteriaMap.ContainsKey($dep)) {
                $depPhase = $criteriaMap[$dep].owning_phase
                if ($depPhase -and $depPhase -ne $c.owning_phase) {
                    $violations += "$id (phase: $($c.owning_phase)) depends on $dep (phase: $depPhase) — cross-phase dependency"
                }
            }
        }
    }

    return $violations
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

# ============================================================
# Handle standalone modes: --check-cycles, -ValidateConfig
# ============================================================

# Resolve criteria config path
$resolvedCriteriaConfig = if ($CriteriaConfig) {
    $CriteriaConfig
} else {
    Join-Path $repoRoot '.specify/gates/tr-criteria.yml'
}

# --check-cycles standalone mode
if ($CheckCycles) {
    $criteria = Get-GateCriteria -ConfigPath $resolvedCriteriaConfig
    if ($criteria.Count -eq 0) {
        $output = @{
            gate = $Gate
            mode = 'check-cycles'
            has_cycles = $false
            cycles_detected = @()
            warning = "No criteria found at $resolvedCriteriaConfig"
        }
        Write-GateJson $output -Json:$Json
        exit 0
    }

    $cycleResult = Test-CyclicDependency -Criteria $criteria
    $output = @{
        gate = $Gate
        mode = 'check-cycles'
        has_cycles = $cycleResult.HasCycles
        cycles_detected = $cycleResult.Cycles
    }
    Write-GateJson $output -Json:$Json
    if ($cycleResult.HasCycles) { exit 1 }
    exit 0
}

# -ValidateConfig standalone mode
if ($ValidateConfig) {
    $criteria = Get-GateCriteria -ConfigPath $resolvedCriteriaConfig
    $configErrors = Get-ConfigValidationErrors -Criteria $criteria

    # Also run cross-phase dependency scan
    $crossPhaseErrors = Test-CrossPhaseDependency -Criteria $criteria

    $allErrors = $configErrors + $crossPhaseErrors

    $output = @{
        gate = $Gate
        mode = 'validate-config'
        valid = ($allErrors.Count -eq 0)
        errors = $allErrors
        criteria_count = $criteria.Count
    }
    Write-GateJson $output -Json:$Json
    if ($allErrors.Count -gt 0) { exit 1 }
    exit 0
}

# ============================================================
# Phase-scoped context injection for TR2_TR3 gate check
# ============================================================
# When -Context is provided, we modify the TR2_TR3 gate check
# to only evaluate criteria for the given phase.
if ($Context -and $Gate -eq 'TR2_TR3' -and $overallStatus -eq 'passed') {
    $criteria = Get-GateCriteria -ConfigPath $resolvedCriteriaConfig
    $phaseCriteria = Get-PhaseFilteredCriteria -Criteria $criteria -PhaseContext $Context

    $currentGateInfo = $currentGate
    if ($currentGateInfo) {
        $currentGateInfo | Add-Member -NotePropertyName 'phase_context' -NotePropertyValue $Context -Force
        $currentGateInfo | Add-Member -NotePropertyName 'phase_criteria_count' -NotePropertyValue $phaseCriteria.Count -Force
        $currentGateInfo | Add-Member -NotePropertyName 'total_criteria_count' -NotePropertyValue $criteria.Count -Force
        $currentGateInfo | Add-Member -NotePropertyName 'phase_criteria' -NotePropertyValue @($phaseCriteria | ForEach-Object { $_.id }) -Force

        # Evaluate criteria status for the phase
        $phasePassed = 0
        $phaseFailed = 0
        $phaseDeferred = 0
        foreach ($c in $phaseCriteria) {
            # Simple heuristic: if criterion's artifact pattern exists, mark as passed
            $id = $c.id
            $matched = $false
            if ($id -eq 'TR2-MM-001' -and $plan -and (Test-Path $plan)) { $matched = $true }
            if ($id -eq 'TR2-MM-002' -and $plan -and (Test-Path $plan) -and (Test-FileContains $plan 'dependency')) { $matched = $true }
            if ($id -eq 'TR2-SM-001') { $matched = $false }  # Task-phase criteria not evaluated in Plan context

            if ($matched) { $phasePassed++ }
            else { $phaseFailed++ }
        }

        $currentGateInfo | Add-Member -NotePropertyName 'phase_criteria_passed' -NotePropertyValue $phasePassed -Force
        $currentGateInfo | Add-Member -NotePropertyName 'phase_criteria_failed' -NotePropertyValue $phaseFailed -Force

        # Log audit entry for phase-scoped check
        $featureName = if ($featureDir) { Split-Path $featureDir -Leaf } else { 'unknown' }
        Write-AuditLog -EventType "gate_criteria_status_change" -Feature $featureName -Gate "$Gate/$Context" `
            -Rationale "Phase-scoped gate check: $phasePassed passed, $phaseFailed failed (out of $($phaseCriteria.Count) criteria)"
    }
}

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
