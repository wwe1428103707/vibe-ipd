# _test_helpers.ps1 — Shared test fixtures and utilities for gate script Pester tests
# Usage: . $PSScriptRoot/_test_helpers.ps1

# Path to the scripts under test
$Script:GateCheckPath  = (Resolve-Path "$PSScriptRoot/../scripts/powershell/gate-check.ps1").Path
$Script:GateRecordPath = (Resolve-Path "$PSScriptRoot/../scripts/powershell/gate-record.ps1").Path
$Script:GateHelpersPath = (Resolve-Path "$PSScriptRoot/../scripts/powershell/_gate_helpers.ps1").Path
$Script:GateCommonPath = (Resolve-Path "$PSScriptRoot/../scripts/powershell/gate-common.ps1").Path
$Script:TrCriteriaPath = (Resolve-Path "$PSScriptRoot/../gates/tr-criteria.yml").Path

function New-TestFeatureDir {
    <#
    .SYNOPSIS
    Create a temporary feature directory for testing gate operations.
    Returns the directory path. Call Remove-TestFeatureDir to clean up.
    #>
    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "speckit-test-$(Get-Random)"
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
    return $tmpDir
}

function Remove-TestFeatureDir {
    param([string]$Path)
    if (Test-Path $Path) {
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function New-TestGitRepo {
    <#
    .SYNOPSIS
    Create a temporary git repo with minimal .specify structure for test isolation.
    Returns the repo root path.
    #>
    $tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "speckit-repo-$(Get-Random)"
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null

    # Create .specify structure
    New-Item -ItemType Directory -Path (Join-Path $tmpDir '.specify') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $tmpDir '.specify/memory') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $tmpDir '.specify/gates') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $tmpDir '.specify/scripts/powershell') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $tmpDir 'specs') -Force | Out-Null

    # Create a minimal gate-status.json
    $gs = @{
        ipd_mode = $true
        last_updated = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
        gates = @{
            TR0    = @{ status = 'passed'; evidence = 'test'; date = '2026-01-01' }
            TR1    = @{ status = 'passed'; evidence = 'test'; date = '2026-01-01' }
            TR2_TR3 = @{ status = 'passed'; evidence = 'test'; date = '2026-01-01' }
            TR4    = @{ status = 'pending'; evidence = $null; date = $null }
            TR4A   = @{ status = 'pending'; evidence = $null; date = $null }
            TR5    = @{ status = 'pending'; evidence = $null; date = $null }
            TR6    = @{ status = 'pending'; evidence = $null; date = $null }
        }
    }
    $gs | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $tmpDir '.specify/memory/gate-status.json') -Encoding UTF8

    return $tmpDir
}

function Remove-TestGitRepo {
    param([string]$Path)
    if (Test-Path $Path) {
        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
    }
}
