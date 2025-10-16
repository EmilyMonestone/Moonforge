# Pfad zum aktuellen Skriptverzeichnis
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Relativ zu diesem Skriptverzeichnis
$configAppScriptPath = Join-Path -Path $scriptDir -ChildPath "config_app.ps1"1)

# App-Konfiguration aktualisieren
Write-Information "Updating app configuration from app_config.dart"
Write-Host "Running PowerShell script: $configAppScriptPath"
& $configAppScriptPath -NonInteractive
if ($LASTEXITCODE -ne 0)
{
    Write-Host "Config app script failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}



# build_runner ausführen
Write-Information "Running build_runner"
dart run build_runner build
if ($LASTEXITCODE -ne 0)
{
    Write-Host "build_runner failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Build completed successfully"
