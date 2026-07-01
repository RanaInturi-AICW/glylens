# GlyLens Build Health Report v1.0

_Last Updated: 2026-06-26 (Build Program 1.4)_  
_Verdict: **CODE GREEN / BUILD PARTIAL**_

## Executive Summary

Build Program 1.4 stabilized the Flutter codebase to a **zero-issue analyzer** state and **83/83 passing tests**. Local Android APK assembly is blocked by a **JDK SSL PKIX** failure when the Gradle wrapper downloads `gradle-9.1.0-all.zip`. CI (Ubuntu + Temurin 17) is expected to produce a green APK without this workstation-specific TLS interception.

## Quality Gate Results

| Gate | Result | Details |
|------|--------|---------|
| `flutter doctor` | PASS* | Cosmetic `[user-branch]` warning on shallow Flutter clone |
| `flutter pub get` | PASS | 0 resolution errors |
| `flutter analyze --fatal-infos` | PASS | 0 issues (was 112 at sprint start) |
| `dart analyze --fatal-infos` | PASS | lib + test + integration_test |
| `flutter test` | PASS | 83 tests |
| `flutter build apk --debug` | **FAIL** | `SSLHandshakeException: PKIX path building failed` |

## Root Cause — APK Failure

| Field | Value |
|-------|-------|
| **Root cause** | Corporate/AV TLS inspection certificate not trusted by JDK used by Gradle wrapper |
| **Impact** | Cannot download Gradle distribution or resolve Gradle Plugin Portal artifacts locally |
| **Evidence** | `org.gradle.wrapper.Download.downloadInternal` throws PKIX; PowerShell `Invoke-WebRequest` succeeds |
| **Recommended fix** | Import org root CA into `D:\glylens-dev\jdk\lib\security\cacerts` **or** pre-seed `~/.gradle/wrapper/dists` with offline zip |
| **Risk** | Low for CI; medium for local dev until cert or offline seed applied |

**Workaround verified:** `distributionUrl=file:///D:/glylens-dev/gradle-9.1.0-all.zip` allows Gradle to start; subsequent plugin resolution still requires TLS to `plugins.gradle.org` unless fully offline mirror configured. **Do not commit file URL** — CI requires HTTPS distribution URL.

## Fixes Applied (BP1.4)

1. Auth import path corrections (`auth_controller`, `firebase_auth_repository`)
2. `Result.when` pattern shadowing fix
3. Value object constructor cleanup (Dart 3 duplicate field init)
4. `SourceType` enum alignment (`userSubmission`, `aiAssisted`)
5. `fake_repositories` null-safe lookup helper
6. Infrastructure skeleton test rewrite
7. Test fixture alignment (portion `serving` key, evidence-level score bands)
8. `ConfidenceScore` unknown-evidence support for refusal flows
9. Lint cleanup (unused imports, non-null assertions, pubspec sort)

## Toolchain Matrix (Canonical)

| Component | Version |
|-----------|---------|
| Flutter | 3.44.4 |
| Dart | 3.12.2 |
| JDK | 17 (CLI) / 21 (Android Studio JBR) |
| AGP | 9.0.1 |
| Gradle | 9.1.0 |
| compileSdk / targetSdk | 36 |
| minSdk | 24 |

## Recommendation

- **Approve code baseline** for RC1.
- **Defer tag** until CI APK artifact is produced.
- Add SSL remediation steps to `platform/GlyLens_Installation_Guide.md` § Troubleshooting.

---

_End of Report_
