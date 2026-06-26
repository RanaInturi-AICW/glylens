# Repository Structure

_Last Updated: 2026-06-26 (BP1.1 verification)_

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

- `.github/workflows/flutter_ci.yml`

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
