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

# Validate gate ID is a known value
function Test-ValidGateId {
    param([string]$GateId)
    return ($GateId -in @('TR0', 'TR1', 'TR2_TR3', 'TR4', 'TR4A', 'TR5'))
}

# Validate gate status is a known value
function Test-ValidGateStatus {
    param([string]$Status)
    return ($Status -in @('passed', 'pending', 'failed', 'skipped'))
}
