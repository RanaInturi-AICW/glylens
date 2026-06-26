#Requires -Version 7.0
<#
.SYNOPSIS
    Runs GlyLens local quality gates (BP1.2 Part 8).
.DESCRIPTION
    Enforces: flutter doctor, analyze, test, format check.
    Exits non-zero on any failure.
.EXAMPLE
    .\scripts\platform\run-quality-gates.ps1
#>
[CmdletBinding()]
param(
    [switch]$SkipDoctor,
    [switch]$AllowWarnings
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. "$PSScriptRoot\_glylens-env-common.ps1"

Write-GlyLensHeader 'GlyLens Local Quality Gates'
$repoRoot = Get-RepoRoot
Push-Location $repoRoot

$failed = $false

function Assert-Step {
    param([string]$Name, [scriptblock]$Action)
    Write-Host "`n>> $Name" -ForegroundColor Cyan
    try {
        & $Action
        if ($LASTEXITCODE -ne 0 -and $null -ne $LASTEXITCODE) {
            throw "Exit code $LASTEXITCODE"
        }
        Write-Host "   PASS" -ForegroundColor Green
    }
    catch {
        Write-Host "   FAIL: $_" -ForegroundColor Red
        $script:failed = $true
    }
}

if (-not $SkipDoctor) {
    Assert-Step 'flutter doctor -v' { flutter doctor -v }
}

Assert-Step 'flutter pub get' { flutter pub get }

Assert-Step 'dart format (check)' {
    dart format --output=none --set-exit-if-changed lib test integration_test scripts
}

Assert-Step 'flutter analyze' {
    if ($AllowWarnings) { flutter analyze }
    else { flutter analyze --fatal-infos }
}

Assert-Step 'dart analyze' { dart analyze --fatal-infos lib test integration_test }

Assert-Step 'flutter test' { flutter test }

Pop-Location

Write-Host ''
if ($failed) {
    Write-Host 'QUALITY GATES: FAILED' -ForegroundColor Red
    Write-Host 'See platform/GlyLens_Local_Quality_Gates_v1.md' -ForegroundColor DarkGray
    exit 1
}

Write-Host 'QUALITY GATES: PASSED' -ForegroundColor Green
exit 0
