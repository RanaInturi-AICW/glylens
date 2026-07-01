# GlyLens Platform — shared environment helpers
# Sourced by audit, validate, and repair scripts. Do not run directly.

. (Join-Path $PSScriptRoot 'glylens-paths.config.ps1')
. (Join-Path $PSScriptRoot 'glylens-toolchain.matrix.ps1')

$script:GlyLensMatrix = Get-GlyLensToolchainMatrix

$script:GlyLensBom = @{
    FlutterVersion           = $script:GlyLensMatrix.FlutterVersion
    DartVersion              = $script:GlyLensMatrix.DartVersion
    JavaVersion              = $script:GlyLensMatrix.JavaVersion
    AgpVersion               = $script:GlyLensMatrix.AgpVersion
    GradleVersion            = $script:GlyLensMatrix.GradleVersion
    KotlinVersion            = $script:GlyLensMatrix.KotlinVersion
    NodeVersion              = '22'
    UbuntuVersion            = '24.04'
    PowerShellMin            = [version]'7.4.0'
    GitMin                   = [version]'2.40.0'
    GhMin                    = [version]'2.40.0'
    CompileSdk               = $script:GlyLensMatrix.CompileSdk
    TargetSdk                = $script:GlyLensMatrix.TargetSdk
    MinSdk                   = $script:GlyLensMatrix.MinSdk
    AndroidApiLevel          = $script:GlyLensMatrix.AndroidApiLevel
    AndroidMinApiLevel       = $script:GlyLensMatrix.AndroidMinApiLevel
    AndroidBuildToolsMin     = $script:GlyLensMatrix.AndroidBuildToolsMin
    AndroidBuildToolsVersion = $script:GlyLensMatrix.AndroidBuildToolsVersion
    AndroidNdkVersion        = $script:GlyLensMatrix.AndroidNdkVersion
    IntlVersion              = $script:GlyLensMatrix.IntlVersion
    RepoUrl                  = 'https://github.com/RanaInturi-AICW/glylens'
}

function Get-GlyLensDevPaths {
    <#
    .SYNOPSIS
        Returns canonical GlyLens dev paths (default: D:\glylens-dev).
    #>
    if (-not $script:GlyLensPathsConfig) {
        . (Join-Path $PSScriptRoot 'glylens-paths.config.ps1')
    }
    return [PSCustomObject]@{
        DevRoot       = $script:GlyLensPathsConfig.DevRoot
        DevDrive      = $script:GlyLensPathsConfig.DevDrive
        FlutterRoot   = $script:GlyLensPathsConfig.FlutterRoot
        FlutterBin    = $script:GlyLensPathsConfig.FlutterBin
        AndroidSdk    = $script:GlyLensPathsConfig.AndroidSdk
        AndroidStudio = $script:GlyLensPathsConfig.AndroidStudio
        PubCache      = $script:GlyLensPathsConfig.PubCache
        MinFreeGbDev  = $script:GlyLensPathsConfig.MinFreeGbDev
        MinFreeGbOS   = $script:GlyLensPathsConfig.MinFreeGbOS
    }
}

function Get-GlyLensDriveFreeGb {
    param([string]$DriveLetter)
    if (-not $DriveLetter) { return $null }
    $letter = $DriveLetter.TrimEnd(':')
    try {
        $vol = Get-Volume -DriveLetter $letter -ErrorAction Stop
        return [math]::Round($vol.SizeRemaining / 1GB, 1)
    }
    catch {
        $ps = Get-PSDrive -Name $letter -ErrorAction SilentlyContinue
        if ($ps) { return [math]::Round($ps.Free / 1GB, 1) }
        return $null
    }
}

function Resolve-GlyLensJdkHome {
    <#
    .SYNOPSIS
        Resolves JDK 17 home: existing JAVA_HOME, flat D:\glylens-dev\jdk, or jdk-17 subfolders.
    #>
    $paths = Get-GlyLensDevPaths

    $envCandidates = @(
        [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
        [Environment]::GetEnvironmentVariable('JAVA_HOME', 'Machine')
        $env:JAVA_HOME
    ) | Where-Object { $_ } | Select-Object -Unique

    foreach ($jdkHomeCandidate in $envCandidates) {
        $javaExe = Join-Path $jdkHomeCandidate 'bin\java.exe'
        if (Test-Path $javaExe) {
            return $jdkHomeCandidate
        }
    }

    $flatJdk = Join-Path $paths.DevRoot 'jdk'
    if (Test-Path (Join-Path $flatJdk 'bin\java.exe')) {
        return $flatJdk
    }

    $dirs = @()
    if (Test-Path $flatJdk) {
        $dirs += Get-ChildItem $flatJdk -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match 'jdk-17|17' }
    }
    foreach ($search in @(
            'D:\Program Files\Eclipse Adoptium'
            'C:\Program Files\Eclipse Adoptium'
            'C:\Program Files\Java'
        )) {
        if (Test-Path $search) {
            $dirs += Get-ChildItem $search -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -match 'jdk-17' }
        }
    }
    $found = $dirs | Sort-Object FullName -Descending | Select-Object -First 1
    if ($found) { return $found.FullName }
    return $null
}

function Resolve-GlyLensAndroidSdk {
    <#
    .SYNOPSIS
        Resolves Android SDK: GLYLENS_ANDROID_SDK, ANDROID_HOME, or known paths.
    #>
    $paths = Get-GlyLensDevPaths

    $envCandidates = @(
        $env:GLYLENS_ANDROID_SDK
        [Environment]::GetEnvironmentVariable('ANDROID_HOME', 'User')
        [Environment]::GetEnvironmentVariable('ANDROID_HOME', 'Machine')
        [Environment]::GetEnvironmentVariable('ANDROID_SDK_ROOT', 'User')
        [Environment]::GetEnvironmentVariable('ANDROID_SDK_ROOT', 'Machine')
        $env:ANDROID_HOME
        $env:ANDROID_SDK_ROOT
        $paths.AndroidSdk
        'D:\AndroidStudio-Sdk'
        (Join-Path $env:LOCALAPPDATA 'Android\Sdk')
        'D:\Android\Sdk'
        'C:\Android\Sdk'
    ) | Where-Object { $_ } | Select-Object -Unique

    foreach ($candidate in $envCandidates) {
        $adb = Join-Path $candidate 'platform-tools\adb.exe'
        if (Test-Path $adb) { return $candidate }
        if (Test-Path (Join-Path $candidate 'platform-tools')) { return $candidate }
    }
    return $null
}

function Get-GlyLensInstalledAndroidPlatforms {
    param([string]$SdkRoot)
    $platformsDir = Join-Path $SdkRoot 'platforms'
    if (-not (Test-Path $platformsDir)) { return @() }
    Get-ChildItem $platformsDir -Directory -ErrorAction SilentlyContinue |
        ForEach-Object {
            if ($_.Name -match '^android-(\d+(?:\.\d+)?)$') {
                [PSCustomObject]@{
                    Folder     = $_.Name
                    ApiVersion = [version]$matches[1]
                }
            }
        } | Sort-Object ApiVersion -Descending
}

function Test-GlyLensAndroidPlatformMeetsMinimum {
    param(
        [string]$SdkRoot,
        [int]$MinApi = 35
    )
    $installed = @(Get-GlyLensInstalledAndroidPlatforms -SdkRoot $SdkRoot)
    $meets = @($installed | Where-Object { $_.ApiVersion.Major -ge $MinApi })
    [PSCustomObject]@{
        Ok        = $meets.Count -gt 0
        Installed = $installed
        Best      = if ($meets.Count -gt 0) { $meets[0] } else { $null }
        MinApi    = $MinApi
    }
}

function Get-GlyLensInstalledBuildTools {
    param([string]$SdkRoot)
    $btDir = Join-Path $SdkRoot 'build-tools'
    if (-not (Test-Path $btDir)) { return @() }
    Get-ChildItem $btDir -Directory -ErrorAction SilentlyContinue |
        ForEach-Object {
            [PSCustomObject]@{
                Folder  = $_.Name
                Version = [version]$_.Name
            }
        } | Sort-Object Version -Descending
}

function Write-GlyLensPathBanner {
    $p = Get-GlyLensDevPaths
    Write-Host "GlyLens dev root: $($p.DevRoot)  (override: set GLYLENS_DEV_ROOT)" -ForegroundColor DarkCyan
}

function Write-GlyLensHeader {
    param([string]$Title)
    Write-Host ''
    Write-Host ('=' * 60) -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host ('=' * 60) -ForegroundColor Cyan
    Write-Host ''
}

function New-GlyLensCheckResult {
    param(
        [string]$Name,
        [ValidateSet('Installed', 'Missing', 'Outdated', 'Misconfigured', 'Pass', 'Fail', 'Warn', 'Skip')]
        [string]$Status,
        [string]$Detail = '',
        [string]$Remediation = ''
    )
    [PSCustomObject]@{
        Name         = $Name
        Status       = $Status
        Detail       = $Detail
        Remediation  = $Remediation
    }
}

function Get-CommandVersion {
    param(
        [string]$CommandName,
        [string]$VersionArg = '--version'
    )
    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        return $null
    }
    try {
        $output = & $CommandName $VersionArg.Split(' ') 2>&1 | Out-String
        return $output.Trim()
    }
    catch {
        return $null
    }
}

function Test-VersionMatch {
    param(
        [string]$Text,
        [string]$Expected
    )
    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    return $Text -match [regex]::Escape($Expected)
}

function Get-RepoRoot {
    $dir = $PSScriptRoot
    while ($dir) {
        if (Test-Path (Join-Path $dir 'pubspec.yaml')) {
            return $dir
        }
        $parent = Split-Path $dir -Parent
        if ($parent -eq $dir) { break }
        $dir = $parent
    }
    throw 'Could not locate GlyLens repository root (pubspec.yaml not found).'
}

function Write-GlyLensReport {
    param(
        [PSCustomObject[]]$Results,
        [string]$ReportPath
    )
    $installed = @($Results | Where-Object { $_.Status -eq 'Installed' -or $_.Status -eq 'Pass' })
    $missing   = @($Results | Where-Object { $_.Status -eq 'Missing' })
    $outdated  = @($Results | Where-Object { $_.Status -eq 'Outdated' })
    $misconfig = @($Results | Where-Object { $_.Status -eq 'Misconfigured' -or $_.Status -eq 'Fail' -or $_.Status -eq 'Warn' })

    Write-Host ''
    Write-Host "Summary: Pass=$($installed.Count)  Missing=$($missing.Count)  Outdated=$($outdated.Count)  Issues=$($misconfig.Count)" -ForegroundColor Yellow
    Write-Host ''

    foreach ($r in $Results) {
        $color = switch ($r.Status) {
            { $_ -in 'Installed', 'Pass' } { 'Green' }
            'Missing' { 'Red' }
            'Outdated' { 'Yellow' }
            default { 'Magenta' }
        }
        Write-Host ("[{0}] {1}" -f $r.Status, $r.Name) -ForegroundColor $color
        if ($r.Detail) { Write-Host "       $($r.Detail)" }
        if ($r.Remediation -and $r.Status -notin 'Installed', 'Pass') {
            Write-Host "       -> $($r.Remediation)" -ForegroundColor DarkGray
        }
    }

    if ($ReportPath) {
        $Results | ConvertTo-Json -Depth 4 | Set-Content -Path $ReportPath -Encoding UTF8
        Write-Host ''
        Write-Host "Report saved: $ReportPath" -ForegroundColor DarkCyan
    }
}
