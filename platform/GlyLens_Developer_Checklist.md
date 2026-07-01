# GlyLens Developer Checklist v1

_Last Updated: 2026-06-26_  
_Build Program: 1.3_  
_Use: Tick each item during workstation stand-up_

---

## Phase A — Machine Prerequisites

- [ ] Windows 11 (Home or Pro) build ≥ 22631
- [ ] 16 GB+ RAM; 50 GB+ free disk on system drive
- [ ] Virtualization enabled in BIOS (if emulator fails)
- [ ] Admin rights for installers
- [ ] `install-prerequisite-check.ps1` passes

---

## Phase B — Core Toolchain

- [ ] PowerShell 7 (`pwsh`) installed
- [ ] Git 2.40+ (`git --version`)
- [ ] GitHub CLI (`gh auth status` → RanaInturi-AICW, push: true)
- [ ] JDK **17** Temurin installed
- [ ] `JAVA_HOME` points to JDK 17
- [ ] `verify-java.ps1` passes

---

## Phase C — Flutter

- [ ] Flutter **3.27.4** cloned to `C:\src\flutter`
- [ ] `C:\src\flutter\bin` on User PATH
- [ ] `flutter --version` → 3.27.4 / Dart 3.6.2
- [ ] `verify-flutter.ps1` passes
- [ ] `flutter doctor -v` — no critical `[✗]` on Android toolchain

---

## Phase D — Android

- [ ] Android Studio Meerkat (2024.3.1+) installed
- [ ] SDK API **35** + Build-Tools **35.0.0** installed
- [ ] `ANDROID_HOME` set to `%LOCALAPPDATA%\Android\Sdk`
- [ ] `sdkmanager --licenses` accepted
- [ ] `flutter doctor --android-licenses` accepted
- [ ] `verify-android.ps1` passes
- [ ] `android/` generated in repo (`flutter create`)
- [ ] Emulator created (Pixel 7 API 35) and launches
- [ ] Physical device shows in `adb devices` (optional but recommended)

---

## Phase E — Docker & WSL

- [ ] Docker Desktop starts; daemon running
- [ ] WSL Ubuntu starts (`wsl -d Ubuntu`)
- [ ] `verify-docker.ps1` passes
- [ ] `verify-wsl.ps1` passes
- [ ] `docker compose -f docker/docker-compose.dev.yml config` succeeds

---

## Phase F — Repository & GitHub

- [ ] Repo cloned; `origin` → RanaInturi-AICW/glylens
- [ ] `verify-github.ps1` passes
- [ ] Branch protection understood (see DevOps Foundation)
- [ ] Dependabot + CodeQL enabled on repo

---

## Phase G — Quality Gates

- [ ] `flutter pub get` succeeds
- [ ] `dart format` — no changes needed
- [ ] `flutter analyze --fatal-infos` passes *
- [ ] `dart analyze --fatal-infos` passes *
- [ ] `flutter test` passes *
- [ ] `flutter build apk --debug` succeeds
- [ ] `run-quality-gates.ps1` passes

\* *May fail until BP1.1 rework (TD-001 intl, TD-002 auth imports) — track separately*

---

## Phase H — Optional (Prepare Only)

- [ ] Firebase CLI installed
- [ ] FlutterFire CLI activated
- [ ] Firebase project **not** created (per policy)
- [ ] Cursor + Dart/Flutter extensions

---

## Sign-Off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Developer | | | |
| Platform Engineering | | | |

**Environment verdict:** __________________ (see `GlyLens_Environment_Readiness_Report.md`)

---

_When all Phase A–G items pass (including quality gates after BP1.1 rework), workstation is **READY FOR BUILD PROGRAM 2**._
