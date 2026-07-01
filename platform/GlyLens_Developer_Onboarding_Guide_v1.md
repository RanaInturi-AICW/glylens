# GlyLens Developer Onboarding Guide v1

_Last Updated: 2026-06-26_  
_Build Program: 1.2 — Enterprise Developer Platform_  
_Audience: New developers and AI agents_  
_Estimated setup time: 4–6 hours (first time)_

This guide is the **only document required** to set up a GlyLens workstation from scratch on **Windows 11 Professional + WSL2 + Docker**.

---

## Before You Start

| Prerequisite | Check |
|--------------|-------|
| Windows 11 23H2+ | `winver` |
| Admin access | For WSL/Docker install |
| GitHub access | `RanaInturi-AICW/glylens` write permission |
| Android phone (optional) | USB debugging |

**Read first:** `docs/GlyLens_Master_Documentation_Index_v1.md` (5 min)

---

## Step 1 — Clone Repository

```powershell
cd "D:\Rana\AI Crafft Works\Git\RanaSalvo-Git"
git clone https://github.com/RanaInturi-AICW/glylens.git
cd glylens
git remote -v
# origin → RanaInturi-AICW/glylens
```

```powershell
gh auth login
# Select: GitHub.com → HTTPS → Login with RanaInturi-AICW
```

---

## Step 2 — Install WSL2 + Ubuntu

**Admin PowerShell:**

```powershell
wsl --install -d Ubuntu-24.04
wsl --set-default-version 2
wsl --update
```

Reboot. Create Ubuntu username/password when prompted.

Verify:

```powershell
wsl -l -v
# Ubuntu-24.04  Running  2
```

---

## Step 3 — Install Docker Desktop

1. Download [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
2. Install → enable **WSL 2 based engine**
3. Settings → Resources → WSL Integration → enable **Ubuntu-24.04**
4. Start Docker Desktop

Verify:

```powershell
docker --version
docker compose version
```

---

## Step 4 — Install Flutter (Native Windows)

**Do NOT install Flutter inside WSL for app development.**

```powershell
mkdir C:\src
cd C:\src
git clone https://github.com/flutter/flutter.git -b 3.27.4 --depth 1
```

Add to **User PATH:** `C:\src\flutter\bin`

```powershell
flutter doctor
flutter --version
# Flutter 3.27.4 • Dart 3.6.2
```

---

## Step 5 — Install Android Studio + SDK

1. Install [Android Studio 2024.2.2](https://developer.android.com/studio)
2. SDK Manager → install:
   - Android SDK Platform **API 35**
   - Android SDK Build-Tools **35.0.0**
   - Android SDK Command-line Tools **16.0**
   - Android Emulator
3. Set environment variables (User):

| Variable | Value |
|----------|-------|
| `ANDROID_HOME` | `%LOCALAPPDATA%\Android\Sdk` |
| `ANDROID_SDK_ROOT` | `%LOCALAPPDATA%\Android\Sdk` |

Add to PATH:
- `%LOCALAPPDATA%\Android\Sdk\platform-tools`
- `%LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\bin`

Accept licenses:

```powershell
sdkmanager --licenses
```

---

## Step 6 — Install JDK 17

```powershell
winget install EclipseAdoptium.Temurin.17.JDK
```

Set `JAVA_HOME` to JDK 17 path (e.g. `C:\Program Files\Eclipse Adoptium\jdk-17.0.13.11-hotspot`).

Android Studio → Settings → Build → Gradle → Gradle JDK → **17**.

---

## Step 7 — Install Git + GitHub CLI

```powershell
winget install Git.Git
winget install GitHub.cli
```

---

## Step 8 — Install Cursor IDE

1. Install [Cursor](https://cursor.com)
2. Open folder: `glylens`
3. Install extensions: Dart, Flutter, Docker, YAML, EditorConfig

---

## Step 9 — Run Environment Scripts

```powershell
cd "D:\Rana\AI Crafft Works\Git\RanaSalvo-Git\glylens"

# Audit (read-only)
.\scripts\platform\audit-environment.ps1

# Repair PATH / env vars (safe, no software install)
.\scripts\platform\repair-environment.ps1 -RepairPath -RepairEnvVars

# Full validation
.\scripts\platform\validate-environment.ps1
```

Fix any **Missing** or **Fail** items using guided output.

---

## Step 10 — Bootstrap Flutter Project

```powershell
cd glylens
flutter create . --org com.glylens --project-name glylens --platforms android,ios
flutter pub get
```

> **Note:** If `pub get` fails on `intl`, apply BP1.1 rework (TD-001) or wait for platform fix PR.

---

## Step 11 — Android Emulator

Android Studio → Device Manager → Create Virtual Device:
- **Pixel 7**
- System image: **API 35**
- RAM: 4096 MB minimum

```powershell
flutter emulators
flutter emulators --launch <emulator_id>
```

---

## Step 12 — Physical Android Device

1. Enable Developer Options + USB debugging
2. Connect USB
3. `adb devices` → device listed

---

## Step 13 — Docker Dev Stack (Optional)

```powershell
cd docker
Copy-Item .env.example .env
docker compose -f docker-compose.dev.yml up -d firebase-emulator
# Emulator UI: http://localhost:4000
```

**Firebase project not yet created** — emulators use `glylens-dev` placeholder only.

---

## Step 14 — Quality Gates

```powershell
.\scripts\platform\run-quality-gates.ps1
```

All gates must pass before committing to `main` or `develop`.

---

## Step 15 — Run App

```powershell
flutter run --dart-define=ENV=development
```

---

## Daily Workflow

```powershell
git pull
.\scripts\platform\run-quality-gates.ps1
# ... develop ...
git checkout -b feature/my-change
git commit -m "feat(scope): description"
git push -u origin HEAD
gh pr create
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `flutter` not found | `repair-environment.ps1 -RepairPath` |
| Android licenses | `sdkmanager --licenses` |
| Docker not running | Start Docker Desktop |
| Git push 403 | `gh auth login` with RanaInturi-AICW |
| `pub get` intl error | See `GlyLens_Technical_Debt_Register_v1.md` TD-001 |
| Emulator slow | Enable WHPX; allocate more RAM |

---

## Reference Documents

| Doc | Purpose |
|-----|---------|
| `platform/GlyLens_Engineering_BOM_v1.md` | Exact versions |
| `platform/GlyLens_Platform_Contract_v1.md` | Supported stack |
| `platform/GlyLens_AI_Engineering_Standards_v1.md` | AI tool rules |
| `platform/GlyLens_Local_Quality_Gates_v1.md` | Commit policy |
| `docs/GlyLens_Build_Program_1_Flutter_Foundation_README_v1.md` | App architecture |

---

## Onboarding Complete Checklist

- [ ] `audit-environment.ps1` — no Missing critical tools
- [ ] `validate-environment.ps1` — exit 0
- [ ] `flutter doctor -v` — Android toolchain OK
- [ ] Emulator or physical device connected
- [ ] Docker compose config valid
- [ ] `gh auth status` — correct account
- [ ] Read Master Documentation Index
- [ ] Quality gates understood

**Welcome to GlyLens Platform Engineering.**
