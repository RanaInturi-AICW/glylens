# GlyLens Code Quality Report v1

_Last Updated: 2026-06-26_  
_Build Program: 1.1 — Engineering Verification_  
_Status: CANONICAL_

---

## 1. Build Verification Results

### 1.1 Local Environment

| Check | Result | Notes |
|-------|--------|-------|
| Flutter on PATH | ❌ NOT AVAILABLE | `where flutter` returned no match on reviewer workstation |
| `flutter pub get` | ⚠️ NOT EXECUTED | Blocked by missing SDK |
| `dart analyze` | ⚠️ NOT EXECUTED | Blocked |
| `flutter analyze` | ⚠️ NOT EXECUTED | Blocked |
| `flutter test` | ⚠️ NOT EXECUTED | Blocked |

### 1.2 CI Environment (Authoritative)

**Workflow:** `.github/workflows/flutter_ci.yml`  
**Latest run:** `28231684317` — **FAILURE** (commit `134902f`, 2026-06-26)

| Step | Result |
|------|--------|
| Checkout | ✅ Pass |
| Flutter setup | ✅ Pass |
| Ensure Flutter platform folders | ❌ **Fail** at `pub get` |
| Verify formatting | ⏭ Skipped |
| Analyze | ⏭ Skipped |
| Unit & widget tests | ⏭ Skipped |
| Build Android APK | ⏭ Skipped |
| Build iOS | ⏭ Skipped |

**Error output:**
```
Because glylens depends on flutter_localizations from sdk which depends on intl 0.20.2,
intl 0.20.2 is required.
So, because glylens depends on intl ^0.19.0, version solving failed.
```

### 1.3 Projected Analyzer Findings (Static Review)

After resolving `intl`, the following **compile errors** are expected:

```
lib/features/auth/application/auth_controller.dart:6:8
  Target of URI doesn't exist: 'auth_providers.dart'

lib/features/auth/infrastructure/firebase_auth_repository.dart:8:8
  Target of URI doesn't exist: '../entities/auth_user.dart'

lib/features/auth/infrastructure/firebase_auth_repository.dart:9:8
  Target of URI doesn't exist: '../repositories/auth_repository.dart'
```

---

## 2. Static Analysis Configuration

**File:** `analysis_options.yaml`

| Setting | Value | Assessment |
|---------|-------|------------|
| Base lints | `flutter_lints` | Standard |
| `strict-casts` | true | ✅ Strong |
| `strict-inference` | true | ✅ Strong |
| `strict-raw-types` | true | ✅ Strong |
| `avoid_print` | true | ✅ Enforced |
| `prefer_single_quotes` | true | ✅ |
| `require_trailing_commas` | true | ✅ |
| `sort_pub_dependencies` | true | ✅ |

**Not enabled (acceptable for BP1):** `always_use_package_imports`, `public_member_api_docs`, custom security lints.

---

## 3. Dependency Review

### 3.1 Production Dependencies

| Package | Version | Purpose | Used? | Replaceable? | Security | Maintenance | Recommended? |
|---------|---------|---------|-------|--------------|----------|-------------|--------------|
| `flutter` | SDK | Framework | ✅ | No | Low risk | Active | ✅ Keep |
| `flutter_localizations` | SDK | l10n | ✅ | No | Low risk | Active | ✅ Keep |
| `flutter_riverpod` | ^2.6.1 | State management (ADR) | ✅ | Theoretically (Bloc) — violates ADR | Low | Active | ✅ Keep |
| `go_router` | ^14.6.2 | Navigation (Blueprint) | ✅ | AutoRoute — violates Blueprint | Low | Active | ✅ Keep |
| `firebase_core` | ^3.8.1 | Firebase init (ADR-0004) | ✅ | No — ADR locked | Google-maintained | Active | ✅ Keep |
| `firebase_auth` | ^5.3.4 | Auth only (BP1 scope) | ✅ | No — ADR locked | Google-maintained | Active | ✅ Keep |
| `google_sign_in` | ^6.2.2 | Google OAuth | ✅ | No for Google auth | Google-maintained | Active | ✅ Keep |
| `sign_in_with_apple` | ^6.1.4 | Apple OAuth | ✅ | No for Apple auth | Community + Apple | Active | ✅ Keep |
| `intl` | ^0.19.0 | Localization formatting | ✅ (via SDK) | N/A | Low | Active | ❌ **Bump to ^0.20.2** |
| `hive_flutter` | ^1.1.0 | KV cache (BP1) | ✅ | Isar in BP2 for corpus | Low | Maintained | ✅ Keep for BP1 |
| `flutter_secure_storage` | ^9.2.4 | Secure token storage | ✅ | Encrypted shared prefs — weaker | Low | Active | ✅ Keep |
| `logger` | ^2.5.0 | Structured logging | ✅ | Flogger, custom | Low | Active | ✅ Keep |
| `equatable` | ^2.0.7 | Value equality | ✅ | manual == | Low | Active | ✅ Keep |
| `meta` | ^1.15.0 | Annotations | ❌ **Unused** | Remove | Low | Active | ❌ **Remove** |
| `dynamic_color` | ^1.7.0 | Material You theming | ✅ | Manual ColorScheme | Low | Active | ✅ Keep |

### 3.2 Dev Dependencies

| Package | Version | Purpose | Used? | Recommended? |
|---------|---------|---------|-------|--------------|
| `flutter_test` | SDK | Testing | ✅ | ✅ Keep |
| `integration_test` | SDK | E2E harness | ⚠️ Placeholder only | ✅ Keep |
| `flutter_lints` | ^5.0.0 | Lint rules | ✅ | ✅ Keep |
| `mocktail` | ^1.0.4 | Mocking | ❌ **Unused** | ❌ Remove or use |
| `test` | ^1.25.8 | Test runner | ✅ (transitive) | ✅ Keep |

### 3.3 Dependency Actions

| Action | Package | Rationale |
|--------|---------|-----------|
| **Fix version** | `intl` → `^0.20.2` | Unblocks `pub get` |
| **Remove** | `meta` | Zero references in `lib/` |
| **Remove or use** | `mocktail` | No mock tests exist |

---

## 4. Code Structure Metrics

| Metric | Value |
|--------|-------|
| `lib/` Dart files | ~110 |
| `test/` Dart files | 13 |
| Feature modules | 12 |
| Platform core modules | 8 (`config`, `cache`, `security`, etc.) |
| Intelligence domain files | ~40 |
| `print()` in lib | 0 |
| `Semantics` widgets | 0 |
| GoRouter routes | 14+ |

---

## 5. Layer Violation Register

| ID | Violation | Severity |
|----|-----------|----------|
| LV-01 | `features/*/presentation` → `bootstrap/providers.dart` | Medium |
| LV-02 | `settings_page.dart` → `app/theme/theme_controller.dart` | Low |
| LV-03 | `auth_controller.dart` → infrastructure `authRepositoryProvider` | Medium |
| LV-04 | `onboarding` / `settings` → `auth/application/auth_controller.dart` | Low (acceptable cross-feature) |

---

## 6. Formatting

CI enforces `dart format` on `lib`, `test`, `integration_test`. Cannot verify pass/fail until pub get succeeds. No obvious formatting violations observed in spot checks.

---

## 7. Intelligence Engine Quality (Sprint 0 — Unchanged)

| Area | Tests | Quality |
|------|-------|---------|
| Domain entities | `entities_test.dart` | ✅ Strong |
| Value objects | `value_objects_test.dart` | ✅ Strong |
| DTOs | `dtos_test.dart` | ✅ Strong |
| Validation | `validation_test.dart` | ✅ Strong |
| Engines | `engine_test.dart`, `confidence_explainability_test.dart` | ✅ Strong |
| Policies | `policy_test.dart` | ✅ Strong |
| Use cases | `use_cases_test.dart` | ✅ Adequate |
| Benchmark | `benchmark_validator_test.dart` | ✅ Adequate |

**Note:** Intelligence tests are expected to pass once platform compile issues are fixed — they do not import broken auth paths.

---

## 8. Quality Gate Verdict

| Gate | Status |
|------|--------|
| `pub get` | ❌ FAIL |
| `flutter analyze` | ❌ BLOCKED |
| `flutter test` | ❌ BLOCKED |
| Format check | ❌ BLOCKED |
| Android build | ❌ BLOCKED |
| iOS build | ❌ BLOCKED |

**Code Quality Grade: D** (intelligence engine: B+; platform layer: F due to compile/CI failure)

---

## 9. Remediation Checklist

- [ ] Bump `intl` to `^0.20.2`
- [ ] Fix auth import paths (TD-002)
- [ ] Remove unused `meta` dependency
- [ ] Remove or adopt `mocktail`
- [ ] Verify green CI on `main`
- [ ] Add platform smoke tests

---

_Related: `GlyLens_Build_Program_1_Engineering_Review_v1.md`, `GlyLens_Technical_Debt_Register_v1.md`_
