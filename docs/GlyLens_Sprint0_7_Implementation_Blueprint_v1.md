# GlyLens Sprint 0.7 Implementation Blueprint v1.0
_Last Updated: 2026-06-20_

This implementation blueprint is built strictly from approved GlyLens documentation only, including:
- `docs/adr/GlyLens_ADR_Repository_v1.md`
- `docs/architecture/GlyLens_Architecture_Blueprint_v1.md`
- `docs/architecture/GlyLens_Food_Intelligence_Graph_v1_1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md`
- `docs/Corpus_Completion_Plan_M1.md`
- `docs/Corpus_Population_Package_M1.md`
- `docs/corpus_gap_analysis_v1.md`
- `docs/Priority_Dataset_Expansion_M1.md`

This document presents the Sprint 0.7 delivery-ready plan for data acquisition, standardization, product intelligence, meal decomposition, execution, and readiness assessment.

---

## Part 1: Data Acquisition and Corpus Completion

### 1.1 Objective
Make the existing M1 catalog implementation-ready by closing the documented nutrition and evidence gaps for:
- 25 baseline ingredients
- 25 baseline foods
- 25 baseline products

The goal is to achieve:
- complete `availableCarbohydrates` coverage
- calculable or populated `glValue`
- explicit `giStatus` values
- assigned `evidenceLevel`
- assigned `trustScore`

### 1.2 Acquisition sources
Use the approved evidence hierarchy and source registry from the Architecture Blueprint and GI Framework.
Preferred source types:
- government datasets: USDA FoodData Central, India Food Composition Tables (IFCT)
- academic/peer-reviewed GI studies: FAO/WHO GI tables, PubMed glycemic index research
- manufacturer labels and product nutrition panels for products
- open-data catalogs for secondary fill and ingredient mapping

### 1.3 Data acquisition tasks
1. Ingest baseline nutrition data for all existing catalog rows.
2. Map raw nutrient fields into the schema required by `GI Reference Catalog Framework v1`.
3. Populate `availableCarbohydrates` explicitly rather than leaving it `unavailable`.
4. Derive `glValue` using the standard GL formula where possible.
5. Localize values with region-aware sources: US for USDA and FAO/WHO; India for IFCT and NIN.
6. Preserve `unavailable` as a valid state only when no reliable source exists.

### 1.4 Priority item focus
Prioritize the highest-impact diabetes-relevant catalog items from the Completion Plan and Gap Analysis:
- Foods: Idli, Chapati, Oats Porridge, Quinoa Bowl, Berry Oatmeal, Grilled Chicken Salad, Whole Grain Vegetable Sandwich, Low-Carb Chicken Wrap, Vegetable Khichdi, Dosa, Chole, Khichdi, Dal Tadka, Palak Paneer
- Beverages: Skim Milk Smoothie with Berries, Masala Chaas/Buttermilk, Coconut Water with Chia, Unsweetened Almond Milk, Sugar-Free Iced Tea
- Products: diabetic-marketing and low-GI packaged items such as Kind Nuts & Spices Bar, Kellogg's Special K, Pure Protein Bar, RXBAR, Nature's Path Qi'a Superfood, Chobani Greek Yogurt, Alpro Soya Milk, Oatly Oat Milk, Patanjali Multigrain Atta, MTR Ragi Idli Mix

### 1.5 Evidence treatment
- Source data from government or academic references earns `A` or `B` evidence.
- Manufacturer label and open-data product claims earn `C` with explicit provenance.
- AI-assisted inference is reserved for fallback only and must be tagged as `D`.
- Any item without measured or published GI remains `Estimated` until authoritative evidence is acquired.

---

## Part 2: Standardization and Harmonization

### 2.1 Schema alignment
Use the `GI Reference Catalog Framework v1` as the single canonical schema for all items.
Record-level compliance must include:
- `giReferenceId` / `glReferenceId`
- `itemType`: `ingredient`, `food`, or `product`
- `itemId`, `itemName`, `itemCategory`
- `giValue`, `giUnit`, `giMeasurementMethod`, `measuredFlag`
- `glValue`, `glUnit`, `availableCarbs`, `digestibleCarbs`, `servingSizeId`, `servingDescription`
- provenance: `sourceId`, `citationIds`, `evidenceLevel`, `trustScore`, `confidenceScore`, `acquisitionDate`
- preparation context for foods and products

### 2.2 Nutrition harmonization
Standardize nutrition fields across the corpus:
- map carbohydrates to `availableCarbs` whenever possible
- capture `digestibleCarbs` when source data provides it
- normalize serving sizes to a canonical unit (typically 100 g or per-portion description)
- compute `glValue` using the approved formula:
  - `GL = (GI × availableCarbs) / 100`
- annotate `glCalculationMethod` as `measured`, `calculated`, or `estimated`

### 2.3 Evidence/trust harmonization
Apply a single evidence and trust workflow for all items:
- evidence level A/B/C/D from the Architecture Blueprint
- trust score range 0-100, with expected baseline ranges:
  - A: 90-95
  - B: 75-90
  - C: 65-80
  - D: 50-65
- confidence score aligned to evidence and source quality
- record whether GI/GL values are `measured` or `estimated`
- store source metadata in a unified citation schema

### 2.4 Canonical record flow
Implement a three-layer harmonization pipeline:
1. raw acquisition: ingest source nutrient and GI data
2. canonical nutrition mapping: produce standard nutrition and serving metadata
3. GI/GL reference linking: create `GI Reference` and `GL Reference` records with explicit provenance

This mirrors the approved Food Intelligence Graph design and keeps catalog structure portable.

---

## Part 3: Product Intelligence and Brand Signal Modeling

### 3.1 Product intelligence objective
Build a product corpus that captures both glycemic properties and brand/marketing signals without changing the core data model.

### 3.2 Product modeling approach
Follow the FIG entity model for `Product` items:
- `product_id`, `barcode`, `brand`, `name`
- `ingredients`, `nutrition_profile_id`, `glycemic_profile_id`
- `sourceId`, `evidenceLevel`, `trustScore`

Model product variants and brand signals explicitly through:
- variant lineage: product → variant (e.g. standard vs low-sugar formulation)
- marketing claim metadata: `claimType`, `positioning`, `diabetesFriendly`
- label provenance: manufacturer nutrition label, ingredient statement, regional formulation

### 3.3 Priority product categories
Focus on the approved M1 product expansion candidates:
- beverages: Coke Zero, Pepsi Zero, Oatly Oat Milk, Alpro Soya Milk
- grain mixes/attas: Diabetic Atta, Patanjali Multigrain Atta, MTR Ragi Idli Mix
- snacks and bars: Sugar Free Biscuits, Protein Bars, RXBAR, Kind Nuts & Spices Bar
- packaged meals: healthy grain bowl, lentil meal kit, ready-to-eat refrigerated bowl

### 3.4 Brand signal handling
Extract product intelligence signals from approved sources:
- `sourceType`: government, academic, industry, openData
- `trustScore` based on label reliability and manufacturer provenance
- `evidenceLevel` for product formulation GI/GL estimates
- `claims` that affect confidence: `low GI`, `sugar-free`, `high fiber`, `diabetes-friendly`

### 3.5 Vendor-neutral intelligence
Maintain the architecture principle of vendor-neutral business logic by storing product intelligence as data, not hard-coded rules.
- product claims and brand signals are catalog attributes
- glycemic scoring remains evidence-weighted and independent of brand marketing

---

## Part 4: Meal Decomposition and Mixed-Meal GI/GL Inference

### 4.1 Purpose
Enable GlyLens to interpret mixed meals from Indian and US diets using ingredient-first decomposition and evidence-aware inference.

### 4.2 Approved mixed-meal modeling
Use the FIG food composition model for all foods:
- `ingredient_id` + `percentage`
- `food_id`, `variant_id`, `confidence`
- `preparationMetadata` for cooking method and regional cuisine

### 4.3 Case study foods
Apply the approved plan to the highest-priority Indian meals from the Priority Dataset Expansion:
- Chicken Biryani
- Masala Dosa
- Pongal

For each dish, build a meal decomposition record that includes:
- ingredient composition by share or grams
- preparation context: cooked rice, batter fermentation, pressure-cooked lentils
- region/cuisine tags: South Indian, North Indian, mixed-meal
- serving description and portion size

### 4.4 Inference method
When direct measured food GI is unavailable, infer mixed-meal GI/GL using a layered approach:
1. collect ingredient GI/GL and available carbs from the corpus
2. normalize to the meal serving
3. estimate composite GI by weighting ingredient GI values by available carbs and proportion
4. adjust for meal-level modifiers such as fiber, fat, protein, fermentation, and food structure
5. calculate GL using the standard formula after available carbs are confirmed

This is consistent with the approved Food Intelligence Graph and evidence-first approach.

### 4.5 Example decomposition patterns
- Chicken Biryani: basmati rice + chicken + yogurt + oil + spices
- Masala Dosa: fermented rice-and-dal batter + potato masala + oil
- Pongal: rice + moong dal + black pepper + ghee

Each pattern must be stored with a `preparationNotes` record and a clear `giStatus` that reflects whether the dish GI is measured, published, or estimated.

---

## Part 5: M1 Execution Roadmap and Success Criteria

### 5.1 Sprint 0.7 milestones
- Milestone 1: complete baseline catalog enrichment for 25 ingredients, 25 foods, 25 products
- Milestone 2: add 25 new ingredients from the Gap Analysis and Priority Dataset Expansion
- Milestone 3: add 25 new foods, with special focus on mixed meals and beverages
- Milestone 4: add 25 new products and product intelligence signals
- Milestone 5: validate the expanded corpus against the `GI Reference Catalog Framework v1`

### 5.2 Success criteria
Catalog is Sprint 0.7 ready when:
- 100% of baseline items have `availableCarbohydrates`
- 100% of items have a usable `glValue` or a documented reason for `unavailable`
- all items have `evidenceLevel`, `trustScore`, and `giStatus`
- product items include brand/product intelligence metadata and claim provenance
- mixed meals include ingredient decomposition and preparation context
- corpus passes schema validation against the approved GI/GL framework

### 5.3 Execution risks and mitigation
Risk: authoritative source data is not available for every target item.
- Mitigation: use high-confidence published estimates and label them as `Estimated` or `D` only for fallback.

Risk: `availableCarbohydrates` remains missing for product labels.
- Mitigation: infer from manufacturer nutrition panels using standard carbohydrate-to-available-carb mappings and preserve source notes.

Risk: mixed-meal GI inference introduces uncertain values.
- Mitigation: store meal-level GI as `Estimated` with provenance, and make ingredient-level values the primary signal.

### 5.4 Validation checkpoints
- check schema compliance for GI and GL records
- verify evidence and trust metadata for all new and updated items
- confirm product intelligence signals are present for prioritized product categories
- review mixed-meal preparation metadata for Chicken Biryani, Masala Dosa, Pongal

---

## Part 6: Implementation Readiness Assessment

### 6.1 Current readiness position
The approved documents show a strong implementation foundation:
- architecture principles support vendor-neutral business logic and evidence-based intelligence
- the Food Intelligence Graph model is defined for ingredients, foods, products, glycemic profile, and evidence
- the GI Reference Catalog Framework provides the exact schema required for Sprint 0.7 readiness
- the Corpus Completion Plan and Priority Dataset Expansion identify the critical missing items and gaps

### 6.2 Remaining gaps
Key readiness gaps are data completeness rather than architecture:
- baseline corpus still lacks `availableCarbohydrates` and `glValue` for most items
- many foods and products remain `Estimated` or `Unavailable` in GI/GL fields
- product intelligence signal coverage is incomplete for brand/marketing items
- mixed-meal decomposition is specified but not yet realized for priority Indian dishes

### 6.3 Readiness summary
The current state is ready for implementation in the following way:
- define data ingestion pipelines next, using the approved schema and source hierarchy
- prioritize completion of baseline catalog values and M1 expansion candidates
- preserve explicit evidence and trust metadata for all derived or imputed values
- keep the architecture and FIG model unchanged while operationalizing the corpus

### 6.4 Recommended first step
Move immediately from specification into data acquisition and schema enforcement:
- execute the Corpus Completion Plan M1 baseline enrichments
- seed the product intelligence dataset with approved product candidates
- create meal decomposition records for Chicken Biryani, Masala Dosa, and Pongal using the FIG composition model
- validate everything against the GI Reference Catalog Framework before any consumer-facing scoring or explainability layer is built
