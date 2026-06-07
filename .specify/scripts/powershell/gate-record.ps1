#!/usr/bin/env pwsh
# gate-record.ps1 — Update gate status in .specify/memory/gate-status.json
# Usage: .specify/scripts/powershell/gate-record.ps1 -Gate TR1 -Status passed -Evidence "Spec created"
# Atomic write: temp file → rename over target

param(
    [Parameter(Mandatory = $true)][string]$Gate,
    [Parameter(Mandatory = $true)][string]$Status,
    [Parameter(Mandatory = $true)][string]$Evidence
)

. "$PSScriptRoot/gate-common.ps1"

$errors = @()

# Validate inputs
if (-not (Test-ValidGateId $Gate)) { $errors += "Invalid gate: $Gate" }
if (-not (Test-ValidGateStatus $Status)) { $errors += "Invalid status: $Status. Use: passed, pending, failed, skipped" }
if ($Evidence.Length -gt 500) { $Evidence = $Evidence.Substring(0, 497) + "..." }

if ($errors.Count -gt 0) {
    Write-GateJson @{ gate = $Gate; status = "error"; errors = $errors }
    exit 1
}

# Determine file paths
$repoRoot = Get-RepoRoot
if (-not $repoRoot) { Write-Error "Not in a spec-kit project"; exit 1 }

$gateFile = Join-Path (Join-Path (Join-Path $repoRoot '.specify') 'memory') 'gate-status.json'
$gateDir = Split-Path $gateFile -Parent

# Ensure directory exists
if (-not (Test-Path $gateDir)) { New-Item -ItemType Directory -Path $gateDir -Force | Out-Null }

# Read existing or create default
$gs = Get-GateStatus
if (-not $gs) {
    $gs = @{
        ipd_mode = $null -ne (Get-RepoRelativePath '.specify/memory/constitution.md')
        last_updated = $(Get-Date -Format 'yyyy-MM-dd')
        gates = @{
            TR0 = @{ status = "pending"; evidence = $null; date = $null }
            TR1 = @{ status = "pending"; evidence = $null; date = $null }
            TR2_TR3 = @{ status = "pending"; evidence = $null; date = $null }
            TR4 = @{ status = "pending"; evidence = $null; date = $null }
            TR4A = @{ status = "pending"; evidence = $null; date = $null }
            TR5 = @{ status = "pending"; evidence = $null; date = $null }
        }
    }
}

# Update the specific gate
$gs.last_updated = (Get-Date -Format 'yyyy-MM-dd')
$gs.gates.$Gate.status = $Status
$gs.gates.$Gate.evidence = $Evidence
$gs.gates.$Gate.date = (Get-Date -Format 'yyyy-MM-dd')

# Atomic write: temp file → rename
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

# Output summary
$gs | ConvertTo-Json -Compress -Depth 5

exit 0
