# Repository Structure

_Last Updated: 2026-06-26 (BP1.3 workstation)_

This document shows the current project folders and source files. See `docs/GlyLens_Repository_Manifest_v1.md` for authoritative artifact inventory and status.

## Root

- `README.md`
- `pubspec.yaml`
- `DOMAIN_LAYER_STRUCTURE.md`
- `REPOSITORY_STRUCTURE.md` (this file)
- `glylens_folders.txt`

## Scripts

- `scripts/convergence_repair.py` — Repair and validate seed JSON
- `scripts/generate_backlog.py` — Generate acquisition backlog and sync CSV
- `scripts/platform/` — BP1.2 audit/validate/repair + **BP1.3 verify/install scripts**

## Flutter Application (`lib/`)

### Platform (Build Program 1 — RUNTIME)

- `lib/main.dart` — Entry point
- `lib/app/` — `GlyLensApp`, GoRouter, shell, theme
- `lib/bootstrap/` — Firebase init, Riverpod providers, global errors
- `lib/core/constants/`, `config/`, `errors/`, `logging/`, `cache/`, `analytics/`, `security/`, `networking/`
- `lib/features/` — auth, splash, onboarding, home, search, scan, history, compare, premium, settings, legal, developer
- `lib/shared/themes/`, `lib/shared/widgets/`
- `lib/l10n/` — Localization (English)

### Food Intelligence Engine (Sprint 0 — RUNTIME)

- `lib/core/application/use_cases/` — lookup, intelligence, compare
- `lib/core/benchmark/`, `lib/core/data/`, `lib/core/domain/`, `lib/core/infrastructure/`, `lib/core/policy/`

## Tests

- `test/core/`, `test/widget/`, `test/golden/` — Platform tests
- `test/application/`, `test/domain/`, etc. — Intelligence engine tests
- `integration_test/` — Integration harness

## CI/CD

- `.github/workflows/flutter_ci.yml` — Flutter CI (pinned 3.27.4)
- `.github/workflows/codeql.yml` — CodeQL security
- `.github/workflows/release.yml` — Release on semver tags
- `.github/dependabot.yml` — Weekly dependency PRs

## Platform (Build Program 1.2)

- `platform/README.md` — Platform entry point
- `platform/GlyLens_Engineering_BOM_v1.md` — Engineering Bill of Materials
- `platform/GlyLens_Platform_Contract_v1.md` — Supported stack contract
- `platform/GlyLens_Developer_Onboarding_Guide_v1.md` — Developer setup guide
- `platform/GlyLens_AI_Engineering_Standards_v1.md` — AI tool standards
- `platform/GlyLens_Local_Quality_Gates_v1.md` — Pre-commit quality policy
- `platform/GlyLens_DevOps_Foundation_v1.md` — DevOps hardening
- `platform/GlyLens_Docker_Strategy_v1.md` — Docker usage policy
- `platform/GlyLens_Platform_Readiness_Assessment_v1.md` — BP1.2 readiness verdict

## Platform (Build Program 1.3 — Workstation Stand-Up)

- `platform/Machine_Discovery_Report.md` — Live machine audit
- `platform/GlyLens_Version_Compatibility_Matrix.md` — Official toolchain matrix
- `platform/GlyLens_Installation_Guide.md` — Install order + rollback
- `platform/GlyLens_Developer_Checklist.md` — Developer tick-list
- `platform/GlyLens_Environment_Readiness_Report.md` — NOT READY verdict
- `scripts/platform/install-prerequisite-check.ps1`
- `scripts/platform/configure-path.ps1`
- `scripts/platform/verify-flutter.ps1`, `verify-java.ps1`, `verify-android.ps1`
- `scripts/platform/verify-docker.ps1`, `verify-wsl.ps1`, `verify-github.ps1`
- `scripts/platform/verify-complete-environment.ps1`

## Docker (`docker/`)

- `docker-compose.dev.yml` — Dev infrastructure stack
- `docker/firebase-emulator/` — Firebase Auth emulator (prepare only)
- `docker/mock-api/` — Stub REST API for BP2
- `docker/python-utils/` — Corpus script runner
- `docker/corpus-validator/` — Seed JSON validation
- `docker/README.md`

## Platform folders

- `android/`, `ios/` — Created via `flutter create` (first run or CI)

## Documentation (`docs/`)

### Governance & Convergence (CANONICAL)

- `GlyLens_Master_Documentation_Index_v1.md`
- `GlyLens_Repository_Manifest_v1.md`
- `GlyLens_Repository_Synchronization_Report_v1.md`
- `GlyLens_Canonical_Source_Registry_v1.md`
- `GlyLens_Citation_Registry_v1.md`
- `GlyLens_Corpus_Acquisition_Workflow_v1.md`
- `GlyLens_Acquisition_Backlog_v1.md`
- `GlyLens_Sprint0_Definition_of_Done_v1.md`
- `GlyLens_Implementation_Readiness_Assessment_v1.md`
- `GlyLens_Executive_Gap_Matrix_v1.md`
- `GlyLens_Sprint1_Gate_Decision_v1.md`
- `GlyLens_Repository_Audit_And_Compliance_Report_v1.md`
- `GlyLens_Runtime_Asset_Corrections_v1.md`

### ADR, Architecture, Product, Prompts

- `docs/adr/` — ADR Repository
- `docs/architecture/` — Blueprint, FIG
- `docs/product/` — Sprint 0 spec, MVP metrics, onboarding
- `docs/prompts/` — Cursor/Codex prompt libraries

### Corpus & Data

- `GlyLens_Reference_Catalog_v1.md` — **CANONICAL nutritional baseline**
- `GI_Reference_Catalog_Framework_v1.md`
- `GlyLens_Food_Benchmark_Dataset_Framework_v1.md`
- `M1_Seed_Dataset_Generation_Plan_v1.md`
- `Corpus_Completion_Plan_M1.md`
- `Priority_Dataset_Expansion_M1.md`
- `Nutritional_Completion_Package_M1.md` (ACTIVE acquisition draft)
- `Corpus_Population_Package_M1.md` (SUPERSEDED)

### Runtime Seed Data (`docs/seed_data/`)

- `README.md` — Import order
- `sources.json`, `citations.json`, `evidence.json`
- `ingredients.json`, `products.json`, `foods.json`, `meal_decompositions.json`
- `*.csv` — Generated mirrors (JSON is canonical)

### Archive

- `docs/archive/` — Superseded document copies (do not use)

## Not Yet Present (Future)

- `firebase/` (Firestore rules — Build Program 3+)
- `scripts/acquire/` (data acquisition automation)

## Implementation (Build Program 1)

- `docs/GlyLens_Build_Program_1_Flutter_Foundation_README_v1.md`
- `docs/GlyLens_Build_Program_1_Architecture_Validation_v1.md`
- `docs/GlyLens_Build_Program_1_Project_Structure_v1.md`

## Build Program 1.1 — Engineering Verification

- `docs/GlyLens_Build_Program_1_Engineering_Review_v1.md` — Production readiness review (REWORK REQUIRED)
- `docs/GlyLens_Technical_Debt_Register_v1.md` — Prioritized technical debt (18 items)
- `docs/GlyLens_Code_Quality_Report_v1.md` — CI/build/analyzer findings
- `docs/GlyLens_Security_Review_v1.md` — Security assessment
- `docs/GlyLens_Performance_Baseline_v1.md` — Cold-start and navigation baseline
