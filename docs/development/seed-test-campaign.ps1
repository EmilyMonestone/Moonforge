<#
Seed a demo campaign into Firestore using Firebase CLI (flat collections)

Usage:
  .\seed-test-campaign.ps1 -Project your-project-id -Uid your-auth-uid [-CampaignId c_demo]

Params:
  -Project     Firebase project ID (required)
  -Uid         Authenticated user UID to add as owner/member (required)
  -CampaignId  Campaign document ID (optional, default: c_demo)

Requires:
  - Firebase CLI (firebase) installed and in PATH.
  - PowerShell 5+ or PowerShell Core.
#>
param(
    [Parameter(Mandatory = $true)] [string]$Project,
    [Parameter(Mandatory = $true)] [string]$Uid,
    [Parameter(Mandatory = $false)] [string]$CampaignId = "c_demo"
)

function Assert-HasFirebaseCli
{
    $null = Get-Command firebase -ErrorAction SilentlyContinue
    if (!$?)
    {
        Write-Error "Firebase CLI not found. Install with: npm install -g firebase-tools"
        exit 1
    }
}

function Assert-FirestoreDocumentsSetSupportsDataFlag
{
    try
    {
        $help = firebase firestore:documents:set --help 2>&1 | Out-String
        if ($help -notmatch "--data")
        {
            Write-Error "Your Firebase CLI does not support '--data' for 'firestore:documents:set'. Please update it: npm install -g firebase-tools"
            exit 1
        }
    }
    catch
    {
        Write-Error "Failed to query Firebase CLI help. Ensure firebase-tools is installed and on PATH."
        exit 1
    }
}

function Invoke-SeedFromJson
{
    param(
        [string]$JsonPath,
        [string]$Project,
        [string]$Uid,
        [string]$CampaignId
    )

    if (!(Test-Path $JsonPath))
    {
        Write-Error "Data file not found: $JsonPath"
        exit 1
    }

    $raw = Get-Content -Raw -Path $JsonPath
    $raw = $raw -replace "__UID__",[Regex]::Escape($Uid)
    $raw = $raw -replace "__CAMPAIGN_ID__",[Regex]::Escape($CampaignId)

    $data = $raw | ConvertFrom-Json
    if (-not $data -or -not $data.documents)
    {
        Write-Error "Invalid data file format. Expected object with 'documents' array."
        exit 1
    }

    foreach ($doc in $data.documents)
    {
        $path = $doc.path
        $json = ($doc.data | ConvertTo-Json -Depth 20 -Compress)
        Write-Host "Seeding $path" -ForegroundColor Cyan
        $args = @("firestore:documents:set", $path, "--project", $Project, "--data", $json)
        firebase @args
        if ($LASTEXITCODE -ne 0)
        {
            Write-Error "Failed to seed $path"
            exit $LASTEXITCODE
        }
    }
}

function Get-ScriptDir
{
    if ($PSScriptRoot -and -not [string]::IsNullOrWhiteSpace($PSScriptRoot))
    {
        return $PSScriptRoot
    }
    if ($PSCommandPath -and -not [string]::IsNullOrWhiteSpace($PSCommandPath))
    {
        return (Split-Path -Parent $PSCommandPath)
    }
    if ($MyInvocation -and $MyInvocation.MyCommand -and $MyInvocation.MyCommand.Path)
    {
        return (Split-Path -Parent $MyInvocation.MyCommand.Path)
    }
    return (Get-Location).Path
}

function Assert-HasNode
{
    $null = Get-Command node -ErrorAction SilentlyContinue
    if (!$?)
    {
        Write-Error "Node.js not found. Install Node.js LTS from https://nodejs.org/ and ensure 'node' is on PATH."
        exit 1
    }
}

function Invoke-SeedWithAdminNode
{
    param(
        [string]$Project,
        [string]$Uid,
        [string]$CampaignId
    )
    $scriptDir = Get-ScriptDir
    $nodeScript = Join-Path $scriptDir "seed-test-campaign.mjs"

    if (!(Test-Path $nodeScript))
    {
        Write-Error "Admin seeder script not found: $nodeScript"
        exit 1
    }

    Assert-HasNode

    # Ensure firebase-admin is installed locally next to the script
    $adminPkg = Join-Path $scriptDir "node_modules/firebase-admin/package.json"
    if (!(Test-Path $adminPkg))
    {
        Write-Host "Installing local npm dependencies (firebase-admin) in $scriptDir ..." -ForegroundColor Yellow
        Push-Location $scriptDir
        try
        {
            if (!(Test-Path (Join-Path $scriptDir 'package.json')))
            {
                npm init -y | Out-Null
                if ($LASTEXITCODE -ne 0)
                {
                    throw "npm init failed"
                }
            }
            npm install --no-audit --no-fund firebase-admin | Out-Null
            if ($LASTEXITCODE -ne 0)
            {
                throw "npm install firebase-admin failed"
            }
        }
        catch
        {
            Pop-Location
            Write-Error "Failed to install firebase-admin. You can install manually: `n`cd `"$scriptDir`"`n npm init -y`n npm install firebase-admin"
            exit 1
        }
        Pop-Location
    }

    # Use ADC if available (GOOGLE_APPLICATION_CREDENTIALS or gcloud ADC)
    $cmd = "node `"$nodeScript`" --project `"$Project`" --uid `"$Uid`" --campaign `"$CampaignId`""
    Write-Host "Falling back to Admin SDK seeder: $cmd" -ForegroundColor Yellow
    & node $nodeScript --project $Project --uid $Uid --campaign $CampaignId
    if ($LASTEXITCODE -ne 0)
    {
        Write-Error "Admin SDK seed failed. Ensure ADC is configured or set GOOGLE_APPLICATION_CREDENTIALS to a service account JSON."
        exit $LASTEXITCODE
    }
}

Write-Host "Seeding demo data into project $Project for uid $Uid ..." -ForegroundColor Green
Write-Host "Campaign ID: $CampaignId" -ForegroundColor Green

Assert-HasFirebaseCli

# Try CLI path first if supported, else fallback to Admin SDK
$help = firebase firestore:documents:set --help 2>&1 | Out-String
if ($help -match "--data")
{
    Assert-FirestoreDocumentsSetSupportsDataFlag

    # Data file located next to this script
    $scriptDir = Get-ScriptDir
    $dataFile = Join-Path $scriptDir "test-campaign-data.json"

    Invoke-SeedFromJson -JsonPath $dataFile -Project $Project -Uid $Uid -CampaignId $CampaignId
}
else
{
    Invoke-SeedWithAdminNode -Project $Project -Uid $Uid -CampaignId $CampaignId
}

Write-Host "Done. Verify data in Firebase Console > Firestore." -ForegroundColor Green
