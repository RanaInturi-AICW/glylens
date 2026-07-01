# Verify Docker Desktop and compose
. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'Verify Docker'
$ok = $true

$docker = Get-Command docker -ErrorAction SilentlyContinue
if (-not $docker) {
    Test-GlyLensExit $false 'Docker CLI' -Remediation 'Install Docker Desktop'
    exit 1
}

$dv = docker --version 2>&1
$ok = (Test-GlyLensExit $true 'Docker CLI' -PassDetail $dv) -and $ok

$info = docker info 2>&1 | Out-String
$daemonOk = $LASTEXITCODE -eq 0
$ok = (Test-GlyLensExit $daemonOk 'Docker daemon running' -FailDetail 'Start Docker Desktop' -Remediation 'Launch Docker Desktop from Start menu') -and $ok

if ($daemonOk) {
    $cv = docker compose version 2>&1
    $ok = (Test-GlyLensExit ($LASTEXITCODE -eq 0) 'Docker Compose' -PassDetail $cv) -and $ok
    $repoRoot = try { Get-RepoRoot } catch { $null }
    if ($repoRoot) {
        $compose = Join-Path $repoRoot 'docker\docker-compose.dev.yml'
        if (Test-Path $compose) {
            docker compose -f $compose config 2>&1 | Out-Null
            $ok = (Test-GlyLensExit ($LASTEXITCODE -eq 0) 'docker-compose.dev.yml valid') -and $ok
        }
    }
}

exit $(if ($ok) { 0 } else { 1 })
