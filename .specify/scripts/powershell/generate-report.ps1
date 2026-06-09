#!/usr/bin/env pwsh
# generate-report.ps1 — Generate static HTML gate report from gate-history.jsonl
# Usage: .specify/scripts/powershell/generate-report.ps1 [-OutputPath <path>] [-Gate <TR1|...>]
param(
    [string]$OutputPath = '',
    [string]$Gate = ''
)

$repoRoot = & { $dir = Split-Path $PSScriptRoot -Parent; while ($dir -and -not (Test-Path (Join-Path $dir '.specify'))) { $dir = Split-Path $dir -Parent } if ($dir) { $dir } else { Get-Location } }

$jsonlFile = Join-Path $repoRoot '.specify/memory/gate-history.jsonl'
$templateFile = Join-Path $repoRoot '.claude/templates/report-template.html'

if (-not $OutputPath) {
    $fj = Join-Path $repoRoot '.specify/feature.json'
    if (Test-Path $fj) { $fc = Get-Content $fj -Raw | ConvertFrom-Json; $featureDir = Join-Path $repoRoot $fc.feature_directory }
    else { $featureDir = $repoRoot }
    $OutputPath = Join-Path $featureDir 'vipd-report.html'
}

# Read JSONL records
$records = @()
if (Test-Path $jsonlFile) {
    Get-Content $jsonlFile | ForEach-Object {
        if ($_.Trim()) {
            try { $records += $_ | ConvertFrom-Json } catch {}
        }
    }
}

# Filter by gate if specified
if ($Gate) { $records = $records | Where-Object { $_.gate -eq $Gate } }

# Generate HTML
if (Test-Path $templateFile) {
    $html = Get-Content $templateFile -Raw
    $dataJson = $records | ConvertTo-Json -Depth 5 -Compress

    # Replace the empty JSON script tag with data
    $html = $html -replace '<script id="gate-data" type="application/json"></script>', "<script id=`"gate-data`" type=`"application/json`">$dataJson</script>"

    # Replace the static GATE_DATA = null; with actual data
    $html = $html -replace 'const GATE_DATA = null;', "const GATE_DATA = $dataJson;"

    $html | Set-Content -LiteralPath $OutputPath -Encoding UTF8
    Write-Host "✅ Report generated: $OutputPath ($($records.Count) records)"
} else {
    Write-Error "Template not found: $templateFile"
    exit 1
}
