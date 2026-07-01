# Verify WSL2 and Ubuntu
. "$PSScriptRoot\_glylens-verify-common.ps1"

function ConvertFrom-WslCliOutput {
    param([string]$Text)
    if (-not $Text) { return '' }
    return ($Text -replace "`0", '')
}

Write-GlyLensHeader 'Verify WSL'
$ok = $true

$wsl = Get-Command wsl -ErrorAction SilentlyContinue
if (-not $wsl) {
    Test-GlyLensExit $false 'WSL installed' -Remediation 'wsl --install'
    exit 1
}

$wv = ConvertFrom-WslCliOutput (wsl --version 2>&1 | Out-String)
$wsl2 = $wv -match '2\.\d+' -or $wv -match 'WSL version:\s*2'
$ok = (Test-GlyLensExit $wsl2 'WSL2' -PassDetail (($wv -split "`n" | Select-Object -First 1).Trim())) -and $ok

$list = ConvertFrom-WslCliOutput (wsl -l -v 2>&1 | Out-String)
$ubuntu = $list -match 'Ubuntu'
$ok = (Test-GlyLensExit $ubuntu 'Ubuntu distro' -PassDetail 'Registered' -Remediation 'wsl --install -d Ubuntu') -and $ok

if ($ubuntu) {
    $running = $list -match 'Ubuntu.*Running'
    if (-not $running) {
        Write-Host '[WARN] Ubuntu is stopped - run: wsl -d Ubuntu' -ForegroundColor Yellow
    }
    else {
        Write-Host '[PASS] Ubuntu running' -ForegroundColor Green
    }
    $rel = ConvertFrom-WslCliOutput (wsl -d Ubuntu -- cat /etc/os-release 2>&1 | Out-String)
    $verLine = ($rel -split "`n" | Where-Object { $_ -match 'PRETTY_NAME' }) -join ' '
    Write-Host "       $verLine"
}

exit $(if ($ok) { 0 } else { 1 })
