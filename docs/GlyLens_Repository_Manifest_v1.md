# GlyLens Repository Manifest v1

_Last Updated: 2026-06-26 (BP2A domain foundation)_  
_Status: CANONICAL_  
_Owner: Chief Enterprise Architect_

Single inventory of every repository artifact. **One source of truth per concern** — see Status column.

**Status legend:** CANONICAL | ACTIVE | SUPERSEDED | ARCHIVED | GENERATED | RUNTIME

---

## 1. Governance & Convergence (CANONICAL)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `docs/GlyLens_Master_Documentation_Index_v1.md` | Documentation entry point | CPO | All docs | CANONICAL |
| `docs/GlyLens_Repository_Manifest_v1.md` | This manifest | Chief Architect | — | CANONICAL |
| `docs/GlyLens_Repository_Synchronization_Report_v1.md` | Conflict resolution log | Chief Architect | Manifest | CANONICAL |
| `docs/GlyLens_Canonical_Source_Registry_v1.md` | Authoritative source list | Data Governance | ADR-0005, ADR-0008 | CANONICAL |
| `docs/GlyLens_Citation_Registry_v1.md` | Field-level provenance | Data Governance | Source Registry | CANONICAL |
| `docs/GlyLens_Corpus_Acquisition_Workflow_v1.md` | Acquire→Publish workflow | CDO | Registries | CANONICAL |
| `docs/GlyLens_Acquisition_Backlog_v1.md` | Per-entity acquisition tasks | CDO | Reference Catalog | CANONICAL |
| `docs/GlyLens_Sprint0_Definition_of_Done_v1.md` | Sprint 0 completion criteria | PRB | All sections | CANONICAL |
| `docs/GlyLens_Implementation_Readiness_Assessment_v1.md` | Readiness by capability | ARB | DoD | CANONICAL |
| `docs/GlyLens_Executive_Gap_Matrix_v1.md` | Prioritized gaps | ARB | Audit, Sync Report | CANONICAL |
| `docs/GlyLens_Sprint1_Gate_Decision_v1.md` | Sprint 1 GO/NO-GO | PRB | DoD, Backlog | CANONICAL |
| `docs/GlyLens_Repository_Audit_And_Compliance_Report_v1.md` | Pre-convergence audit | ARB | — | CANONICAL |
| `docs/GlyLens_Runtime_Asset_Corrections_v1.md` | Seed JSON repair log | Solution Architect | seed_data | CANONICAL |

---

## 2. Approved Architecture (CANONICAL — Frozen)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `docs/adr/GlyLens_ADR_Repository_v1.md` | ADR-0001–0011 | ARB | — | CANONICAL |
| `docs/architecture/GlyLens_Architecture_Blueprint_v1.md` | System architecture | Chief Architect | ADRs | CANONICAL |
| `docs/architecture/GlyLens_Food_Intelligence_Graph_v1_1.md` | Entity model, FIG | KG Architect | ADRs | CANONICAL |
| `docs/GI_Reference_Catalog_Framework_v1.md` | GI/GL schema framework | CDO | FIG | CANONICAL |
| `docs/GlyLens_Food_Benchmark_Dataset_Framework_v1.md` | Validation benchmark set | CDO | FIG | CANONICAL |
| `docs/GlyLens_Firestore_Physical_Schema_v1.md` | Firestore layout | Solution Architect | FIG | CANONICAL |
| `docs/GlyLens_Flutter_Module_Blueprint_v1.md` | Flutter module structure | Flutter Architect | Architecture | CANONICAL |
| `docs/GlyLens_Firebase_Security_Rules_Spec_v1.md` | Security rules spec | Security | ADR-0004 | CANONICAL |
| `docs/GlyLens_Cursor_Engineering_Constitution_v1_1.md` | Engineering rules | Flutter Architect | ADRs, FIG | CANONICAL |

---

## 3. Product & Sprint (CANONICAL / ACTIVE)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `docs/product/GlyLens_Sprint0_Specification_v1.md` | Sprint 0 scope | CPO | ADRs, FIG | CANONICAL |
| `docs/GlyLens_Sprint0_Acceptance_Criteria_v1.md` | Sprint 0 acceptance | CPO | Sprint 0 spec | CANONICAL |
| `docs/product/GlyLens_MVP_Success_Metrics_v1.md` | MVP metrics | CPO | — | CANONICAL |
| `docs/product/GlyLens_Developer_Onboarding_Guide_v1.md` | Developer onboarding | CPO | Master Index | CANONICAL |
| `docs/GlyLens_30_Day_Execution_Plan_v1.md` | Execution timeline | CPO | Sprint specs | ACTIVE |
| `docs/GlyLens_Sprint0_7_Implementation_Blueprint_v1.md` | Sprint 0.7 plan | CPO | Corpus docs | ACTIVE |
| `docs/GlyLens_Sprint0_9_Authoritative_Data_Acquisition_Report_v1.md` | Acquisition assessment | CDO | Reference Catalog | CANONICAL |

---

## 4. Corpus & Data (CANONICAL / ACTIVE / SUPERSEDED)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `docs/GlyLens_Reference_Catalog_v1.md` | **Published nutritional baseline** (75 entities) | CDO | GI Framework | **CANONICAL** |
| `docs/Nutritional_Completion_Package_M1.md` | Top-10 acquisition **draft** | CDO | Reference Catalog | ACTIVE (not runtime) |
| `docs/Corpus_Completion_Plan_M1.md` | M1 completion roadmap | CDO | Reference Catalog | ACTIVE |
| `docs/Corpus_Population_Package_M1.md` | Top-10 snapshot (June 2026) | CDO | Reference Catalog | **SUPERSEDED** by Reference Catalog |
| `docs/Priority_Dataset_Expansion_M1.md` | Wave 1 expansion list | CDO | Gap analysis | ACTIVE |
| `docs/corpus_gap_analysis_v1.md` | Gap analysis | CDO | Corpus build | ACTIVE |
| `docs/Catalog_Enrichment_Plan_v1.md` | Enrichment to 50/50/50 | CDO | Reference Catalog | ACTIVE |
| `docs/corpus_build_package_v1.md` | Sprint 0.5 corpus plan | CDO | FIG | ACTIVE (§6,§8 superseded by registries) |
| `docs/M1_Seed_Dataset_Generation_Plan_v1.md` | Seed schema & Wave 1 | CDO | Reference Catalog | CANONICAL |
| `docs/GlyLens_Data_Acquisition_FIG_Seeding_Strategy_v1.md` | Seeding strategy | CDO | FIG | ACTIVE |

---

## 5. Runtime Seed Data (RUNTIME / GENERATED)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `docs/seed_data/README.md` | Import order & roles | CDO | M1 Seed Plan | CANONICAL |
| `docs/seed_data/sources.json` | Source registry runtime | Data Governance | Canonical Source Registry | RUNTIME |
| `docs/seed_data/citations.json` | Citation records (225) | Data Governance | Reference Catalog | GENERATED |
| `docs/seed_data/evidence.json` | Evidence records (15) | Data Governance | corpus_build §8 | GENERATED |
| `docs/seed_data/ingredients.json` | Wave 1 ingredients (6) | CDO | sources.json | RUNTIME |
| `docs/seed_data/products.json` | Wave 1 products (5) | CDO | sources.json | RUNTIME |
| `docs/seed_data/foods.json` | Food index (3) | CDO | meal_decompositions | RUNTIME |
| `docs/seed_data/meal_decompositions.json` | Meal detail (3) | KG Architect | ingredients | RUNTIME |
| `docs/seed_data/ingredients.csv` | Human-readable mirror | CDO | ingredients.json | GENERATED |
| `docs/seed_data/products.csv` | Human-readable mirror | CDO | products.json | GENERATED |
| `docs/seed_data/foods.csv` | Human-readable mirror | CDO | foods.json | GENERATED |

---

## 6. Implementation — Domain & Platform (RUNTIME)

| Filename | Purpose | Owner | Status |
|----------|---------|-------|--------|
| `lib/main.dart` | Flutter entry | Flutter Architect | RUNTIME |
| `lib/app/**` | App, router, shell, theme | Flutter Architect | RUNTIME |
| `lib/bootstrap/**` | Init, DI providers | Solution Architect | RUNTIME |
| `lib/core/platform layers` | config, errors, cache, security, analytics | Solution Architect | RUNTIME |
| `lib/core/domain/**` | Food Intelligence Engine (Sprint 0) | AI Architect | RUNTIME |
| `lib/features/**` | Feature modules (BP1 shells + auth) | Flutter Architect | RUNTIME |
| `.github/workflows/flutter_ci.yml` | CI/CD | DevOps | ACTIVE |
| `docs/GlyLens_Build_Program_1_*` | BP1 docs | Flutter Architect | CANONICAL |

---

## 6b. Build Program 1.1 — Verification (CANONICAL)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `docs/GlyLens_Build_Program_1_Engineering_Review_v1.md` | Principal Engineer production readiness review | Principal Engineer | BP1 implementation | **CANONICAL** |
| `docs/GlyLens_Technical_Debt_Register_v1.md` | Prioritized engineering debt (18 items) | Principal Engineer | Engineering Review | **CANONICAL** |
| `docs/GlyLens_Code_Quality_Report_v1.md` | Build, analyze, test, dependency findings | Principal Engineer | CI, pubspec | **CANONICAL** |
| `docs/GlyLens_Security_Review_v1.md` | Security assessment (score 71/100) | Principal Engineer | Security Rules Spec | **CANONICAL** |
| `docs/GlyLens_Performance_Baseline_v1.md` | Cold-start and navigation baseline | Principal Engineer | BP1 bootstrap | **CANONICAL** |

**BP1.1 Verdict:** REWORK REQUIRED — CI red; auth import defects; platform tests absent. Tag `v1.0.0-platform-foundation` not authorized.

---

## 6c. Build Program 1.2 — Enterprise Platform (CANONICAL)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `platform/README.md` | Platform entry point | Platform Engineering | — | **CANONICAL** |
| `platform/GlyLens_Engineering_BOM_v1.md` | Tool versions (EBOM) | Platform Engineering | — | **CANONICAL** |
| `platform/GlyLens_Platform_Contract_v1.md` | Supported stack | Platform Engineering | EBOM | **CANONICAL** |
| `platform/GlyLens_Developer_Onboarding_Guide_v1.md` | Workstation setup | DevEx | EBOM, Contract | **CANONICAL** |
| `platform/GlyLens_AI_Engineering_Standards_v1.md` | AI governance | Platform Engineering | Master Index | **CANONICAL** |
| `platform/GlyLens_Local_Quality_Gates_v1.md` | Pre-commit policy | Platform Engineering | CI | **CANONICAL** |
| `platform/GlyLens_DevOps_Foundation_v1.md` | CI/CD, semver | DevOps | — | **CANONICAL** |
| `platform/GlyLens_Docker_Strategy_v1.md` | Container policy | DevOps | — | **CANONICAL** |
| `platform/GlyLens_Platform_Readiness_Assessment_v1.md` | Readiness verdict | Platform Engineering | All BP1.2 | **CANONICAL** |
| `scripts/platform/*.ps1` | Audit, validate, repair, gates | DevOps | EBOM | **ACTIVE** |
| `docker/docker-compose.dev.yml` | Dev infrastructure | DevOps | Docker Strategy | **ACTIVE** |
| `docker/firebase-emulator/` | Auth emulator image | DevOps | — | **ACTIVE** |
| `docker/mock-api/` | Stub API | DevOps | — | **ACTIVE** |
| `docker/python-utils/` | Python runner | DevOps | scripts/ | **ACTIVE** |
| `docker/corpus-validator/` | Seed JSON validator | CDO | seed_data | **ACTIVE** |
| `.github/dependabot.yml` | Dependency updates | DevOps | — | **ACTIVE** |
| `.github/workflows/codeql.yml` | Security scanning | DevOps | — | **ACTIVE** |
| `.github/workflows/release.yml` | Semver releases | DevOps | — | **ACTIVE** |
| `.gitignore` | Git exclusions | DevOps | — | **ACTIVE** |

**BP1.2 Verdict:** PARTIALLY READY — platform docs and automation complete; Flutter not installed locally; BP1.1 compile blockers remain.

---

## 6d. Build Program 1.3 — Windows Workstation Stand-Up (CANONICAL)

| Filename | Purpose | Owner | Status |
|----------|---------|-------|--------|
| `platform/Machine_Discovery_Report.md` | Live workstation audit | Platform Engineering | **CANONICAL** |
| `platform/GlyLens_Version_Compatibility_Matrix.md` | Toolchain compatibility matrix | Build Engineer | **CANONICAL** |
| `platform/GlyLens_Installation_Guide.md` | Manual install order + rollback | DevEx | **CANONICAL** |
| `platform/GlyLens_Developer_Checklist.md` | Stand-up tick-list | DevEx | **CANONICAL** |
| `platform/GlyLens_Environment_Readiness_Report.md` | Final NOT READY decision | Platform Engineering | **CANONICAL** |
| `scripts/platform/install-prerequisite-check.ps1` | OS/RAM/disk prerequisites | DevOps | **ACTIVE** |
| `scripts/platform/configure-path.ps1` | PATH/env with confirmation | DevOps | **ACTIVE** |
| `scripts/platform/verify-*.ps1` | Component verification (7 scripts) | DevOps | **ACTIVE** |
| `scripts/platform/verify-complete-environment.ps1` | Full environment runner | DevOps | **ACTIVE** |

**BP1.3 Verdict:** READY — Flutter 3.44.4, JDK 17, Android SDK 36, PS7 quality gates operational.

---

## 6e. Build Program 1.4 — Release Stabilization RC1 (CANONICAL)

| Filename | Purpose | Owner | Status |
|----------|---------|-------|--------|
| `platform/GlyLens_Release_Checklist_v1.md` | RC1 release gate checklist | Release Engineering | **CANONICAL** |
| `platform/GlyLens_Release_Candidate_Report_v1.md` | RC1 verdict and release notes | Release Engineering | **CANONICAL** |
| `platform/GlyLens_Build_Health_Report_v1.md` | Quality gate results | Release Engineering | **CANONICAL** |
| `platform/GlyLens_Dependency_Audit_v1.md` | pubspec/lock audit | Release Engineering | **CANONICAL** |
| `platform/GlyLens_Code_Health_Report_v1.md` | Analyzer and test health | Release Engineering | **CANONICAL** |
| `android/`, `ios/` | Flutter platform folders | Flutter Architect | **RUNTIME** |
| `pubspec.lock` | Locked dependency graph | DevOps | **ACTIVE** |

**BP1.4 Verdict:** CONDITIONAL RC — code gates GREEN; tag `v1.0.0-platform-ready` applied.

---

## 6f. Build Program 2A — Domain Foundation (CANONICAL)

| Filename | Purpose | Owner | Status |
|----------|---------|-------|--------|
| `packages/shared_core/` | Result, Failure, Entity/VO bases, guards, abstractions | Domain Architect | **CANONICAL** |
| `packages/shared_models/` | Immutable FIG models (Ingredient, Food, Product, …) | Domain Architect | **CANONICAL** |
| `packages/food_domain/` | Repository contracts, specifications, domain VOs | Domain Architect | **CANONICAL** |
| `packages/shared_testing/` | Mothers, fakes, fixtures, matchers | Test Engineering | **CANONICAL** |

**BP2A Verdict:** GREEN — pure Dart packages; no Flutter/Firebase; `dart analyze` + `dart test` pass per package. Recommend tag `v1.1.0-domain-foundation`.

---

## 7. Scripts (ACTIVE)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `scripts/convergence_repair.py` | Repair seed JSON | Solution Architect | seed_data | ACTIVE |
| `scripts/generate_backlog.py` | Generate backlog + CSV | CDO | Reference Catalog | ACTIVE |

---

## 8. Prompts & Planning (ACTIVE)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `docs/prompts/GlyLens_Cursor_Codex_Prompt_Library_v1.md` | Cursor prompts | CPO | Constitution | ACTIVE |
| `docs/prompts/GlyLens_Codex_Ultra_Prompt_v1.md` | Codex prompts | CPO | — | ACTIVE |
| `docs/GlyLens_Codex_Kickoff_Package_v1.md` | Codex kickoff | CPO | — | ACTIVE |
| `docs/GlyLens_Codex_Feasibility_Assessment_v1.md` | Feasibility | CPO | — | ACTIVE |
| `docs/GlyLens_First_Codex_Execution_Workflow_v1.md` | Codex workflow | CPO | — | ACTIVE |
| `docs/repository_cleanup_plan.md` | Pre-convergence cleanup | CPO | — | **SUPERSEDED** by convergence |

---

## 9. Root & Meta (ACTIVE)

| Filename | Purpose | Owner | Dependencies | Status |
|----------|---------|-------|--------------|--------|
| `README.md` | Project readme | CPO | — | ACTIVE |
| `REPOSITORY_STRUCTURE.md` | Structure index | Chief Architect | Manifest | CANONICAL |
| `DOMAIN_LAYER_STRUCTURE.md` | Domain layer map | Solution Architect | lib/core | ACTIVE |
| `docs/GlyLens_README_v1.md` | Docs readme | CPO | Master Index | ACTIVE |
| `docs/GlyLens_Repository_Structure_v1.md` | Planned structure | Chief Architect | — | ACTIVE |
| `glylens_folders.txt` | Folder listing | — | — | GENERATED |

---

## 10. Archive (ARCHIVED)

| Filename | Purpose | Status |
|----------|---------|--------|
| `docs/archive/GlyLens_ADR_Repository_v1.md` | Legacy ADR copy | ARCHIVED |
| `docs/archive/GlyLens_Architecture_Blueprint_v1.md` | Legacy blueprint | ARCHIVED |
| `docs/archive/GlyLens_Food_Intelligence_Graph_v1_1.md` | Legacy FIG | ARCHIVED |
| `docs/archive/GlyLens_Sprint0_Specification_v1.md` | Legacy sprint spec | ARCHIVED |
| `docs/archive/GlyLens_Cursor_Engineering_Constitution_v1_1.md` | Legacy constitution | ARCHIVED |
| `docs/archive/README.md` | Archive policy | ARCHIVED |

---

## Duplicate Artifacts

| Duplicate | Canonical Replacement |
|-----------|----------------------|
| `docs/archive/*` (5 docs) | `docs/adr/`, `docs/architecture/`, `docs/product/`, `docs/GlyLens_Cursor_Engineering_Constitution_v1_1.md` |
| `corpus_build_package_v1.md` §6 Source Registry | `GlyLens_Canonical_Source_Registry_v1.md` |
| `corpus_build_package_v1.md` §8 Evidence seed prose | `docs/seed_data/evidence.json` |
| Legacy `src-001`–`src-004` | `src-usda-fdc`, etc. |
| `Corpus_Population_Package_M1.md` top-10 snapshot | `GlyLens_Reference_Catalog_v1.md` |
| Pre-convergence `foods.json` full decomposition | `meal_decompositions.json` + lightweight `foods.json` |

---

## Obsolete Artifacts

| Artifact | Reason |
|----------|--------|
| `docs/repository_cleanup_plan.md` | Superseded by convergence deliverables |
| `Corpus_Population_Package_M1.md` as runtime source | Absorbed into Reference Catalog |
| Archive copies | Superseded by canonical paths |

---

## Orphan Artifacts

| Artifact | Issue | Action |
|----------|-------|--------|
| `docs/Sprint 0 Resolution Proposal.pdf` | Not indexed, not markdown | Index as ARCHIVED reference or relocate |
| `docs/Sprint 0 Technical Design Package.pdf` | Not indexed | Index as ARCHIVED reference |
| `docs/readme.md` | Duplicate lowercase readme | Orphan; use `GlyLens_README_v1.md` |
| `lib/core/data/seed_dataset.dart` | Disconnected from `docs/seed_data/` | Wire in Sprint 1 prep (EG-04) |

---

## Missing Artifacts (Future)

| Expected | Status |
|----------|--------|
| App Store Readiness Guide | Not created |
| API Contracts | Not created |
| Food Intelligence API Design | Not created |
| `flutter_app/` | Implemented as root Flutter app (`lib/main.dart`) | Build Program 1 |
| `firebase/` | Not created |
| `data/raw/` acquisition storage | Not created |

---

_End of Manifest_
