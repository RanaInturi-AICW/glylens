# GlyLens Platform Engineering

Official enterprise development platform for GlyLens (Build Program 1.2 + 1.3 + 1.4).

## Build Program 1.4 — Release Candidate

| Document | Purpose |
|----------|---------|
| [Release Checklist](GlyLens_Release_Checklist_v1.md) | RC1 gate checklist |
| [Release Candidate Report](GlyLens_Release_Candidate_Report_v1.md) | **CONDITIONAL RC** verdict |
| [Build Health Report](GlyLens_Build_Health_Report_v1.md) | Quality gate results |
| [Dependency Audit](GlyLens_Dependency_Audit_v1.md) | pubspec.lock audit |
| [Code Health Report](GlyLens_Code_Health_Report_v1.md) | Analyzer + test health |

## Start Here

| Document | Purpose |
|----------|---------|
| [Developer Onboarding](GlyLens_Developer_Onboarding_Guide_v1.md) | BP1.2 — Platform overview |
| **[Installation Guide](GlyLens_Installation_Guide.md)** | **BP1.3 — Step-by-step workstation install** |
| [Developer Checklist](GlyLens_Developer_Checklist.md) | Tick-list for stand-up |
| [Machine Discovery Report](Machine_Discovery_Report.md) | Live audit of this machine |
| [Environment Readiness](GlyLens_Environment_Readiness_Report.md) | **READY** — workstation verified |
| [Version Compatibility Matrix](GlyLens_Version_Compatibility_Matrix.md) | Official toolchain matrix |
| [Engineering BOM](GlyLens_Engineering_BOM_v1.md) | Exact tool versions |
| [Platform Contract](GlyLens_Platform_Contract_v1.md) | Supported stack & policies |

## Scripts (BP1.3)

```powershell
.\scripts\platform\install-prerequisite-check.ps1
.\scripts\platform\configure-path.ps1 -RepairAll          # confirms each change
.\scripts\platform\verify-complete-environment.ps1
```

| Script | Purpose |
|--------|---------|
| `install-prerequisite-check.ps1` | RAM, disk, OS prerequisites |
| `configure-path.ps1` | PATH + JAVA_HOME + ANDROID_HOME (with confirmation) |
| `verify-flutter.ps1` | Flutter 3.27.x + doctor |
| `verify-java.ps1` | JDK 17 + JAVA_HOME |
| `verify-android.ps1` | SDK, adb, API 36+ |
| `verify-docker.ps1` | Docker daemon + compose |
| `verify-wsl.ps1` | WSL2 + Ubuntu |
| `verify-github.ps1` | gh auth + repo push access |
| `verify-complete-environment.ps1` | Runs all checks |

## Docker

See [`../docker/README.md`](../docker/README.md).

## Governance

- [AI Engineering Standards](GlyLens_AI_Engineering_Standards_v1.md)
- [Local Quality Gates](GlyLens_Local_Quality_Gates_v1.md)
- [DevOps Foundation](GlyLens_DevOps_Foundation_v1.md)
- [Docker Strategy](GlyLens_Docker_Strategy_v1.md)
