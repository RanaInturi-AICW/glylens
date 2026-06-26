# GlyLens Repository Synchronization Report v1

_Last Updated: 2026-06-26_  
_Status: CANONICAL_  
_Owner: Chief Enterprise Architect_

## Canonical Truth Hierarchy

```
Tier 1 — CANONICAL (runtime + governance authority)
├── GlyLens_Reference_Catalog_v1.md          (published nutritional baseline)
├── GlyLens_Canonical_Source_Registry_v1.md
├── GlyLens_Citation_Registry_v1.md
├── GI_Reference_Catalog_Framework_v1.md     (schema)
├── docs/seed_data/*.json                    (runtime import mirrors)
└── ADR / Architecture / FIG                 (approved, frozen)

Tier 2 — ACTIVE (plans, acquisition drafts, not runtime truth)
├── Nutritional_Completion_Package_M1.md     (acquisition draft)
├── GlyLens_Acquisition_Backlog_v1.md
├── Corpus_Completion_Plan_M1.md
└── Priority_Dataset_Expansion_M1.md

Tier 3 — SUPERSEDED (historical; do not use for implementation)
├── Corpus_Population_Package_M1.md          → absorbed into Reference Catalog
├── corpus_build_package_v1.md §6, §8        → superseded by canonical registries
└── repository_cleanup_plan.md               → superseded by this convergence
```

---

## Conflict Register

### CONF-001 — Basmati Rice `availableCarbohydrates`

| Field | Location | Value |
|-------|----------|-------|
| Reference Catalog | `GlyLens_Reference_Catalog_v1.md` ingr-001 | `unavailable` |
| Nutritional Completion | `Nutritional_Completion_Package_M1.md` §1.1 | `44.4 g` |
| Seed JSON | `ingredients.json` (no Basmati row) | N/A |

**Canonical value:** `unavailable` (Reference Catalog)  
**Reason:** Catalog is the published runtime baseline. Nutritional Completion is an ACTIVE acquisition draft pending workflow validation (Stages 2–6).  
**Downstream affected:** `citations.json` cite for ingr-001 `availableCarbohydrates` = PENDING_ACQUISITION; acquisition backlog ACQ task for ingr-001.

---

### CONF-002 — Brown Rice / Rolled Oats / Chickpea carbs and GL

Same pattern as CONF-001 for ingr-002, ingr-003, ingr-005 and Top 10 ingredients in Nutritional Completion Package.

**Canonical value:** Reference Catalog `unavailable` for carbs/GL  
**Reason:** Draft acquisition values not yet published.  
**Downstream:** 122 PENDING_ACQUISITION citations; backlog status PENDING_VALIDATION.

---

### CONF-003 — Whole Wheat Flour `giValue`

| Location | Value |
|----------|-------|
| Reference Catalog ingr-004 | `unavailable` |
| Nutritional Completion §1.4 | carbs `72.0 g`; GL `unavailable` (documented reason) |

**Canonical:** `giValue: unavailable`  
**Reason:** Catalog explicitly marks GI unavailable; Nutritional Completion does not assert GI.

---

### CONF-004 — Catalog Enrichment vs Sprint 0.9 missing carb counts

| Document | Missing carbs count |
|----------|---------------------|
| Catalog_Enrichment_Plan_v1.md | 73 of 75 |
| Sprint 0.9 Report | 72 of 75 |
| Repository Audit | 72 of 75 |

**Canonical:** **72 of 75** (Egg, Grilled Salmon, StarKist Tuna Pouch complete)  
**Reason:** Verified by pattern match on Reference Catalog file.  
**Downstream:** Catalog_Enrichment_Plan §1.1 should reference 72 (documentation note only).

---

### CONF-005 — `foods.json` vs `meal_decompositions.json` duplication

| Before | After convergence |
|--------|-------------------|
| Identical full decomposition in both files | `meal_decompositions.json` = canonical detail; `foods.json` = lightweight index with `mealDecompositionId` |

**Canonical:** Split model per `docs/seed_data/README.md`  
**Downstream:** `foods.csv` schema updated; M1 Seed Plan foods schema annotation recommended.

---

### CONF-006 — Source ID schemes

| Location | IDs |
|----------|-----|
| Legacy sources.json | `src-001`–`src-004` |
| Canonical Registry | `src-usda-fdc`, `src-ifct`, etc. |

**Canonical:** `GlyLens_Canonical_Source_Registry_v1.md` IDs  
**Resolution:** `sources.json` rewritten. Legacy IDs **ARCHIVED**.

---

### CONF-007 — Field naming: `giValue` vs `GI`

| Layer | Convention |
|-------|--------------|
| Reference Catalog / Framework | `giValue`, `glValue`, `availableCarbohydrates` |
| Seed JSON (Wave 1) | `GI`, `GL`, `availableCarbohydrates` |

**Canonical:** Framework names for published catalog; seed JSON names preserved for Wave 1 import with **normalize-stage mapping** documented in `GlyLens_Runtime_Asset_Corrections_v1.md`.  
**Not a value conflict** — naming only.

---

### CONF-008 — Firestore collections vs FIG

| Collection | FIG | Architecture Blueprint | Firestore Physical Schema |
|------------|-----|------------------------|---------------------------|
| nutrition_profiles | Yes | No | No |
| glycemic_profiles | Yes | No | No |
| evidence | Yes | No | No |

**Canonical:** FIG v1.1 (approved)  
**Resolution:** Blueprint and Firestore Schema marked **ACTIVE** with sync note — implementation must follow FIG. Doc update tracked in EG-06; **no architecture redesign**.

---

### CONF-009 — Chicken Biryani ingredient percentages

| Location | Rice % |
|----------|--------|
| FIG example | 65% |
| Sprint 0.7 Blueprint | basmati rice 60% (in JSON sample 60%) |
| meal_decompositions.json | 60% |
| M1 Seed Plan Part 3 | 60% |

**Canonical:** **60%** in seed/meal records (repository evidence)  
**Note:** FIG example is illustrative; meal seed is canonical for Wave 1.

---

### CONF-010 — Egg completeness

| Document | States Egg complete |
|----------|---------------------|
| Corpus Completion Plan | Only Egg + StarKist complete |
| Sprint 0.9 | Egg, Grilled Salmon, StarKist |

**Canonical:** Egg has `availableCarbohydrates: 0` in catalog — **complete for numeric fields** (0 is valid).

---

## Synchronization Actions Taken

| Action | Artifact |
|--------|----------|
| Repaired sources.json | `docs/seed_data/sources.json` |
| Created citations.json | 225 records from catalog |
| Created evidence.json | 15 seed records |
| Deduplicated foods/meals | `foods.json`, `meal_decompositions.json` |
| Regenerated CSV from JSON | `ingredients.csv`, `foods.csv`, `products.csv` |
| Added entityId/sourceId to seed JSON | All Wave 1 seed files |
| Published canonical registries | Source, Citation, Workflow, Backlog |
| Marked superseded documents | See Manifest |
| Did NOT merge Nutritional Completion into catalog | Preserves no-fabrication policy |

---

## Section 8 — Repository Consistency Audit

### Field Names

| Approved (FIG/Framework) | Domain Dart | Seed JSON | Consistent |
|--------------------------|-------------|-----------|------------|
| ingredient_id (doc example) | ingredientId | entityId / canonicalName | Map at import |
| giValue | GIValue.value | GI | Normalize |
| glycemic_profile_id | glycemicProfileId | glycemicProfileId (foods) | Partial |

### Entity References

| Relationship | Status |
|--------------|--------|
| Product → ingredients | Documented in FIG; not in seed products |
| Food → mealDecompositionId | ✅ Wired in foods.json |
| Meal → ingredient names | Names only; no ingredientId FK — **GAP EG-16** |
| Citation → sourceId | ✅ citations.json |
| Evidence → entityId | ✅ evidence.json |

### Identifiers

| Namespace | Pattern | Authority |
|-----------|---------|-----------|
| Catalog | ingr-NNN, food-NNN, prod-NNN | Reference Catalog |
| Wave 1 | wave1-{type}-{slug} | Priority Dataset Expansion |
| Meals | meal-NNN | seed_data |
| Sources | src-{slug} | Canonical Source Registry |
| Citations | cite-NNNN | Citation Registry |

### Inconsistencies Flagged (Not Auto-Fixed)

1. `gi_engine.dart` behavior vs ADR-0008 — **implementation fix required**
2. `SeedDataset` IDs (`ing_basmati_rice`) vs catalog IDs (`ingr-001`) — **mapper required**
3. Moong Dal (meals) vs Mung Bean (catalog) — **alias map required**
4. Firestore schema missing FIG collections — **doc sync EG-06**

---

## Dependencies

- `docs/GlyLens_Repository_Manifest_v1.md`
- `docs/GlyLens_Runtime_Asset_Corrections_v1.md`
- `docs/GlyLens_Repository_Audit_And_Compliance_Report_v1.md`
