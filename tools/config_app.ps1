# config_app.ps1
# This script provides a menu-based interface for configuring the Sandi app.
# It allows updating version numbers and app description.

param (
    [switch]$Help,
    [switch]$NonInteractive  # For use by build.ps1
)

# Function to display help information for version numbers
function Show-VersionHelp
{
    param (
        [switch]$ExitAfter
    )

    Write-Host "========================================================"
    Write-Host "                 VERSION NUMBER HELP                    "
    Write-Host "========================================================"
    Write-Host ""
    Write-Host "Semantic Versioning Explained:"
    Write-Host ""
    Write-Host "MAJOR version (X.y.z)"
    Write-Host "  Increment when you make incompatible API changes."
    Write-Host "  Example: Breaking changes that require users to modify their code."
    Write-Host ""
    Write-Host "MINOR version (x.Y.z)"
    Write-Host "  Increment when you add functionality in a backward-compatible manner."
    Write-Host "  Example: New features that don't break existing functionality."
    Write-Host ""
    Write-Host "PATCH version (x.y.Z)"
    Write-Host "  Increment when you make backward-compatible bug fixes."
    Write-Host "  Example: Bug fixes that don't change or break existing functionality."
    Write-Host ""
    Write-Host "BUILD number (x.y.z+B)"
    Write-Host "  Increment for builds that don't change the public API."
    Write-Host "  Example: Internal changes, performance improvements, or rebuilds."
    Write-Host ""
    Write-Host "For more information, visit: https://semver.org/"
    Write-Host ""
    Write-Host "========================================================"
    Write-Host ""

    if ($ExitAfter)
    {
        exit 0
    }
}

# Function to display help information for the app description
function Show-DescriptionHelp
{
    Write-Host "========================================================"
    Write-Host "               APP DESCRIPTION HELP                     "
    Write-Host "========================================================"
    Write-Host ""
    Write-Host "The app description is a short text that describes the purpose"
    Write-Host "and functionality of the Sandi app. It is used in various places:"
    Write-Host ""
    Write-Host "- In the pubspec.yaml file for the Flutter app description"
    Write-Host "- In the app's About dialog"
    Write-Host "- In app stores and distribution platforms"
    Write-Host ""
    Write-Host "Guidelines for a good app description:"
    Write-Host "- Keep it concise but informative"
    Write-Host "- Mention the app's main purpose and target audience"
    Write-Host "- Avoid technical jargon unless necessary"
    Write-Host "- Consider localization needs if the app is multilingual"
    Write-Host ""
    Write-Host "========================================================"
    Write-Host ""
}

# Function to display the main help information
function Show-MainHelp
{
    Write-Host "========================================================"
    Write-Host "                 SANDI CONFIG TOOL HELP                 "
    Write-Host "========================================================"
    Write-Host ""
    Write-Host "This tool allows you to configure various aspects of the Sandi app:"
    Write-Host ""
    Write-Host "1. Update Version - Change the version numbers (major, minor, patch, build)"
    Write-Host "2. Update Description - Modify the app description text"
    Write-Host "3. Help - Display this help information"
    Write-Host "4. Exit - Exit the configuration tool"
    Write-Host ""
    Write-Host "Command-line parameters:"
    Write-Host "  -Help            : Display this help information"
    Write-Host "  -NonInteractive  : Update version numbers without user interaction"
    Write-Host "                     (used by build.ps1)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\config_app.ps1             : Start the interactive configuration tool"
    Write-Host "  .\config_app.ps1 -Help       : Display this help information"
    Write-Host "  .\config_app.ps1 -NonInteractive : Update version numbers non-interactively"
    Write-Host ""
    Write-Host "========================================================"
    Write-Host ""
}

# Function to get version input with help support
function Get-VersionInput
{
    param (
        [string]$PromptText,
        [string]$DefaultValue
    )

    $inputComplete = $false
    $result = $DefaultValue

    while (-not $inputComplete)
    {
        $input = Read-Host "$PromptText [$DefaultValue]"

        if ( [string]::IsNullOrWhiteSpace($input))
        {
            $result = $DefaultValue
            $inputComplete = $true
        }
        elseif ($input.ToLower() -eq "help")
        {
            Show-VersionHelp
            Write-Host "Enter new version numbers (press Enter to keep current value):"
            Write-Host "Type 'help' at any prompt to see explanations of version numbers."
            Write-Host ""
        }
        else
        {
            $result = $input
            $inputComplete = $true
        }
    }

    return $result
}

# Pfad zum aktuellen Skriptverzeichnis
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Pfade zu den relevanten Dateien
$appConfigPath = Join-Path -Path $scriptDir -ChildPath "..\moonforge\lib\core\constants\app_config.dart"
$versionDartPath = Join-Path -Path $scriptDir -ChildPath "..\moonforge\lib\core\constants\version.dart"
$pubspecPath = Join-Path -Path $scriptDir -ChildPath "..\moonforge\pubspec.yaml"
$pkgbuildPath = Join-Path -Path $scriptDir -ChildPath "..\moonforge\arch_build\PKGBUILD"

# Use version.dart if app_config.dart doesn't exist yet
if (-not (Test-Path $appConfigPath) -and (Test-Path $versionDartPath))
{
    $appConfigPath = $versionDartPath
}

# Überprüfen, ob die Konfigurationsdatei existiert
if (-not (Test-Path $appConfigPath))
{
    Write-Error "Configuration file not found: $appConfigPath"
    exit 1
}

# Show help if requested
if ($Help)
{
    Show-MainHelp
    exit 0
}

# Function to update version numbers
function Update-Version
{
    param (
        [switch]$NonInteractive
    )

    # Version aus app_config.dart extrahieren
    $configContent = Get-Content $appConfigPath -Raw
    $majorVersion = [regex]::Match($configContent, 'versionMajor\s*=\s*(\d+)').Groups[1].Value
    $minorVersion = [regex]::Match($configContent, 'versionMinor\s*=\s*(\d+)').Groups[1].Value
    $patchVersion = [regex]::Match($configContent, 'versionPatch\s*=\s*(\d+)').Groups[1].Value
    $buildVersion = [regex]::Match($configContent, 'versionBuild\s*=\s*(\d+)').Groups[1].Value
    $appDescription = [regex]::Match($configContent, 'appDescription\s*=\s*''([^'']+)''').Groups[1].Value

    # Versionstrings erstellen
    $currentPubspecVersion = "$majorVersion.$minorVersion.$patchVersion+$buildVersion"
    $currentMsixVersion = "$majorVersion.$minorVersion.$patchVersion.$buildVersion"
    $currentPkgbuildVersion = "$majorVersion.$minorVersion.$patchVersion"

    # Aktuelle Version anzeigen
    Write-Host "========================================================"
    Write-Host "                 SANDI VERSION UPDATER                  "
    Write-Host "========================================================"
    Write-Host ""
    Write-Host "Current version: v$majorVersion.$minorVersion.$patchVersion (Build $buildVersion)"
    Write-Host "Description: $appDescription"
    Write-Host ""
    Write-Host "Version details:"
    Write-Host "  - Pubspec: $currentPubspecVersion"
    Write-Host "  - MSIX:    $currentMsixVersion"
    Write-Host "  - PKGBUILD: $currentPkgbuildVersion"
    Write-Host ""

    if ($NonInteractive)
    {
        # In non-interactive mode, just update the files with current version
        $newMajorVersion = $majorVersion
        $newMinorVersion = $minorVersion
        $newPatchVersion = $patchVersion
        $newBuildVersion = $buildVersion
    }
    else
    {
        Write-Host "TIP: Type 'help' at any prompt to see explanations of version numbers."
        Write-Host ""
        Write-Host "========================================================"
        Write-Host ""

        # Benutzer nach neuer Version fragen
        Write-Host "Enter new version numbers (press Enter to keep current value):"
        Write-Host ""

        $newMajorVersion = Get-VersionInput -PromptText "Major version" -DefaultValue $majorVersion
        $newMinorVersion = Get-VersionInput -PromptText "Minor version" -DefaultValue $minorVersion
        $newPatchVersion = Get-VersionInput -PromptText "Patch version" -DefaultValue $patchVersion
        $newBuildVersion = Get-VersionInput -PromptText "Build number" -DefaultValue $buildVersion

        # Neue Versionstrings erstellen
        $pubspecVersion = "$newMajorVersion.$newMinorVersion.$newPatchVersion+$newBuildVersion"
        $msixVersion = "$newMajorVersion.$newMinorVersion.$newPatchVersion.$newBuildVersion"
        $pkgbuildVersion = "$newMajorVersion.$newMinorVersion.$newPatchVersion"

        Write-Host ""
        Write-Host "New version will be: v$newMajorVersion.$newMinorVersion.$newPatchVersion (Build $newBuildVersion)"
        $confirmation = Read-Host "Do you want to proceed? (Y/N)"

        if ($confirmation -ne "Y" -and $confirmation -ne "y")
        {
            Write-Host "Version update cancelled."
            return
        }
    }

    # Neue Versionstrings erstellen
    $pubspecVersion = "$newMajorVersion.$newMinorVersion.$newPatchVersion+$newBuildVersion"
    $msixVersion = "$newMajorVersion.$newMinorVersion.$newPatchVersion.$newBuildVersion"
    $pkgbuildVersion = "$newMajorVersion.$newMinorVersion.$newPatchVersion"

    # app_config.dart aktualisieren
    Write-Host "Updating app_config.dart..."
    $configContent = [regex]::Replace($configContent, 'versionMajor\s*=\s*\d+', "versionMajor = $newMajorVersion")
    $configContent = [regex]::Replace($configContent, 'versionMinor\s*=\s*\d+', "versionMinor = $newMinorVersion")
    $configContent = [regex]::Replace($configContent, 'versionPatch\s*=\s*\d+', "versionPatch = $newPatchVersion")
    $configContent = [regex]::Replace($configContent, 'versionBuild\s*=\s*\d+', "versionBuild = $newBuildVersion")
    Set-Content -Path $appConfigPath -Value $configContent

    # pubspec.yaml aktualisieren
    Write-Host "Updating pubspec.yaml..."
    $pubspecContent = Get-Content $pubspecPath -Raw
    $pubspecContent = [regex]::Replace($pubspecContent, 'version:\s*[\d\.]+\+\d+', "version: $pubspecVersion")
    $pubspecContent = [regex]::Replace($pubspecContent, 'msix_version:\s*[\d\.]+', "msix_version: $msixVersion")
    Set-Content -Path $pubspecPath -Value $pubspecContent

    # PKGBUILD aktualisieren
    Write-Host "Updating PKGBUILD..."
    if (Test-Path -LiteralPath $pkgbuildPath)
    {
        try
        {
            $pkgbuildContent = Get-Content -LiteralPath $pkgbuildPath -Raw
            $pkgbuildContent = [regex]::Replace($pkgbuildContent, 'pkgver=[\d\.]+', "pkgver=$pkgbuildVersion")
            Set-Content -LiteralPath $pkgbuildPath -Value $pkgbuildContent
        }
        catch
        {
            Write-Host "Skipping PKGBUILD update (error accessing file: $pkgbuildPath)"
            Write-Host "  Details: $( $_.Exception.Message )"
        }
    }
    else
    {
        Write-Host "Skipping PKGBUILD update (file not found: $pkgbuildPath)"
    }

    Write-Host ""
    Write-Host "Version update completed successfully!"
    Write-Host "New version: v$newMajorVersion.$newMinorVersion.$newPatchVersion (Build $newBuildVersion)"
}

# Function to update app description
function Update-Description
{
    # Description aus app_config.dart extrahieren
    $configContent = Get-Content $appConfigPath -Raw
    $appDescription = [regex]::Match($configContent, 'appDescription\s*=\s*''([^'']+)''').Groups[1].Value

    Write-Host "========================================================"
    Write-Host "              SANDI DESCRIPTION UPDATER                 "
    Write-Host "========================================================"
    Write-Host ""
    Write-Host "Current app description:"
    Write-Host "  $appDescription"
    Write-Host ""
    Write-Host "TIP: Type 'help' to see guidelines for writing a good app description."
    Write-Host ""
    Write-Host "========================================================"
    Write-Host ""

    # Benutzer nach neuer Beschreibung fragen
    Write-Host "Enter new app description (press Enter to keep current value):"
    Write-Host "Type 'help' to see guidelines for writing a good app description."
    Write-Host ""

    $inputComplete = $false
    $newDescription = $appDescription

    while (-not $inputComplete)
    {
        $input = Read-Host "Description"

        if ( [string]::IsNullOrWhiteSpace($input))
        {
            $newDescription = $appDescription
            $inputComplete = $true
        }
        elseif ($input.ToLower() -eq "help")
        {
            Show-DescriptionHelp
        }
        else
        {
            $newDescription = $input
            $inputComplete = $true
        }
    }

    if ($newDescription -eq $appDescription)
    {
        Write-Host "Description unchanged."
        return
    }

    Write-Host ""
    Write-Host "New description will be:"
    Write-Host "  $newDescription"
    $confirmation = Read-Host "Do you want to proceed? (Y/N)"

    if ($confirmation -ne "Y" -and $confirmation -ne "y")
    {
        Write-Host "Description update cancelled."
        return
    }

    # app_config.dart aktualisieren
    Write-Host "Updating app_config.dart..."
    $configContent = [regex]::Replace($configContent, "appDescription\s*=\s*'[^']+'", "appDescription = '$newDescription'")
    Set-Content -Path $appConfigPath -Value $configContent

    # pubspec.yaml aktualisieren
    Write-Host "Updating pubspec.yaml..."
    $pubspecContent = Get-Content $pubspecPath -Raw
    $pubspecContent = [regex]::Replace($pubspecContent, 'description:\s*"[^"]+"', "description: `"$newDescription`"")
    Set-Content -Path $pubspecPath -Value $pubspecContent

    # PKGBUILD aktualisieren
    Write-Host "Updating PKGBUILD description..."
    if (Test-Path -LiteralPath $pkgbuildPath)
    {
        try
        {
            $pkgbuildContent = Get-Content -LiteralPath $pkgbuildPath -Raw
            $replacement = "pkgdesc=`"$newDescription`""
            $pkgbuildContent = [regex]::Replace($pkgbuildContent, 'pkgdesc="[^"]+"', $replacement)
            Set-Content -LiteralPath $pkgbuildPath -Value $pkgbuildContent
        }
        catch
        {
            Write-Host "Skipping PKGBUILD description update (error accessing file: $pkgbuildPath)"
            Write-Host "  Details: $( $_.Exception.Message )"
        }
    }
    else
    {
        Write-Host "Skipping PKGBUILD description update (file not found: $pkgbuildPath)"
    }

    Write-Host ""
    Write-Host "Description update completed successfully!"
    Write-Host "New description: $newDescription"
}

# Run in non-interactive mode if requested (for build.ps1)
if ($NonInteractive)
{
    Update-Version -NonInteractive
    exit 0
}

# Main menu loop
$exitRequested = $false

while (-not $exitRequested)
{
    Clear-Host
    Write-Host "========================================================"
    Write-Host "                 SANDI CONFIGURATION TOOL               "
    Write-Host "========================================================"
    Write-Host ""
    Write-Host "Please select an option:"
    Write-Host ""
    Write-Host "1. Update Version"
    Write-Host "2. Update Description"
    Write-Host "3. Help"
    Write-Host "4. Exit"
    Write-Host ""
    Write-Host "========================================================"
    Write-Host ""

    $choice = Read-Host "Enter your choice (1-4)"

    switch ($choice)
    {
        "1" {
            Clear-Host
            Update-Version
            Write-Host ""
            Write-Host "Press Enter to return to the main menu..."
            Read-Host
        }
        "2" {
            Clear-Host
            Update-Description
            Write-Host ""
            Write-Host "Press Enter to return to the main menu..."
            Read-Host
        }
        "3" {
            Clear-Host
            Show-MainHelp
            Write-Host "Press Enter to return to the main menu..."
            Read-Host
        }
        "4" {
            $exitRequested = $true
            Write-Host "Exiting configuration tool."
        }
        default {
            Write-Host "Invalid choice. Please enter a number between 1 and 4."
            Write-Host "Press Enter to continue..."
            Read-Host
        }
    }
}