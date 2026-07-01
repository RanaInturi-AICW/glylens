# GlyLens Master Documentation Index v1.0
_Last Updated: 2026-06-26 (BP2A domain foundation)_

## Purpose

This document is the single entry point for all GlyLens documentation.

All AI agents (Claude, Codex, Cursor) must start here.

---

# Reading Order

1. ADR Repository
2. Architecture Blueprint
3. Food Intelligence Graph
4. Sprint Specification
5. Engineering Constitution
6. Security Rules
7. Prompt Library
8. Execution Plan
9. Repository Manifest
10. Sprint 0 Definition of Done
11. Sprint 1 Gate Decision

---

# Core Principles

- Data > AI
- Evidence > Opinion
- Explainability First
- Cost Optimization First
- Security by Design
- Ingredient-First Intelligence
- Proprietary Platform

---

# Authoritative Documents

## Product

- `docs/product/GlyLens_Sprint0_Specification_v1.md`
- `docs/product/GlyLens_MVP_Success_Metrics_v1.md`
- `docs/product/GlyLens_Developer_Onboarding_Guide_v1.md`

## Architecture

- `docs/architecture/GlyLens_Architecture_Blueprint_v1.md`
- `docs/architecture/GlyLens_Food_Intelligence_Graph_v1_1.md`

## Knowledge Graph

- `docs/architecture/GlyLens_Food_Intelligence_Graph_v1_1.md`

## Decisions

- `docs/adr/GlyLens_ADR_Repository_v1.md`

## Engineering

- `docs/GlyLens_Cursor_Engineering_Constitution_v1_1.md`

## Security

- `docs/GlyLens_Firebase_Security_Rules_Spec_v1.md`

## Governance & Convergence (CANONICAL)

- `docs/GlyLens_Repository_Manifest_v1.md`
- `docs/GlyLens_Repository_Synchronization_Report_v1.md`
- `docs/GlyLens_Canonical_Source_Registry_v1.md`
- `docs/GlyLens_Citation_Registry_v1.md`
- `docs/GlyLens_Corpus_Acquisition_Workflow_v1.md`
- `docs/GlyLens_Acquisition_Backlog_v1.md`
- `docs/GlyLens_Sprint0_Definition_of_Done_v1.md`
- `docs/GlyLens_Implementation_Readiness_Assessment_v1.md`
- `docs/GlyLens_Executive_Gap_Matrix_v1.md`
- `docs/GlyLens_Sprint1_Gate_Decision_v1.md`
- `docs/GlyLens_Repository_Audit_And_Compliance_Report_v1.md`
- `docs/GlyLens_Runtime_Asset_Corrections_v1.md`

## Validation Framework

- `docs/GlyLens_Food_Benchmark_Dataset_Framework_v1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md`

## Infrastructure Schemas

- `docs/GlyLens_Firestore_Physical_Schema_v1.md`
- `docs/GlyLens_Flutter_Module_Blueprint_v1.md`

## Prompts

- `docs/prompts/GlyLens_Cursor_Codex_Prompt_Library_v1.md`
- `docs/prompts/GlyLens_Codex_Ultra_Prompt_v1.md`

## Planning

- `docs/GlyLens_30_Day_Execution_Plan_v1.md`
- `docs/corpus_build_package_v1.md`
- `docs/corpus_gap_analysis_v1.md`
- `docs/GlyLens_Reference_Catalog_v1.md` (**CANONICAL nutritional baseline**)
- `docs/Catalog_Enrichment_Plan_v1.md`
- `docs/Corpus_Completion_Plan_M1.md`
- `docs/Corpus_Population_Package_M1.md` (SUPERSEDED — see Manifest)
- `docs/Nutritional_Completion_Package_M1.md` (ACTIVE acquisition draft — not runtime canonical)
- `docs/Priority_Dataset_Expansion_M1.md`
- `docs/M1_Seed_Dataset_Generation_Plan_v1.md`
- `docs/GlyLens_Sprint0_7_Implementation_Blueprint_v1.md`
- `docs/GlyLens_Sprint0_9_Authoritative_Data_Acquisition_Report_v1.md`
- `docs/GlyLens_Sprint0_Acceptance_Criteria_v1.md`
- `docs/GlyLens_Data_Acquisition_FIG_Seeding_Strategy_v1.md`
- `docs/repository_cleanup_plan.md` (SUPERSEDED — see Manifest)

## Runtime Seed Data

- `docs/seed_data/README.md`
- `docs/seed_data/sources.json`
- `docs/seed_data/citations.json`
- `docs/seed_data/evidence.json`
- `docs/seed_data/ingredients.json`
- `docs/seed_data/products.json`
- `docs/seed_data/foods.json`
- `docs/seed_data/meal_decompositions.json`

## Scripts

- `scripts/convergence_repair.py`
- `scripts/generate_backlog.py`

## Implementation (Build Program 1 — Sprint 1A)

- `docs/GlyLens_Build_Program_1_Flutter_Foundation_README_v1.md` — **ACTIVE**
- `docs/GlyLens_Build_Program_1_Architecture_Validation_v1.md` — **CANONICAL**
- `docs/GlyLens_Build_Program_1_Project_Structure_v1.md` — **CANONICAL**
- `lib/main.dart` — **RUNTIME**
- `lib/app/`, `lib/bootstrap/`, `lib/features/`, `lib/shared/` — **RUNTIME**
- `lib/core/constants|config|errors|logging|cache|analytics|security|networking/` — **RUNTIME**
- `.github/workflows/flutter_ci.yml` — **ACTIVE**

## Build Program 1.1 — Engineering Verification (CANONICAL)

- `docs/GlyLens_Build_Program_1_Engineering_Review_v1.md` — **CANONICAL** — Principal Engineer review; verdict **REWORK REQUIRED**
- `docs/GlyLens_Technical_Debt_Register_v1.md` — **CANONICAL** — 18 debt items (3 Critical)
- `docs/GlyLens_Code_Quality_Report_v1.md` — **CANONICAL** — Build/analyze/test findings
- `docs/GlyLens_Security_Review_v1.md` — **CANONICAL** — Security assessment (71/100)
- `docs/GlyLens_Performance_Baseline_v1.md` — **CANONICAL** — Architectural performance profile

## Build Program 1.2 — Enterprise Developer Platform (CANONICAL)

- `platform/README.md` — **CANONICAL** — Platform entry point
- `platform/GlyLens_Version_Compatibility_Matrix.md` — **CANONICAL SSOT** — Flutter 3.44.4 + AGP 9.0.1 + JDK 17 matrix
- `scripts/platform/glylens-toolchain.matrix.ps1` — programmatic matrix (scripts/CI)
- `platform/GlyLens_Engineering_BOM_v1.md` — Host OS, Docker, tooling (mobile chain defers to matrix)
- `platform/GlyLens_Platform_Contract_v1.md` — **CANONICAL** — Supported stack
- `platform/GlyLens_Developer_Onboarding_Guide_v1.md` — **CANONICAL** — Workstation setup
- `platform/GlyLens_AI_Engineering_Standards_v1.md` — **CANONICAL** — AI tool governance
- `platform/GlyLens_Local_Quality_Gates_v1.md` — **CANONICAL** — Pre-commit policy
- `platform/GlyLens_DevOps_Foundation_v1.md` — **CANONICAL** — CI/CD, semver, branch protection
- `platform/GlyLens_Docker_Strategy_v1.md` — **CANONICAL** — Container policy
- `platform/GlyLens_Platform_Readiness_Assessment_v1.md` — **CANONICAL** — Verdict: **PARTIALLY READY**

## Build Program 1.3 — Windows Workstation Stand-Up (CANONICAL)

- `platform/Machine_Discovery_Report.md` — **CANONICAL** — Live machine audit
- `platform/GlyLens_Version_Compatibility_Matrix.md` — **CANONICAL SSOT** — Flutter 3.44.4 + AGP 9.0.1 + JDK 17
- `platform/GlyLens_Installation_Guide.md` — **CANONICAL** — Manual install steps (no auto-install)
- `platform/GlyLens_Developer_Checklist.md` — **CANONICAL** — Stand-up tick-list
- `platform/GlyLens_Environment_Readiness_Report.md` — **CANONICAL** — Verdict: **READY**
- `scripts/platform/install-prerequisite-check.ps1` — Prerequisites
- `scripts/platform/configure-path.ps1` — PATH/env (confirmed changes)
- `scripts/platform/verify-*.ps1` — Per-component verification
- `scripts/platform/verify-complete-environment.ps1` — Full verification runner
- `scripts/platform/` — Audit, validate, repair, quality-gate PowerShell scripts
- `docker/` — Compose stack (emulator, mock API, corpus tools)
- `.github/dependabot.yml` — Dependency updates
- `.github/workflows/codeql.yml` — Security analysis
- `.github/workflows/release.yml` — Semver releases

## Build Program 1.4 — Release Stabilization RC1 (CANONICAL)

- `platform/GlyLens_Release_Checklist_v1.md` — **CANONICAL** — RC gate checklist
- `platform/GlyLens_Release_Candidate_Report_v1.md` — **CANONICAL** — Verdict: **CONDITIONAL RC**
- `platform/GlyLens_Build_Health_Report_v1.md` — **CANONICAL** — Quality gate results
- `platform/GlyLens_Dependency_Audit_v1.md` — **CANONICAL** — Dependency audit
- `platform/GlyLens_Code_Health_Report_v1.md` — **CANONICAL** — Code/test health
- `android/`, `ios/` — **RUNTIME** — Flutter platform projects (AGP 9.0.1)
- `pubspec.lock` — **ACTIVE** — Locked dependencies

**BP1.4 Verdict:** CODE GREEN — tag `v1.0.0-platform-ready` applied.

## Build Program 2A — Domain Foundation (CANONICAL)

- `packages/shared_core/` — **CANONICAL** — Result, Failure, guards, clock/logger/config abstractions
- `packages/shared_models/` — **CANONICAL** — Immutable FIG models + JSON + validation
- `packages/food_domain/` — **CANONICAL** — Repository interfaces, specifications, domain value objects
- `packages/shared_testing/` — **CANONICAL** — Object mothers, in-memory fakes, benchmark fixtures

**BP2A Verdict:** GREEN — pure Dart; no Flutter/Firebase. Run `dart test` in each package directory.

## Archive and Legacy

- `docs/archive/` contains duplicate versions and deprecated vendor-specific docs.
- Candidate archive files include copied or older versions of architecture, ADR, sprint specs, and the Firebase/Firestore documents.

---

# Governance

Every new document must:

- Have version number
- Have update date
- Reference ADRs where applicable

---

# Future Documents

- App Store Readiness Guide
- API Contracts
- Food Intelligence API Design
- `flutter_app/` application scaffold
- `firebase/` infrastructure scaffold
- `scripts/acquire/` acquisition automation
