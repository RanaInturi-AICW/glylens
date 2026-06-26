#Requires -Version 7.0
<#
.SYNOPSIS
    Validates GlyLens environment readiness (extends audit with functional checks).
.DESCRIPTION
    Runs flutter doctor, license check, docker hello-world, and repo quality pre-checks.
    Does NOT install software.
.EXAMPLE
    .\scripts\platform\validate-environment.ps1
#>
[CmdletBinding()]
param(
    [switch]$SkipFlutterDoctor,
    [switch]$SkipDocker
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

. "$PSScriptRoot\_glylens-env-common.ps1"

Write-GlyLensHeader 'GlyLens Environment Validation (BP1.2)'
$results = @()
$repoRoot = Get-RepoRoot

# Inherit audit
& "$PSScriptRoot\audit-environment.ps1" -ReportJson (Join-Path $env:TEMP 'glylens-validate-audit.json') | Out-Null
$auditResults = Get-Content (Join-Path $env:TEMP 'glylens-validate-audit.json') | ConvertFrom-Json
$results += $auditResults

# PATH validation
$requiredPathFragments = @('flutter\bin', 'platform-tools', 'Git\cmd')
$pathEnv = $env:PATH -split ';'
foreach ($frag in $requiredPathFragments) {
    $found = @($pathEnv | Where-Object { $_ -match [regex]::Escape($frag) }).Count -gt 0
    $results += New-GlyLensCheckResult -Name "PATH contains $frag" -Status $(if ($found) { 'Pass' } else { 'Fail' }) `
        -Remediation "Run .\scripts\platform\repair-environment.ps1 -RepairPath"
}

# ANDROID_HOME
$ah = $env:ANDROID_HOME
if (-not $ah) { $ah = $env:ANDROID_SDK_ROOT }
$results += New-GlyLensCheckResult -Name 'ANDROID_HOME / ANDROID_SDK_ROOT' -Status $(if ($ah) { 'Pass' } else { 'Fail' }) `
    -Detail $(if ($ah) { $ah } else { 'Not set' }) `
    -Remediation 'Set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk (User environment variable).'

# Flutter doctor
if (-not $SkipFlutterDoctor -and (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host 'Running flutter doctor -v ...' -ForegroundColor DarkCyan
    $doctor = flutter doctor -v 2>&1 | Out-String
    $doctorOk = $doctor -notmatch '\[✗\]' -and $doctor -notmatch '\[X\]'
    if (-not $doctorOk) {
        # Allow missing Xcode on Windows
        $doctorOk = ($doctor -notmatch '\[✗\].*Android toolchain' -and $doctor -notmatch '\[X\].*Android toolchain') -and
                    ($doctor -match '\[✓\].*Flutter' -or $doctor -match '\[√\].*Flutter')
    }
    $results += New-GlyLensCheckResult -Name 'flutter doctor -v' -Status $(if ($doctorOk) { 'Pass' } else { 'Fail' }) `
        -Detail 'See console output above' `
        -Remediation 'Resolve each [✗] item: Android licenses, cmdline-tools, Android Studio install.'
    Write-Host $doctor
}
elseif ($SkipFlutterDoctor) {
    $results += New-GlyLensCheckResult -Name 'flutter doctor -v' -Status 'Skip' -Detail 'Skipped by flag'
}
else {
    $results += New-GlyLensCheckResult -Name 'flutter doctor -v' -Status 'Fail' -Remediation 'Install Flutter SDK first.'
}

# Android licenses
if (Get-Command sdkmanager -ErrorAction SilentlyContinue) {
    $licenses = sdkmanager --licenses 2>&1 | Out-String
    $licOk = $licenses -notmatch 'not accepted' -or $licenses -match 'All SDK package licenses accepted'
    $results += New-GlyLensCheckResult -Name 'Android SDK Licenses' -Status $(if ($licOk) { 'Pass' } else { 'Warn' }) `
        -Remediation 'sdkmanager --licenses (accept all with y).'
}
else {
    $cmdline = Join-Path $env:LOCALAPPDATA 'Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat'
    if (Test-Path $cmdline) {
        $results += New-GlyLensCheckResult -Name 'Android SDK Licenses' -Status 'Warn' `
            -Remediation "Add cmdline-tools to PATH; run: `"$cmdline`" --licenses"
    }
    else {
        $results += New-GlyLensCheckResult -Name 'Android SDK Licenses' -Status 'Fail' `
            -Remediation 'Android Studio → SDK Manager → SDK Tools → Android SDK Command-line Tools.'
    }
}

# Docker functional test
if (-not $SkipDocker -and (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host 'Running docker compose version ...' -ForegroundColor DarkCyan
    $dc = docker compose version 2>&1 | Out-String
    $dcOk = $LASTEXITCODE -eq 0
    $results += New-GlyLensCheckResult -Name 'docker compose' -Status $(if ($dcOk) { 'Pass' } else { 'Fail' }) -Detail $dc.Trim()
    if ($dcOk -and (Test-Path (Join-Path $repoRoot 'docker\docker-compose.dev.yml'))) {
        $configOk = docker compose -f (Join-Path $repoRoot 'docker\docker-compose.dev.yml') config 2>&1 | Out-String
        $results += New-GlyLensCheckResult -Name 'docker-compose.dev.yml valid' -Status $(if ($LASTEXITCODE -eq 0) { 'Pass' } else { 'Fail' }) -Detail 'Config parse check'
    }
}

# GitHub auth push test (read-only)
if (Get-Command gh -ErrorAction SilentlyContinue) {
    try {
        $perms = gh api repos/RanaInturi-AICW/glylens --jq '.permissions.push' 2>&1
        $canPush = $perms -eq 'true'
        $results += New-GlyLensCheckResult -Name 'GitHub Push Permission' -Status $(if ($canPush) { 'Pass' } else { 'Warn' }) `
            -Detail "push=$perms" `
            -Remediation 'gh auth login with RanaInturi-AICW or request collaborator write access.'
    }
    catch {
        $results += New-GlyLensCheckResult -Name 'GitHub Push Permission' -Status 'Warn' -Detail $_.Exception.Message
    }
}

# Pub get pre-check
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Push-Location $repoRoot
    try {
        $pubGet = flutter pub get 2>&1 | Out-String
        $pubOk = $LASTEXITCODE -eq 0
        $results += New-GlyLensCheckResult -Name 'flutter pub get' -Status $(if ($pubOk) { 'Pass' } else { 'Fail' }) `
            -Detail $(if ($pubOk) { 'Dependencies resolved' } else { ($pubGet -split "`n" | Select-Object -Last 5) -join ' ' }) `
            -Remediation 'Fix pubspec.yaml (see BP1.1 TD-001: intl ^0.20.2).'
    }
    finally { Pop-Location }
}

Write-GlyLensReport -Results $results -ReportPath (Join-Path $env:TEMP 'glylens-validate-report.json')

$failures = @($results | Where-Object { $_.Status -in 'Missing', 'Misconfigured', 'Fail' })
exit $(if ($failures.Count -gt 0) { 1 } else { 0 })
