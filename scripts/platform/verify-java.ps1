# Verify Java / JDK 17 for GlyLens matrix
. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'Verify Java (JDK 17)'
$ok = $true

$jdkHome = Resolve-GlyLensJdkHome
if ($jdkHome) {
    $ok = (Test-GlyLensExit $true 'JDK 17 install directory' -PassDetail $jdkHome) -and $ok
    $jdkJava = Join-Path $jdkHome 'bin\java.exe'
    $jv = & $jdkJava -version 2>&1 | Out-String
    $is17 = $jv -match 'version "17' -or $jv -match 'openjdk 17'
    $ok = (Test-GlyLensExit $is17 'JDK 17 binary' -PassDetail (($jv -split "`n" | Select-Object -First 1))) -and $ok
}
else {
    $ok = (Test-GlyLensExit $false 'JDK 17 install directory' -Remediation 'Install Temurin 17 to D:\glylens-dev\jdk') -and $ok
}

$userHome = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
$machineHome = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'Machine')
$jh = if ($env:JAVA_HOME) { $env:JAVA_HOME } elseif ($userHome) { $userHome } else { $machineHome }
$jhOk = $jh -and (Test-Path (Join-Path $jh 'bin\java.exe'))
$ok = (Test-GlyLensExit $jhOk 'JAVA_HOME configured' -PassDetail $jh -Remediation 'configure-path.ps1 -SetJavaHome -Force') -and $ok

function Get-GlyLensExpectedJavaFromRegistry {
    $machine = [Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';' | Where-Object { $_ }
    $user = [Environment]::GetEnvironmentVariable('PATH', 'User') -split ';' | Where-Object { $_ }
    foreach ($dir in (@($machine) + @($user))) {
        $candidate = Join-Path $dir 'java.exe'
        if (Test-Path $candidate) { return $candidate }
    }
    return $null
}

$java = Get-Command java -ErrorAction SilentlyContinue
if ($java) {
    $pv = java -version 2>&1 | Out-String
    $pathIs17 = $pv -match 'version "17' -or $pv -match 'openjdk 17'
    if (-not $pathIs17) {
        $expectedJava = Get-GlyLensExpectedJavaFromRegistry
        $registryIs17 = $false
        if ($expectedJava) {
            $ev = & $expectedJava -version 2>&1 | Out-String
            $registryIs17 = $ev -match 'version "17' -or $ev -match 'openjdk 17'
        }
        $remediation = if ($registryIs17) {
            'Persisted PATH is JDK 17 but this session is stale. Run: .\scripts\platform\configure-path.ps1 -SetJavaHome -Force then fully quit and reopen Cursor (not just the terminal).'
        }
        else {
            'Run configure-path.ps1 -SetJavaHome -Force; fully restart Cursor; remove C:\Program Files\Common Files\Oracle\Java\javapath from System PATH if needed (Admin).'
        }
        $ok = (Test-GlyLensExit $false 'java on PATH is JDK 17' `
            -FailDetail (($pv -split "`n" | Select-Object -First 1) + " ($($java.Source))") `
            -Remediation $remediation) -and $ok
        if ($registryIs17 -and $expectedJava) {
            Write-Host ('[INFO] Registry PATH resolves JDK 17 at: {0}' -f $expectedJava) -ForegroundColor Cyan
        }
    }
    else {
        $ok = (Test-GlyLensExit $true 'java on PATH is JDK 17' -PassDetail $java.Source) -and $ok
    }
}
else {
    $ok = (Test-GlyLensExit $false 'java on PATH' -Remediation 'configure-path.ps1 -SetJavaHome -Force') -and $ok
}

exit $(if ($ok) { 0 } else { 1 })
