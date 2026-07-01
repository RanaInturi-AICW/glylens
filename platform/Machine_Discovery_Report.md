# GlyLens Machine Discovery Report

_Generated: 2026-06-26_  
_Build Program: 1.3 — Enterprise Windows Development Platform_  
_Machine: Primary GlyLens workstation_  
_Method: Live audit via Platform Engineering scripts_

---

## Executive Summary

This workstation has a **solid foundation** (Windows 11 Pro 25H2, 16 GB RAM, WSL2, Docker Desktop, Git, GitHub CLI, partial ADB) but is **not ready for Flutter development**. Flutter, Android Studio, and a complete Android SDK are missing. Java 21 is installed without `JAVA_HOME` and is the wrong target for the recommended GlyLens matrix (JDK **17**). Docker Desktop is installed but the daemon is **not running**. PowerShell **7** (`pwsh`) is not installed.

**Verdict:** NOT READY — see `GlyLens_Environment_Readiness_Report.md`

---

## 1. Hardware

| Attribute | Detected Value | Assessment |
|-----------|----------------|------------|
| **CPU** | 11th Gen Intel Core i5-1155G7 @ 2.50GHz (4C/8T) | ✅ Meets minimum |
| **RAM** | 16 GB (16,134 MB reported) | ✅ Meets minimum (32 GB recommended) |
| **Architecture** | x64 | ✅ |
| **Disk (C:)** | ~178 GB used / ~44 GB free | ⚠️ Adequate; monitor free space during Android SDK + emulator |
| **Virtualization** | VBS status: 2 (running) | ✅ |
| **Hyper-V** | Present (Windows 11 Pro) | ✅ Required for emulator/WSL2 |

---

## 2. Operating System

| Attribute | User-Stated | **Detected** | Notes |
|-----------|-------------|--------------|-------|
| Edition | Windows 11 Home | **Windows 11 Pro** (25H2) | Registry: `Windows 10 Pro` display on build 26200 |
| Build | — | **26200** | Exceeds EBOM minimum 26100 |
| Version | — | 10.0.26200.8655 | Current insider/stable channel build |

---

## 3. Shell & Scripting

| Tool | Status | Version | Notes |
|------|--------|---------|-------|
| Windows PowerShell | ✅ Installed | **5.1.26100.8655** | Default shell |
| PowerShell 7 (`pwsh`) | ❌ **Missing** | — | Required for BP1.2 scripts; install via winget |
| Windows Terminal | Not audited | — | Recommended |

---

## 4. WSL2

| Component | Status | Version |
|-----------|--------|---------|
| WSL | ✅ Installed | **2.6.3.0** |
| Kernel | ✅ | **6.6.87.2-1** |
| Default distro | Ubuntu | Version **2** (WSL2) |
| Ubuntu state | ⚠️ Stopped | Must start for Docker integration |
| Ubuntu release | ⚠️ **26.04 LTS** (Resolute) | EBOM recommends 24.04; 26.04 acceptable for Docker |

```text
wsl -l -v
  Ubuntu            Stopped    2
  docker-desktop    Stopped    2
```

---

## 5. Docker Desktop

| Component | Status | Version |
|-----------|--------|---------|
| Docker CLI | ✅ Installed | **29.4.2** |
| Docker Compose | ✅ Installed | **v5.1.3** |
| Docker daemon | ❌ **Not running** | `dockerDesktopLinuxEngine` pipe missing |
| WSL backend | ⚠️ Stopped distros | Start Docker Desktop + Ubuntu |

---

## 6. Source Control & GitHub

| Tool | Status | Version |
|------|--------|---------|
| Git | ✅ Installed | **2.54.0.windows.1** |
| Git LFS | ✅ Installed | **3.7.1** |
| GitHub CLI | ✅ Installed | **2.92.0** |
| GitHub Auth | ✅ Active | **RanaInturi-AICW** (push: true) |
| Secondary account | Inactive | pratapblr |
| Repository remote | ✅ Correct | `https://github.com/RanaInturi-AICW/glylens.git` |
| Repo permissions | ✅ Admin | push, maintain, admin |

SSH keys: not audited in this pass (HTTPS + gh credential helper in use).

---

## 7. Java

| Attribute | Status | Value |
|-----------|--------|-------|
| `java` on PATH | ✅ | **Oracle JDK 21.0.1** |
| `JAVA_HOME` | ❌ **Not set** | — |
| PATH entries | ⚠️ | `C:\Program Files\Java\jdk-21\bin`, Oracle javapath |
| GlyLens target | ❌ Mismatch | Matrix requires **JDK 17** (Temurin) |

---

## 8. Android Toolchain

| Component | Status | Notes |
|-----------|--------|-------|
| Android Studio | ❌ **Not installed** | — |
| Android SDK (`%LOCALAPPDATA%\Android\Sdk`) | ❌ **Not present** | — |
| `ANDROID_HOME` | ❌ **Not set** | — |
| ADB (standalone) | ⚠️ Partial | `C:\Android\adb.exe` v1.0.32 only |
| Android Emulator | ❌ Not installed | — |
| Physical device | ❌ None connected | `adb devices` empty |
| Gradle wrapper | ❌ N/A | `android/` not generated in repo |

---

## 9. Flutter & Dart

| Tool | Status |
|------|--------|
| Flutter | ❌ **Not on PATH** |
| Dart | ❌ **Not on PATH** |
| `flutter doctor` | ❌ Cannot run |

---

## 10. Firebase Tooling

| Tool | Status | Notes |
|------|--------|-------|
| Firebase project | ❌ Not created | Per project policy |
| Firebase CLI | ❌ Not installed | — |
| FlutterFire CLI | ❌ Not installed | Requires Dart |

---

## 11. IDEs

| IDE | Status | Version |
|-----|--------|---------|
| VS Code | ✅ Installed | **1.126.0** |
| Cursor | ✅ Installed | **3.9.8** |
| Android Studio | ❌ Not installed | Required for SDK + emulator |

---

## 12. Repository State

| Item | Value |
|------|-------|
| Path | `D:\Rana\AI Crafft Works\Git\RanaSalvo-Git\glylens` |
| Branch | `main` (tracking `origin/main`) |
| Uncommitted | BP1.2 platform doc edits |
| `pubspec.yaml` | `intl: ^0.19.0` — **blocks pub get** on current Flutter stable (TD-001) |
| `android/` folder | Not committed |

---

## 13. PATH & Environment Summary

| Variable | Set? | Value |
|----------|------|-------|
| `JAVA_HOME` | ❌ | — |
| `ANDROID_HOME` | ❌ | — |
| `ANDROID_SDK_ROOT` | ❌ | — |
| Flutter bin | ❌ | — |

PATH includes: `C:\Android`, `C:\Program Files\Java\jdk-21\bin`

---

## 14. Gap Summary

| Priority | Gap |
|----------|-----|
| P0 | Install Flutter 3.27.4 stable |
| P0 | Install Android Studio + SDK API 35 |
| P0 | Install JDK 17; set `JAVA_HOME` |
| P0 | Install PowerShell 7 |
| P1 | Start Docker Desktop; verify daemon |
| P1 | Start WSL Ubuntu |
| P1 | Run `flutter create` + commit `android/` |
| P1 | Resolve `intl` pubspec conflict (BP1.1 TD-001) |
| P2 | Install Firebase CLI (prepare only) |
| P2 | Configure Android emulator + physical device USB debugging |

---

_Re-run discovery: `.\scripts\platform\install-prerequisite-check.ps1` and `.\scripts\platform\verify-complete-environment.ps1`_
