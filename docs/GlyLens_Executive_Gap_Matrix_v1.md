# GlyLens Executive Gap Matrix v1

_Last Updated: 2026-06-26_  
_Status: CANONICAL_  
_Owner: Architecture Review Board_

---

| ID | Gap | Severity | Recommended Action | Effort | Blocking Dependencies | Owner |
|----|-----|----------|-------------------|--------|----------------------|-------|
| EG-01 | 72/75 catalog items lack carbs and GL | **CRITICAL** | Execute acquisition workflow for baseline 75 via USDA/IFCT/FAO-WHO | 3–4 weeks | Source access, validation scripts | CDO |
| EG-02 | GI Engine synthesizes values (ADR-0008) | **CRITICAL** | Refactor to measured/published lookup path | 1 week | Evidence + citation linkage | Principal AI Architect |
| EG-03 | No Flutter application | **CRITICAL** | Bootstrap `flutter_app/` per Module Blueprint | 1 week | None | Principal Flutter Architect |
| EG-04 | Seed data not wired to runtime repositories | **CRITICAL** | JSON import into `SeedDataset` or Firestore adapter | 1 week | EG-07 valid JSON ✅ | Principal Solution Architect |
| EG-05 | Nutritional Completion not published to catalog | **HIGH** | Validate draft via workflow Stage 2–6; publish v1.1 | 2 weeks | EG-01 | CDO |
| EG-06 | Collection model doc inconsistency | **HIGH** | Sync Blueprint + Firestore Schema docs to FIG (doc-only) | 2 days | ARB approval | Chief Enterprise Architect |
| EG-07 | `citations.json` / `sources.json` repaired | **RESOLVED** | Maintain via convergence scripts | Done | — | Data Governance |
| EG-08 | 50/50/50 corpus target unmet | **HIGH** | Execute Corpus Completion Plan M1 stages 2–4 | 4–6 weeks | EG-01 | CDO |
| EG-09 | No Firebase infrastructure | **HIGH** | Create `firebase/` rules, indexes, project config | 1 week | EG-03 | Principal Solution Architect |
| EG-10 | API contract incomplete vs FIG | **HIGH** | Extend `FoodIntelligenceResult.toJson()` to FIG contract | 3 days | None | Principal Solution Architect |
| EG-11 | Meal portion modeling absent | **HIGH** | Add serving metadata to meal records per Framework §7 | 1 week | EG-01 ingredient carbs | Knowledge Graph Architect |
| EG-12 | Acquisition automation scripts missing | **HIGH** | Implement `scripts/acquire/` per workflow v1 | 2 weeks | EG-07 | CDO |
| EG-13 | Archive duplicates remain in repo | **MEDIUM** | Remove or relocate `docs/archive/` duplicates | 1 day | Manifest sign-off | CPO |
| EG-14 | Master index was incomplete | **RESOLVED** | Updated 2026-06-26 | Done | — | CPO |
| EG-15 | Benchmark framework unsatisfied | **MEDIUM** | Acquire benchmark items per Framework v1 | 2 weeks | EG-01 | CDO |
| EG-16 | Food entity naming mismatch (Mung Bean vs Moong Dal) | **MEDIUM** | Add alias map in normalization stage | 2 days | EG-12 | Knowledge Graph Architect |
| EG-17 | `foods.json` / decomposition deduplication | **RESOLVED** | Lightweight foods index | Done | — | CDO |
| EG-18 | App Store / API contract docs missing | **LOW** | Create when Sprint 2+ approaches | TBD | EG-03 | CPO |
| EG-19 | PDF artifacts in docs/ unindexed | **LOW** | Index or archive PDFs | 1 day | None | CPO |
| EG-20 | GI Engine unit tests pass but behavior violates policy | **HIGH** | Update tests after EG-02 refactor | 2 days | EG-02 | Principal AI Architect |

---

## Severity Summary

| Severity | Open | Resolved |
|----------|------|----------|
| CRITICAL | 4 | 0 |
| HIGH | 9 | 2 |
| MEDIUM | 3 | 1 |
| LOW | 2 | 0 |

---

## Dependencies

- `docs/GlyLens_Acquisition_Backlog_v1.md`
- `docs/GlyLens_Sprint0_Definition_of_Done_v1.md`
