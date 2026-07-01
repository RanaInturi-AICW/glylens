# Create D:\glylens-dev folder structure (no software download)
param([switch]$Force)

. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'Initialize GlyLens Dev Root'
$p = Get-GlyLensDevPaths
Write-GlyLensPathBanner

$dirs = @(
    $p.DevRoot
    $p.FlutterRoot
    (Split-Path $p.AndroidSdk -Parent)
    $p.AndroidSdk
    $p.AndroidStudio
    (Split-Path $p.PubCache -Parent)
    $p.PubCache
    (Join-Path $p.DevRoot 'jdk')
    (Join-Path $p.DevRoot 'docker')
)

foreach ($d in $dirs) {
    if (Test-Path $d) {
        Write-Host "Exists: $d" -ForegroundColor DarkGray
        continue
    }
    if (-not (Confirm-GlyLensAction "Create directory: $d" -Force:$Force)) {
        Write-Host 'Skipped.' -ForegroundColor Yellow
        continue
    }
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    Write-Host "Created: $d" -ForegroundColor Green
}

Write-Host ''
Write-Host 'Next: GlyLens_Installation_Guide.md Step 1 (install tools into these folders)' -ForegroundColor Cyan
