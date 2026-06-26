# GlyLens Sprint 1 Gate Decision v1

_Last Updated: 2026-06-26_  
_Status: CANONICAL_  
_Owner: Product Review Board + Architecture Review Board_

## Question

Can GlyLens proceed to **SPRINT 1 — SEARCH EXPERIENCE**?

## Decision

# NO-GO

---

## Justification (Repository Evidence)

### 1. Data Readiness Blocker

- `GlyLens_Reference_Catalog_v1.md`: **72 of 75** entities lack `availableCarbohydrates` and `glValue`.
- Only **3 of 92** backlog entities are `READY` (3.3%) per `GlyLens_Acquisition_Backlog_v1.md`.
- `GlyLens_Sprint0_9_Authoritative_Data_Acquisition_Report_v1.md` Part 7: **No-Go** for authoritative Sprint 1.
- Search Experience displaying glycemic intelligence without authoritative carbs/GL violates ADR-0008 and Engineering Constitution.

### 2. Implementation Blocker

- No Flutter application (`main.dart` absent; `pubspec.yaml` domain-only).
- `SeedDataset` contains **1 food**; Reference Catalog has **25 foods** not loaded.
- Search use case exists but has no product-facing layer and no authoritative corpus behind it.

### 3. Engine Policy Blocker

- `lib/core/data/engines/gi_engine.dart` synthesizes GI from evidence weights — not approved lookup behavior per ADR-0008 and FIG non-negotiables.
- Sprint 1 Search would surface non-authoritative computed values.

### 4. Sprint 0 Definition of Done

- Overall Sprint 0 completion: **67%** (31/46 criteria) per `GlyLens_Sprint0_Definition_of_Done_v1.md`.
- Governance and repository convergence: **COMPLETE**.
- Architecture, corpus, data, implementation: **INCOMPLETE**.

### 5. What Convergence Did Achieve

- Single canonical source registry, citation registry, acquisition workflow, and backlog.
- Valid runtime JSON assets and deduplicated seed structure.
- Documented conflicts with canonical resolutions.
- Repository ready for **implementation to begin** — not for **Sprint 1 feature release**.

---

## Mandatory Blockers (Must Close Before Sprint 1 GO)

| # | Blocker | Owner |
|---|---------|-------|
| B1 | Publish authoritative carbs + GL for minimum viable search corpus (recommend: baseline 75 + Wave 1 via acquisition workflow) | CDO |
| B2 | Refactor GI Engine to lookup-only (no synthesis) | Principal AI Architect |
| B3 | Wire `docs/seed_data/` or Firestore into food/product repositories | Principal Solution Architect |
| B4 | Bootstrap Flutter app with search screen consuming `LookupFoodUseCase` | Principal Flutter Architect |
| B5 | Implement refusal UX for `unavailable` and low-confidence records | CPO + Flutter Architect |

---

## Conditional Prototype Path (Not Sprint 1 GO)

Per Sprint 0.9, a **labeled prototype** may proceed only if:

- Scope limited to Coke Zero and Pepsi Zero (numeric-ready seed products)
- All other queries return refusal / "data pending" state
- Not marketed as authoritative nutrition

This is **not** a Sprint 1 GO for Search Experience.

---

## Implementation Sequence (Execute After Blockers Close)

When B1–B5 are satisfied and ARB re-issues GO:

1. **Week 1 — Runtime corpus**
   - Run acquisition workflow for top 25 search-priority foods (Idli, Dosa, Chapati, Oats Porridge, etc.)
   - Import JSON → domain repositories
   - Validate citations for all displayed fields

2. **Week 1 — Engine hardening**
   - GI lookup path only
   - Wire `RefusalPolicy` into `GetFoodIntelligenceUseCase`
   - Align API JSON to FIG contract

3. **Week 2 — Flutter Search**
   - Create `flutter_app/` per Module Blueprint
   - Search input → `LookupFoodUseCase` → results list
   - Detail view: GI, GL, confidence, evidence, sources (or refusal reason)

4. **Week 2 — Firebase read layer**
   - Deploy Firestore read-only collections for ingredients, foods, products
   - Security rules per `GlyLens_Firebase_Security_Rules_Spec_v1.md`

5. **Week 3 — QA gate**
   - Benchmark validator against `GlyLens_Food_Benchmark_Dataset_Framework_v1.md`
   - Re-run Definition of Done checklist
   - ARB Sprint 1 GO review

---

## Sign-off Required for Future GO

- Chief Data Officer (corpus)
- Chief Data Governance Officer (citations)
- Principal AI Architect (engine policy)
- Principal Flutter Architect (search UI)
- Product Review Board

---

_End of Gate Decision_
