# GlyLens Technical Debt Register v1

_Last Updated: 2026-06-26_  
_Owner: Principal Engineer (Build Program 1.1)_  
_Status: ACTIVE_

Prioritized engineering debt for the Flutter Platform Foundation and shared intelligence runtime. Classifications: **Critical**, **High**, **Medium**, **Low**.

---

## Summary

| Severity | Count | Must fix before BP2 |
|----------|-------|---------------------|
| Critical | 3 | Yes |
| High | 5 | Yes (P0/P1) |
| Medium | 6 | Recommended |
| Low | 4 | Optional |
| **Total** | **18** | |

---

## Critical

### TD-001 — Dependency resolution failure (`intl` version conflict)

| Field | Detail |
|-------|--------|
| **Description** | `pubspec.yaml` pins `intl: ^0.19.0` but Flutter stable SDK pins `intl 0.20.2` via `flutter_localizations`. `flutter pub get` fails. |
| **Impact** | CI blocked; no analyze, test, or build possible. Entire quality gate non-functional. |
| **Evidence** | GitHub Actions run `28231684317`; CI log: "version solving failed" |
| **Recommendation** | Change to `intl: ^0.20.2` or remove explicit `intl` dependency. |
| **Effort** | 15 minutes |

### TD-002 — Auth module broken import paths

| Field | Detail |
|-------|--------|
| **Description** | `auth_controller.dart` imports `auth_providers.dart` from wrong directory. `firebase_auth_repository.dart` imports `../entities/` and `../repositories/` instead of `../domain/entities/` and `../domain/repositories/`. |
| **Impact** | Platform layer will not compile after pub get fix. Auth feature entirely broken. |
| **Evidence** | Static review of `lib/features/auth/`; files at `infrastructure/auth_providers.dart` |
| **Recommendation** | Fix import paths; move `authRepositoryProvider` registration to bootstrap or use `../infrastructure/auth_providers.dart`. |
| **Effort** | 30 minutes |

### TD-003 — CI never validates current codebase

| Field | Detail |
|-------|--------|
| **Description** | Latest push to `main` has failing CI. No green build artifact exists for Build Program 1. |
| **Impact** | Production readiness claim cannot be substantiated. Regression detection absent. |
| **Evidence** | `gh run list` — failure on commit `134902f` |
| **Recommendation** | Resolve TD-001 and TD-002; re-run CI; require green `main` before BP2. |
| **Effort** | 1 hour (including verification) |

---

## High

### TD-004 — No GoRouter authentication/onboarding guards

| Field | Detail |
|-------|--------|
| **Description** | Router has no `redirect` callback. Users can navigate directly to `/home` without auth or onboarding completion. |
| **Impact** | Security and UX inconsistency; bypasses anonymous onboarding flow. |
| **Evidence** | `lib/app/router/app_router.dart` — no redirect logic |
| **Recommendation** | Add `redirect` using `authStateProvider` and `onboardingCompleteProvider`; use `GoRouterRefreshStream`. |
| **Effort** | 4 hours |

### TD-005 — Welcome page auth buttons not wired

| Field | Detail |
|-------|--------|
| **Description** | Google and Apple sign-in buttons route to `/onboarding/anonymous` instead of calling `AuthController.signInWithGoogle/Apple`. |
| **Impact** | OAuth implementation exists in repository but is unreachable from UI. |
| **Evidence** | `lib/features/onboarding/presentation/welcome_page.dart` |
| **Recommendation** | Wire buttons to `authControllerProvider`; handle loading/error states. |
| **Effort** | 3 hours |

### TD-006 — Platform test coverage near zero

| Field | Detail |
|-------|--------|
| **Description** | No tests for bootstrap, router, auth, Hive cache, or secure storage. Golden and integration tests are placeholders. |
| **Impact** | Platform regressions undetected; rework risk in BP2. |
| **Evidence** | `test/golden/golden_test.dart`, `integration_test/app_test.dart` |
| **Recommendation** | Add router redirect tests, auth controller tests with mocked repository, bootstrap provider smoke test. |
| **Effort** | 2 days |

### TD-007 — Platform folders not committed

| Field | Detail |
|-------|--------|
| **Description** | `android/` and `ios/` are generated ephemerally in CI via `flutter create`. Not in repository. |
| **Impact** | Non-reproducible builds; Firebase/Google Sign-In platform config cannot be versioned. |
| **Evidence** | `.github/workflows/flutter_ci.yml` step "Ensure Flutter platform folders" |
| **Recommendation** | Run `flutter create` locally; commit platform folders; configure Firebase placeholders; remove CI create step. |
| **Effort** | 4 hours |

### TD-008 — Presentation layer imports bootstrap directly

| Field | Detail |
|-------|--------|
| **Description** | Feature pages import `bootstrap/providers.dart` for `onboardingCompleteProvider`, `appConfigProvider`, etc. |
| **Impact** | Layer coupling; features depend on composition root; harder to test in isolation. |
| **Evidence** | `splash_page.dart`, `settings_page.dart`, `developer_page.dart`, `anonymous_onboarding_page.dart` |
| **Recommendation** | Export feature-specific provider facades from `features/*/application/` or `app/di/`. |
| **Effort** | 1 day |

---

## Medium

### TD-009 — Unused dependencies (`meta`, `mocktail`)

| Field | Detail |
|-------|--------|
| **Description** | `meta` has zero imports in `lib/`. `mocktail` declared in dev_dependencies but unused in `test/`. |
| **Impact** | Dependency bloat; false signal of mock-based testing. |
| **Recommendation** | Remove `meta`; use `mocktail` in auth tests or remove. |
| **Effort** | 30 minutes |

### TD-010 — Hardcoded route strings in UI

| Field | Detail |
|-------|--------|
| **Description** | Feature pages use string literals (`'/home'`, `'/settings'`) instead of `AppRoutes` constants. |
| **Impact** | Refactor fragility; route drift risk. |
| **Evidence** | Multiple `features/*/presentation/*.dart` |
| **Recommendation** | Replace with `AppRoutes.*` or `context.go(AppRoutes.home)`. |
| **Effort** | 2 hours |

### TD-011 — `TokenStorage.clear()` wipes all secure storage

| Field | Detail |
|-------|--------|
| **Description** | Sign-out calls `FlutterSecureStorage.deleteAll()` rather than deleting auth keys only. |
| **Impact** | May clear unrelated secure data in future features. |
| **Evidence** | `lib/core/security/flutter_secure_storage_service.dart` |
| **Recommendation** | Delete only `AppConstants.secureStorageAuthTokenKey` and refresh token key. |
| **Effort** | 1 hour |

### TD-012 — No accessibility semantics

| Field | Detail |
|-------|--------|
| **Description** | Zero `Semantics` widgets; no screen reader labels on custom controls. |
| **Impact** | WCAG / platform accessibility compliance gap. |
| **Recommendation** | Add semantics to `AppShell` nav items, `ErrorView`, onboarding CTAs. |
| **Effort** | 1 day |

### TD-013 — Analytics and crash reporting are NoOp

| Field | Detail |
|-------|--------|
| **Description** | `NoOpAnalyticsService` and `NoOpCrashReportingService` wired in production path. |
| **Impact** | No production observability until BP3+ integration. |
| **Evidence** | `lib/bootstrap/providers.dart` |
| **Recommendation** | Acceptable for BP1; schedule Firebase Analytics/Crashlytics in BP3 with env gating. |
| **Effort** | 2 days (future) |

### TD-014 — Flutter SDK version unpinned in CI

| Field | Detail |
|-------|--------|
| **Description** | CI uses `channel: stable` without version pin. |
| **Impact** | CI may break on SDK upgrades without code change (as seen with `intl`). |
| **Recommendation** | Pin `flutter-version: '3.24.x'` in workflow. |
| **Effort** | 30 minutes |

---

## Low

### TD-015 — Theme preference not persisted

| Field | Detail |
|-------|--------|
| **Description** | `themeModeProvider` is in-memory `StateProvider`; resets on app restart. |
| **Impact** | Minor UX friction. |
| **Recommendation** | Persist to Hive via `CacheStore`. |
| **Effort** | 2 hours |

### TD-016 — Developer page exposes internal config

| Field | Detail |
|-------|--------|
| **Description** | Developer screen shows Firebase project ID and feature flags. |
| **Impact** | Low risk in dev builds; should be compile-time gated for production. |
| **Recommendation** | Wrap in `kDebugMode` or `!config.isProduction`. |
| **Effort** | 1 hour |

### TD-017 — Certificate pinning not implemented

| Field | Detail |
|-------|--------|
| **Description** | `NoOpCertificatePinningService` always active. |
| **Impact** | Acceptable for BP1 (no HTTP traffic). Required before API integration. |
| **Recommendation** | Implement in BP2/BP3 when `HttpClient` is real. |
| **Effort** | 1 day (future) |

### TD-018 — Sprint 0 seed data not wired to repositories

| Field | Detail |
|-------|--------|
| **Description** | `SeedDataset` has minimal data; `docs/seed_data/` not loaded by fake repositories. |
| **Impact** | Intelligence engine cannot serve catalog data at runtime. |
| **Evidence** | Sprint 0 DoD I7; `lib/core/data/seed_dataset.dart` |
| **Recommendation** | BP2 scope — wire JSON loader to fake repos or Isar. |
| **Effort** | 3 days (BP2) |

---

## Debt Burn-Down Order (Recommended)

1. TD-001 → TD-002 → TD-003 (same PR — unblock CI)
2. TD-007 (platform folders)
3. TD-004, TD-005 (auth flow)
4. TD-006 (platform tests)
5. TD-008, TD-009, TD-010 (maintainability)
6. TD-011 through TD-018 (incremental)

---

_This register is reviewed at each Build Program gate. New items require Principal Engineer approval._
