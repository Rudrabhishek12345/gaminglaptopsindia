# Same .env loader as launch.ps1
$envPath = Join-Path (Split-Path -Path $PSScriptRoot -Parent) ".env"
if (Test-Path $envPath) {
  Get-Content $envPath | ForEach-Object {
    if ($_ -match "^\s*$" -or $_ -match "^\s*#") { return }
    $pair = $_ -split "=", 2
    if ($pair.Count -eq 2) { [Environment]::SetEnvironmentVariable($pair[0].Trim(), $pair[1].Trim(), "Process") }
  }
} else { Write-Host "❌ .env not found"; exit 1 }

# Force parallel by env knob
[Environment]::SetEnvironmentVariable("PARALLEL", "1", "Process")
python (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "orchestrator.py")
