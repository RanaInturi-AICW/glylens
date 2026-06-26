# GlyLens DevOps Foundation v1

_Last Updated: 2026-06-26_  
_Build Program: 1.2 — Part 5_  
_Status: CANONICAL_

---

## 1. GitHub Actions Workflows

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| Flutter CI | `flutter_ci.yml` | push/PR `main`, `develop` | Format, analyze, test, Android/iOS debug build |
| CodeQL | `codeql.yml` | push/PR `main`, weekly | Static security analysis |
| Release | `release.yml` | tag `v*` | Build artifacts + GitHub Release |

### CI Hardening (BP1.2)

- Flutter **pinned to 3.27.4** (matches EBOM)
- `concurrency` groups cancel stale runs
- `workflow_dispatch` for manual runs
- Java 17 for Android builds
- Corpus validator job (Docker) on `docs/seed_data` changes

---

## 2. Dependabot

**File:** `.github/dependabot.yml`

| Ecosystem | Path | Schedule |
|-----------|------|----------|
| `pub` | `/` | Weekly (Monday) |
| `github-actions` | `/` | Weekly |
| `docker` | `/docker` | Weekly |

---

## 3. CodeQL

- Language: `javascript`, `python` (Docker mock-api, corpus tools)
- Dart: not yet supported by CodeQL — covered by `flutter analyze`
- Runs on PR and weekly schedule

---

## 4. Secret Scanning

| Control | Status |
|---------|--------|
| GitHub secret scanning | Enable in repo Settings → Security |
| Push protection | **Recommended** for `main` |
| No secrets in workflows | ✅ Uses `dart-define` placeholders only |
| Docker `.env` | Gitignored via root `.gitignore` |

---

## 5. Release Workflow

**Trigger:** Annotated tag `v*.*.*` (semver)

| Tag Pattern | Meaning |
|-------------|---------|
| `v0.9.0-architecture-frozen` | Sprint 0 (exists) |
| `v1.0.0-platform-foundation` | BP1 complete (not yet authorized) |
| `v1.1.0`+ | Semver releases |

Release workflow builds debug APK and attaches to GitHub Release (no store deploy).

---

## 6. Branch Protection (Recommended)

Apply to `main` and `develop` via GitHub Settings:

| Rule | Setting |
|------|---------|
| Require PR | ✅ |
| Require status checks | `Flutter CI / analyze-test-build` |
| Require CodeQL | ✅ (when available) |
| Require linear history | Optional |
| Restrict force push | ✅ |
| Require signed commits | Optional (future) |
| Require review | 1 approval |

```bash
# Example (org admin):
gh api repos/RanaInturi-AICW/glylens/branches/main/protection -X PUT ...
```

---

## 7. Conventional Commits

**Format:** `<type>(<scope>): <description>`

| Type | Use |
|------|-----|
| `feat` | New feature (BP2+) |
| `fix` | Bug fix |
| `platform` | DevOps, scripts, Docker |
| `docs` | Documentation only |
| `test` | Tests only |
| `refactor` | Code restructure |
| `chore` | Maintenance |

**Examples:**
```
platform(ci): pin Flutter 3.27.4 in workflow
fix(auth): correct import paths in firebase_auth_repository
docs(platform): add BP1.2 onboarding guide
```

---

## 8. Semantic Versioning

`MAJOR.MINOR.PATCH` per [semver.org](https://semver.org)

| Component | Version source |
|-----------|----------------|
| App | `pubspec.yaml` `version:` |
| Platform docs | Filename `_v1.md` |
| Git tags | `v{pubspec version}` at release |

---

## 9. Artifact Retention

| Artifact | Retention |
|----------|-----------|
| Android debug APK | 30 days |
| Coverage reports | Future — 14 days |

---

## 10. Repository Hygiene

- `CODEOWNERS` — future: platform team for `.github/`, `platform/`, `docker/`
- PR template — recommended for scope checklist
- Issue templates — `platform`, `bug`, `feature`

---

_Related: `GlyLens_Local_Quality_Gates_v1.md`, `GlyLens_Engineering_BOM_v1.md`_
