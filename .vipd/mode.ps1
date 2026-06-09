# VIPD Mode Utility (PowerShell)
# Usage: . .vipd/mode.ps1; Get-VipdMode | Set-VipdMode <standard|claude-code>

$script:VipdConfigPath = ".vipd/config.yml"

function Get-VipdMode {
  if (-not (Test-Path $script:VipdConfigPath)) { return "standard" }
  $content = Get-Content $script:VipdConfigPath -Raw
  if ($content -match 'mode:\s*(\S+)') { return $matches[1] }
  return "standard"
}

function Set-VipdMode {
  param([string]$Mode)
  $valid = @("standard", "claude-code")
  if ($Mode -notin $valid) {
    Write-Error "Invalid mode: $Mode. Valid: $($valid -join ', ')"
    return
  }
  if (-not (Test-Path $script:VipdConfigPath)) {
    "@(`"language: en`nmode: $Mode`")" | Set-Content $script:VipdConfigPath
    return
  }
  $content = Get-Content $script:VipdConfigPath
  $matched = $false
  $content = $content | ForEach-Object {
    if ($_ -match '^mode:\s*') {
      $matched = $true
      "mode: $Mode"
    } else { $_ }
  }
  if (-not $matched) { $content += "mode: $Mode" }
  $content | Set-Content $script:VipdConfigPath
}

Export-ModuleMember -Function Get-VipdMode, Set-VipdMode
