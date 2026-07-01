# Configure PATH and environment variables — requires confirmation per change
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$SetJavaHome,
    [switch]$SetAndroidHome,
    [switch]$SetFlutterPath,
    [switch]$SetPubCache,
    [switch]$RepairAll,
    [switch]$Force
)

. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'GlyLens PATH Configuration (BP1.3)'
Write-GlyLensPathBanner
$paths = Get-GlyLensDevPaths

# Load persisted JAVA_HOME into this session for detection
if (-not $env:JAVA_HOME) {
    $persistedJh = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
    if (-not $persistedJh) {
        $persistedJh = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'Machine')
    }
    if ($persistedJh) { $env:JAVA_HOME = $persistedJh }
}

Write-Host 'This script modifies USER environment variables only after confirmation.' -ForegroundColor Yellow
Write-Host ''

if ($RepairAll) {
    $SetJavaHome = $true
    $SetAndroidHome = $true
    $SetFlutterPath = $true
    $SetPubCache = $true
}

function Add-UserPathEntry {
    param(
        [string]$Entry,
        [switch]$Promote
    )
    if (-not $Entry) { return $false }
    if (-not (Test-Path $Entry -ErrorAction SilentlyContinue)) {
        Write-Host "PATH target not found (install first): $Entry" -ForegroundColor Yellow
        return $false
    }
    $userPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
    $parts = @($userPath -split ';' | Where-Object { $_ })
    if ($parts -contains $Entry) {
        if (-not $Promote) {
            Write-Host "PATH already contains: $Entry" -ForegroundColor DarkGray
            return $true
        }
        $parts = @($parts | Where-Object { $_ -ne $Entry })
        Write-Host "Promoting PATH entry to front: $Entry" -ForegroundColor Cyan
    }
    if (-not (Confirm-GlyLensAction "Prepend to User PATH (first): $Entry" -Force:$Force)) {
        Write-Host 'Skipped.' -ForegroundColor Yellow
        return $false
    }
    $parts = @($Entry) + @($parts | Where-Object { $_ -ne $Entry })
    [Environment]::SetEnvironmentVariable('PATH', ($parts -join ';'), 'User')
    $env:PATH = ($parts -join ';') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'Machine')
    Write-Host "Prepended: $Entry" -ForegroundColor Green
    return $true
}

function Set-UserEnvVar {
    param([string]$Name, [string]$Value)
    if (-not $Value) { return $false }
    if (-not (Confirm-GlyLensAction "Set User $Name = $Value" -Force:$Force)) {
        Write-Host 'Skipped.' -ForegroundColor Yellow
        return $false
    }
    [Environment]::SetEnvironmentVariable($Name, $Value, 'User')
    Set-Item -Path "env:$Name" -Value $Value
    Write-Host "Set $Name" -ForegroundColor Green
    return $true
}

function Find-Jdk17 {
    return Resolve-GlyLensJdkHome
}

# JDK 17
if ($SetJavaHome) {
    $jdkHome = Find-Jdk17
    if ($jdkHome) {
        $javaExe = Join-Path $jdkHome 'bin\java.exe'
        $ver = & $javaExe -version 2>&1 | Out-String
        if ($ver -notmatch 'version "17') {
            Write-Host ('[WARN] JAVA_HOME points to non-17 JDK: {0}' -f $jdkHome) -ForegroundColor Yellow
            Write-Host ('       {0}' -f (($ver -split "`n" | Select-Object -First 1))) -ForegroundColor Yellow
        }
        else {
            Write-Host ('[OK] JDK 17 found: {0}' -f $jdkHome) -ForegroundColor Green
            Write-Host ('       {0}' -f (($ver -split "`n" | Select-Object -First 1))) -ForegroundColor DarkGray
        }
        $currentUserHome = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
        if ($currentUserHome -eq $jdkHome) {
            Write-Host ('JAVA_HOME already set (User): {0}' -f $jdkHome) -ForegroundColor DarkGray
        }
        else {
            Set-UserEnvVar -Name 'JAVA_HOME' -Value $jdkHome
        }
        $jdkBin = Join-Path $jdkHome 'bin'
        Add-UserPathEntry -Entry $jdkBin -Promote
        $oracleJavapath = 'C:\Program Files\Common Files\Oracle\Java\javapath'
        $machinePath = [Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';' |
            Where-Object { $_ }
        if ($machinePath -contains $oracleJavapath) {
            Write-Host ('[WARN] Machine PATH contains Oracle javapath (JDK 21 shim): {0}' -f $oracleJavapath) -ForegroundColor Yellow
            Write-Host '       Persisted PATH prefers JDK 17; restart Cursor fully if java -version still shows 21.' -ForegroundColor DarkGray
            Write-Host '       Optional (Admin): remove Oracle javapath from System PATH in Environment Variables.' -ForegroundColor DarkGray
        }
        $env:PATH = ($jdkBin + ';' + (($env:PATH -split ';' | Where-Object { $_ -and $_ -ne $jdkBin }) -join ';'))
    }
    else {
        Write-Host ('[FAIL] JDK 17 not found. Install to: {0}' -f (Join-Path $paths.DevRoot 'jdk')) -ForegroundColor Red
        Write-Host '       See GlyLens_Installation_Guide.md Step 2 (D: drive install).' -ForegroundColor DarkGray
    }
}
# Android SDK
if ($SetAndroidHome) {
    if (-not $env:ANDROID_HOME) {
        $persisted = [Environment]::GetEnvironmentVariable('ANDROID_HOME', 'User')
        if (-not $persisted) {
            $persisted = [Environment]::GetEnvironmentVariable('ANDROID_HOME', 'Machine')
        }
        if ($persisted) { $env:ANDROID_HOME = $persisted }
    }

    $sdk = Resolve-GlyLensAndroidSdk
    if ($sdk) {
        Write-Host ('[OK] Android SDK found: {0}' -f $sdk) -ForegroundColor Green
        $currentUser = [Environment]::GetEnvironmentVariable('ANDROID_HOME', 'User')
        if ($currentUser -eq $sdk) {
            Write-Host ('ANDROID_HOME already set (User): {0}' -f $sdk) -ForegroundColor DarkGray
        }
        else {
            Set-UserEnvVar -Name 'ANDROID_HOME' -Value $sdk
        }
        $currentRoot = [Environment]::GetEnvironmentVariable('ANDROID_SDK_ROOT', 'User')
        if ($currentRoot -ne $sdk) {
            Set-UserEnvVar -Name 'ANDROID_SDK_ROOT' -Value $sdk
        }
        Add-UserPathEntry -Entry (Join-Path $sdk 'platform-tools')
        $cmdline = Join-Path $sdk 'cmdline-tools\latest\bin'
        if (Test-Path $cmdline) { Add-UserPathEntry -Entry $cmdline }
        $emu = Join-Path $sdk 'emulator'
        if (Test-Path $emu) { Add-UserPathEntry -Entry $emu }
    }
    else {
        Write-Host ('[FAIL] SDK not found. Set SDK path to {0} or D:\AndroidStudio-Sdk' -f $paths.AndroidSdk) -ForegroundColor Red
        Write-Host '       Or set User env GLYLENS_ANDROID_SDK=D:\AndroidStudio-Sdk' -ForegroundColor DarkGray
    }
}

# Flutter (D: default)
if ($SetFlutterPath) {
    $flutterCandidates = @(
        $paths.FlutterBin
        'D:\glylens-dev\flutter\bin'
        'C:\src\flutter\bin'
        'D:\flutter\bin'
        "$env:USERPROFILE\flutter\bin"
    )
    $flutterBin = $flutterCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($flutterBin) {
        Add-UserPathEntry -Entry $flutterBin
    }
    else {
        Write-Host "[FAIL] Flutter not found. Clone to: $($paths.FlutterRoot)" -ForegroundColor Red
    }
}

# Pub cache on D:
if ($SetPubCache) {
    if (-not (Test-Path $paths.PubCache)) {
        if (Confirm-GlyLensAction "Create directory $($paths.PubCache)" -Force:$Force) {
            New-Item -ItemType Directory -Path $paths.PubCache -Force | Out-Null
        }
    }
    if (Test-Path $paths.PubCache) {
        Set-UserEnvVar -Name 'PUB_CACHE' -Value $paths.PubCache
        Add-UserPathEntry -Entry (Join-Path $paths.PubCache 'bin')
    }
}

Write-Host ''
Write-Host 'Restart terminal for PATH changes to take full effect.' -ForegroundColor Cyan
