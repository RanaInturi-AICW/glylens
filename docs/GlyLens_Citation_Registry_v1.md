# GlyLens Citation Registry v1

_Last Updated: 2026-06-26_  
_Status: CANONICAL_  
_Owner: Chief Data Governance Officer_  
_Runtime mirror: `docs/seed_data/citations.json` (225 citation records for 75 Reference Catalog entities × 3 fields)_

## Purpose

Every future and existing nutritional value must be traceable to a source through a citation record.

## Schema

| Field | Description |
|-------|-------------|
| `citationId` | Unique citation identifier (`cite-0001` …) |
| `entityId` | Reference Catalog entity ID (`ingr-001`, `food-001`, `prod-001`, or `wave1-*`) |
| `fieldName` | `giValue`, `glValue`, or `availableCarbohydrates` |
| `sourceId` | Foreign key to `GlyLens_Canonical_Source_Registry_v1.md` |
| `retrievalDate` | ISO date when value entered catalog; `null` if not yet acquired |
| `validationStatus` | `VALIDATED`, `PENDING_ACQUISITION`, `PENDING_VALIDATION`, `REJECTED` |
| `evidenceLevel` | A / B / C / D |
| `confidence` | Confidence range string from catalog |

## Registry Summary (Reference Catalog v1)

| validationStatus | Count |
|------------------|-------|
| VALIDATED | 103 |
| PENDING_ACQUISITION | 122 |

**VALIDATED** citations correspond to fields with non-`unavailable` values in `GlyLens_Reference_Catalog_v1.md`.  
**PENDING_ACQUISITION** citations correspond to `unavailable` fields.

## Wave 1 Seed Citations

Wave 1 seed entities (`wave1-*`) receive citations upon inclusion in Reference Catalog v1.1 publish. Until then, provenance is tracked in:

- `docs/seed_data/ingredients.json` (`sourceId`, `sourceStatus`)
- `docs/seed_data/products.json` (`sourceId`, `sourceStatus`)
- `docs/seed_data/meal_decompositions.json` (`sourceId`, `sourceStatus`)

## Governance Rules

1. No nutritional value may be published without a `citationId`.
2. `sourceId` must exist in Canonical Source Registry.
3. Calculated GL citations must reference both GI and carbohydrate source citations.
4. Import pipeline must load citations before entity records.

## Dependencies

- `docs/GlyLens_Canonical_Source_Registry_v1.md`
- `docs/GlyLens_Reference_Catalog_v1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md` §4
