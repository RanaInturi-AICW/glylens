# GlyLens Build Program 1.1 — Engineering Review Report v1

_Last Updated: 2026-06-26_  
_Reviewer: Independent Principal Engineer (Build Program 1.1 Verification)_  
_Scope: Flutter Platform Foundation — production readiness assessment_  
_Architecture Status: FROZEN — no redesign performed_

---

## Executive Summary

Build Program 1 delivered a structurally sound Flutter platform foundation aligned with the approved Flutter Module Blueprint, Engineering Constitution, and ADR constraints. The Food Intelligence Engine (Sprint 0) remains well-tested and domain-pure. **However, the platform layer does not currently compile or pass CI.** GitHub Actions run `28231684317` failed at dependency resolution before analyze, test, or build steps executed.

**Final Decision: REWORK REQUIRED**

The foundation is architecturally directionally correct but **not production-ready** until build blockers are resolved, CI is green, and minimum platform test coverage is established.

---

## Engineering Scores

| Dimension | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Architecture | 74 / 100 | 20% | 14.8 |
| Security | 71 / 100 | 20% | 14.2 |
| Performance | 68 / 100 | 10% | 6.8 |
| Maintainability | 58 / 100 | 15% | 8.7 |
| Testability | 61 / 100 | 15% | 9.2 |
| Production Readiness | 32 / 100 | 20% | 6.4 |
| **Overall Engineering Score** | **60 / 100** | 100% | **60.0** |

### Score Evidence Summary

#### Architecture — 74 / 100

**Strengths (+)**
- Layer layout matches Blueprint: `app/`, `bootstrap/`, `core/`, `features/`, `shared/` (`docs/GlyLens_Flutter_Module_Blueprint_v1.md`)
- `core/domain` is Flutter-free; no import of `core/data` from domain
- `core` does not import `features` (correct dependency direction)
- Riverpod-only state management per Constitution
- GoRouter with `StatefulShellRoute.indexedStack` and five-tab shell
- Vendor-neutral abstractions for analytics, crash, HTTP, secure storage, cache
- Auth feature has domain repository interface (`features/auth/domain/`)

**Deficiencies (−)**
- Presentation imports `bootstrap/providers.dart` directly (4 pages) — violates strict layer isolation
- Auth DI split across `bootstrap/`, `auth_providers.dart`, `auth_controller.dart`
- **Compile-breaking auth import paths** (see Code Quality Report §2.1)
- No GoRouter `redirect` / auth guards — onboarding gate only in splash timer
- Welcome page routes Google/Apple buttons to anonymous onboarding, not auth controller

#### Security — 71 / 100

**Strengths (+)**
- No committed secrets, `.env`, or `google-services.json`
- Firebase config via `String.fromEnvironment` (`lib/core/config/app_config.dart`)
- `flutter_secure_storage` abstraction with `TokenStorage`
- `avoid_print: true`; structured `AppLogger`
- Certificate pinning interface (NoOp in BP1 — acceptable)

**Deficiencies (−)**
- No route-level authentication guards
- Dev placeholder credentials (`dev-api-key`, `glylens-dev`) — must be overridden in prod CI/CD
- `TokenStorage.clear()` calls `deleteAll()` — wipes entire secure storage namespace
- Developer page exposes `firebaseProjectId` and feature flags
- No log redaction for auth tokens
- Cert pinning not enabled

#### Performance — 68 / 100

**Strengths (+)**
- Bootstrap serializes init before `runApp` (Firebase → analytics → crash → pinning → Hive)
- `UncontrolledProviderScope` avoids rebuild during pre-app init
- `StatefulShellRoute.indexedStack` preserves tab state
- `VisualDensity.adaptivePlatformDensity` in theme
- Tablet breakpoint at 720px with `ConstrainedBox(maxWidth: 960)`

**Deficiencies (−)**
- No cold-start profiling evidence (Flutter not available locally; CI never reached build)
- Bootstrap awaits five services sequentially — parallelization opportunity for NoOp services
- GoRouter instantiates all shell branches at navigation setup
- No lazy route loading
- Hive `initialize()` on every cold start — acceptable for BP1 but unmeasured

#### Maintainability — 58 / 100

**Strengths (+)**
- Strict analyzer settings (`strict-casts`, `strict-inference`, `strict-raw-types`)
- Consistent feature folder naming
- Centralized `AppRoutes` constants (partially used)
- Documentation trail: BP1 README, Architecture Validation, Project Structure

**Deficiencies (−)**
- **CI red** — primary quality gate non-functional
- Broken relative imports in auth module
- Hardcoded route strings in feature pages vs `AppRoutes`
- Unused dependencies (`meta`, `mocktail`) increase maintenance surface
- `intl` version pin incompatible with current Flutter stable SDK
- Platform folders generated ephemerally in CI (`flutter create`) — not committed

#### Testability — 61 / 100

**Strengths (+)**
- 12 intelligence-engine test files with strong domain/engine/policy coverage
- `Result`/`Failure` unit tests
- CI workflow defines format, analyze, test, Android/iOS debug builds
- `integration_test/` and `test/golden/` directories exist

**Deficiencies (−)**
- Golden and integration tests are **placeholders only** (`expect(true, isTrue)`)
- Zero tests for auth, router, bootstrap, Hive cache, secure storage
- `mocktail` declared but unused — no mock-based platform tests
- CI never executed tests on latest push (pub get failure)
- No coverage reporting in CI

#### Production Readiness — 32 / 100

**Strengths (+)**
- CI workflow structure is appropriate for BP1
- Environment matrix (dev/qa/uat/prod) in `AppConfig`
- Material 3 theme with light/dark/system modes
- l10n scaffold (`flutter gen-l10n`)

**Deficiencies (−)**
- **Build does not succeed** — blocking
- No committed `android/` / `ios/` with Firebase platform config
- Analytics and crash reporting are NoOp
- No accessibility semantics audit pass
- No App Store / Play Store readiness artifacts
- Sprint 0 DoD A9/A10 partially addressed but corpus/runtime wiring still open

---

## Build Verification

### Execution Environment

| Command | Local (Windows) | CI (GitHub Actions) |
|---------|-----------------|---------------------|
| `flutter pub get` | **NOT RUN** — Flutter/Dart not on PATH | **FAILED** |
| `dart analyze` | NOT RUN | NOT REACHED |
| `flutter analyze` | NOT RUN | NOT REACHED |
| `flutter test` | NOT RUN | NOT REACHED |

### CI Evidence — Run `28231684317` (2026-06-26, push `134902f`)

**Failure step:** `Ensure Flutter platform folders` → `flutter create` triggers `pub get`

```
Because glylens depends on flutter_localizations from sdk which depends on intl 0.20.2,
intl 0.20.2 is required.
So, because glylens depends on intl ^0.19.0, version solving failed.
```

**Recommendation:** `intl: ^0.20.2` (or remove explicit `intl` pin and rely on SDK resolution).

### Static Analysis — Auth Module Compile Defects

Even after `pub get` fix, the following import errors will block `flutter analyze`:

| File | Issue |
|------|-------|
| `lib/features/auth/application/auth_controller.dart:6` | `import 'auth_providers.dart'` — file lives in `infrastructure/`, not `application/` |
| `lib/features/auth/infrastructure/firebase_auth_repository.dart:8-9` | Imports `../entities/` and `../repositories/` — correct paths are `../domain/entities/` and `../domain/repositories/` |

See `docs/GlyLens_Code_Quality_Report_v1.md` for full analyzer findings.

---

## Dependency Review

See `docs/GlyLens_Code_Quality_Report_v1.md` §3 for per-package assessment.

**Immediate actions:**
1. Bump `intl` to `^0.20.2`
2. Remove unused `meta` dependency
3. Remove or use `mocktail` in platform tests

---

## Architecture Review

### Clean Architecture Compliance

| Boundary | Verdict | Evidence |
|----------|---------|----------|
| Domain purity | ✅ PASS | No Flutter imports in `core/domain` |
| Data → Domain | ✅ PASS | Engines/repos import domain interfaces |
| Features → Core | ✅ PASS | Features use core abstractions |
| Core → Features | ✅ PASS | No upward imports |
| Presentation → Bootstrap | ⚠️ VIOLATION | Splash, settings, developer, anonymous onboarding |
| Application → Infrastructure | ⚠️ VIOLATION | `auth_controller.dart` reads `authRepositoryProvider` from infrastructure |
| Circular dependencies | ✅ PASS | No package-level cycles detected |

### Riverpod

- Pre-`runApp` `ProviderContainer` with config override — correct pattern
- Provider types: `Provider`, `StateProvider`, `StreamProvider` only
- Missing: `Notifier`/`AsyncNotifier`, router refresh on auth stream, centralized feature DI module

### GoRouter

- Routes: splash, welcome, onboarding, premium, settings, legal (3), developer, shell (5 tabs)
- Missing: `redirect`, `refreshListenable`, deep-link error handling
- `appRouterProvider` rebuilds router on every provider invalidation — acceptable at BP1 scale

---

## Security Review

See `docs/GlyLens_Security_Review_v1.md`.

---

## Performance Baseline

See `docs/GlyLens_Performance_Baseline_v1.md`.

---

## Accessibility Review

| Criterion | Status | Evidence |
|-----------|--------|----------|
| Material 3 | ✅ | `useMaterial3: true` in `AppTheme` |
| Dark mode | ✅ | `ThemeModePreference` + dynamic color support |
| Dynamic text scaling | ⚠️ PARTIAL | No explicit `textScaler` clamping; relies on Flutter defaults |
| Screen reader | ❌ GAP | Zero `Semantics` widgets in `lib/` |
| Tablet readiness | ✅ | `ResponsiveLayout` at 720px breakpoint |
| Touch targets | ⚠️ PARTIAL | Standard Material buttons; no explicit 48dp audit |

---

## Test Review

| Category | Files | Assessment |
|----------|-------|------------|
| Domain unit tests | 4 | Strong |
| Engine/policy tests | 4 | Strong |
| Application use cases | 1 | Adequate for Sprint 0 scope |
| Platform (`core/errors`) | 1 | Minimal but valid |
| Widget/l10n | 1 | Smoke test only |
| Golden | 1 | Placeholder |
| Integration | 1 | Placeholder |
| Auth/Router/Bootstrap | 0 | **Critical gap** |

**Estimated coverage:** Intelligence engine ~70% meaningful; platform layer ~5%.

---

## CI/CD Review

Workflow: `.github/workflows/flutter_ci.yml`

| Step | Present | Assessment |
|------|---------|------------|
| Format check | ✅ | `dart format --set-exit-if-changed` |
| Analyze | ✅ | `--fatal-infos` |
| Unit/widget tests | ✅ | `flutter test` |
| Android debug build | ✅ | APK artifact upload |
| iOS debug build | ✅ | `--no-codesign` |
| Flutter version pin | ❌ | Uses `channel: stable` only — non-reproducible |
| Coverage report | ❌ | Not configured |
| Integration tests | ❌ | Not in CI |
| Golden tests | ❌ | Not in CI |
| Firebase dart-defines in CI | ⚠️ | Only `ENV=development`; no Firebase keys (build may fail post-fix) |
| Caching | ✅ | `cache: true` on flutter-action |

**Recommendations:**
1. Pin Flutter SDK version (e.g. `3.24.5`)
2. Commit `android/` and `ios/` with GlyLens branding; remove CI `flutter create` step
3. Add `flutter test --coverage` + artifact upload
4. Separate job for integration tests on emulator (BP1.2)
5. Add `dependabot.yml` for pub updates

---

## Sprint 0 Definition of Done — BP1 Impact

| Criterion | Pre-BP1 | Post-BP1 Review |
|-----------|---------|-----------------|
| A9 Flutter scaffold | ❌ | ✅ `lib/main.dart`, full `lib/app/` tree — **SATISFIED** |
| A10 Firebase scaffold | ❌ | ⚠️ Bootstrap Firebase Auth only; no `firebase/` rules directory — **PARTIAL** |
| I5 Unit tests | ✅ | ✅ Unchanged; intelligence tests intact |
| I7 Seed wiring | ❌ | ❌ Still not connected to UI repositories |
| Governance (G1–G8) | ✅ | ✅ Unchanged |
| Corpus (C1–C8) | Partial | Unchanged — out of BP1 scope |

**Sprint 0 overall remains INCOMPLETE (67%)** — BP1 closes the Flutter scaffold gap only.

---

## Technical Debt

See `docs/GlyLens_Technical_Debt_Register_v1.md` — 18 items registered (3 Critical, 5 High).

---

## Final Decision

### **REWORK REQUIRED**

Build Program 1 cannot be tagged `v1.0.0-platform-foundation` or authorize Build Program 2 until:

1. **P0 — Green CI:** Fix `intl` constraint; fix auth import paths; verify `flutter analyze` and `flutter test` pass
2. **P0 — Compile:** Platform layer must build on Android and iOS in CI
3. **P1 — Auth wiring:** Fix welcome page sign-in buttons; add route guards
4. **P1 — Platform tests:** Minimum smoke tests for bootstrap, router, auth controller (mocked)
5. **P2 — Commit platform folders** with Firebase placeholder config documented

### Build Program 2 Authorization

**NOT AUTHORIZED** until REWORK items P0 and P1 are closed and CI is green on `main`.

### Recommended Tag (after rework)

`v1.0.0-platform-foundation` — upon successful CI run and Principal Engineer re-review.

---

## Related Deliverables

| Document | Purpose |
|----------|---------|
| `GlyLens_Code_Quality_Report_v1.md` | Build output, linter, dependency detail |
| `GlyLens_Security_Review_v1.md` | Security findings |
| `GlyLens_Performance_Baseline_v1.md` | Startup and navigation baseline |
| `GlyLens_Technical_Debt_Register_v1.md` | Prioritized debt backlog |

---

_Reviewer attestation: This review was performed against repository evidence only. No architecture redesign or feature implementation was performed per Build Program 1.1 charter._
