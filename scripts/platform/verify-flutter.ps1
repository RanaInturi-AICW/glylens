# Verify Flutter installation
. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'Verify Flutter'
Write-GlyLensPathBanner
$paths = Get-GlyLensDevPaths
$ok = $true

$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
    Test-GlyLensExit $false 'Flutter on PATH' -FailDetail "Not found — install to $($paths.FlutterRoot)" -Remediation 'See GlyLens_Installation_Guide.md Step 3'
    exit 1
}

$ver = flutter --version 2>&1 | Out-String
$verOk = $ver -match '3\.27\.'
$ok = (Test-GlyLensExit $verOk 'Flutter version 3.27.x' -PassDetail ($ver -split "`n" | Select-Object -First 1) -Remediation 'git -C C:\src\flutter checkout 3.27.4 && flutter upgrade') -and $ok

$dartOk = $ver -match 'Dart 3\.6\.'
$ok = (Test-GlyLensExit $dartOk 'Dart 3.6.x bundled' -PassDetail 'OK' -Remediation 'Use Flutter 3.27.4') -and $ok

Write-Host ''
Write-Host 'flutter doctor -v:' -ForegroundColor Cyan
flutter doctor -v
$doctor = flutter doctor 2>&1 | Out-String
$doctorOk = $doctor -notmatch '\[✗\]' -and $doctor -notmatch '\[X\]'
if ($doctor -match 'Android toolchain.*\[✗\]') { $doctorOk = $false }
$ok = (Test-GlyLensExit $doctorOk 'flutter doctor' -PassDetail 'No critical failures' -Remediation 'Fix items marked [✗]') -and $ok

exit $(if ($ok) { 0 } else { 1 })
