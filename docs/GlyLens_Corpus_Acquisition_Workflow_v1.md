# GlyLens Corpus Acquisition Workflow v1

_Last Updated: 2026-06-26_  
_Status: CANONICAL_  
_Owner: Chief Data Officer_

## Workflow

```
Acquire
  ↓
Validate
  ↓
Normalize
  ↓
Evidence Assignment
  ↓
Trust Assignment
  ↓
Corpus Publication
  ↓
Runtime Distribution
```

---

## Stage 1 — Acquire

**Entry criteria:** Entity exists in `GlyLens_Acquisition_Backlog_v1.md` with `assignedSource`.

**Activities:**
- Extract raw nutrient and GI data from Canonical Source Registry sources
- Record `retrievalDate` and raw reference metadata
- Store raw extracts under future `data/raw/` (not yet implemented)

**Exit criteria:** Raw values captured with source document reference.

**Quality gate:** Source is Tier 1 or Tier 2 approved; no unapproved sources.

---

## Stage 2 — Validate

**Entry criteria:** Raw acquisition record exists.

**Activities:**
- Validate against `GI_Reference_Catalog_Framework_v1.md` field rules
- Validate GI range 0–100; carbohydrates ≥ 0
- Cross-check against `GlyLens_Food_Benchmark_Dataset_Framework_v1.md` where applicable
- Run `benchmark_validator.dart` rules (when wired)

**Exit criteria:** Validation pass or explicit `REJECTED` with reason.

**Quality gate:** No contradictory evidence without adjudication record.

---

## Stage 3 — Normalize

**Entry criteria:** Validated raw values.

**Activities:**
- Map to canonical field names: `availableCarbohydrates`, `giValue`, `glValue`
- Normalize serving sizes per Framework §7
- Compute `glValue` only when both GI and available carbs are validated: `GL = (GI × availableCarbohydrates) / 100`
- Assign `giStatus`: Measured / Published / Estimated / Unavailable

**Exit criteria:** Normalized record matches GI Reference Catalog Framework templates.

**Quality gate:** No fabricated values; `unavailable` preserved when source does not provide data.

---

## Stage 4 — Evidence Assignment

**Entry criteria:** Normalized record with provenance.

**Activities:**
- Create or update `evidence.json` record
- Link `evidenceLevel` A/B/C/D per ADR-0005
- Link `citationId` per field in `citations.json`

**Exit criteria:** Every populated field has evidence + citation.

**Quality gate:** Evidence level matches source tier policy.

---

## Stage 5 — Trust Assignment

**Entry criteria:** Evidence assigned.

**Activities:**
- Assign `trustScore` per source registry baseline ranges
- Assign `confidence` / `confidenceScore` per Confidence Policy
- Apply `RefusalPolicy` thresholds for low-confidence records

**Exit criteria:** Trust and confidence metadata complete.

**Quality gate:** Trust score within approved range for evidence level.

---

## Stage 6 — Corpus Publication

**Entry criteria:** Entity passes stages 1–5.

**Activities:**
- Publish to `GlyLens_Reference_Catalog_v1.md` successor version (v1.1+)
- Update acquisition backlog status to `READY`
- Regenerate `citations.json` and `evidence.json`

**Exit criteria:** Reference Catalog updated; backlog reflects `READY`.

**Quality gate:** 100% schema compliance per GI Reference Catalog Framework.

---

## Stage 7 — Runtime Distribution

**Entry criteria:** Published catalog record.

**Activities:**
- Export to `docs/seed_data/*.json`
- Import to domain `SeedDataset` / Firestore (future)
- Enable search and intelligence use cases

**Exit criteria:** Runtime repositories serve published values only.

**Quality gate:** JSON valid; import order per `docs/seed_data/README.md`.

---

## Validation Rules (Summary)

| Rule | Enforcement |
|------|-------------|
| Never fabricate GI/GL/carbs | Engineering Constitution; ADR-0008 |
| `unavailable` is valid | Reference Catalog policy |
| GL requires carbs + GI | M1 Seed Plan §1.4 |
| `evidenceLevel` ∈ {A,B,C,D} | GI Framework |
| `sourceId` must exist in Canonical Source Registry | Citation Registry |
| Meal decomposition percentages sum to 100 | M1 Seed Plan §1.4 |
| Below confidence 50 → refuse | FIG Confidence Engine |

## Dependencies

- `docs/GlyLens_Canonical_Source_Registry_v1.md`
- `docs/GlyLens_Citation_Registry_v1.md`
- `docs/GlyLens_Acquisition_Backlog_v1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md`
