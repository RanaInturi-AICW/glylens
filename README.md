# GlyLens

**Food Intelligence for Better Decisions**

Enterprise Flutter platform + Food Intelligence Engine (domain layer).

## Build Program 1.4 — Release Stabilization (RC1)

**Status: CODE GREEN** — analyzer 0 issues, 83/83 tests pass.  
**Local APK:** blocked by JDK SSL (Gradle wrapper PKIX) — see [Release Candidate Report](platform/GlyLens_Release_Candidate_Report_v1.md).

| Report | Link |
|--------|------|
| Release Checklist | [GlyLens_Release_Checklist_v1.md](platform/GlyLens_Release_Checklist_v1.md) |
| Build Health | [GlyLens_Build_Health_Report_v1.md](platform/GlyLens_Build_Health_Report_v1.md) |
| Dependency Audit | [GlyLens_Dependency_Audit_v1.md](platform/GlyLens_Dependency_Audit_v1.md) |
| Code Health | [GlyLens_Code_Health_Report_v1.md](platform/GlyLens_Code_Health_Report_v1.md) |
| RC Verdict | [GlyLens_Release_Candidate_Report_v1.md](platform/GlyLens_Release_Candidate_Report_v1.md) |

**Target tag:** `v1.0.0-platform-ready` (after CI APK green).

## Build Program 1.3 — Workstation Stand-Up

**Status: READY** — see [Environment Readiness Report](platform/GlyLens_Environment_Readiness_Report.md)

```powershell
.\scripts\platform\install-prerequisite-check.ps1
# Follow platform/GlyLens_Installation_Guide.md
.\scripts\platform\verify-complete-environment.ps1
```

| Matrix | Flutter 3.44.4 · Dart 3.12.2 · JDK 17 · AGP 9.0.1 · API 36 |
|--------|-------------------------------------------------------------|
| Guide | [Installation Guide](platform/GlyLens_Installation_Guide.md) |
| Checklist | [Developer Checklist](platform/GlyLens_Developer_Checklist.md) |

## Build Program 1.2 — Enterprise Developer Platform

Official engineering platform for Windows 11 Professional + WSL2 + Docker + native Flutter.

### New developer? Start here

1. [Platform Onboarding Guide](platform/GlyLens_Developer_Onboarding_Guide_v1.md)
2. [Master Documentation Index](docs/GlyLens_Master_Documentation_Index_v1.md)

### Environment setup (PowerShell)

```powershell
.\scripts\platform\audit-environment.ps1
.\scripts\platform\repair-environment.ps1 -RepairPath -RepairEnvVars
.\scripts\platform\validate-environment.ps1
```

### Quality gates (required before commit)

```powershell
.\scripts\platform\run-quality-gates.ps1
```

### Docker (supporting services only)

```powershell
cd docker
Copy-Item .env.example .env
docker compose -f docker-compose.dev.yml up -d firebase-emulator
```

See [platform/README.md](platform/README.md) and [docker/README.md](docker/README.md).

---

## Build Program 1 — Flutter Platform Foundation

Sprint 1A delivers the production Flutter scaffold: Riverpod, GoRouter, Firebase Auth, Hive offline cache, Material 3 themes, localization framework, and feature shells.

### Quick start (after environment setup)

```bash
flutter create . --org com.glylens --project-name glylens --platforms android,ios
flutter pub get
flutter run --dart-define=ENV=development
```

See [Build Program 1 README](docs/GlyLens_Build_Program_1_Flutter_Foundation_README_v1.md).

## Documentation

Start at [docs/GlyLens_Master_Documentation_Index_v1.md](docs/GlyLens_Master_Documentation_Index_v1.md).

## Project layout

```
lib/
  app/              # App shell, router, theme
  bootstrap/        # Init, providers, Firebase
  core/             # Platform + Food Intelligence Engine
  features/         # Feature modules (auth, home, search, …)
  shared/           # Themes, widgets
  main.dart
platform/           # BOM, contract, onboarding, DevOps docs
docker/             # Emulator, mock API, corpus tools
scripts/platform/   # Audit, validate, repair, quality gates
```

## Tests & CI

```bash
flutter test
```

| Workflow | Purpose |
|----------|---------|
| `.github/workflows/flutter_ci.yml` | Format, analyze, test, build |
| `.github/workflows/codeql.yml` | Security analysis |
| `.github/workflows/release.yml` | Tag releases |

## Scope

| Included (BP1) | Deferred |
|----------------|----------|
| Flutter foundation | Food Intelligence UI |
| Firebase Auth | Firestore |
| Offline cache (Hive) | Barcode / camera |
| Navigation shells | Search logic |
| Developer platform (BP1.2) | Firebase project (not yet created) |

## Toolchain (pinned)

| Tool | Version |
|------|---------|
| Flutter | 3.44.4 |
| Dart | 3.12.2 |
| Java | 17 |

Full matrix: [Version Compatibility Matrix](platform/GlyLens_Version_Compatibility_Matrix.md).
