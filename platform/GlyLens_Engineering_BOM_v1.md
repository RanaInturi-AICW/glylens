# GlyLens Engineering Bill of Materials (EBOM) v1

_Last Updated: 2026-06-26 (mobile toolchain defers to Version Compatibility Matrix v2)_  
_Build Program: 1.2 — Enterprise Developer Platform_  
_Status: CANONICAL_  
_Owner: Platform Engineering_

The EBOM defines **exact recommended versions** for the official GlyLens engineering workstation and CI runners. All developers and AI agents must align with this BOM unless a Platform Contract exception is approved.

---

## 1. Host Operating System

| Component | Recommended Version | Minimum | Notes |
|-----------|-------------------|---------|-------|
| **Windows** | Windows 11 **24H2** (Build 26100) | Windows 11 23H2 (Build 22631) | Primary dev host |
| **Windows Edition** | **Professional** | Home or Pro | WSL2 + Hyper-V (Pro recommended) |
| **PowerShell** | **7.4.6** (pwsh) | 7.4.0 | Default shell for GlyLens scripts |
| **Windows Terminal** | **1.22** | 1.20 | Optional but recommended |

---

## 2. WSL2 & Linux

| Component | Recommended Version | Minimum | Notes |
|-----------|-------------------|---------|-------|
| **WSL** | **2.3.26** | 2.2.0 | `wsl --version` |
| **WSL Default Version** | **2** | 2 | `wsl --set-default-version 2` |
| **Ubuntu (WSL)** | **24.04.1 LTS** (Noble Numbat) | 22.04 LTS | `wsl -d Ubuntu` |
| **Linux Kernel (WSL)** | **6.6.x** (Microsoft build) | 5.15+ | Via `wsl --update` |

**Policy:** Flutter, Android SDK, and Dart run **natively on Windows**. WSL2 is for Docker, Python corpus tools, and Firebase Emulator Suite containers — not for `flutter run`.

---

## 3. Flutter & Dart

**Mobile toolchain versions are defined in `GlyLens_Version_Compatibility_Matrix.md` (canonical).**  
Programmatic source: `scripts/platform/glylens-toolchain.matrix.ps1`.

| Component | Recommended Version | Minimum (pubspec) | Notes |
|-----------|-------------------|-------------------|-------|
| **Flutter** | **3.44.4** (stable) | >= 3.44.0 | Pin in CI |
| **Dart** | **3.12.2** (bundled) | ^3.12.0 | Ships with Flutter 3.44.4 |
| **Flutter channel** | `stable` | stable | No beta/master for production work |

```bash
flutter --version
# Expected: Flutter 3.44.4 • channel stable • Dart 3.12.2
```

---

## 4. Android Toolchain

**See `GlyLens_Version_Compatibility_Matrix.md` for the full resolved chain.**

| Component | Recommended Version | Minimum | Notes |
|-----------|-------------------|---------|-------|
| **Android Studio** | **2025.2.3+** (Otter 3 Feature Drop) | 2025.2.3 | AGP 9 support |
| **Android SDK Platform** | **API 36+** | API 36 | e.g. `android-36.1` |
| **Android SDK Build-Tools** | **37.0.0** | 36.0.0 | AGP 9 minimum 36.0.0 |
| **Android Gradle Plugin** | **9.0.1** | 9.0.0 | Via Flutter 3.44 template |
| **Gradle (wrapper)** | **9.1.0** | 9.1.0 | AGP 9 requirement |
| **Kotlin** | **2.3.20** (template) | — | Built-in via AGP 9 |
| **compileSdk / targetSdk** | **36** | 36 | Flutter template default |
| **minSdk** | **24** | 24 | Android 7.0+ |
| **Java (JDK)** | **17.0.19** (Temurin) | 17 | `JAVA_HOME` → JDK 17 |
| **NDK** | **28.2.13676358** | — | When required by plugins |

---

## 5. Apple Toolchain (Optional — macOS CI only)

| Component | Recommended Version | Notes |
|-----------|-------------------|-------|
| **Xcode** | **16.2** | macOS runner only |
| **CocoaPods** | **1.16.2** | iOS builds |
| **iOS Deployment Target** | **13.0** | Flutter default |

Windows developers target **Android only** for local device testing. iOS builds run on GitHub Actions macOS runners (future).

---

## 6. Source Control & GitHub

| Component | Recommended Version | Minimum | Notes |
|-----------|-------------------|---------|-------|
| **Git** | **2.47.1** | 2.40 | Windows install |
| **GitHub CLI** | **2.63.2** | 2.40 | `gh auth login` |
| **Git LFS** | **3.6.0** | Optional | For large assets (future) |

**Repository:** `https://github.com/RanaInturi-AICW/glylens`

---

## 7. Container Platform

| Component | Recommended Version | Minimum | Notes |
|-----------|-------------------|---------|-------|
| **Docker Desktop** | **4.37.2** | 4.30 | WSL2 backend enabled |
| **Docker Engine** | **27.4.0** | 26.x | Via Docker Desktop |
| **Docker Compose** | **v2.31.0** | v2.24 | `docker compose` plugin |
| **WSL Integration** | Enabled for Ubuntu | Required | Docker Desktop → Settings → Resources → WSL |

**Policy:** Docker is **not** used for Flutter builds. See `platform/GlyLens_Docker_Strategy_v1.md`.

---

## 8. Firebase Tooling (Prepare Only — Project Not Yet Created)

| Component | Recommended Version | Minimum | Notes |
|-----------|-------------------|---------|-------|
| **Firebase CLI** | **13.29.1** | 13.x | `npm install -g firebase-tools` |
| **FlutterFire CLI** | **1.0.1** | 1.0 | `dart pub global activate flutterfire_cli` |
| **Node.js** | **22.12.0 LTS** | 20 LTS | Required for Firebase CLI |

**Status:** Firebase project **not yet created**. Install CLIs only; do not run `flutterfire configure` until Platform Engineering authorizes.

---

## 9. Python (Corpus & Scripts)

| Component | Recommended Version | Minimum | Notes |
|-----------|-------------------|---------|-------|
| **Python** | **3.12.8** | 3.11 | Native Windows or Docker |
| **pip** | **24.3.1** | 23.x | |

Used for `scripts/convergence_repair.py`, `scripts/generate_backlog.py`, and Docker corpus validation.

---

## 10. IDE & AI Tools

| Component | Recommended Version | Notes |
|-----------|-------------------|-------|
| **Cursor** | **0.50.x** (latest stable) | Primary AI IDE |
| **VS Code** | **1.96.x** | Optional; Cursor is VS Code–based |

### Recommended VS Code / Cursor Extensions

| Extension | ID | Purpose |
|-----------|-----|---------|
| Dart | `Dart-Code.dart-code` | Dart language support |
| Flutter | `Dart-Code.flutter` | Flutter tooling |
| Error Lens | `usernamehw.errorlens` | Inline diagnostics |
| GitLens | `eamodio.gitlens` | Git history |
| YAML | `redhat.vscode-yaml` | CI/CD files |
| Docker | `ms-azuretools.vscode-docker` | Compose files |
| EditorConfig | `EditorConfig.EditorConfig` | Format consistency |

---

## 11. Hardware Minimum Recommendations

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU | 4 cores / 8 threads | 8 cores / 16 threads |
| RAM | 16 GB | 32 GB |
| Storage | 256 GB SSD (50 GB free) | 512 GB NVMe |
| Display | 1920×1080 | 2560×1440 |
| Android device | USB debugging capable | Pixel or equivalent |
| Emulator | HAXM/WHPX enabled | 8 GB RAM allocated to emulator |

---

## 12. CI Runner Alignment

GitHub Actions `ubuntu-latest` must use the same Flutter pin as local BOM:

| CI Component | Version |
|--------------|---------|
| Flutter (pinned) | **3.44.4** |
| Java | **17** (actions/setup-java) |
| Node (Firebase jobs) | **22** |

---

## 13. Version Drift Policy

1. EBOM versions are updated quarterly or when Flutter stable releases.
2. `pubspec.yaml` `environment:` constraints must remain compatible with EBOM.
3. CI Flutter pin must match EBOM within one patch version.
4. Changes require PR to `platform/GlyLens_Engineering_BOM_v1.md` + Manifest update.

---

## 14. Quick Verification

```powershell
# From repository root
.\scripts\platform\audit-environment.ps1
.\scripts\platform\validate-environment.ps1
```

---

_Related: `GlyLens_Platform_Contract_v1.md`, `GlyLens_Developer_Onboarding_Guide_v1.md`_
