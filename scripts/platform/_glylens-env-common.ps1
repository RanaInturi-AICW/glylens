# GlyLens Platform — shared environment helpers
# Sourced by audit, validate, and repair scripts. Do not run directly.

$script:GlyLensBom = @{
    FlutterVersion     = '3.27.4'
    DartVersion        = '3.6.2'
    JavaVersion        = '17'
    NodeVersion        = '22'
    UbuntuVersion      = '24.04'
    PowerShellMin      = [version]'7.4.0'
    GitMin             = [version]'2.40.0'
    GhMin              = [version]'2.40.0'
    AndroidApiLevel    = 35
    RepoUrl            = 'https://github.com/RanaInturi-AICW/glylens'
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
