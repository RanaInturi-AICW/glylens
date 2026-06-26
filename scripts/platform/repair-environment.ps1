#Requires -Version 7.0
<#
.SYNOPSIS
    Guided remediation for GlyLens environment PATH and variables.
.DESCRIPTION
    Does NOT install software. Repairs PATH entries and prints guided steps for missing tools.
.EXAMPLE
    .\scripts\platform\repair-environment.ps1 -WhatIf
    .\scripts\platform\repair-environment.ps1 -RepairPath -RepairEnvVars
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$RepairPath,
    [switch]$RepairEnvVars,
    [switch]$ShowGuidance
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

. "$PSScriptRoot\_glylens-env-common.ps1"

Write-GlyLensHeader 'GlyLens Environment Repair (BP1.2)'

if (-not $RepairPath -and -not $RepairEnvVars -and -not $ShowGuidance) {
    $ShowGuidance = $true
    Write-Host 'No repair flags specified. Showing guidance only. Use -RepairPath -RepairEnvVars to apply safe fixes.' -ForegroundColor Yellow
    Write-Host ''
}

# Detect common install locations
$candidates = @{
    Flutter   = @('C:\src\flutter\bin', 'C:\flutter\bin', "$env:USERPROFILE\flutter\bin", 'D:\flutter\bin')
    AndroidSdk = @(
        (Join-Path $env:LOCALAPPDATA 'Android\Sdk'),
        'C:\Android\Sdk'
    )
    Git       = @('C:\Program Files\Git\cmd', 'C:\Program Files (x86)\Git\cmd')
    Gh        = @('C:\Program Files\GitHub CLI')
    Java      = @(
        'C:\Program Files\Eclipse Adoptium\jdk-17*\bin',
        'C:\Program Files\Java\jdk-17*\bin'
    )
    PubCache  = @(
        (Join-Path $env:LOCALAPPDATA 'Pub\Cache\bin'),
        (Join-Path $env:USERPROFILE 'AppData\Local\Pub\Cache\bin')
    )
}

function Find-FirstExisting {
    param([string[]]$Paths)
    foreach ($p in $Paths) {
        $resolved = Resolve-Path $p -ErrorAction SilentlyContinue
        if ($resolved) { return $resolved.Path }
        if (Test-Path $p) { return $p }
    }
    return $null
}

$flutterBin = Find-FirstExisting $candidates.Flutter
$androidSdk = Find-FirstExisting $candidates.AndroidSdk
$gitCmd     = Find-FirstExisting $candidates.Git
$ghPath     = Find-FirstExisting $candidates.Gh
$pubBin     = Find-FirstExisting $candidates.PubCache

$pathAdditions = @()
if ($flutterBin) { $pathAdditions += $flutterBin }
if ($androidSdk) {
    $pathAdditions += (Join-Path $androidSdk 'platform-tools')
    $cmdline = Join-Path $androidSdk 'cmdline-tools\latest\bin'
    if (Test-Path $cmdline) { $pathAdditions += $cmdline }
}
if ($gitCmd) { $pathAdditions += $gitCmd }
if ($ghPath) { $pathAdditions += $ghPath }
if ($pubBin) { $pathAdditions += $pubBin }

$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
if (-not $userPath) { $userPath = '' }
$pathList = $userPath -split ';' | Where-Object { $_ }

if ($RepairPath -and $pathAdditions.Count -gt 0) {
    $changed = $false
    foreach ($add in $pathAdditions) {
        if ($pathList -notcontains $add) {
            if ($PSCmdlet.ShouldProcess($add, 'Add to User PATH')) {
                $pathList += $add
                $changed = $true
                Write-Host "Added to PATH: $add" -ForegroundColor Green
            }
        }
        else {
            Write-Host "Already in PATH: $add" -ForegroundColor DarkGray
        }
    }
    if ($changed) {
        $newPath = ($pathList | Select-Object -Unique) -join ';'
        [Environment]::SetEnvironmentVariable('PATH', $newPath, 'User')
        $env:PATH = $newPath + ';' + [Environment]::GetEnvironmentVariable('PATH', 'Machine')
        Write-Host 'User PATH updated. Restart terminal for full effect.' -ForegroundColor Green
    }
}
elseif ($RepairPath) {
    Write-Host 'No known SDK paths found to add. See guidance below.' -ForegroundColor Yellow
}

if ($RepairEnvVars -and $androidSdk) {
    if ($PSCmdlet.ShouldProcess('ANDROID_HOME', "Set to $androidSdk")) {
        [Environment]::SetEnvironmentVariable('ANDROID_HOME', $androidSdk, 'User')
        [Environment]::SetEnvironmentVariable('ANDROID_SDK_ROOT', $androidSdk, 'User')
        $env:ANDROID_HOME = $androidSdk
        $env:ANDROID_SDK_ROOT = $androidSdk
        Write-Host "ANDROID_HOME set to $androidSdk" -ForegroundColor Green
    }
}

# JAVA_HOME guidance
$javaHome = Get-ChildItem 'C:\Program Files\Eclipse Adoptium' -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match 'jdk-17' } | Select-Object -First 1
if ($RepairEnvVars -and $javaHome) {
    if ($PSCmdlet.ShouldProcess('JAVA_HOME', "Set to $($javaHome.FullName)")) {
        [Environment]::SetEnvironmentVariable('JAVA_HOME', $javaHome.FullName, 'User')
        $env:JAVA_HOME = $javaHome.FullName
        Write-Host "JAVA_HOME set to $($javaHome.FullName)" -ForegroundColor Green
    }
}

if ($ShowGuidance) {
    Write-Host ''
    Write-Host '--- Guided Remediation (manual installs) ---' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '1. Flutter 3.27.4 stable' -ForegroundColor White
    Write-Host '   git clone https://github.com/flutter/flutter.git -b 3.27.4 C:\src\flutter'
    Write-Host '   Add C:\src\flutter\bin to User PATH'
    Write-Host ''
    Write-Host '2. Android Studio 2024.2.2' -ForegroundColor White
    Write-Host '   Install → SDK Manager → API 35, Build-Tools 35.0.0, Command-line Tools'
    Write-Host '   sdkmanager --licenses'
    Write-Host ''
    Write-Host '3. JDK 17 (Temurin)' -ForegroundColor White
    Write-Host '   winget install EclipseAdoptium.Temurin.17.JDK'
    Write-Host ''
    Write-Host '4. Docker Desktop' -ForegroundColor White
    Write-Host '   Enable WSL2 backend; integrate with Ubuntu-24.04'
    Write-Host ''
    Write-Host '5. GitHub CLI' -ForegroundColor White
    Write-Host '   winget install GitHub.cli'
    Write-Host '   gh auth login'
    Write-Host ''
    Write-Host '6. Firebase CLI (prepare only)' -ForegroundColor White
    Write-Host '   npm install -g firebase-tools@13.29.1'
    Write-Host '   dart pub global activate flutterfire_cli'
    Write-Host ''
    Write-Host '7. Re-validate' -ForegroundColor White
    Write-Host '   .\scripts\platform\validate-environment.ps1'
    Write-Host ''
    Write-Host 'Full guide: platform/GlyLens_Developer_Onboarding_Guide_v1.md' -ForegroundColor DarkCyan
}

Write-Host ''
Write-Host 'Repair complete. Run audit-environment.ps1 to verify.' -ForegroundColor Cyan
