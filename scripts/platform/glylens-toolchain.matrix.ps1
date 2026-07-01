# GlyLens Mobile Toolchain Matrix — programmatic single source of truth
# Documentation mirror: platform/GlyLens_Version_Compatibility_Matrix.md
# Resolved: 2026-06-26 from Flutter stable 3.44.4 + AGP 9.0.1 compatibility tables

$script:GlyLensToolchainMatrix = [ordered]@{
    MatrixVersion            = '2.0.0'
    ResolvedDate             = '2026-06-26'
    ResolvedFrom             = @(
        'Flutter stable tag 3.44.4 (releases_linux.json)'
        'packages/flutter_tools/lib/src/android/gradle_utils.dart @ stable'
        'Android Gradle Plugin 9.0.1 release notes'
    ) -join '; '

    # Flutter / Dart
    FlutterVersion           = '3.44.4'
    FlutterChannel           = 'stable'
    DartVersion              = '3.12.2'
    PubspecSdkConstraint     = '^3.12.0'
    PubspecFlutterConstraint = '>=3.44.0'
    IntlVersion              = '0.20.2'

    # Android Gradle toolchain (Flutter 3.44.4 template defaults)
    AgpVersion               = '9.0.1'
    GradleVersion            = '9.1.0'
    KotlinVersion            = '2.3.20'
    KotlinBuiltInAgpVersion  = '2.2.10'

    # JDK (AGP 9 / Gradle 9 minimum)
    JavaVersion              = '17'
    JdkVendor                = 'Eclipse Temurin'
    JdkRecommended           = '17.0.19'

    # App SDK levels (flutter.compileSdkVersion / targetSdk / minSdk)
    CompileSdk               = 36
    TargetSdk                = 36
    MinSdk                   = 24
    AndroidApiLevel          = 36
    AndroidMinApiLevel       = 36

    # SDK Manager installs
    AndroidBuildToolsMin     = '36.0.0'
    AndroidBuildToolsVersion = '37.0.0'
    AndroidNdkVersion        = '28.2.13676358'

    # IDE
    AndroidStudioMin         = '2025.2.3'
    AndroidStudioName        = 'Otter 3 Feature Drop'
}

function Get-GlyLensToolchainMatrix {
    if (-not $script:GlyLensToolchainMatrix) {
        . (Join-Path $PSScriptRoot 'glylens-toolchain.matrix.ps1')
    }
    return [PSCustomObject]$script:GlyLensToolchainMatrix
}

function Test-GlyLensToolchainCompatibility {
    <#
    .SYNOPSIS
        Validates that resolved matrix fields form a mutually compatible chain.
    #>
    $m = Get-GlyLensToolchainMatrix
    $issues = @()

    if ([version]$m.GradleVersion -lt [version]'9.1.0') {
        $issues += "Gradle $($m.GradleVersion) < AGP 9 minimum 9.1.0"
    }
    if ([version]$m.AndroidBuildToolsMin -lt [version]'36.0.0') {
        $issues += "Build-Tools min $($m.AndroidBuildToolsMin) < AGP 9 minimum 36.0.0"
    }
    if ($m.CompileSdk -ne $m.TargetSdk) {
        $issues += "compileSdk ($($m.CompileSdk)) != targetSdk ($($m.TargetSdk))"
    }
    if ($m.AndroidApiLevel -lt $m.CompileSdk) {
        $issues += "Installed platform API ($($m.AndroidApiLevel)) < compileSdk ($($m.CompileSdk))"
    }

    [PSCustomObject]@{
        Valid  = $issues.Count -eq 0
        Issues = $issues
    }
}
