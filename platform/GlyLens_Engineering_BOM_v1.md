# GlyLens Engineering Bill of Materials (EBOM) v1

_Last Updated: 2026-06-26_  
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

| Component | Recommended Version | Minimum (pubspec) | Notes |
|-----------|-------------------|-------------------|-------|
| **Flutter** | **3.27.4** (stable) | >= 3.24.0 | Pin in CI; matches `intl 0.20.2` |
| **Dart** | **3.6.2** (bundled) | ^3.5.0 | Ships with Flutter 3.27.4 |
| **Flutter channel** | `stable` | stable | No beta/master for production work |

```bash
# Verify
flutter --version
# Expected: Flutter 3.27.4 • channel stable • Dart 3.6.2
```

---

## 4. Android Toolchain

| Component | Recommended Version | Minimum | Notes |
|-----------|-------------------|---------|-------|
| **Android Studio** | **2024.2.2** (Ladybug) Patch 2 | 2024.1 | IDE + SDK Manager |
| **Android SDK Platform** | **≥ API 35** | API 34 | `platforms;android-35` or newer (e.g. `android-36.1`) |
| **Android SDK Build-Tools** | **37.0.0** | 35.0.0 | Backward-compatible with compileSdk 35 |
| **Android SDK Command-line Tools** | **16.0** | 13.0 | |
| **Android Emulator** | **35.2.10** | 34.x | Pixel 7 API 35 image |
| **NDK** | **27.2.12479018** | Optional for BP1 | Required for some plugins later |
| **Java (JDK)** | **17.0.13** (Temurin) | 17 | `JAVA_HOME` must point to JDK 17 |
| **Gradle (wrapper)** | **8.10.2** | 8.7 | Set when `android/` committed |
| **Android Gradle Plugin** | **8.7.3** | 8.5 | Via Flutter template |
| **Kotlin** | **2.0.21** | 1.9+ | Via Flutter template |

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
| Flutter (pinned) | **3.27.4** |
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
