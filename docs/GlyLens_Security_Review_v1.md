# GlyLens Security Review v1

_Last Updated: 2026-06-26_  
_Build Program: 1.1 — Engineering Verification_  
_Reviewer: Independent Principal Engineer_  
_Scope: Flutter Platform Foundation (Build Program 1)_

---

## Executive Summary

Security foundations follow Engineering Constitution and ADR-0004 constraints: compile-time configuration, secure storage abstraction, structured logging without `print()`, and no committed secrets. **No critical secret exposure was found.** Platform security posture is **adequate for a development foundation** but **insufficient for production release** due to missing route guards, placeholder Firebase credentials, and absent certificate pinning.

**Security Score: 71 / 100**

---

## 1. Secrets Handling

### 1.1 Source Code Scan

| Check | Result | Evidence |
|-------|--------|----------|
| Real Firebase API keys (`AIza...`) | ✅ None found | Repo-wide grep |
| `.env` files | ✅ None | Glob search |
| `google-services.json` committed | ✅ None | Not in repo |
| `GoogleService-Info.plist` committed | ✅ None | Not in repo |
| Hardcoded passwords/tokens | ✅ None | Manual review |

### 1.2 Configuration Pattern

Firebase credentials resolved via compile-time defines in `AppConfig.fromEnvironment()`:

```dart
const apiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'dev-api-key');
const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'glylens-dev');
```

| Risk | Severity | Mitigation |
|------|----------|------------|
| Dev defaults in production build | **High** if not overridden | CI/CD must inject real defines for UAT/prod; fail build if `dev-api-key` in production |
| Defaults visible in binary | Low | Expected for `--dart-define`; not secret extraction risk for placeholders |

**Recommendation:** Add `AppConfig` assertion: `if (isProduction && firebaseApiKey == 'dev-api-key') throw ConfigurationException(...)`.

---

## 2. Firebase Initialization

| Aspect | Assessment |
|--------|------------|
| Scope | Auth only — Firestore excluded per BP1 ✅ |
| Init location | `bootstrap()` before `runApp` ✅ |
| Failure handling | Rethrows — app won't start with bad config ✅ |
| Options source | Hand-written `DefaultFirebaseOptions.fromConfig()` — not `flutterfire configure` output ⚠️ |
| Platform config files | Not committed — OAuth may fail on device ⚠️ |

**Finding SEC-001:** Firebase init is fail-fast (good) but platform OAuth configuration is incomplete for real sign-in testing.

---

## 3. Authentication Security

### 3.1 Implementation

| Control | Status |
|---------|--------|
| Anonymous auth | ✅ Implemented via Firebase |
| Google Sign-In | ✅ Repository implemented; UI not wired |
| Apple Sign-In | ✅ Repository implemented; UI not wired |
| ID token persistence | ✅ Saved to secure storage on sign-in |
| Sign-out cleanup | ✅ Auth + Google + storage clear |
| Refresh token storage | ⚠️ `saveRefreshToken` exists but unused |

### 3.2 Gaps

| ID | Finding | Severity |
|----|---------|----------|
| SEC-002 | No GoRouter auth redirect — unauthenticated access to `/home` | **High** |
| SEC-003 | Onboarding bypass via direct navigation | **Medium** |
| SEC-004 | Welcome page does not invoke real OAuth | **Medium** |
| SEC-005 | Auth errors logged with Firebase exception details | **Low** — may leak error codes |

---

## 4. Secure Storage

**Stack:** `flutter_secure_storage` → `FlutterSecureStorageService` → `TokenStorage`

| Control | Status |
|---------|--------|
| Abstraction interface | ✅ `SecureStorageService` |
| Key constants | ✅ `AppConstants.secureStorageAuthTokenKey` |
| Platform keychain/keystore | ✅ Delegated to plugin |
| Scoped deletion on sign-out | ❌ `deleteAll()` clears entire storage |

**Finding SEC-006:** Sign-out should delete only auth-related keys to prevent collateral data loss (TD-011).

---

## 5. Logging

| Control | Status |
|---------|--------|
| `avoid_print` enforced | ✅ |
| `AppLogger` abstraction | ✅ |
| Log level gating by environment | ✅ `enableLogging` false in production |
| PII/token redaction | ❌ Not implemented |
| Developer page log exposure | ⚠️ Shows config flags |

**Finding SEC-007:** Add redaction filter for tokens, emails, and UIDs before production.

---

## 6. Network Security

| Control | Status |
|---------|--------|
| HTTP client | `NoOpHttpClient` — throws on use ✅ (no attack surface) |
| Certificate pinning | Interface exists; `NoOpCertificatePinningService` active |
| TLS enforcement | N/A — no network calls in BP1 |

**Finding SEC-008:** Certificate pinning must be enabled before any API integration (BP2+).

---

## 7. Environment Configuration

| Environment | Logging | Analytics | Crash Reporting |
|-------------|---------|-----------|-----------------|
| development | On | Off | Off |
| qa | On | Off | On |
| uat | On | On | On |
| production | Off | On | On |

**Assessment:** Sensible defaults. Production logging disabled is correct; ensure crash reporting is wired before prod (currently NoOp).

---

## 8. Error Handling

| Pattern | Assessment |
|---------|------------|
| `Result<T>` / `Failure` for platform errors | ✅ |
| Domain errors separate from platform | ✅ |
| Global `FlutterError.onError` | ✅ Records to crash service + logger |
| `PlatformDispatcher.onError` | ✅ Catches async errors |
| User-facing error messages | ⚠️ `ErrorView` generic; no error code sanitization |

---

## 9. Dependency Security

| Package | Concern | Status |
|---------|---------|--------|
| `firebase_auth` | Google-maintained | ✅ |
| `flutter_secure_storage` | Widely used; review Android backup flags | ⚠️ Verify `AndroidOptions` in BP1.2 |
| `google_sign_in` | OAuth token handling | ✅ Standard pattern |
| `sign_in_with_apple` | Apple credential flow | ✅ Standard pattern |
| `hive_flutter` | Local cache — no encryption at rest | ⚠️ Acceptable for non-sensitive KV; do not store tokens in Hive |

**Finding SEC-009:** Auth tokens stored only in secure storage (not Hive) — verified in `FirebaseAuthRepository._persistToken`.

---

## 10. CI/CD Security

| Control | Status |
|---------|--------|
| Secrets in workflow | ✅ None committed |
| Firebase keys in CI | ⚠️ Only `ENV=development` — debug build may use dev placeholders |
| Artifact upload | Debug APK only — acceptable |
| Branch protection | Not verified in this review |

**Recommendation:** Use GitHub encrypted secrets for UAT/prod build workflows (separate workflow, manual dispatch).

---

## 11. Compliance with Security Spec

| `GlyLens_Firebase_Security_Rules_Spec_v1.md` | BP1 Status |
|-----------------------------------------------|------------|
| Firestore rules | N/A — Firestore not implemented |
| Auth rules | Client-side Firebase Auth only |
| Premium entitlement | `isPremium: false` hardcoded — acceptable shell |

---

## 12. Findings Summary

| ID | Finding | Severity | Remediation |
|----|---------|----------|-------------|
| SEC-001 | Platform OAuth config not committed | Medium | TD-007 |
| SEC-002 | No auth route guards | High | TD-004 |
| SEC-003 | Onboarding bypass | Medium | TD-004 |
| SEC-004 | OAuth UI not wired | Medium | TD-005 |
| SEC-005 | Auth error logging | Low | Redact in logger |
| SEC-006 | `deleteAll()` on sign-out | Medium | TD-011 |
| SEC-007 | No log redaction | Medium | BP1.2 |
| SEC-008 | No cert pinning | Low (BP1) | BP2+ |
| SEC-009 | Hive unencrypted | Low | Document policy |

---

## 13. Verdict

**APPROVED for development foundation** with mandatory rework on SEC-002, SEC-004, and production config validation before any public release.

**NOT APPROVED for production deployment.**

---

_Related: `GlyLens_Build_Program_1_Engineering_Review_v1.md`, `GlyLens_Technical_Debt_Register_v1.md`_
