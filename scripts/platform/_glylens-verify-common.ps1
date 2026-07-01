# GlyLens Platform — shared helpers (PS 5.1+)
. "$PSScriptRoot\_glylens-env-common.ps1" 2>$null
if (-not (Get-Command Write-GlyLensHeader -ErrorAction SilentlyContinue)) {
    . (Join-Path $PSScriptRoot '_glylens-env-common.ps1')
}

function Confirm-GlyLensAction {
    param(
        [string]$Message,
        [switch]$Force
    )
    if ($Force) { return $true }
    $r = Read-Host "$Message [y/N]"
    return $r -match '^[yY]'
}

function Test-GlyLensExit {
    param(
        [bool]$Condition,
        [string]$Name,
        [string]$PassDetail = 'OK',
        [string]$FailDetail = 'Failed',
        [string]$Remediation = ''
    )
    $status = if ($Condition) { 'PASS' } else { 'FAIL' }
    $color = if ($Condition) { 'Green' } else { 'Red' }
    Write-Host ('[{0}] {1}' -f $status, $Name) -ForegroundColor $color
    Write-Host "       $(if ($Condition) { $PassDetail } else { $FailDetail })"
    if (-not $Condition -and $Remediation) {
        Write-Host "       -> $Remediation" -ForegroundColor DarkGray
    }
    return $Condition
}
