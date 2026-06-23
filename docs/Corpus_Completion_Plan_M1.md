# GlyLens Corpus Completion Plan M1
_Last Updated: 2026-06-20_

This plan is derived from:
- `docs/GlyLens_Reference_Catalog_v1.md`
- `docs/corpus_gap_analysis_v1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md`

It defines the M1 completion roadmap to reach:
- 50 Ingredients
- 50 Foods
- 50 Products

with:
- available carbohydrates populated
- GL calculable
- evidence level assigned
- trust score assigned

## 1. Current Catalog Gap Summary

### 1.1 Nutritional field gaps

Ingredients:
- 24 of 25 ingredients are missing `availableCarbohydrates`
- 24 of 25 ingredients are missing `glValue`
- `giStatus` is `Estimated` for 1 ingredient: Paneer
- `giStatus` is `Unavailable` for 1 ingredient: Whole Wheat Flour

Foods:
- 25 of 25 foods are missing `availableCarbohydrates`
- 25 of 25 foods are missing `glValue`
- 19 of 25 foods have `giStatus: Estimated`

Products:
- 24 of 25 products are missing `availableCarbohydrates`
- 24 of 25 products are missing `glValue`
- 21 of 25 products have `giStatus: Estimated`

### 1.2 Records with critical catalog gaps

Critical missing fields are concentrated in the baseline catalog, especially for:
- all foods
- most products
- all ingredients except Egg

The only complete nutritional records are:
- Egg (Ingredient)
- StarKist Tuna Pouch (Product)

## 2. Critical Missing Nutritional Fields

The highest-priority field completion work is:

1. Populate `availableCarbohydrates` for every item.
2. Populate `glValue` for every item once available carbohydrates are known.
3. Resolve `giStatus` for estimated items by acquiring authoritative GI references or clearly marking them as `Estimated` with source context.
4. Assign evidence level for every item, especially for manufacturer-sourced products and estimated foods.
5. Assign trust score for every item, using source quality, method, and provenance.

## 3. Highest-Priority Foods for Diabetes Users

These foods should be prioritized for catalog completion because they are diabetes-relevant, commonly consumed, and have high potential clinical value:

- Idli
- Chapati
- Oats Porridge
- Quinoa Bowl
- Berry Oatmeal
- Grilled Chicken Salad
- Whole Grain Vegetable Sandwich
- Low-Carb Chicken Wrap
- Apple and Peanut Butter Snack
- Vegetable Khichdi
- Dosa
- Chole (Chickpea Curry)
- Khichdi
- Dal Tadka
- Palak Paneer

## 4. Highest-Priority Restaurant Foods

These restaurant-style or ready-to-eat foods should be enriched first for real-world diet modeling:

- Grilled Chicken Salad
- Quinoa Bowl
- Tofu Stir-fry
- Whole Grain Vegetable Sandwich
- Grilled Vegetable Sandwich
- Low-Carb Chicken Wrap
- Berry Bowl with Nuts
- Apple and Peanut Butter Snack
- Skim Milk Smoothie with Berries
- Whole Grain Chapati Wrap

## 5. Highest-Priority Beverages

Beverages are underrepresented and are essential for diabetes risk modeling. Prioritize:

- Skim Milk Smoothie with Berries
- Masala Chaas / Buttermilk (new candidate)
- Coconut Water with Chia (new candidate)
- Unsweetened Almond Milk (new candidate)
- Sugar-Free Iced Tea (new candidate)
- Oatly Oat Milk
- Alpro Soya Milk

## 6. Highest-Priority Diabetic-Marketing Products

These products should be prioritized because they directly signal market demand and diabetes-relevant positioning:

- Kind Nuts & Spices Bar
- Kellogg's Special K
- Pure Protein Bar
- RXBAR
- Nature's Path Qi'a Superfood
- Chobani Greek Yogurt
- Alpro Soya Milk
- Oatly Oat Milk
- Whole Foods 365 Almond Butter
- Patanjali Multigrain Atta
- MTR Ragi Idli Mix
- Haldiram Sprouted Moong Salad Pack
- Tata Sampann Rajma
- Dabur Honey (Low GI positioning)

## 7. Corpus Completion Roadmap

### 7.1 Stage 1: Baseline Catalog Enrichment

For the existing 25 ingredients, 25 foods, and 25 products:
- Acquire authoritative `availableCarbohydrates` values from:
  - USDA FoodData Central
  - India Food Composition Tables (IFCT)
  - FAO/WHO GI tables
  - manufacturer nutrition labels
- Compute or acquire `glValue` for every item using serving size and available carbs.
- Confirm or update `giStatus` from `Estimated` to `Published` or `Measured` where possible.
- Assign `evidenceLevel` for each item:
  - A for government/academic measured sources
  - B for high-confidence estimates and national composition tables
  - C for manufacturer label or product marketing-derived values
- Assign `trustScore` within 70-95 range based on source provenance.

### 7.2 Stage 2: Add 25 New Ingredients

Add missing high-priority ingredient candidates from the gap analysis, including:
- berries: Strawberries, Blueberries, Kiwi, Pomegranate
- nuts/seeds: Walnuts, Pistachios, Pumpkin Seeds, Sunflower Seeds
- regional Indian pulses/grains: Toor Dal, Masoor Dal, Black Chickpea, Horse Gram, Bajra Flour, Jowar Flour
- high-value vegetables: Green Peas, Eggplant, Okra, Cauliflower
- plant-based beverages/ingredients: Coconut Flour, Green Tea

Each new ingredient must include:
- `availableCarbohydrates`
- `giValue`
- `glValue`
- `evidenceLevel`
- `trustScore`

### 7.3 Stage 3: Add 25 New Foods

Add missing high-priority food candidates, including:
- Indian regional meals: Pesarattu, Thepla, Bajra Roti with Sarson Ka Saag, Gujarati Khichu, Bengali Dal and Brown Rice
- US staples: Burrito Bowl, Whole Grain Sandwich, Turkey Chili, Black Bean Tacos
- restaurant-ready meals: Grilled Vegetable Sandwich, Tofu Stir-fry, Salmon and Quinoa Bowl, Kale and Quinoa Salad
- beverage meals: Coconut Water with Chia, Masala Chaas, Low-Sugar Smoothie Bowl

Each new food must include:
- `availableCarbohydrates`
- `glValue`
- `evidenceLevel`
- `trustScore`
- `giStatus`

### 7.4 Stage 4: Add 25 New Products

Add missing high-priority products, including:
- low-sugar diabetic-marketing bars and snacks
- low-GI flour and atta mixes
- unsweetened plant milks
- ready-to-eat healthy grain bowls
- electrolyte and beverage products with low-sugar claims

Each new product must include:
- `availableCarbohydrates`
- `glValue`
- `evidenceLevel`
- `trustScore`
- `giStatus`

### 7.5 Stage 5: Catalog Validation

Validate every item against the `GI Reference Catalog Framework v1` schema.

Required validation checks:
- `availableCarbohydrates` is populated
- `glValue` is populated or calculable
- `evidenceLevel` is assigned
- `trustScore` is assigned
- `sourceName` and `sourceType` are present
- `giStatus` is explicit (`Measured`, `Published`, `Estimated`, or `Unavailable`)

## 8. M1 Milestones

- Milestone 1: Enrich baseline 25 ingredients/foods/products with missing nutrition values and evidence metadata.
- Milestone 2: Add 25 new ingredients and complete field assignment.
- Milestone 3: Add 25 new foods and complete field assignment.
- Milestone 4: Add 25 new products and complete field assignment.
- Milestone 5: Final validation and publish as `GlyLens_Reference_Catalog_v1.1` or `Corpus_Completion_Plan_M1` deliverable.

## 9. Prioritized Execution

### Critical
- Available carbohydrates for every item
- GL values for every item
- Evidence level assignment for all estimated and product-sourced records
- Trust score assignment for all catalog records
- Completion of high-impact diabetes foods and restaurant meals

### High
- Completion of bathrooms and beverage entries
- Completion of diabetic-marketing products
- Addition of Indian regional foods and US staple meals

### Medium
- Expansion to seeds, nuts, and alternative grains
- Addition of more plant-based dairy alternatives
- Broader product coverage for prepared, packaged meals

### Low
- Secondary seasoning ingredients and specialty novelty products
- Rare regional items beyond the first 50-item expansion

## 10. Implementation Notes

- Maintain balance across Ingredients, Foods, and Products to preserve 50/50/50 target.
- Use the Source Registry and Evidence Registry as the authoritative provenance basis for all assigned values.
- Treat this plan as the M1 completion roadmap; subsequent catalog versions can expand beyond 50/50/50.
