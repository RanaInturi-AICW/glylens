# GlyLens Release Checklist v1.0

_Last Updated: 2026-06-26 (Build Program 1.4 — RC1)_  
_Target Tag: `v1.0.0-platform-ready`_

## Environment

| Check | Requirement | RC1 Status |
|-------|-------------|------------|
| Flutter | 3.44.4 stable | PASS |
| Dart | 3.12.2 | PASS |
| JDK | 17 (Temurin at `D:\glylens-dev\jdk`) | PASS |
| Android SDK | API 36+, Build-Tools 36.1.0 | PASS |
| AGP / Gradle | 9.0.1 / 9.1.0 | CONFIGURED |
| `verify-complete-environment.ps1` | ENVIRONMENT: READY | PASS |
| Gradle wrapper download (Java TLS) | No PKIX errors | **FAIL** — see Build Health Report |

## Build

| Gate | Command | RC1 Status |
|------|---------|------------|
| Clean resolve | `flutter pub get` | PASS |
| Static analysis | `flutter analyze --fatal-infos` | PASS (0 issues) |
| Dart analysis | `dart analyze --fatal-infos lib test integration_test` | PASS |
| Format | `dart format --set-exit-if-changed .` | Run in CI |
| Debug APK | `flutter build apk --debug --dart-define=ENV=development` | **BLOCKED** (local SSL) |
| Release APK | Not in BP1.4 scope | N/A |

## Tests

| Suite | Count | RC1 Status |
|-------|-------|------------|
| Unit / domain / policy / engines | 83 | PASS |
| Widget (l10n) | included | PASS |
| Golden | placeholder harness | PASS |
| Integration | `integration_test/app_test.dart` | Present — run on device in BP2A |

## CI

| Workflow | Purpose | RC1 Status |
|----------|---------|------------|
| `.github/workflows/flutter_ci.yml` | analyze, test, debug APK | CONFIGURED (Flutter 3.44.4) |
| `.github/workflows/codeql.yml` | Security scan | ACTIVE |
| `.github/workflows/release.yml` | Semver releases | ACTIVE |
| Dependabot | Dependency PRs | ACTIVE |

**Action:** Confirm green CI run on `main` before tagging.

## Architecture

| Rule | RC1 Status |
|------|------------|
| Firebase confined to `bootstrap/` + `features/auth/infrastructure/` | PASS |
| No Flutter imports in `lib/core/domain` | PASS |
| No circular package boundaries | PASS |
| ADR stack frozen (Riverpod, GoRouter, Hive) | PASS |
| No Food Intelligence feature implementation | PASS (domain only) |

## Security

| Check | RC1 Status |
|-------|------------|
| No `.env` / API keys committed | PASS |
| `firebase_options.dart` uses placeholder template | PASS |
| `flutter_secure_storage` abstraction present | PASS |
| Debug flags via `--dart-define=ENV=` | PASS |
| No `print()` in production lib | PASS |

## Documentation

| Artifact | RC1 Status |
|----------|------------|
| Master Documentation Index | UPDATED (BP1.4) |
| Repository Manifest | UPDATED (BP1.4) |
| README | UPDATED (BP1.4) |
| REPOSITORY_STRUCTURE.md | UPDATED (BP1.4) |
| Platform release reports (this sprint) | CREATED |

## Release Readiness

| Criterion | Status |
|-----------|--------|
| All code gates green locally | **YES** |
| Local debug APK | **NO** — JDK SSL / Gradle wrapper PKIX |
| Architecture violations | **NONE** |
| Tag `v1.0.0-platform-ready` authorized | **CONDITIONAL** — pending CI APK + SSL remediation |

### SSL remediation (workstation)

1. Download Gradle 9.1.0 offline: `Invoke-WebRequest https://services.gradle.org/distributions/gradle-9.1.0-all.zip`
2. Seed wrapper cache or use corporate root CA in JDK `cacerts`
3. Re-run `flutter build apk --debug`

### Build Program 2A authorization

**Build Program 2A is authorized** for Food Intelligence wiring **after**:

1. GitHub Actions `flutter_ci` reports green (including APK), **and**
2. Tag `v1.0.0-platform-ready` is applied to that commit.

---

_End of Checklist_
