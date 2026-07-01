# GlyLens install prerequisite check (read-only, no installs)
param([switch]$JsonReport)

. "$PSScriptRoot\_glylens-env-common.ps1"

Write-GlyLensHeader 'GlyLens Install Prerequisite Check (BP1.3)'
Write-GlyLensPathBanner
$paths = Get-GlyLensDevPaths
$issues = 0

# OS
$os = Get-CimInstance Win32_OperatingSystem
$winOk = $os.Caption -match 'Windows 11'
if (-not $winOk) { $issues++ }
$osLabel = if ($winOk) { 'PASS' } else { 'FAIL' }
$osColor = if ($winOk) { 'Green' } else { 'Red' }
Write-Host ('[{0}] Windows 11' -f $osLabel) -ForegroundColor $osColor
Write-Host ('       {0} Build {1}' -f $os.Caption, $os.BuildNumber)

# RAM
$ramGb = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)
$ramOk = $ramGb -ge 15.5
if (-not $ramOk) { $issues++ }
$ramLabel = if ($ramOk) { 'PASS' } else { 'FAIL' }
$ramColor = if ($ramOk) { 'Green' } else { 'Red' }
Write-Host ('[{0}] RAM >= 16 GB' -f $ramLabel) -ForegroundColor $ramColor
Write-Host ('       {0} GB' -f $ramGb)

# Dev drive disk (primary - tools install here)
$devLetter = $paths.DevDrive.TrimEnd(':')
$devFreeGb = Get-GlyLensDriveFreeGb $devLetter
if ($null -eq $devFreeGb) {
    Write-Host ('[FAIL] Dev drive {0} not found' -f $paths.DevDrive) -ForegroundColor Red
    Write-Host '       Set GLYLENS_DEV_ROOT to an existing drive in scripts\platform\glylens-paths.config.ps1' -ForegroundColor Yellow
    $issues++
}
else {
    $devDiskOk = $devFreeGb -ge $paths.MinFreeGbDev
    if (-not $devDiskOk) { $issues++ }
    $devLabel = if ($devDiskOk) { 'PASS' } else { 'FAIL' }
    $devColor = if ($devDiskOk) { 'Green' } else { 'Red' }
    Write-Host ('[{0}] Free disk >= {1} GB on dev drive {2}' -f $devLabel, $paths.MinFreeGbDev, $paths.DevDrive) -ForegroundColor $devColor
    Write-Host ('       {0} GB free - installs go under {1}' -f $devFreeGb, $paths.DevRoot)
}

# OS drive (C:) - advisory only
$cFreeGb = Get-GlyLensDriveFreeGb 'C'
if ($null -ne $cFreeGb) {
    $cOk = $cFreeGb -ge $paths.MinFreeGbOS
    $cLabel = if ($cOk) { 'PASS' } else { 'WARN' }
    $cColor = if ($cOk) { 'Green' } else { 'Yellow' }
    Write-Host ('[{0}] OS drive C: >= {1} GB (advisory)' -f $cLabel, $paths.MinFreeGbOS) -ForegroundColor $cColor
    Write-Host ('       {0} GB free - low C: is OK when using {1}' -f $cFreeGb, $paths.DevRoot)
}

# Dev root folder
if (-not (Test-Path $paths.DevRoot)) {
    Write-Host ('[INFO] Dev root will be created on first install: {0}' -f $paths.DevRoot) -ForegroundColor Cyan
}

# Virtualization
$hyper = (systeminfo | Select-String 'Hyper-V Requirements').Line
Write-Host ('[INFO] {0}' -f $hyper)

# Admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
$adminLabel = if ($isAdmin) { 'INFO' } else { 'WARN' }
Write-Host ('[{0}] Running as Administrator' -f $adminLabel)
if (-not $isAdmin) {
    Write-Host '       Some installers require admin; re-run installers elevated if needed.' -ForegroundColor Yellow
}

# Network
$netOk = Test-Connection github.com -Count 1 -Quiet -ErrorAction SilentlyContinue
if (-not $netOk) { $issues++ }
$netLabel = if ($netOk) { 'PASS' } else { 'FAIL' }
$netColor = if ($netOk) { 'Green' } else { 'Red' }
Write-Host ('[{0}] Network (github.com)' -f $netLabel) -ForegroundColor $netColor

Write-Host ''
if ($issues -eq 0) {
    Write-Host 'Prerequisites: PASS - proceed with GlyLens_Installation_Guide.md' -ForegroundColor Green
    exit 0
}
Write-Host ('Prerequisites: FAIL ({0} blocking issue(s))' -f $issues) -ForegroundColor Red
exit 1
