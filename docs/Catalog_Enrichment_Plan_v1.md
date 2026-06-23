# GlyLens Catalog Enrichment Plan v1.0
_Last Updated: 2026-06-20_

This document analyzes the current `docs/GlyLens_Reference_Catalog_v1.md` and produces the first enrichment plan for reaching the GlyLens target corpus of:

- 50 Ingredients
- 50 Foods
- 50 Products

It is based on:
- `docs/corpus_build_package_v1.md`
- `docs/corpus_gap_analysis_v1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md`
- Source Registry
- Evidence Registry

No application code is generated.

## 1. Gap Assessment

### 1.1 Missing Available Carbohydrate Values

The current catalog is missing available carbohydrate values for 73 of 75 records.
Only Egg and StarKist Tuna Pouch currently have explicit available carbohydrate values documented.

Impact:
- GL cannot be computed reliably
- Serving-level carb exposure is undefined for most items
- Benchmark comparability is limited

### 1.2 Missing GL Values

The current catalog is missing GL values for 73 of 75 records.
Even where GI is present, GL is unavailable for almost every ingredient, food, and product.

Impact:
- Meal glycemic load assessment cannot be performed
- Comparative ranking of portion-level risk is incomplete
- Clinical relevance for diabetes management is weak

### 1.3 Missing Benchmark Foods

The current catalog lacks benchmark coverage for key food categories:
- Restaurant-style bowl meals
- Indian regional prepared meals
- US staple fast-casual entrées
- Packaged diabetic-marketing meal products

Impact:
- Reference catalog cannot validate real-world meal behavior
- Missing calibration points for meal-level GI/GL benchmarking

### 1.4 Missing Diabetic-Relevant Foods

The current catalog has limited representation of foods marketed for or commonly chosen by people with diabetes.
Notable gaps include:
- low-GI snack bars and breakfast cereals
- vegetable-based wraps and bowls
- low-sugar beverage pairings

Impact:
- Diabetic user needs are under-served
- Catalog lacks consumer-facing product signals

### 1.5 Missing Indian Foods

The current catalog is heavily skewed toward South Indian and basic Indian staples.
Missing regional and culturally important items include:
- Maharashtrian, Gujarati, Bengali, Punjabi, and northeastern dishes
- Indian fermented beverages and low-GI meal accompaniments

Impact:
- Indian corpus lacks regional depth
- Dietary patterns for Indian diabetes are underrepresented

### 1.6 Missing US Staple Foods

US coverage is limited to cereals, salad, and a few bowls.
Missing staples include:
- whole grain sandwich and wrap meals
- burrito bowls and chili
- protein-focused ready meals

Impact:
- US diabetic meal patterns are incomplete
- Retail and restaurant conforming options are not benchmarked

### 1.7 Missing Restaurant Foods

The current catalog does not include true restaurant or ready-to-eat meals.
Missing items include:
- bowl meals, grilled entrée salads, tacos, and frozen meal bowls
- restaurant-style beverages and snack combos

Impact:
- Real-world dining data is not supported
- Meal preparation metadata is too home-cooking centric

### 1.8 Missing Beverages

The current catalog only includes one beverage-style food (Skim Milk Smoothie with Berries).
Missing beverage coverage includes:
- coconut water
- unsweetened plant milks
- sugar-free drinks
- traditional Indian buttermilk

Impact:
- Beverage GI/GL signal is absent
- Hydration and liquid meal contexts are missing

### 1.9 Missing Diabetic-Marketing Products

The current product set has some branded staples but lacks explicit diabetic-marketing products.
Missing categories include:
- low-GI atta and flour mixes
- diabetic-friendly meal kits
- sugar-free snack bars and drinks
- fortified low-carb packaged meals

Impact:
- Product corpus lacks market signaling
- Diabetes-specific product discovery is impaired

## 2. Prioritization

### 2.1 Critical

- Fill available carbohydrate values for all catalog records
- Populate GL values for all catalog records with GI
- Add benchmark foods for restaurant meals, Indian regions, and US staple bowls
- Add missing diabetic-relevant foods across India and US
- Add missing beverages and product categories with diabetic marketing relevance

### 2.2 High

- Add more Indian regional foods beyond south India and Punjab
- Add US staple meal entries for sandwich, taco, and chili patterns
- Add products with explicit low-GI or diabetic-friendly claims
- Enrich preparation notes and serving metadata for meal-level comparability

### 2.3 Medium

- Add ingredient-level seeds, nuts, and pulse diversity
- Add product items from alternate dairy and plant-based lines
- Add beverage and snack product coverage for market readiness

### 2.4 Low

- Add detailed culinary spice and seasoning ingredients
- Add convenience or novelty diabetic products with lower priority
- Add rare regional items beyond the first 50-item expansion

## 3. M1 Dataset Completion Plan

The M1 plan fills the remaining 25 items in each domain to reach 50 Ingredients, 50 Foods, and 50 Products.
Each item below is a missing candidate with expected source, evidence level, and trust range.

### 3.1 Missing Ingredient Candidates (25)

1. Strawberries | Fruit | US | Expected Source: FAO/WHO Glycemic Index tables | Evidence Level: A | Trust Range: 88-94
2. Blueberries | Fruit | US | Expected Source: FAO/WHO Glycemic Index tables | Evidence Level: A | Trust Range: 88-94
3. Kiwi | Fruit | US | Expected Source: FAO/WHO Glycemic Index tables | Evidence Level: A | Trust Range: 88-94
4. Pomegranate | Fruit | India | Expected Source: Clinical glycemic index studies or IFCT | Evidence Level: A | Trust Range: 85-92
5. Walnuts | Nut | US | Expected Source: USDA FoodData Central / FAO tables | Evidence Level: A | Trust Range: 88-94
6. Pistachios | Nut | US / India | Expected Source: FAO/WHO Glycemic Index tables | Evidence Level: A | Trust Range: 88-94
7. Pumpkin Seeds | Seed | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
8. Sunflower Seeds | Seed | US / India | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
9. Green Peas | Vegetable | US / India | Expected Source: USDA FoodData Central / IFCT | Evidence Level: A | Trust Range: 88-94
10. Toor Dal | Legume | India | Expected Source: IFCT | Evidence Level: A | Trust Range: 85-92
11. Masoor Dal | Legume | India / US | Expected Source: FAO/WHO Glycemic Index tables | Evidence Level: A | Trust Range: 85-92
12. Horse Gram | Legume | India | Expected Source: Academic GI studies | Evidence Level: B | Trust Range: 80-86
13. Black Chickpea | Legume | India | Expected Source: Academic GI studies | Evidence Level: B | Trust Range: 80-86
14. Moth Bean | Legume | India | Expected Source: Academic GI studies | Evidence Level: B | Trust Range: 80-86
15. Eggplant | Vegetable | India / US | Expected Source: USDA FoodData Central / IFCT | Evidence Level: B | Trust Range: 80-86
16. Okra | Vegetable | India / US | Expected Source: USDA FoodData Central / IFCT | Evidence Level: A | Trust Range: 85-92
17. Cabbage | Vegetable | US / India | Expected Source: USDA FoodData Central / IFCT | Evidence Level: A | Trust Range: 85-92
18. Cauliflower | Vegetable | US | Expected Source: USDA FoodData Central | Evidence Level: A | Trust Range: 85-92
19. Bajra Flour / Pearl Millet Flour | Grain | India | Expected Source: IFCT | Evidence Level: B | Trust Range: 80-86
20. Jowar Flour | Grain | India | Expected Source: IFCT | Evidence Level: B | Trust Range: 80-86
21. Amaranth Grain | Grain | US / India | Expected Source: USDA / IFCT | Evidence Level: B | Trust Range: 80-86
22. Rye Flour | Grain | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-86
23. Coconut Flour | Ingredient | US / India | Expected Source: USDA / IFCT | Evidence Level: B | Trust Range: 80-86
24. Mustard Greens | Vegetable | India | Expected Source: IFCT | Evidence Level: B | Trust Range: 80-86
25. Green Tea | Beverage Ingredient | US / India | Expected Source: Clinical studies / FAO reference | Evidence Level: A | Trust Range: 86-92

### 3.2 Missing Food Candidates (25)

1. Pesarattu | Mixed Meal | India | Expected Source: IFCT / clinical GI studies | Evidence Level: A | Trust Range: 85-92
2. Thepla | Mixed Meal | India | Expected Source: IFCT | Evidence Level: B | Trust Range: 80-86
3. Bajra Roti with Sarson Ka Saag | Mixed Meal | India | Expected Source: IFCT / regional food composition studies | Evidence Level: B | Trust Range: 80-86
4. Gujarati Khichu | Mixed Meal | India | Expected Source: IFCT / academic sources | Evidence Level: B | Trust Range: 80-86
5. Bengali Dal and Brown Rice | Mixed Meal | India | Expected Source: IFCT / clinical GI studies | Evidence Level: B | Trust Range: 80-86
6. Masala Chaas (Buttermilk) | Beverage | India | Expected Source: IFCT / NIN India | Evidence Level: B | Trust Range: 80-86
7. Sattu Drink | Beverage | India | Expected Source: academic / regional nutrition studies | Evidence Level: B | Trust Range: 78-84
8. Baingan Bharta | Mixed Meal | India | Expected Source: IFCT | Evidence Level: B | Trust Range: 80-86
9. Millet Upma | Mixed Meal | India | Expected Source: IFCT | Evidence Level: B | Trust Range: 80-86
10. Green Gram Dosa | Mixed Meal | India | Expected Source: NIN India / IFCT | Evidence Level: B | Trust Range: 80-86
11. Whole Grain Veggie Burger | Mixed Meal | US | Expected Source: USDA FoodData Central / manufacturer data | Evidence Level: B | Trust Range: 80-88
12. Burrito Bowl | Mixed Meal | US | Expected Source: USDA FoodData Central / clinical GI research | Evidence Level: B | Trust Range: 80-88
13. Turkey Chili | Mixed Meal | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
14. Whole Grain Sandwich | Mixed Meal | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
15. Black Bean Tacos | Mixed Meal | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
16. Kale and Quinoa Salad | Mixed Meal | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
17. Salmon and Quinoa Bowl | Mixed Meal | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
18. Coconut Water with Chia | Beverage | US / India | Expected Source: manufacturer label / clinical nutrition sources | Evidence Level: B | Trust Range: 78-86
19. Unsweetened Iced Coffee | Beverage | US | Expected Source: clinical beverage GI studies | Evidence Level: A | Trust Range: 85-92
20. Low-Sugar Smoothie Bowl | Mixed Meal | US | Expected Source: USDA FoodData Central / manufacturer label | Evidence Level: B | Trust Range: 80-88
21. Greek Salad with Chickpeas | Mixed Meal | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
22. Lentil Chili | Mixed Meal | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
23. Roasted Vegetable Platter | Mixed Meal | US | Expected Source: USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
24. Cauliflower Rice Stir-Fry | Mixed Meal | US | Expected Source: USDA FoodData Central / academic sources | Evidence Level: B | Trust Range: 80-88
25. Low-GI Paneer Salad | Mixed Meal | India / US | Expected Source: IFCT / USDA FoodData Central | Evidence Level: B | Trust Range: 80-88

### 3.3 Missing Product Candidates (25)

1. Sugar-Free Iced Tea | Beverage | US | Expected Source: Manufacturer label + ADA publications | Evidence Level: B | Trust Range: 78-86
2. Low-Sugar Coconut Water | Beverage | US / India | Expected Source: Manufacturer label + clinical beverage studies | Evidence Level: B | Trust Range: 78-86
3. Unsweetened Almond Milk | Dairy Alternative | US | Expected Source: USDA FoodData Central | Evidence Level: A | Trust Range: 85-92
4. Fortified Soy Milk | Dairy Alternative | US | Expected Source: USDA FoodData Central | Evidence Level: A | Trust Range: 85-92
5. Low-GI Multigrain Atta | Grain | India | Expected Source: Manufacturer label + IFCT | Evidence Level: B | Trust Range: 78-86
6. Jowar/Bajra Roti Mix | Grain | India | Expected Source: Manufacturer label + IFCT | Evidence Level: B | Trust Range: 78-86
7. Healthy Grain Bowl Frozen Meal | Mixed Meal | US | Expected Source: Manufacturer label + USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
8. Ready-to-Eat Lentil Curry Pouch | Mixed Meal | India | Expected Source: Manufacturer label + IFCT | Evidence Level: B | Trust Range: 78-86
9. Diabetic Protein Bar | Snack | US | Expected Source: Manufacturer label + ADA publications | Evidence Level: C | Trust Range: 70-78
10. Low-Carb Snack Bar | Snack | US | Expected Source: Manufacturer label | Evidence Level: C | Trust Range: 70-78
11. High-Fiber Cracker Brand | Snack | US | Expected Source: Manufacturer label + USDA FoodData Central | Evidence Level: B | Trust Range: 78-86
12. Sugar-Free Peanut Butter | Spread | US / India | Expected Source: Manufacturer label | Evidence Level: C | Trust Range: 70-78
13. Low-Carb Dosa Mix | Grain | India | Expected Source: Manufacturer label + IFCT | Evidence Level: B | Trust Range: 78-86
14. Millet Porridge Pouch | Grain | India | Expected Source: Manufacturer label + IFCT | Evidence Level: B | Trust Range: 78-86
15. Prepackaged Salad Bowl | Mixed Meal | US | Expected Source: Manufacturer label + USDA FoodData Central | Evidence Level: B | Trust Range: 80-88
16. Low-Sugar Granola | Snack | US | Expected Source: Manufacturer label + USDA FoodData Central | Evidence Level: B | Trust Range: 78-86
17. Low-Sugar Muesli | Grain | US | Expected Source: Manufacturer label | Evidence Level: B | Trust Range: 78-86
18. Plant-Based Yogurt Alternative | Dairy Alternative | US | Expected Source: Manufacturer label + USDA FoodData Central | Evidence Level: B | Trust Range: 78-86
19. Low-GI Breakfast Cereal | Grain | US | Expected Source: Manufacturer label + ADA publications | Evidence Level: B | Trust Range: 78-86
20. Diabetic-Friendly Electrolyte Drink | Beverage | US | Expected Source: Manufacturer label + clinical hydration studies | Evidence Level: B | Trust Range: 78-86
21. Low-Fat Paneer Pack | Dairy | India | Expected Source: Manufacturer label + IFCT | Evidence Level: B | Trust Range: 78-86
22. Sprouted Lentil Salad Pack | Protein | India | Expected Source: Manufacturer label + IFCT | Evidence Level: B | Trust Range: 78-86
23. Low-Sugar Chutney Sachet | Condiment | India | Expected Source: Manufacturer label | Evidence Level: C | Trust Range: 70-78
24. Packaged Whole Grain Bread | Grain | US | Expected Source: Manufacturer label + USDA FoodData Central | Evidence Level: B | Trust Range: 78-86
25. Plant-Based Cheese Alternative | Dairy Alternative | US | Expected Source: Manufacturer label + USDA FoodData Central | Evidence Level: B | Trust Range: 78-86

## 4. Enrichment Execution Notes

- All newly added candidates must carry `availableCarbohydrates` and `glValue` metadata before the next catalog release.
- GI values may remain `unavailable` until authoritative sources are acquired; every item must document `giStatus` clearly as `Measured`, `Published`, `Estimated`, or `Unavailable`.
- Benchmark food coverage should be prioritized for restaurant-style meals, diabetic-relevant bowl/plate patterns, and the US/Indian regional split.
- Products should prioritize diabetic-marketing claims and explicit low-GI / low-sugar positioning.
- The catalog should preserve a balanced 50/50/50 item count across Ingredients, Foods, and Products.

## 5. Recommended Next Steps

1. Ingest authoritative `availableCarbohydrates` and `GL` values from USDA FDC, IFCT, FAO/WHO GI tables, and ADA publications for the 25 missing candidate items.
2. Add the missing restaurant foods and US staple foods to the Food catalog first, then backfill Indian regional foods and beverages.
3. Add the missing diabetic-marketing packaged products with manufacturer label and clinical support metadata.
4. Validate all new catalog items against the `GI Reference Catalog Framework v1` schema.
5. Publish the enriched catalog as `GlyLens_Reference_Catalog_v1.1` once the 50/50/50 target is complete.
