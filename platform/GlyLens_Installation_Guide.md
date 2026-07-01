# GlyLens Installation Guide

_Last Updated: 2026-06-26_  
_Build Program: 1.3 — Workstation Stand-Up_  
_Status: CANONICAL_  
_Target: Windows 11 + native Flutter + native Android SDK_

**This guide does not auto-install software.** Run each step manually and verify before proceeding.

**Official matrix:** `GlyLens_Version_Compatibility_Matrix.md`

---

## Default install drive: **D:**

GlyLens installs all heavy tooling on **`D:\glylens-dev`** by default (not `C:`). Your repo already lives on `D:`; this keeps ~15 GB+ of SDK/Flutter off the OS drive.

| Path | Purpose |
|------|---------|
| `D:\glylens-dev\flutter` | Flutter SDK |
| `D:\glylens-dev\android\sdk` | Android SDK (`ANDROID_HOME`) default |
| `D:\AndroidStudio-Sdk` | Android SDK alternate (`GLYLENS_ANDROID_SDK`) |
| `D:\glylens-dev\android-studio` | Android Studio (optional custom install) |
| `D:\glylens-dev\jdk` | JDK 17 (Temurin) |
| `D:\glylens-dev\pub-cache` | Dart pub cache (`PUB_CACHE`) |

### How to change the drive

**Option A — Environment variable (recommended):**

```powershell
[System.Environment]::SetEnvironmentVariable('GLYLENS_DEV_ROOT', 'E:\glylens-dev', 'User')
```

**Option B — Edit config file:**

`scripts\platform\glylens-paths.config.ps1` → change default `D:\glylens-dev`

**Show current paths:**

```powershell
.\scripts\platform\show-dev-paths.ps1
```

**Create folder structure (no software installed):**

```powershell
.\scripts\platform\initialize-dev-root.ps1
```

---

## Installation Order

| Step | Component | Required |
|------|-----------|----------|
| 0 | Prerequisite check | ✅ |
| 1 | PowerShell 7 | ✅ |
| 2 | JDK 17 (Temurin) | ✅ |
| 3 | Flutter 3.27.4 stable | ✅ |
| 4 | Android Studio Meerkat | ✅ |
| 5 | Android SDK components | ✅ |
| 6 | PATH & environment variables | ✅ |
| 7 | Android licenses | ✅ |
| 8 | Flutter platform folders | ✅ |
| 9 | Android Emulator | ✅ |
| 10 | Physical device USB debugging | Recommended |
| 11 | Docker Desktop (start) | ✅ |
| 12 | WSL Ubuntu (start) | ✅ |
| 13 | Firebase CLI (prepare only) | Optional |
| 14 | Full environment verification | ✅ |

---

## Step 0 — Prerequisite Check

```powershell
cd "D:\Rana\AI Crafft Works\Git\RanaSalvo-Git\glylens"
.\scripts\platform\install-prerequisite-check.ps1
```

Requires: **50 GB free on dev drive (D:)**; 15 GB+ free on C: is advisory. Virtualization enabled.

```powershell
.\scripts\platform\initialize-dev-root.ps1   # optional: create D:\glylens-dev folders
.\scripts\platform\install-prerequisite-check.ps1
```

---

## Step 1 — PowerShell 7

| | |
|-|-|
| **Download** | https://github.com/PowerShell/PowerShell/releases (7.4.6+) |
| **Silent install** | `msiexec.exe /package PowerShell-7.4.6-win-x64.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1` |
| **winget** | `winget install Microsoft.PowerShell` |
| **Install to D:** | MSI: `msiexec /i PowerShell-7.4.6-win-x64.msi INSTALLDIR="D:\glylens-dev\powershell" /passive` |
| **Verify** | `pwsh -Version` |

---

## Step 2 — JDK 17 (Eclipse Temurin)

| | |
|-|-|
| **Download** | https://adoptium.net/temurin/releases/?version=17 |
| **Install to D:** | Run Temurin `.msi` → choose `D:\glylens-dev\jdk\` or use: |
| **Silent (D:)** | `msiexec /i OpenJDK17U-jdk_x64_windows_hotspot_*.msi INSTALLDIR="D:\glylens-dev\jdk" /passive` |
| **winget** | `winget install EclipseAdoptium.Temurin.17.JDK` *(defaults to C: — prefer MSI to D:)* |
| **Verify** | `D:\glylens-dev\jdk\bin\java.exe -version` |

**Environment variables (User):**

| Variable | Value |
|----------|-------|
| `JAVA_HOME` | `D:\glylens-dev\jdk` (or exact Temurin subfolder, e.g. `...\jdk-17.0.13.11-hotspot`) |

Remove or deprioritize JDK 21 on PATH for Android builds. Android Studio → Settings → Build → Gradle → JDK → **17**.

**Configure (with confirmation):**

```powershell
.\scripts\platform\configure-path.ps1 -SetJavaHome
```

---

## Step 3 — Flutter 3.27.4 Stable

| | |
|-|-|
| **Install path** | `D:\glylens-dev\flutter` |
| **Commands** | See below |

```powershell
.\scripts\platform\initialize-dev-root.ps1
cd D:\glylens-dev
git clone https://github.com/flutter/flutter.git -b 3.27.4 --depth 1 flutter
```

Add **User PATH:** `D:\glylens-dev\flutter\bin`

```powershell
flutter config --no-analytics
flutter doctor
flutter --version
# Expected: Flutter 3.27.4 • channel stable • Dart 3.6.2
```

**Optional (not required for GlyLens mobile):**

```powershell
flutter config --enable-web
flutter config --enable-windows-desktop
```

---

## Step 4 — Android Studio

| | |
|-|-|
| **Download** | https://developer.android.com/studio (Meerkat 2024.3.1+) |
| **Install to D:** | Run installer → set location to `D:\glylens-dev\android-studio` |
| **Verify** | Launch Android Studio; SDK Manager opens |

First-run wizard: **Custom** installation → set **Android SDK location** to:

`D:\glylens-dev\android\sdk` **or** `D:\AndroidStudio-Sdk` (if Studio blocks nested paths)

If you used a custom path, set:

```powershell
[System.Environment]::SetEnvironmentVariable('GLYLENS_ANDROID_SDK', 'D:\AndroidStudio-Sdk', 'User')
```

*(Do not use default `%LOCALAPPDATA%\Android\Sdk` on C: unless intentional.)*

---

## Step 5 — Android SDK Components

Android Studio → **SDK Manager**:

| Tab | Install |
|-----|---------|
| SDK Platforms | Android **API 35 or newer** (e.g. API 36 — you have `android-36.1`) |
| SDK Tools | Android SDK Build-Tools **37.0.0** (or latest stable) |
| SDK Tools | Android SDK Command-line Tools **16.0** |
| SDK Tools | Android Emulator |
| SDK Tools | Google USB Driver (physical device) |

**Verify:**

```powershell
.\scripts\platform\verify-android.ps1
```

---

## Step 6 — PATH & Environment Variables

```powershell
.\scripts\platform\configure-path.ps1 -RepairAll
```

Sets (with confirmation):

| Variable | Value |
|----------|-------|
| `ANDROID_HOME` | `D:\glylens-dev\android\sdk` or `D:\AndroidStudio-Sdk` |
| `ANDROID_SDK_ROOT` | same as ANDROID_HOME |
| `PUB_CACHE` | `D:\glylens-dev\pub-cache` |
| PATH | flutter\bin, platform-tools, cmdline-tools\latest\bin |

---

## Step 7 — Android Licenses

```powershell
flutter doctor --android-licenses
# Accept all with 'y'
```

---

## Step 8 — GlyLens Platform Folders

```powershell
cd "D:\Rana\AI Crafft Works\Git\RanaSalvo-Git\glylens"
flutter create . --org com.glylens --project-name glylens --platforms android,ios
flutter pub get
```

If `pub get` fails on `intl`, apply TD-001 (`intl: ^0.20.2`) per Engineering Review.

---

## Step 9 — Android Emulator

Android Studio → Device Manager → Create Device:

| Setting | Value |
|---------|-------|
| Device | Pixel 7 |
| System image | API **35+** (Google APIs) x86_64 — use latest installed (e.g. API 36) |
| RAM | 4096 MB |

```powershell
flutter emulators
flutter emulators --launch <emulator_id>
flutter devices
```

---

## Step 10 — Physical Android Device

1. Enable **Developer options** + **USB debugging**
2. Connect USB; allow debugging prompt on phone
3. Install Google USB driver if device not listed (SDK Manager)
4. Verify: `adb devices` → `device` (not `unauthorized`)

---

## Step 11 — Docker Desktop

1. Start **Docker Desktop** from Start menu
2. Settings → General → Use WSL 2 based engine ✅
3. Settings → Resources → **Disk image location** → `D:\glylens-dev\docker`
4. Settings → Resources → WSL Integration → **Ubuntu** ✅

```powershell
.\scripts\platform\verify-docker.ps1
docker compose -f docker\docker-compose.dev.yml config
```

---

## Step 12 — WSL Ubuntu

```powershell
wsl --update
wsl -d Ubuntu
# Inside WSL: uname -a
exit
```

---

## Step 13 — Firebase CLI (Prepare Only — No Project)

```powershell
winget install OpenJS.NodeJS.LTS
npm install -g firebase-tools@13.29.1
dart pub global activate flutterfire_cli
# Add D:\glylens-dev\pub-cache\bin to PATH (configure-path.ps1 -SetPubCache does this)
firebase --version
```

**Do not run** `flutterfire configure` until Firebase project is authorized.

---

## Step 14 — Full Verification

```powershell
.\scripts\platform\verify-complete-environment.ps1
.\scripts\platform\run-quality-gates.ps1
```

---

## Rollback Strategy

| Component | Rollback |
|-----------|----------|
| Flutter | Delete `D:\glylens-dev\flutter`; remove from PATH |
| Android Studio | Uninstall via Settings → Apps; delete `D:\glylens-dev\android` if clean slate |
| JDK 17 | Uninstall Temurin; restore JAVA_HOME to previous |
| PATH changes | System Properties → Environment Variables → User PATH → remove GlyLens entries |
| Docker | Stop containers: `docker compose -f docker\docker-compose.dev.yml down` |
| Repo `android/` | `git checkout -- android/` or delete folder before commit |

**Snapshot recommendation:** Create Windows System Restore point before Step 4.

---

## Troubleshooting

See `GlyLens_Environment_Readiness_Report.md` § Remediation.

---

_Related: `GlyLens_Developer_Checklist.md`, `Machine_Discovery_Report.md`_
