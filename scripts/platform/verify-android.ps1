# Verify Android Studio SDK, adb, licenses
. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'Verify Android'
Write-GlyLensPathBanner
$paths = Get-GlyLensDevPaths
$ok = $true
$minApi = $GlyLensBom.AndroidApiLevel
$preferredBt = $GlyLensBom.AndroidBuildToolsVersion

$sdk = Resolve-GlyLensAndroidSdk
if ($sdk) {
    $ok = (Test-GlyLensExit $true 'Android SDK directory' -PassDetail $sdk) -and $ok
}
else {
    $ok = (Test-GlyLensExit $false 'Android SDK directory' `
        -FailDetail ('Expected {0} or D:\AndroidStudio-Sdk' -f $paths.AndroidSdk) `
        -Remediation 'Set GLYLENS_ANDROID_SDK or run configure-path.ps1 -SetAndroidHome -Force') -and $ok
}

$adb = $null
if ($sdk) {
    $adbPath = Join-Path $sdk 'platform-tools\adb.exe'
    if (Test-Path $adbPath) { $adb = $adbPath }
}
if (-not $adb) {
    $adb = Get-Command adb -ErrorAction SilentlyContinue
}
$ok = (Test-GlyLensExit ($null -ne $adb) 'adb available' `
    -Remediation 'SDK Manager: install Android SDK Platform-Tools') -and $ok

if ($sdk) {
    $platformCheck = Test-GlyLensAndroidPlatformMeetsMinimum -SdkRoot $sdk -MinApi $minApi
    $platformLabel = "Android API platform (>= $minApi)"
    if ($platformCheck.Ok) {
        $platformDetail = $platformCheck.Best.Folder
        $ok = (Test-GlyLensExit $true $platformLabel -PassDetail $platformDetail) -and $ok
    }
    else {
        $ok = (Test-GlyLensExit $false $platformLabel `
            -Remediation ("SDK Manager: install Android API {0} or newer (e.g. android-36)" -f $minApi)) -and $ok
    }

    $preferredBtPath = Join-Path $sdk "build-tools\$preferredBt"
    $btOk = Test-Path $preferredBtPath
    $btDetail = $preferredBt
    if (-not $btOk) {
        $installedBt = @(Get-GlyLensInstalledBuildTools -SdkRoot $sdk)
        $bestBt = $installedBt | Select-Object -First 1
        if ($bestBt -and $bestBt.Version.Major -ge 35) {
            Write-Host ('[INFO] build-tools {0} found ({1} preferred)' -f $bestBt.Folder, $preferredBt) -ForegroundColor Cyan
            $btOk = $true
            $btDetail = $bestBt.Folder
        }
    }
    $ok = (Test-GlyLensExit $btOk 'Android SDK Build-Tools' -PassDetail $btDetail `
        -Remediation ("SDK Manager: install Build-Tools {0}" -f $preferredBt)) -and $ok
}

if ($adb) {
    $devOut = & $adb devices 2>&1 | Out-String
    $count = (@($devOut -split "`n" | Where-Object { $_ -match '\tdevice$' -and $_ -notmatch 'emulator' })).Count
    $emu = (@($devOut -split "`n" | Where-Object { $_ -match 'emulator' })).Count
    Write-Host ('[INFO] Physical devices: {0} | Emulators: {1}' -f $count, $emu)
    if ($count -eq 0 -and $emu -eq 0) {
        Write-Host '[WARN] No Android target connected - start emulator or connect USB device' -ForegroundColor Yellow
    }
}

$localAppData = $env:LOCALAPPDATA
$studioPaths = @(
    (Join-Path $paths.DevRoot 'android-studio')
    (Join-Path ${env:ProgramFiles} 'Android\Android Studio')
    (Join-Path $localAppData 'Programs\Android Studio')
)
$studioOk = @($studioPaths | Where-Object { Test-Path $_ }).Count -gt 0
$ok = (Test-GlyLensExit $studioOk 'Android Studio installed' `
    -Remediation 'Install Android Studio Meerkat 2024.3.1 or newer') -and $ok

$userAndroidHome = [Environment]::GetEnvironmentVariable('ANDROID_HOME', 'User')
if ($sdk -and $userAndroidHome -ne $sdk) {
    Write-Host ('[WARN] ANDROID_HOME (User) is "{0}" but SDK detected at "{1}"' -f $userAndroidHome, $sdk) -ForegroundColor Yellow
    Write-Host '       Run: .\scripts\platform\configure-path.ps1 -SetAndroidHome -Force' -ForegroundColor DarkGray
}

exit $(if ($ok) { 0 } else { 1 })
