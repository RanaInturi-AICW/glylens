# GlyLens Seed Data — Canonical Runtime Import Package

_Last Updated: 2026-06-26_  
_Status: RUNTIME (Wave 1 subset)_

## Canonical Import Order

1. `sources.json`
2. `citations.json`
3. `evidence.json`
4. `ingredients.json`
5. `products.json`
6. `foods.json`
7. `meal_decompositions.json`

## File Roles

| File | Purpose | Canonical For |
|------|---------|---------------|
| `sources.json` | Source registry runtime mirror | Source lineage (`sourceId`) |
| `citations.json` | Field-level provenance for Reference Catalog entities | Citation traceability |
| `evidence.json` | Evidence records linking entities to sources | Evidence assignment |
| `ingredients.json` | Wave 1 ingredient seed records | Ingredient import |
| `products.json` | Wave 1 product seed records | Product import |
| `foods.json` | Food entity index (lightweight) | Food entity references |
| `meal_decompositions.json` | Meal composition detail | Meal intelligence decomposition |

## Schema Authority

- Catalog field naming for published corpus: `docs/GI_Reference_Catalog_Framework_v1.md`
- Published catalog baseline: `docs/GlyLens_Reference_Catalog_v1.md`
- Governance registries: `docs/GlyLens_Canonical_Source_Registry_v1.md`, `docs/GlyLens_Citation_Registry_v1.md`

## Notes

- `foods.json` does **not** duplicate meal decomposition payloads; use `mealDecompositionId` to resolve detail in `meal_decompositions.json`.
- CSV files mirror JSON for human review; **JSON is canonical** for import.
- Values marked `unavailable` must not be fabricated at import time.
