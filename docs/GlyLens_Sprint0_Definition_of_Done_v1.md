# GlyLens Sprint 0 Definition of Done v1

_Last Updated: 2026-06-26_  
_Status: CANONICAL_  
_Owner: Product Review Board_

A Sprint 0 item is **COMPLETE** only when **every** criterion in its section is satisfied.

---

## 1. Architecture

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| A1 | ADR Repository v1 exists and is approved | ✅ COMPLETE | `docs/adr/GlyLens_ADR_Repository_v1.md` |
| A2 | Architecture Blueprint v1 exists and is approved | ✅ COMPLETE | `docs/architecture/GlyLens_Architecture_Blueprint_v1.md` |
| A3 | Food Intelligence Graph v1.1 exists and is approved | ✅ COMPLETE | `docs/architecture/GlyLens_Food_Intelligence_Graph_v1_1.md` |
| A4 | Firestore Physical Schema v1 documented | ✅ COMPLETE | `docs/GlyLens_Firestore_Physical_Schema_v1.md` |
| A5 | Flutter Module Blueprint v1 documented | ✅ COMPLETE | `docs/GlyLens_Flutter_Module_Blueprint_v1.md` |
| A6 | Domain layer implements approved entity model | ✅ COMPLETE | `lib/core/domain/entities/` |
| A7 | Repository interfaces defined (vendor-neutral) | ✅ COMPLETE | `lib/core/domain/repositories/` |
| A8 | Collection model aligned across Blueprint, FIG, Firestore Schema | ❌ INCOMPLETE | `nutrition_profiles`, `evidence`, `glycemic_profiles` collections inconsistent |
| A9 | Flutter application scaffold exists | ❌ INCOMPLETE | No `main.dart`, no `flutter_app/` |
| A10 | Firebase infrastructure scaffold exists | ❌ INCOMPLETE | No `firebase/` directory |

**Architecture Section: INCOMPLETE (6/10)**

---

## 2. Corpus

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| C1 | Reference Catalog v1 published (baseline) | ✅ COMPLETE | 75 entities |
| C2 | 50/50/50 catalog target met | ❌ INCOMPLETE | 25/25/25 only |
| C3 | 100% `availableCarbohydrates` populated | ❌ INCOMPLETE | 72/75 unavailable |
| C4 | 100% `glValue` populated or documented unavailable | ❌ INCOMPLETE | 72/75 unavailable |
| C5 | Wave 1 seed JSON valid and import-ordered | ✅ COMPLETE | Post-convergence repair |
| C6 | Benchmark framework items satisfied | ❌ INCOMPLETE | Most benchmarks lack numeric GL |
| C7 | Meal decomposition for Biryani, Dosa, Pongal | ✅ COMPLETE | `meal_decompositions.json` |
| C8 | Nutritional values single canonical source | ✅ COMPLETE | Reference Catalog is canonical; conflicts documented |

**Corpus Section: INCOMPLETE (4/8)**

---

## 3. Governance

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| G1 | Canonical Source Registry published | ✅ COMPLETE | `GlyLens_Canonical_Source_Registry_v1.md` + `sources.json` |
| G2 | Citation Registry published | ✅ COMPLETE | `GlyLens_Citation_Registry_v1.md` + `citations.json` |
| G3 | Evidence registry materialized | ✅ COMPLETE | `evidence.json` (15 seed records) |
| G4 | Acquisition workflow documented | ✅ COMPLETE | `GlyLens_Corpus_Acquisition_Workflow_v1.md` |
| G5 | Acquisition backlog for all entities | ✅ COMPLETE | `GlyLens_Acquisition_Backlog_v1.md` (92 entities) |
| G6 | Repository manifest published | ✅ COMPLETE | `GlyLens_Repository_Manifest_v1.md` |
| G7 | No ACTIVE duplicate sources of truth | ✅ COMPLETE | Superseded docs marked; archive identified |
| G8 | All seed JSON parses without error | ✅ COMPLETE | Convergence repair validation |

**Governance Section: COMPLETE (8/8)**

---

## 4. Data

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| D1 | Authoritative GI values from approved sources only | ⚠️ PARTIAL | Catalog has GI for 34/75; Wave 1 mostly unavailable |
| D2 | No fabricated nutritional values in canonical catalog | ✅ COMPLETE | `unavailable` used consistently |
| D3 | Acquisition pipeline operational (scripts) | ❌ INCOMPLETE | Workflow documented; acquisition scripts not built |
| D4 | Nutritional Completion Package published to catalog | ❌ INCOMPLETE | Draft exists; not published via workflow |
| D5 | ≥75% entities READY in backlog | ❌ INCOMPLETE | 3.3% READY (3/92) |
| D6 | Coke Zero / Pepsi Zero demo-ready | ✅ COMPLETE | Seed products with numeric 0 values |

**Data Section: INCOMPLETE (2/6)**

---

## 5. Repository

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| R1 | Master Documentation Index current | ✅ COMPLETE | Updated 2026-06-26 |
| R2 | REPOSITORY_STRUCTURE.md current | ✅ COMPLETE | Updated 2026-06-26 |
| R3 | Synchronization report published | ✅ COMPLETE | `GlyLens_Repository_Synchronization_Report_v1.md` |
| R4 | Audit report published | ✅ COMPLETE | `GlyLens_Repository_Audit_And_Compliance_Report_v1.md` |
| R5 | Archive duplicates identified | ✅ COMPLETE | Manifest + archive README |
| R6 | Convergence deliverables complete | ✅ COMPLETE | Deliverables 1–12 |

**Repository Section: COMPLETE (6/6)**

---

## 6. Implementation Readiness

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| I1 | GI Engine implements lookup (not synthesis) | ❌ INCOMPLETE | `gi_engine.dart` synthesizes from weights |
| I2 | GL Engine formula correct | ✅ COMPLETE | `gl_engine.dart` |
| I3 | Confidence / Evidence / Explainability engines exist | ✅ COMPLETE | `lib/core/data/engines/` |
| I4 | Refusal policy implemented | ✅ COMPLETE | `refusal_policy.dart` |
| I5 | Unit tests exist | ✅ COMPLETE | 10 test files |
| I6 | Use cases for search and intelligence | ✅ COMPLETE | `lookup_food_use_case.dart`, `get_food_intelligence_use_case.dart` |
| I7 | Fake repositories wired to authoritative seed | ❌ INCOMPLETE | `SeedDataset` has 1 food; not connected to `docs/seed_data/` |
| I8 | API contract JSON matches FIG contract | ❌ INCOMPLETE | Missing `impact_score`, `explanations` in output |

**Implementation Readiness Section: INCOMPLETE (5/8)**

---

## Sprint 0 Overall Verdict

| Section | Complete | Total | % |
|---------|----------|-------|---|
| Architecture | 6 | 10 | 60% |
| Corpus | 4 | 8 | 50% |
| Governance | 8 | 8 | 100% |
| Data | 2 | 6 | 33% |
| Repository | 6 | 6 | 100% |
| Implementation | 5 | 8 | 63% |
| **Overall** | **31** | **46** | **67%** |

**Sprint 0 is NOT COMPLETE.** Governance and repository convergence criteria are satisfied. Architecture implementation, corpus completeness, data acquisition, and runtime wiring remain open.

---

## Mandatory Before Sprint 1

1. Close GI Engine lookup vs. synthesis gap (ADR-0008)
2. Wire `docs/seed_data/` into domain repositories or Firestore import path
3. Publish top-priority acquisition batch via Corpus Acquisition Workflow
4. Bootstrap Flutter application scaffold
5. Align Firestore collection list across FIG, Blueprint, and Physical Schema (documentation sync only — no redesign)
