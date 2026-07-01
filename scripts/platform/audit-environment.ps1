#Requires -Version 7.0
<#
.SYNOPSIS
    Audits the GlyLens development environment against the Engineering BOM.
.DESCRIPTION
    Reports Installed / Missing / Outdated / Misconfigured for all platform tools.
    Does NOT install or modify software.
.EXAMPLE
    .\scripts\platform\audit-environment.ps1
    .\scripts\platform\audit-environment.ps1 -ReportJson .\glylens-audit.json
#>
[CmdletBinding()]
param(
    [string]$ReportJson = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

. "$PSScriptRoot\_glylens-env-common.ps1"

Write-GlyLensHeader 'GlyLens Environment Audit (BP1.2)'
$results = @()

# --- Windows ---
$os = Get-CimInstance Win32_OperatingSystem
$results += New-GlyLensCheckResult -Name 'Windows 11' -Status $(if ($os.Caption -match 'Windows 11') { 'Installed' } else { 'Misconfigured' }) `
    -Detail $os.Caption `
    -Remediation 'Upgrade to Windows 11 23H2 or later per Platform Contract.'

$psVer = $PSVersionTable.PSVersion
$results += New-GlyLensCheckResult -Name 'PowerShell' -Status $(if ($psVer -ge $GlyLensBom.PowerShellMin) { 'Installed' } else { 'Outdated' }) `
    -Detail "pwsh $psVer" `
    -Remediation 'Install PowerShell 7.4+ from https://github.com/PowerShell/PowerShell/releases'

# --- WSL2 ---
$wslVer = Get-CommandVersion 'wsl' '--version'
if ($null -eq $wslVer) {
    $results += New-GlyLensCheckResult -Name 'WSL2' -Status 'Missing' -Remediation 'wsl --install (admin PowerShell); reboot; wsl --set-default-version 2'
}
else {
    $wslOk = $wslVer -match 'WSL version:\s*2\.' -or $wslVer -match '2\.\d+'
    $results += New-GlyLensCheckResult -Name 'WSL2' -Status $(if ($wslOk) { 'Installed' } else { 'Misconfigured' }) `
        -Detail ($wslVer -split "`n" | Select-Object -First 3) -join '; ' `
        -Remediation 'wsl --update; wsl --set-default-version 2'
    try {
        $ubuntu = wsl -l -v 2>&1 | Out-String
        $hasUbuntu = $ubuntu -match 'Ubuntu'
        $results += New-GlyLensCheckResult -Name 'Ubuntu (WSL)' -Status $(if ($hasUbuntu) { 'Installed' } else { 'Missing' }) `
            -Detail $(if ($hasUbuntu) { ($ubuntu -split "`n" | Where-Object { $_ -match 'Ubuntu' }) -join ' ' } else { 'No Ubuntu distro' }) `
            -Remediation 'wsl --install -d Ubuntu-24.04'
    }
    catch {
        $results += New-GlyLensCheckResult -Name 'Ubuntu (WSL)' -Status 'Skip' -Detail $_.Exception.Message
    }
}

# --- Flutter / Dart ---
$flutterVer = Get-CommandVersion 'flutter' '--version'
if ($null -eq $flutterVer) {
    $results += New-GlyLensCheckResult -Name 'Flutter' -Status 'Missing' `
        -Remediation 'Clone stable 3.27.4 to C:\src\flutter; add bin to PATH. See platform/GlyLens_Developer_Onboarding_Guide_v1.md'
    $results += New-GlyLensCheckResult -Name 'Dart' -Status 'Missing' -Remediation 'Installed with Flutter SDK.'
}
else {
    $flutterOk = Test-VersionMatch $flutterVer $GlyLensBom.FlutterVersion
    $results += New-GlyLensCheckResult -Name 'Flutter' -Status $(if ($flutterOk) { 'Installed' } else { 'Outdated' }) `
        -Detail ($flutterVer -split "`n" | Select-Object -First 1) `
        -Remediation "flutter upgrade; target $($GlyLensBom.FlutterVersion) stable per EBOM."
    $dartLine = ($flutterVer -split "`n" | Where-Object { $_ -match 'Dart' } | Select-Object -First 1)
    $dartOk = Test-VersionMatch $dartLine $GlyLensBom.DartVersion
    $results += New-GlyLensCheckResult -Name 'Dart' -Status $(if ($dartOk) { 'Installed' } else { 'Outdated' }) `
        -Detail $dartLine -Remediation 'Upgrade Flutter to matching Dart version.'
}

# --- Android SDK ---
$androidHome = $env:ANDROID_HOME
if (-not $androidHome) { $androidHome = Join-Path $env:LOCALAPPDATA 'Android\Sdk' }
$sdkExists = Test-Path $androidHome
$results += New-GlyLensCheckResult -Name 'Android SDK' -Status $(if ($sdkExists) { 'Installed' } else { 'Missing' }) `
    -Detail $(if ($sdkExists) { $androidHome } else { 'ANDROID_HOME not set / SDK not found' }) `
    -Remediation 'Install Android Studio; SDK Manager → API 35+ platform + Build-Tools 37.0.0; set ANDROID_HOME.'

if ($sdkExists) {
    $adb = Join-Path $androidHome 'platform-tools\adb.exe'
    $results += New-GlyLensCheckResult -Name 'Android platform-tools (adb)' -Status $(if (Test-Path $adb) { 'Installed' } else { 'Missing' }) `
        -Remediation 'sdkmanager "platform-tools"'
    $platformCheck = Test-GlyLensAndroidPlatformMeetsMinimum -SdkRoot $androidHome -MinApi $GlyLensBom.AndroidApiLevel
    $platformName = "Android API platform (>= $($GlyLensBom.AndroidApiLevel))"
    $results += New-GlyLensCheckResult -Name $platformName -Status $(if ($platformCheck.Ok) { 'Installed' } else { 'Missing' }) `
        -Detail $(if ($platformCheck.Ok) { $platformCheck.Best.Folder } else { 'No platform at or above minimum API' }) `
        -Remediation "sdkmanager `"platforms;android-$($GlyLensBom.AndroidApiLevel)`" (or newer)"
    $preferredBt = Join-Path $androidHome "build-tools\$($GlyLensBom.AndroidBuildToolsVersion)"
    $btInstalled = Get-GlyLensInstalledBuildTools -SdkRoot $androidHome
    $btOk = (Test-Path $preferredBt) -or (($btInstalled | Select-Object -First 1).Version.Major -ge 35)
    $btDetail = if (Test-Path $preferredBt) { $GlyLensBom.AndroidBuildToolsVersion } else { ($btInstalled | Select-Object -First 1).Folder }
    $results += New-GlyLensCheckResult -Name 'Android SDK Build-Tools' -Status $(if ($btOk) { 'Installed' } else { 'Missing' }) `
        -Detail $btDetail `
        -Remediation "sdkmanager `"build-tools;$($GlyLensBom.AndroidBuildToolsVersion)`""
}

# --- Java ---
$javaVer = Get-CommandVersion 'java' '-version'
if ($null -eq $javaVer) {
    $results += New-GlyLensCheckResult -Name 'Java (JDK 17)' -Status 'Missing' `
        -Remediation 'Install Eclipse Temurin 17; set JAVA_HOME. Android Studio → Gradle JDK → 17.'
}
else {
    $javaOk = $javaVer -match 'version "17' -or $javaVer -match 'openjdk 17'
    $results += New-GlyLensCheckResult -Name 'Java (JDK 17)' -Status $(if ($javaOk) { 'Installed' } else { 'Outdated' }) `
        -Detail ($javaVer -split "`n" | Select-Object -First 1) `
        -Remediation 'Install JDK 17; set JAVA_HOME to JDK 17 path.'
}
if ($env:JAVA_HOME) {
    $results += New-GlyLensCheckResult -Name 'JAVA_HOME' -Status 'Installed' -Detail $env:JAVA_HOME
}
else {
    $results += New-GlyLensCheckResult -Name 'JAVA_HOME' -Status 'Misconfigured' `
        -Remediation 'Set JAVA_HOME to JDK 17 install path (System Environment Variables).'
}

# --- Gradle (project wrapper when present) ---
$repoRoot = try { Get-RepoRoot } catch { $null }
if ($repoRoot) {
    $gradlew = Join-Path $repoRoot 'android\gradlew.bat'
    if (Test-Path $gradlew) {
        $gradleOut = & $gradlew --version 2>&1 | Out-String
        $results += New-GlyLensCheckResult -Name 'Gradle (wrapper)' -Status 'Installed' -Detail ($gradleOut -split "`n" | Select-Object -First 3) -join ' '
    }
    else {
        $results += New-GlyLensCheckResult -Name 'Gradle (wrapper)' -Status 'Missing' `
            -Detail 'android/ not committed yet' `
            -Remediation 'Run: flutter create . --org com.glylens --project-name glylens --platforms android,ios'
    }
}

# --- Git / GitHub CLI ---
$gitVer = Get-CommandVersion 'git' '--version'
if ($gitVer) {
    $gv = [version]($gitVer -replace '[^\d\.]', '')
    $results += New-GlyLensCheckResult -Name 'Git' -Status $(if ($gv -ge $GlyLensBom.GitMin) { 'Installed' } else { 'Outdated' }) -Detail $gitVer
}
else {
    $results += New-GlyLensCheckResult -Name 'Git' -Status 'Missing' -Remediation 'https://git-scm.com/download/win'
}

$ghVer = Get-CommandVersion 'gh' '--version'
if ($ghVer) {
    $results += New-GlyLensCheckResult -Name 'GitHub CLI' -Status 'Installed' -Detail ($ghVer -split "`n" | Select-Object -First 1)
    try {
        $ghAuth = gh auth status 2>&1 | Out-String
        $authed = $ghAuth -match 'Logged in'
        $results += New-GlyLensCheckResult -Name 'GitHub Authentication' -Status $(if ($authed) { 'Installed' } else { 'Misconfigured' }) `
            -Detail $(if ($authed) { ($ghAuth -split "`n" | Select-Object -First 2) -join ' ' } else { 'Not logged in' }) `
            -Remediation 'gh auth login — use RanaInturi-AICW account with repo write access.'
    }
    catch {
        $results += New-GlyLensCheckResult -Name 'GitHub Authentication' -Status 'Misconfigured' -Remediation 'gh auth login'
    }
}
else {
    $results += New-GlyLensCheckResult -Name 'GitHub CLI' -Status 'Missing' -Remediation 'winget install GitHub.cli'
}

# --- Docker ---
$dockerVer = Get-CommandVersion 'docker' '--version'
if ($null -eq $dockerVer) {
    $results += New-GlyLensCheckResult -Name 'Docker Desktop' -Status 'Missing' `
        -Remediation 'Install Docker Desktop; enable WSL2 backend + Ubuntu integration.'
}
else {
    $results += New-GlyLensCheckResult -Name 'Docker Desktop' -Status 'Installed' -Detail $dockerVer
    try {
        $dockerInfo = docker info 2>&1 | Out-String
        $dockerOk = $LASTEXITCODE -eq 0
        $results += New-GlyLensCheckResult -Name 'Docker Engine' -Status $(if ($dockerOk) { 'Installed' } else { 'Misconfigured' }) `
            -Detail $(if ($dockerOk) { 'Daemon running' } else { $dockerInfo }) `
            -Remediation 'Start Docker Desktop; ensure WSL integration enabled for Ubuntu.'
    }
    catch {
        $results += New-GlyLensCheckResult -Name 'Docker Engine' -Status 'Misconfigured' -Remediation 'Start Docker Desktop.'
    }
    $composeVer = Get-CommandVersion 'docker' 'compose version'
    $results += New-GlyLensCheckResult -Name 'Docker Compose' -Status $(if ($composeVer) { 'Installed' } else { 'Missing' }) -Detail $composeVer
}

# --- Firebase / FlutterFire (prepare only) ---
$firebaseVer = Get-CommandVersion 'firebase' '--version'
$results += New-GlyLensCheckResult -Name 'Firebase CLI' -Status $(if ($firebaseVer) { 'Installed' } else { 'Missing' }) `
    -Detail $(if ($firebaseVer) { $firebaseVer } else { 'Not installed' }) `
    -Remediation 'npm install -g firebase-tools@13.29.1 (prepare only; project not yet created).'

$flutterfireVer = Get-CommandVersion 'flutterfire' '--version'
if (-not $flutterfireVer) {
    $dartPubCache = Join-Path $env:LOCALAPPDATA 'Pub\Cache\bin\flutterfire.bat'
    if (Test-Path $dartPubCache) { $flutterfireVer = 'available via pub cache' }
}
$results += New-GlyLensCheckResult -Name 'FlutterFire CLI' -Status $(if ($flutterVer) { 'Installed' } elseif ($flutterfireVer) { 'Installed' } else { 'Missing' }) `
    -Detail $(if ($flutterfireVer) { $flutterfireVer } else { 'Not activated' }) `
    -Remediation 'dart pub global activate flutterfire_cli; add Pub Cache bin to PATH.'

# --- Android device / emulator ---
if (Get-Command adb -ErrorAction SilentlyContinue) {
    try {
        $devices = adb devices 2>&1 | Out-String
        $physical = ($devices -split "`n" | Where-Object { $_ -match '\tdevice$' -and $_ -notmatch 'emulator' }).Count
        $emulator = ($devices -split "`n" | Where-Object { $_ -match 'emulator' }).Count
        $results += New-GlyLensCheckResult -Name 'Android Physical Device' -Status $(if ($physical -gt 0) { 'Installed' } else { 'Missing' }) `
            -Detail "$physical device(s) connected" `
            -Remediation 'Enable USB debugging; install Google USB driver if needed; adb devices'
        $results += New-GlyLensCheckResult -Name 'Android Emulator' -Status $(if ($emulator -gt 0) { 'Installed' } else { 'Missing' }) `
            -Detail "$emulator emulator(s) running" `
            -Remediation 'Android Studio → Device Manager → Create Pixel 7 API 35 AVD; start emulator.'
    }
    catch {
        $results += New-GlyLensCheckResult -Name 'Android adb' -Status 'Misconfigured' -Detail $_.Exception.Message
    }
}
else {
    $results += New-GlyLensCheckResult -Name 'Android adb' -Status 'Missing' -Remediation 'Install Android SDK platform-tools.'
}

# --- Repository ---
if ($repoRoot) {
    $results += New-GlyLensCheckResult -Name 'GlyLens Repository' -Status 'Installed' -Detail $repoRoot
    $remote = git -C $repoRoot remote get-url origin 2>&1
    $remoteOk = $remote -match 'RanaInturi-AICW/glylens'
    $results += New-GlyLensCheckResult -Name 'Git Remote (origin)' -Status $(if ($remoteOk) { 'Installed' } else { 'Misconfigured' }) `
        -Detail $remote -Remediation "git remote set-url origin $($GlyLensBom.RepoUrl).git"
}

$reportPath = if ($ReportJson) { $ReportJson } else { Join-Path $env:TEMP 'glylens-audit-report.json' }
Write-GlyLensReport -Results $results -ReportPath $reportPath

$exitCode = if (@($results | Where-Object { $_.Status -in 'Missing', 'Misconfigured', 'Fail' }).Count -gt 0) { 1 } else { 0 }
exit $exitCode
