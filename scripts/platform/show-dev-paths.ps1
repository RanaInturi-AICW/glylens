# Show GlyLens dev paths (D: drive defaults)
. "$PSScriptRoot\_glylens-env-common.ps1"

Write-GlyLensHeader 'GlyLens Dev Paths'
$p = Get-GlyLensDevPaths
$free = Get-GlyLensDriveFreeGb $p.DevDrive.TrimEnd(':')

Write-Host "GLYLENS_DEV_ROOT env: $(if ($env:GLYLENS_DEV_ROOT) { $env:GLYLENS_DEV_ROOT } else { '(not set — using default)' })"
Write-Host ''
Write-Host "DevRoot        $($p.DevRoot)"
Write-Host "DevDrive       $($p.DevDrive)  ($free GB free)"
Write-Host "FlutterRoot    $($p.FlutterRoot)"
Write-Host "FlutterBin     $($p.FlutterBin)"
Write-Host "AndroidSdk     $($p.AndroidSdk)"
Write-Host "AndroidStudio  $($p.AndroidStudio)"
Write-Host "PubCache       $($p.PubCache)"
Write-Host ''
Write-Host 'To change drive: set User env GLYLENS_DEV_ROOT or edit scripts\platform\glylens-paths.config.ps1'
