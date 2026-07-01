# Verify Git, GitHub CLI, repository access
. "$PSScriptRoot\_glylens-verify-common.ps1"

Write-GlyLensHeader 'Verify GitHub'
$ok = $true

$git = Get-Command git -ErrorAction SilentlyContinue
$ok = (Test-GlyLensExit ($null -ne $git) 'Git' -PassDetail (git --version 2>&1)) -and $ok

$gh = Get-Command gh -ErrorAction SilentlyContinue
if (-not $gh) {
    $ok = (Test-GlyLensExit $false 'GitHub CLI' -Remediation 'winget install GitHub.cli') -and $ok
}
else {
    $ok = (Test-GlyLensExit $true 'GitHub CLI' -PassDetail (gh --version 2>&1 | Select-Object -First 1)) -and $ok
    $auth = gh auth status 2>&1 | Out-String
    $loggedIn = $auth -match 'Logged in'
    $ok = (Test-GlyLensExit $loggedIn 'GitHub authenticated' -Remediation 'gh auth login') -and $ok
    if ($loggedIn) {
        $active = ($auth -split "`n" | Where-Object { $_ -match 'Active account: true' -or $_ -match '✓ Logged in' } | Select-Object -First 1)
        Write-Host "       $active"
    }
}

try {
    $repoRoot = Get-RepoRoot
    $remote = git -C $repoRoot remote get-url origin 2>&1
    $remoteOk = $remote -match 'RanaInturi-AICW/glylens'
    $ok = (Test-GlyLensExit $remoteOk 'origin remote' -PassDetail $remote) -and $ok
    if ($gh) {
        $push = gh api repos/RanaInturi-AICW/glylens --jq '.permissions.push' 2>&1
        $ok = (Test-GlyLensExit ($push -eq 'true') 'Push permission' -PassDetail "push=$push") -and $ok
    }
}
catch {
    Write-Host "[FAIL] Repository root: $_" -ForegroundColor Red
    $ok = $false
}

$lfs = Get-Command git-lfs -ErrorAction SilentlyContinue
if ($lfs) {
    Write-Host "[PASS] Git LFS: $(git lfs version 2>&1 | Select-Object -First 1)" -ForegroundColor Green
}

exit $(if ($ok) { 0 } else { 1 })
