#!/usr/bin/env pwsh
# gate-detect-ipd-mode.ps1 — Detect whether IPD mode is active
# Usage: .specify/scripts/powershell/gate-detect-ipd-mode.ps1 [-Json]
# Returns: {"ipd_mode": true/false}

param(
    [switch]$Json
)

# Load shared helpers
. "$PSScriptRoot/gate-common.ps1"

$repoRoot = Get-RepoRoot
$constitutionPath = Join-Path $repoRoot '.specify/memory/constitution.md'

$ipdMode = $false
$reason = ""

if (-not (Test-Path -LiteralPath $constitutionPath -PathType Leaf)) {
    $reason = "Constitution not found at .specify/memory/constitution.md"
} elseif (-not (Test-FileContains -Path $constitutionPath -Pattern "Gate Criteria Reference")) {
    $reason = "Constitution exists but does not contain 'Gate Criteria Reference' section"
} else {
    $ipdMode = $true
}

if ($Json) {
    @{ipd_mode = $ipdMode } | ConvertTo-Json -Compress
} else {
    if ($ipdMode) {
        Write-Output "IPD mode: ACTIVE"
    } else {
        Write-Output "IPD mode: INACTIVE ($reason)"
    }
}

exit 0
