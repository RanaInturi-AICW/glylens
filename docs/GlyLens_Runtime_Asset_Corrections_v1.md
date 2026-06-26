# GlyLens Runtime Asset Corrections Report v1

_Last Updated: 2026-06-26_  
_Owner: Principal Solution Architect_  
_Script: `scripts/convergence_repair.py`, `scripts/generate_backlog.py`_

## Summary

All `docs/seed_data/*.json` files validated successfully after convergence repair.

---

## Corrections Applied

### 1. `sources.json`

| Issue | Correction |
|-------|------------|
| Invalid JSON (control character in IFCT description, line 18) | Rewrote file with valid UTF-8 |
| Only 4 sources (`src-001`–`src-004`) | Replaced with 11 canonical `sourceId` values per `GlyLens_Canonical_Source_Registry_v1.md` |
| Missing fields: tier, license, updateFrequency, acquisitionMethod | Added all required governance fields |
| Duplicate/legacy IDs | Removed `src-001`–`src-004`; superseded by canonical IDs |

### 2. `citations.json` (CREATED)

| Action | Detail |
|--------|--------|
| Created | 225 citation records (75 entities × 3 fields) |
| Source | Parsed from `GlyLens_Reference_Catalog_v1.md` |
| VALIDATED | 103 citations (fields with numeric or non-unavailable values) |
| PENDING_ACQUISITION | 122 citations (fields marked `unavailable`) |

### 3. `evidence.json` (CREATED)

| Action | Detail |
|--------|--------|
| Created | 15 evidence records from `corpus_build_package_v1.md` §8 |
| Linked | `entityId` resolved to Reference Catalog IDs where name match exists |
| validationStatus | `VALIDATED` when entityId resolved; otherwise `PENDING_VALIDATION` |

### 4. `ingredients.json`

| Issue | Correction |
|-------|------------|
| Missing `entityId` | Added (`ingr-002`, `ingr-003`, `ingr-005`, `wave1-ing-*`) |
| Free-text `source` only | Added `sourceId` and `sourceStatus` (`EXPECTED` / `ASSIGNED`) |

### 5. `foods.json`

| Issue | Correction |
|-------|------------|
| Duplicated full meal decomposition payloads (identical to `meal_decompositions.json`) | Replaced with lightweight food index records |
| Missing `foodId` | Added `wave1-food-*` identifiers |
| Missing decomposition link | Added `mealDecompositionId` foreign key |

### 6. `meal_decompositions.json`

| Issue | Correction |
|-------|------------|
| Missing `mealId`, `foodId` | Added `meal-001`–`meal-003` and `wave1-food-*` |
| Missing `sourceId` | Added `src-ifct` with `sourceStatus: EXPECTED` |

### 7. `products.json`

| Issue | Correction |
|-------|------------|
| Missing `entityId` | Added `wave1-prod-*` identifiers |
| Missing `sourceId` | Added `src-manufacturer-label` |

### 8. CSV Templates

| File | Correction |
|------|------------|
| `ingredients.csv` | Regenerated from JSON; added `entityId`, `sourceId`, `sourceStatus` columns |
| `foods.csv` | Regenerated to match lightweight `foods.json` schema |
| `products.csv` | Regenerated; added `entityId`, `sourceId`, `sourceStatus` columns |

### 9. `docs/seed_data/README.md` (CREATED)

Documents canonical import order and file roles.

---

## Schema Consistency Notes

| Layer | Naming Convention | Status |
|-------|-------------------|--------|
| Reference Catalog | `giValue`, `glValue`, `availableCarbohydrates` | CANONICAL for published corpus |
| Seed JSON (Wave 1) | `GI`, `GL`, `availableCarbohydrates` | ACTIVE for import; map at normalize stage |
| Domain Dart | `giValue`, `glValue` via value objects | RUNTIME |
| FIG examples | `snake_case` JSON examples | DOCUMENTATION only |

Mappers (`lib/core/infrastructure/mappers/mapper_abstractions.dart`) remain skeleton — field mapping is documented, not yet implemented.

---

## Not Corrected (By Design)

- No nutritional values invented or updated in Reference Catalog
- `Nutritional_Completion_Package_M1.md` values not merged into catalog (pending workflow Stage 6 publish)
- `lib/core/data/seed_dataset.dart` not modified (runtime code out of scope for data repair)

---

## Validation Command

```bash
python scripts/convergence_repair.py
```

Expected output: `VALID:` for all seven JSON files.
