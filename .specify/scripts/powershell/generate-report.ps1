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
    # Auto-detect feature directory
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
    # Inject data as a JSON script tag for the static HTML to read
    $dataJson = $records | ConvertTo-Json -Depth 5 -Compress
    $injection = "<script id=`"gate-data`" type=`"application/json`">$dataJson</script>`n<script>"
    $html = $html -replace '<script>', $injection
    # Also inject JSON data inline for static file viewing
    $inlineData = @"
<script>
// Static gate report data
const GATE_DATA = $dataJson;
document.addEventListener('DOMContentLoaded', function() {
  const summary = document.getElementById('summary');
  const dashboard = document.getElementById('dashboard');
  const timeline = document.getElementById('timeline');
  if (!GATE_DATA || GATE_DATA.length === 0) { timeline.innerHTML = '<div class=\"empty\">暂无门控记录</div>'; return; }
  const total = GATE_DATA.length;
  const passed = GATE_DATA.filter(r => r.status === 'passed').length;
  const failed = GATE_DATA.filter(r => r.status === 'failed').length;
  const degraded = GATE_DATA.filter(r => r.status === 'degraded').length;
  summary.innerHTML = '<div class=\"card\"><h3>总检查次数</h3><div class=\"count\">'+total+'</div></div><div class=\"card\"><h3>✅ 通过</h3><div class=\"count\">'+passed+'</div></div><div class=\"card\"><h3>❌ 失败</h3><div class=\"count\">'+failed+'</div></div><div class=\"card\"><h3>⚠️ 降级</h3><div class=\"count\">'+degraded+'</div></div>';
  const gates = [...new Set(GATE_DATA.map(r => r.gate))].sort();
  dashboard.innerHTML = gates.map(g => { const r = GATE_DATA.filter(x => x.gate === g).slice(-1)[0]; const cls = r.status === 'passed' ? 'gate-pass' : r.status === 'degraded' ? 'gate-degraded' : 'gate-fail'; return '<div class=\"gate-badge '+cls+'\">'+g+'<br><small>'+r.status+'</small></div>'; }).join('');
  timeline.innerHTML = GATE_DATA.slice().reverse().map(r => { const dot = r.status === 'passed' ? '#22c55e' : r.status === 'degraded' ? '#f59e0b' : '#ef4444'; const conds = (r.conditions||[]).map(c => '<tr><td>'+c.criterion+'</td><td>'+(c.matched?'✅':'❌')+'</td><td>'+(c.category||'—')+'</td></tr>').join(''); return '<details class=\"record\"><summary><span class=\"status-dot\" style=\"background:'+dot+'\"></span> ['+r.gate+'] '+r.status+'</summary><div class=\"meta\">'+r.timestamp+' | attempt #'+r.attempt+' | auto-fix: '+(r.auto_fix_attempted?'yes':'no')+'</div><div class=\"detail\"><table><tr><th>条件</th><th>结果</th><th>分类</th></tr>'+conds+'</table></div></details>'; }).join('');
});
</script>
"@
    $html = $html -replace '</body>', "$inlineData</body>"
    $html | Set-Content -LiteralPath $OutputPath -Encoding UTF8
    Write-Host "✅ Report generated: $OutputPath"
} else {
    Write-Error "Template not found: $templateFile"
    exit 1
}
