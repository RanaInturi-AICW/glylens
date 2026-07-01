# GlyLens Local Quality Gates v1

_Last Updated: 2026-06-26_  
_Build Program: 1.2 — Part 8_  
_Status: CANONICAL_

---

## Policy

**No commit to `main` or `develop` is allowed unless all gates pass.**

Enforcement:
- **Local:** `.\scripts\platform\run-quality-gates.ps1`
- **CI:** `.github/workflows/flutter_ci.yml`
- **Recommended:** Install pre-commit hook (see §5)

---

## Required Gates

| # | Gate | Command | Must Pass |
|---|------|---------|-----------|
| G1 | Flutter doctor | `flutter doctor -v` | No `[✗]` on Android toolchain (Windows) |
| G2 | Dependencies | `flutter pub get` | Exit 0 |
| G3 | Format | `dart format --set-exit-if-changed lib test integration_test` | No diff |
| G4 | Flutter analyze | `flutter analyze --fatal-infos` | Zero issues |
| G5 | Dart analyze | `dart analyze --fatal-infos lib test integration_test` | Zero issues |
| G6 | Tests | `flutter test` | All pass |
| G7 | Security | No new critical findings | Manual / CodeQL on PR |
| G8 | Secrets scan | No credentials in diff | GitHub secret scanning |

---

## One-Command Runner

```powershell
.\scripts\platform\run-quality-gates.ps1
```

---

## Pre-Commit Checklist (Developer)

- [ ] Branch named per convention (`feature/`, `fix/`, `platform/`, `docs/`)
- [ ] Quality gates script passed
- [ ] No secrets in diff
- [ ] Canonical docs updated if adding artifacts
- [ ] Technical debt register updated if incurring debt

---

## CI Parity

Local gates must match CI. Flutter version pin: **3.44.4** (see Version Compatibility Matrix).

---

## Known Blockers (BP1.1 Rework)

Until resolved, gates **will fail**:

| ID | Issue |
|----|-------|
| TD-001 | `intl` version conflict |
| TD-002 | Auth import paths |

Resolve before claiming BP1 platform complete.

---

## Pre-Commit Hook (Optional)

```powershell
# .git/hooks/pre-commit (create manually)
#!/usr/bin/env pwsh
& "$PSScriptRoot/../../scripts/platform/run-quality-gates.ps1" -SkipDoctor
if ($LASTEXITCODE -ne 0) { exit 1 }
```

---

## Exception Process

Emergency bypass requires:
1. `platform-exception` GitHub label
2. Principal Engineer approval
3. Follow-up issue within 48 hours

---

_Related: `GlyLens_DevOps_Foundation_v1.md`_
