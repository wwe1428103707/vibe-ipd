#!/usr/bin/env pwsh
# Gate utility common functions — shared helpers for gate-detect-ipd-mode, gate-check, gate-record
# Source this file from individual gate scripts: . "$PSScriptRoot/gate-common.ps1"

# Emit JSON output with consistent formatting and exit code handling
function Write-GateJson {
    param(
        [Parameter(Mandatory = $true, Position = 0)]$InputObject,
        [switch]$Json
    )

    if ($Json) {
        $InputObject | ConvertTo-Json -Compress
    } else {
        $InputObject
    }
}

# Test if a file contains a specific pattern (content match, not just file existence)
function Test-FileContains {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Pattern
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $false
    }

    try {
        return (Select-String -LiteralPath $Path -Pattern $Pattern -Quiet -ErrorAction SilentlyContinue) -ne $null
    } catch {
        return $false
    }
}

# Get repository root by locating .specify directory
function Get-RepoRoot {
    $current = (Get-Location).Path
    while ($true) {
        if (Test-Path (Join-Path $current ".specify") -PathType Container) {
            return $current
        }
        $parent = Split-Path $current -Parent
        if ([string]::IsNullOrEmpty($parent) -or $parent -eq $current) { return $null }
        $current = $parent
    }
}

# Build an absolute path relative to repo root
function Get-RepoRelativePath {
    param([string]$RelativePath)

    $root = Get-RepoRoot
    if (-not $root) { return $null }
    return Join-Path $root $RelativePath
}

# Read gate-status.json, return parsed object (or default if missing/corrupt)
function Get-GateStatus {
    $path = Get-RepoRelativePath '.specify/memory/gate-status.json'
    if (-not $path -or -not (Test-Path $path)) {
        return $null
    }
    try {
        return Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
    } catch {
        return $null
    }
}

# Validate gate ID is a known value (TR6 added for Launch gate)
function Test-ValidGateId {
    param([string]$GateId)
    return ($GateId -in @('TR0', 'TR1', 'TR2_TR3', 'TR4', 'TR4A', 'TR5', 'TR6'))
}

# Validate gate status is a known value (hold, recycled, and conditional-pass added for IPD decisions)
function Test-ValidGateStatus {
    param([string]$Status)
    return ($Status -in @('passed', 'pending', 'failed', 'skipped', 'hold', 'recycled', 'conditional-pass'))
}

# Validate gate decision is a known IPD decision (Go/Kill/Hold/Recycle)
function Test-ValidGateDecision {
    param([string]$Decision)
    return ($Decision -in @('Go', 'Kill', 'Hold', 'Recycle', ''))
}

# Get gate dependency order — returns ordered array of prerequisite gates for a given gate
function Get-GateOrder {
    return @('TR0', 'TR1', 'TR2_TR3', 'TR4', 'TR4A', 'TR5', 'TR6')
}

# Get prerequisite gates for a given gate (all gates that must pass before this one)
function Get-PrerequisiteGates {
    param([string]$GateId)

    $order = Get-GateOrder
    $idx = [array]::IndexOf($order, $GateId)
    if ($idx -lt 0) { return @() }
    return $order[0..($idx - 1)]
}

# Validate that prerequisite gates have passed before allowing recording (FR-013)
function Test-GateOrder {
    param(
        [string]$GateId,
        [hashtable]$CurrentStatus
    )

    $prereqs = Get-PrerequisiteGates -GateId $GateId
    $failedPrereqs = @()

    foreach ($prereq in $prereqs) {
        if ($prereq -notin $CurrentStatus.Keys -or $CurrentStatus[$prereq] -ne 'passed') {
            $failedPrereqs += $prereq
        }
    }

    if ($failedPrereqs.Count -gt 0) {
        return @{
            Valid  = $false
            FailedPrerequisites = $failedPrereqs
            Message = "Cannot record $($GateId) as passed because prerequisite gates have not passed: $($failedPrereqs -join ', ')"
        }
    }

    return @{ Valid = $true; FailedPrerequisites = @(); Message = '' }
}

# Resolve per-feature gate-status.json path (FR-003b, per-feature isolation)
# Reads .specify/feature.json to determine the current feature directory,
# then returns the path to specs/NNN-feature-name/gate-status.json.
# Falls back to legacy .specify/memory/gate-status.json if feature directory not found.
function Get-FeatureGateStatusPath {
    param(
        [switch]$LegacyFallback
    )

    $root = Get-RepoRoot
    if (-not $root) { return $null }

    # Try per-feature path first
    $featureFile = Join-Path $root '.specify/feature.json'
    if (Test-Path -LiteralPath $featureFile -PathType Leaf) {
        try {
            $featureJson = Get-Content -LiteralPath $featureFile -Raw | ConvertFrom-Json
            $featureDir = $featureJson.feature_directory
            if ($featureDir) {
                $perFeaturePath = Join-Path $root "$featureDir/gate-status.json"
                if ($LegacyFallback -and -not (Test-Path -LiteralPath $perFeaturePath -PathType Leaf)) {
                    # Fall back to legacy path if per-feature file doesn't exist yet
                    $legacyPath = Join-Path $root '.specify/memory/gate-status.json'
                    if (Test-Path -LiteralPath $legacyPath -PathType Leaf) {
                        return $legacyPath
                    }
                }
                return $perFeaturePath
            }
        } catch {
            # Fall through to legacy path
        }
    }

    # Legacy path
    if ($LegacyFallback) {
        $legacyPath = Join-Path $root '.specify/memory/gate-status.json'
        if (Test-Path -LiteralPath $legacyPath -PathType Leaf) {
            return $legacyPath
        }
    }

    # Default: return per-feature path even if it doesn't exist yet (will be created)
    if ($featureDir) {
        return Join-Path $root "$featureDir/gate-status.json"
    }

    return Join-Path $root '.specify/memory/gate-status.json'
}
