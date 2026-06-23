# GlyLens Sprint 0.9 Authoritative Data Acquisition Report v1

## Part 1 – Authoritative Source Inventory

This report is grounded in the approved GlyLens documentation set:
- `docs/GlyLens_Reference_Catalog_v1.md`
- `docs/Corpus_Population_Package_M1.md`
- `docs/Priority_Dataset_Expansion_M1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md`
- `docs/GlyLens_Sprint0_7_Implementation_Blueprint_v1.md`
- `docs/M1_Seed_Dataset_Generation_Plan_v1.md`

Authoritative source registry candidates documented in the repository include:
- USDA FoodData Central — government, US, trust 90-95, evidence A/B
- India Food Composition Tables (IFCT) — government, India, trust 88-93, evidence A/B
- FAO/WHO Glycemic Index tables — academic, global, trust 88-94, evidence A
- National Institute of Nutrition India — government, India, trust 88-93, evidence A/B
- Manufacturer nutrition labels — industry, global, trust 70-80, evidence C
- Open Food Facts and other openData sources are referenced for lower-confidence provenance

These sources form the approved evidence backbone for GlyLens Sprint 0.9 acquisition.

## Part 2 – Authoritative Data Gap Analysis

A data review of `docs/GlyLens_Reference_Catalog_v1.md` shows the catalog is schema-complete but nutrition-data incomplete:
- Total catalog items: 75 (25 ingredients, 25 foods, 25 products)
- Missing `availableCarbohydrates`: 72 of 75 items
- Missing `glValue`: 72 of 75 items
- Missing `giValue`: 41 of 75 items

Only three items are fully numeric-ready for GI/GL inference:
- `Egg` (Ingredient)
- `Grilled Salmon` (Food)
- `StarKist Tuna Pouch` (Product)

The largest gap is the missing carbohydrate and glycemic load axis for the baseline catalog. This is the single most critical risk to authoritative dataset readiness.

## Part 3 – Wave 1 Ingredient Acquisition Package

Wave 1 ingredient candidates are documented in `docs/Priority_Dataset_Expansion_M1.md`:
- Jamun
- Banana
- White Rice
- Foxtail Millet
- Ragi
- Jowar

Current state for Wave 1 ingredients:
- All six items are present as seed candidates
- All six have `availableCarbohydrates`, `GI`, and `GL` recorded as `unavailable`
- All six carry evidence-level assignments and expected source guidance

Required authoritative actions:
1. Acquire `availableCarbohydrates` and `GL` for each Wave 1 ingredient from USDA FDC, IFCT, FAO/WHO, or equivalent national composition tables.
2. Confirm or update `GI` using published tables or measured values.
3. Persist source metadata as `sourceId`/`citationId` in the catalog ingest layer.

## Part 4 – Wave 1 Product Acquisition Package

Wave 1 product candidates are documented in `docs/Priority_Dataset_Expansion_M1.md`:
- Coke Zero
- Pepsi Zero
- Sugar Free Biscuits
- Diabetic Atta
- Protein Bars

Current readiness:
- Coke Zero and Pepsi Zero are data-ready with 0g carbs, GI 0, GL 0, and manufacturer-label evidence.
- Sugar Free Biscuits, Diabetic Atta, and Protein Bars are placeholders with nutrition fields still unavailable.

Required authoritative actions:
1. Source manufacturer nutrition details for the three pending branded products.
2. Assign `availableCarbohydrates`, compute `GL`, and record `GIStatus` as `Estimated` or `Published`.
3. Maintain product evidence-level `C` for label-derived values and keep trust scores aligned to the approved range.

## Part 5 – Meal Intelligence Foundation

`docs/M1_Seed_Dataset_Generation_Plan_v1.md` defines the meal decomposition schema and Wave 1 mixed-meal records.

Wave 1 meal intelligence items:
- Chicken Biryani
- Masala Dosa
- Pongal

Current status:
- Mixed-meal structure is ready with ingredient composition, preparation method, and evidence metadata.
- Numeric GI/GL inference for these meals remains dependent on ingredient-level carbohydrate and GI data.

Next steps:
1. Complete ingredient-level numeric sourcing for the meal components.
2. Validate mixed-meal composition percentages and ensure they sum to 100 where available.
3. Tag mixed-meal records with evidence level `B` and source lineage from IFCT / FAO/WHO expectations.

## Part 6 – Seed Dataset Readiness Report

Seed dataset readiness is partially achieved:
- Source and import strategy are documented in `docs/M1_Seed_Dataset_Generation_Plan_v1.md`
- JSON and CSV schema expectations are defined clearly
- Import sequencing is specified: sources → ingredients → products → foods → meal decompositions

Remaining readiness gaps:
- Ingredient records still use `unavailable` for carbohydrate and load values in the six Wave 1 items
- Product records are incomplete for three Wave 1 products
- Mixed-meal records are structurally ready but numerically pending

The dataset is ready for ingestion as a skeleton, but not yet ready for authoritative glycemic analysis across Wave 1.

## Part 7 – Sprint 1 Go / No-Go Assessment

Recommendation: No-Go for an authoritative Sprint 1 launch that depends on accurate GI/GL inference across the baseline and Wave 1 catalog.

Rationale:
- The data model is in place, but the glycemic acquisition axis is incomplete.
- 72 of 75 baseline catalog items lack `availableCarbohydrates` and `GL`.
- 12 of 17 Wave 1 priority entities remain unresolved for numeric nutrition values.

Conditional green light for Sprint 1 if scoped to:
- UI/UX search experience validation
- ingestion pipeline proof-of-concept
- limited demo using only Coke Zero and Pepsi Zero

This must be explicitly framed as a prototype, not an authoritative nutrition release.

## Part 8 – Top 20 Acquisition Tasks

1. Ingest USDA FoodData Central carbohydrate values for all 75 catalog items.
2. Ingest IFCT carbohydrate values for India-region ingredients.
3. Acquire FAO/WHO GI values for baseline and Wave 1 grains.
4. Compute `GL` for all items where numeric carbs and GI exist.
5. Update `docs/GlyLens_Reference_Catalog_v1.md` with completed values.
6. Resolve `availableCarbohydrates` for Jamun.
7. Resolve `availableCarbohydrates` for Banana.
8. Resolve `availableCarbohydrates` for White Rice.
9. Resolve `availableCarbohydrates` for Foxtail Millet.
10. Resolve `availableCarbohydrates` for Ragi.
11. Resolve `availableCarbohydrates` for Jowar.
12. Source nutrition labels for Sugar Free Biscuits.
13. Source nutrition labels for Diabetic Atta.
14. Source nutrition labels for Protein Bars.
15. Add `sourceId`/`citationId` mappings for all acquired values.
16. Validate imported meal decomposition percentages.
17. Confirm `GIStatus` for all food and product records.
18. Migrate source registry entries into `sources.json` / `citations.json`.
19. Run schema validation against `GI_Reference_Catalog_Framework_v1.md`.
20. Publish a `GlyLens_Reference_Catalog_v1.1` draft when the baseline numeric gaps are closed.

## Part 9 – Risks and Blockers

- Core blocker: missing authoritative carbohydrate and GL values for the majority of the baseline catalog.
- Source risk: dependency on external tables and manufacturer labels may delay data acquisition.
- Model risk: mixed meals cannot be accurately scored until ingredient numeric values are available.
- Scope risk: Sprint 1 may be mis-scoped if it assumes complete nutrition readiness.

## Part 10 – Recommended Next Codex Prompt

Use this prompt to generate the next authoritative data acquisition plan:

"Based on the GlyLens Sprint 0.9 documentation assets and the current catalog gap analysis, create a prioritized acquisition plan for completing `availableCarbohydrates`, `GI`, and `GL` values for the 75 baseline catalog items and the 17 Wave 1 priority entities. Include source mapping to USDA FoodData Central, IFCT, FAO/WHO GI tables, and manufacturer nutrition labels, and define the data validation rules for final Sprint 1 readiness."

