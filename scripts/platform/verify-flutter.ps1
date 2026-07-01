# Verify Flutter installation
. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'Verify Flutter'
Write-GlyLensPathBanner
$paths = Get-GlyLensDevPaths
$ok = $true
$targetFlutter = $GlyLensBom.FlutterVersion
$targetDart = $GlyLensBom.DartVersion
$flutterMajorMinor = ($targetFlutter -split '\.')[0..1] -join '.'
$dartMajorMinor = ($targetDart -split '\.')[0..1] -join '.'

$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
    Test-GlyLensExit $false 'Flutter on PATH' -FailDetail ('Not found - install to {0}' -f $paths.FlutterRoot) -Remediation 'See GlyLens_Installation_Guide.md Step 3'
    exit 1
}

$ver = flutter --version 2>&1 | Out-String
$flutterLabel = ('Flutter {0}.' -f $flutterMajorMinor)
$verOk = $ver -match [regex]::Escape($flutterLabel)
$ok = (Test-GlyLensExit $verOk ('Flutter version {0}.x' -f $flutterMajorMinor) `
    -PassDetail ($ver -split "`n" | Select-Object -First 1) `
    -Remediation ('git -C {0} fetch origin tag {1}; git -C {0} checkout {1}; flutter --version' -f $paths.FlutterRoot, $targetFlutter)) -and $ok

$dartLabel = ('Dart {0}.' -f $dartMajorMinor)
$dartOk = $ver -match [regex]::Escape($dartLabel)
$ok = (Test-GlyLensExit $dartOk ('Dart {0}.x bundled' -f $dartMajorMinor) -PassDetail $targetDart `
    -Remediation ('Use Flutter {0} stable' -f $targetFlutter)) -and $ok

Write-Host ''
Write-Host 'flutter doctor -v:' -ForegroundColor Cyan
flutter doctor -v
$doctor = flutter doctor 2>&1 | Out-String
$doctorOk = $doctor -notmatch '\[X\]' -and $doctor -notmatch '\[✗\]'
if ($doctor -match 'Android toolchain.*\[X\]' -or $doctor -match 'Android toolchain.*\[✗\]') { $doctorOk = $false }
$ok = (Test-GlyLensExit $doctorOk 'flutter doctor' -PassDetail 'No critical failures' -Remediation 'Fix items marked with X in flutter doctor output') -and $ok

exit $(if ($ok) { 0 } else { 1 })
