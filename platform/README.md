# GlyLens Platform Engineering

Official enterprise development platform for GlyLens (Build Program 1.2).

## Start Here

| Document | Purpose |
|----------|---------|
| [Developer Onboarding](GlyLens_Developer_Onboarding_Guide_v1.md) | **New developer setup from scratch** |
| [Engineering BOM](GlyLens_Engineering_BOM_v1.md) | Exact tool versions |
| [Platform Contract](GlyLens_Platform_Contract_v1.md) | Supported stack & policies |
| [Platform Readiness](GlyLens_Platform_Readiness_Assessment_v1.md) | Current READY / NOT READY status |

## Scripts

```powershell
.\scripts\platform\audit-environment.ps1
.\scripts\platform\validate-environment.ps1
.\scripts\platform\repair-environment.ps1 -RepairPath -RepairEnvVars
.\scripts\platform\run-quality-gates.ps1
```

## Docker

See [`../docker/README.md`](../docker/README.md).

## Governance

- [AI Engineering Standards](GlyLens_AI_Engineering_Standards_v1.md)
- [Local Quality Gates](GlyLens_Local_Quality_Gates_v1.md)
- [DevOps Foundation](GlyLens_DevOps_Foundation_v1.md)
- [Docker Strategy](GlyLens_Docker_Strategy_v1.md)
