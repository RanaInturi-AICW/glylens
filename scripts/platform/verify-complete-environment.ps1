# Complete environment verification — runs all verify-* scripts
param([switch]$SkipQualityGates)

. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'GlyLens Complete Environment Verification (BP1.3)'

$scripts = @(
    'install-prerequisite-check.ps1',
    'verify-java.ps1',
    'verify-flutter.ps1',
    'verify-android.ps1',
    'verify-docker.ps1',
    'verify-wsl.ps1',
    'verify-github.ps1'
)

$failed = @()
foreach ($s in $scripts) {
    $path = Join-Path $PSScriptRoot $s
    Write-Host "`n--- Running $s ---`n" -ForegroundColor DarkCyan
    & $path
    if ($LASTEXITCODE -ne 0) { $failed += $s }
}

if (-not $SkipQualityGates -and (Get-Command flutter -ErrorAction SilentlyContinue)) {
    $qg = Join-Path $PSScriptRoot 'run-quality-gates.ps1'
    if (Test-Path $qg) {
        Write-Host "`n--- Running run-quality-gates.ps1 ---`n" -ForegroundColor DarkCyan
        & $qg
        if ($LASTEXITCODE -ne 0) { $failed += 'run-quality-gates.ps1' }
    }
}
elseif (-not $SkipQualityGates) {
    Write-Host '[SKIP] Quality gates — Flutter not installed' -ForegroundColor Yellow
}

Write-Host ''
Write-GlyLensHeader 'Summary'
if ($failed.Count -eq 0) {
    Write-Host 'ENVIRONMENT: READY (or READY WITH MINOR ACTIONS if warnings only)' -ForegroundColor Green
    Write-Host 'See platform/GlyLens_Environment_Readiness_Report.md for final decision.'
    exit 0
}

Write-Host "ENVIRONMENT: NOT READY — $($failed.Count) check(s) failed:" -ForegroundColor Red
$failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
Write-Host ''
Write-Host 'Remediation: platform/GlyLens_Installation_Guide.md'
Write-Host '             platform/GlyLens_Environment_Readiness_Report.md'
exit 1
