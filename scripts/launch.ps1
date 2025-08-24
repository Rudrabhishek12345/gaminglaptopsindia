# Load .env into process
$envPath = Join-Path (Split-Path -Path $PSScriptRoot -Parent) ".env"
if (Test-Path $envPath) {
  Get-Content $envPath | ForEach-Object {
    if ($_ -match "^\s*$" -or $_ -match "^\s*#") { return }
    $pair = $_ -split "=", 2
    if ($pair.Count -eq 2) { [Environment]::SetEnvironmentVariable($pair[0].Trim(), $pair[1].Trim(), "Process") }
  }
} else { Write-Host "❌ .env not found"; exit 1 }

# Run orchestrator
Write-Host "🚀 Orchestrator starting..."
python (Join-Path (Split-Path -Path $PSScriptRoot -Parent) "orchestrator.py")
