#!/usr/bin/env pwsh
# _gate_helpers.ps1 — Shared helper functions for gate tooling
# Source this file from individual gate scripts: . "$PSScriptRoot/_gate_helpers.ps1"
#
# Functions:
#   Write-AuditLog     — Append JSON Lines entry to audit.log
#   Get-GateCriteria   — Parse tr-criteria.yml and return criteria objects
#   Set-DeferredItems  — Write deferred-items.json per feature
#   Get-DeferredItems  — Read deferred-items.json per feature

# Resolve the repo root directory
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

# ---------------------------------------------------------------------------
# Write-AuditLog — Append a JSON Lines entry to .specify/gates/audit.log
# ---------------------------------------------------------------------------
function Write-AuditLog {
    param(
        [Parameter(Mandatory = $true)][string]$EventType,
        [Parameter(Mandatory = $true)][string]$Feature,
        [Parameter(Mandatory = $true)][string]$Gate,
        [string]$CriterionId = '',
        [string]$FromState = '',
        [string]$ToState = '',
        [string]$Rationale = ''
    )

    $root = Get-RepoRoot
    if (-not $root) { return }

    $logPath = Join-Path $root '.specify/gates/audit.log'
    $logDir = Split-Path $logPath -Parent
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

    # Get actor from git config, fall back to 'unknown'
    $actor = 'unknown'
    try {
        $gitUser = git config user.name 2>$null
        if ($gitUser) { $actor = $gitUser }
    } catch {}

    $entry = @{
        timestamp    = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
        actor        = $actor
        event_type   = $EventType
        feature      = $Feature
        gate         = $Gate
        criterion_id = $CriterionId
        from_state   = $FromState
        to_state     = $ToState
        rationale    = $Rationale
    } | ConvertTo-Json -Compress

    Add-Content -LiteralPath $logPath -Value $entry
}

# ---------------------------------------------------------------------------
# Get-GateCriteria — Parse .specify/gates/tr-criteria.yml and return criteria
# Returns array of criteria objects with: id, gate, type, title, owning_phase,
#   description, depends_on, validation_hint
# ---------------------------------------------------------------------------
function Get-GateCriteria {
    param(
        [string]$ConfigPath = ''  # optional override path
    )

    $root = Get-RepoRoot
    if (-not $root) { return @() }

    if (-not $ConfigPath) {
        $ConfigPath = Join-Path $root '.specify/gates/tr-criteria.yml'
    }

    if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
        Write-Warning "Gate criteria config not found at $ConfigPath"
        return @()
    }

    $content = Get-Content -LiteralPath $ConfigPath -Raw

    # Parse YAML via PowerShell — simple line-by-line parser for the known structure
    # This avoids external YAML module dependencies.
    $criteria = @()
    $current = $null
    $inCriteriaList = $false

    # Simple YAML parser for the specific tr-criteria.yml format
    # Uses regex matching for known fields
    $lines = $content -split "`n"
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -eq 'gate_criteria:') {
                    continue
        }
        if ($trimmed -eq '' -or $trimmed -match '^#') { continue }

        if ($trimmed -match '^- id:\s+"(.+)"') {
            # Start a new criterion
            if ($current) { $criteria += $current }
            $current = @{
                id              = $matches[1]
                gate            = ''
                type            = ''
                title           = ''
                owning_phase    = ''
                description     = ''
                depends_on      = @()
                validation_hint = ''
                status          = 'pending'
            }
            continue
        }

        if ($current) {
            if ($trimmed -match '^gate:\s+"(.+)"') {
                $current.gate = $matches[1]
            } elseif ($trimmed -match '^type:\s+"(.+)"') {
                $current.type = $matches[1]
            } elseif ($trimmed -match "^type:\s+(.+)$") {
                $current.type = $matches[1]
            } elseif ($trimmed -match '^title:\s+"(.+)"') {
                $current.title = $matches[1]
            } elseif ($trimmed -match "^title:\s+(.+)$") {
                $current.title = $matches[1]
            } elseif ($trimmed -match '^owning_phase:\s+"(.+)"') {
                $current.owning_phase = $matches[1]
            } elseif ($trimmed -match "^owning_phase:\s+(.+)$") {
                $current.owning_phase = $matches[1]
            } elseif ($trimmed -match '^description:\s+"(.+)"') {
                $current.description = $matches[1]
            } elseif ($trimmed -match "^description:\s+(.+)$") {
                $current.description = $matches[1]
            } elseif ($trimmed -match '^validation_hint:\s+"(.+)"') {
                $current.validation_hint = $matches[1]
            } elseif ($trimmed -match "^validation_hint:\s+(.+)$") {
                $current.validation_hint = $matches[1]
            } elseif ($trimmed -match '^depends_on:\s*\[(.*)\]') {
                $deps = $matches[1]
                if ($deps.Trim() -ne '') {
                    $current.depends_on = $deps -split ',' | ForEach-Object { $_.Trim().Trim('"') }
                } else {
                    $current.depends_on = @()
                }
            } elseif ($trimmed -match '^\s+-\s+"(.+)"' -and -not ($line -match '^\s+-\s+id:')) {
                # List item under depends_on (alternative format)
                if ($current.depends_on -isnot [array]) { $current.depends_on = @() }
                $current.depends_on += $matches[1]
            }
        }
    }

    if ($current) { $criteria += $current }

    return $criteria
}

# ---------------------------------------------------------------------------
# Set-DeferredItems — Write deferred-items.json for a feature
# ---------------------------------------------------------------------------
function Set-DeferredItems {
    param(
        [Parameter(Mandatory = $true)][string]$FeatureDir,
        [Parameter(Mandatory = $true)][array]$Items,
        [Parameter(Mandatory = $true)][string]$OriginatingGate
    )

    $data = @{
        feature          = (Split-Path $FeatureDir -Leaf)
        originating_gate = $OriginatingGate
        created_at       = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
        updated_at       = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
        items            = $Items
    }

    $path = Join-Path $FeatureDir 'deferred-items.json'
    $data | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $path -Encoding UTF8
}

# ---------------------------------------------------------------------------
# Get-DeferredItems — Read deferred-items.json for a feature
# Returns $null if file does not exist
# ---------------------------------------------------------------------------
function Get-DeferredItems {
    param(
        [Parameter(Mandatory = $true)][string]$FeatureDir
    )

    $path = Join-Path $FeatureDir 'deferred-items.json'
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        return $null
    }

    try {
        return Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
    } catch {
        return $null
    }
}

# Exported for module use — always dot-source this file for direct function access
# Export-ModuleMember not used here since this file is always dot-sourced, not imported as a module
