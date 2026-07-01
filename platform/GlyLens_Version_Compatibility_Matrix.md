# GlyLens Version Compatibility Matrix v2

_Last Updated: 2026-06-26_  
_Matrix ID: 2.0.0_  
_Status: **CANONICAL — SINGLE SOURCE OF TRUTH**_  
_Owner: Platform Engineering_  
_Programmatic mirror: `scripts/platform/glylens-toolchain.matrix.ps1`_

---

## Purpose

Define **one officially supported mobile toolchain** for GlyLens — derived from mutual compatibility between Flutter stable, Dart, Android Gradle Plugin (AGP), Gradle, Kotlin, JDK, and Android SDK. All CI pins, platform scripts, onboarding docs, and `pubspec.yaml` constraints must align with this matrix.

---

## Resolution Summary (2026-06-26)

| Decision | Outcome |
|----------|---------|
| Flutter channel | **stable** `3.44.4` (latest stable hotfix) |
| Android migration | **AGP 9.0.1** + **Gradle 9.1.0** (Flutter 3.44 template) |
| SDK levels | **compileSdk / targetSdk 36**; **minSdk 24** (Flutter 3.44 default) |
| JDK | **17** (AGP 9 / Gradle 9 floor; JDK 21 not required) |
| Validation | Chain verified against Flutter `gradle_utils.dart` @ stable and AGP 9.0.1 release notes |

---

## Official Toolchain Matrix

| Layer | Version | Minimum | Source / Rationale |
|-------|---------|---------|-------------------|
| **Flutter** | **3.44.4** | 3.44.0 | [Flutter stable releases](https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json); CI + local pin |
| **Dart** | **3.12.2** | ^3.12.0 | Bundled with Flutter 3.44.4 |
| **Android Gradle Plugin** | **9.0.1** | 9.0.0 | Flutter 3.44.4 `templateAndroidGradlePluginVersion` |
| **Gradle Wrapper** | **9.1.0** | 9.1.0 | AGP 9.0.1 minimum; Flutter `templateDefaultGradleVersion` |
| **Kotlin (template KGP)** | **2.3.20** | — | Flutter template; AGP 9 built-in Kotlin uses KGP **2.2.10** |
| **JDK (build)** | **17.0.19** (Temurin) | 17 | Gradle 9 + AGP 9 minimum; `JAVA_HOME` required |
| **compileSdk** | **36** | 36 | Flutter `compileSdkVersionInt` @ stable |
| **targetSdk** | **36** | 36 | Flutter `targetSdkVersion` @ stable |
| **minSdk** | **24** | 24 | Flutter `minSdkVersionInt` @ stable (Android 7.0+) |
| **Android SDK Platform** | **≥ API 36** | 36 | e.g. `android-36`, `android-36.1` |
| **Android SDK Build-Tools** | **37.0.0** | 36.0.0 | AGP 9.0.1 minimum Build-Tools 36.0.0 |
| **NDK** | **28.2.13676358** | — | Flutter template default when NDK required |
| **Android Studio** | **2025.2.3+** (Otter 3 Feature Drop) | 2025.2.3 | AGP 9.0+ IDE support |
| **intl** (pubspec) | **0.20.2** | 0.20.2 | Matches `flutter_localizations` @ Flutter 3.44.4 |

---

## Compatibility Chain

```
Flutter 3.44.4 (stable)
  └── Dart 3.12.2
  └── intl 0.20.2 (flutter_localizations)
  └── android/ template (Kotlin DSL .kts)
        └── AGP 9.0.1
        └── Gradle 9.1.0
        └── JDK 17 (JAVA_HOME)
        └── Built-in Kotlin (KGP 2.2.10 via AGP; template KGP 2.3.20)
        └── compileSdk 36 / targetSdk 36 / minSdk 24
        └── SDK Platform ≥36 + Build-Tools ≥36.0.0 (37.0.0 recommended)
        └── NDK 28.2.13676358 (when required)
```

---

## AGP 9 / Flutter 3.44 Migration Notes

| Topic | Guidance |
|-------|----------|
| **Built-in Kotlin** | AGP 9 enables built-in Kotlin by default; do not manually apply `org.jetbrains.kotlin.android` in new `flutter create` output |
| **Gradle DSL** | New projects use `.gradle.kts` (Kotlin DSL); Groovy `.gradle` still supported |
| **minSdk 24** | Drops Android 6.0 and below (~1% devices); required by Flutter 3.44 template |
| **Plugin authors** | Third-party Flutter plugins may need AGP 9 / minSdk 24 updates; run `flutter pub outdated` after upgrade |
| **Regenerate android/** | Run `flutter create . --org com.glylens --project-name glylens --platforms android,ios` after upgrading Flutter |

---

## CI / Local Parity

| Environment | Flutter | Java | Gradle | Notes |
|-------------|---------|------|--------|-------|
| GitHub Actions | 3.44.4 | 17 (Temurin) | 9.1.0 (wrapper) | `subosito/flutter-action` + `setup-java@v4` |
| Windows workstation | 3.44.4 | 17 (Temurin) | 9.1.0 | Native install; `D:\glylens-dev\flutter` |
| WSL Ubuntu | — | — | — | Docker only; no Flutter |

---

## pubspec.yaml Constraints (aligned)

```yaml
environment:
  sdk: ^3.12.0
  flutter: ">=3.44.0"

dependencies:
  intl: ^0.20.2
```

---

## Version Verification Commands

```powershell
flutter --version          # Flutter 3.44.4 • Dart 3.12.2
java -version              # openjdk 17.x
.\scripts\platform\verify-android.ps1
.\scripts\platform\verify-java.ps1
.\scripts\platform\verify-flutter.ps1

# After android/ exists:
cd android; .\gradlew.bat --version   # Gradle 9.1.0
```

---

## Upgrade Policy

| Component | Policy |
|-----------|--------|
| Flutter stable patch (3.44.x) | Adopt after CI green; update `glylens-toolchain.matrix.ps1` + this doc |
| Flutter minor (3.47+) | Re-run full matrix resolution; regenerate `android/` template |
| AGP major | Follow Flutter stable template; use Android Studio AGP Upgrade Assistant |
| minSdk / compileSdk | Only change when Flutter stable template changes |

---

## Superseded Matrix (v1)

| v1 (2026-06-26) | v2 (current) |
|-----------------|--------------|
| Flutter 3.27.4 | Flutter **3.44.4** |
| Dart 3.6.2 | Dart **3.12.2** |
| AGP 8.7.3 | AGP **9.0.1** |
| Gradle 8.10.2 | Gradle **9.1.0** |
| compileSdk / targetSdk 35 | **36** |
| minSdk 21 | **24** |
| API platform ≥35 | **≥36** |
| Build-Tools 35.0.0 / 37.0.0 | **≥36.0.0** (37.0.0 recommended) |

---

_Related: `scripts/platform/glylens-toolchain.matrix.ps1`, `GlyLens_Engineering_BOM_v1.md` (defers mobile toolchain to this document), `GlyLens_Installation_Guide.md`_
