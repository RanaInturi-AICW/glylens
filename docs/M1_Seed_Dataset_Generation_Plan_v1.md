# M1 Seed Dataset Generation Plan v1.0
_Last Updated: 2026-06-20_

This plan uses approved GlyLens documentation only:
- `docs/GlyLens_Reference_Catalog_v1.md`
- `docs/Corpus_Population_Package_M1.md`
- `docs/Priority_Dataset_Expansion_M1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md`
- `docs/GlyLens_Sprint0_7_Implementation_Blueprint_v1.md`

It defines the seed dataset schema, import strategy, validation rules, and Wave 1 import-ready records for ingredients, meals, and products.

---

## Part 1 – Seed Dataset Strategy

### 1.1 JSON format
Use a normalized JSON payload for each entity type.

Entity files:
- `ingredients.json`
- `foods.json`
- `products.json`
- `meal_decompositions.json`

Each JSON file is an array of objects.

Required fields for ingredients:
- `canonicalName`
- `aliases` (array)
- `category`
- `region`
- `availableCarbohydrates` (numeric or `"unavailable"`)
- `GI` (numeric or `"unavailable"`)
- `GL` (numeric or `"unavailable"`)
- `GIStatus`
- `evidenceLevel`
- `source`
- `trustScore` (numeric)
- `confidence` (numeric or range string)

Required fields for foods (meal decomposition records):
- `itemName`
- `itemType` (`food`)
- `ingredientList` (array of `{name, percentage}`)
- `preparationMethod`
- `preparationNotes`
- `evidenceLevel`
- `source`
- `trustScore`
- `confidence`

Required fields for products:
- `brand`
- `productName`
- `productCategory`
- `barcode` (placeholder allowed)
- `nutritionSource`
- `marketingClaims` (array)
- `availableCarbohydrates` (numeric or `"unavailable"`)
- `GI` (numeric or `"unavailable"`)
- `GL` (numeric or `"unavailable"`)
- `GIStatus`
- `evidenceLevel`
- `source`
- `trustScore` (numeric)
- `confidence` (numeric or range string)

### 1.2 CSV format
Use separate CSV files by entity type with consistent headers.

Ingredient CSV headers:
`canonicalName,aliases,category,region,availableCarbohydrates,GI,GL,GIStatus,evidenceLevel,source,trustScore,confidence`

Food CSV headers:
`itemName,itemType,ingredientList,ingredientPercentages,preparationMethod,preparationNotes,evidenceLevel,source,trustScore,confidence`

Product CSV headers:
`brand,productName,productCategory,barcode,nutritionSource,marketingClaims,availableCarbohydrates,GI,GL,GIStatus,evidenceLevel,source,trustScore,confidence`

Values that are unavailable must be encoded as the literal string `unavailable` in CSV.
Arrays should be serialized as pipe-delimited strings in CSV, for example:
- `aliases`: `Rolled Oats|Old Fashioned Oats`
- `ingredientList`: `Basmati Rice|Chicken|Yogurt|Oil|Spices`
- `ingredientPercentages`: `60|20|10|5|5`
- `marketingClaims`: `zero sugar|zero calories`

### 1.3 Import sequencing
Follow this dependency-aware import order:

1. `sources.json` / `citations.json`
   - Ingest source registry and citation metadata first.
2. `ingredients.json`
   - Seed ingredient catalog items before foods and products.
3. `products.json`
   - Import products after ingredient records if products reference ingredients.
4. `foods.json`
   - Import meal-level items and mixed-meal records.
5. `meal_decompositions.json`
   - Import decomposition records last, after referenced ingredients and foods exist.

This order preserves the Food Intelligence Graph relationships and aligns with the approved FIG entity model.

### 1.4 Validation rules

#### Schema completeness
- All required fields must be present.
- `canonicalName`, `productName`, `brand`, and `itemName` must not be empty.
- `aliases` and `marketingClaims` must be arrays or pipe-delimited strings.

#### Evidence and source validation
- `evidenceLevel` must be one of: `A`, `B`, `C`, `D`.
- `source` must reference an approved source type from the GI framework: government, academic, industry, openData.
- `trustScore` must be numeric and between 50 and 100.
- `confidence` may be a single numeric value or a documented range.

#### GI / GL rules
- If `availableCarbohydrates` and `GI` are numeric, `GL` must be numeric or explicitly marked `unavailable` with a documented reason.
- When both `availableCarbohydrates` and `GI` are numeric, `GL` should be calculated using: `GL = (GI × availableCarbohydrates) / 100`.
- If `availableCarbohydrates` is `unavailable`, `GL` may remain `unavailable`.

#### Meal decomposition rules
- `ingredientList` percentages should sum to 100 where a complete composition is available.
- `preparationMethod` and `preparationNotes` must capture cooking context.
- `evidenceLevel` must reflect the level of the mixed-meal estimate.

#### Product readiness rules
- `barcode` may be a placeholder, but must exist as a string.
- `nutritionSource` is required for any product seed record.
- `marketingClaims` must document the product's glycemic or health positioning.

---

## Part 2 – Wave 1 Seed Records

### Ingredients

```json
[
  {
    "canonicalName": "Jamun",
    "aliases": ["Jamun Fruit", "Indian Blackberry"],
    "category": "Fruit",
    "region": "India",
    "availableCarbohydrates": "unavailable",
    "GI": "unavailable",
    "GL": "unavailable",
    "GIStatus": "unavailable",
    "evidenceLevel": "B",
    "source": "India Food Composition Tables (IFCT) / National Institute of Nutrition India (expected)",
    "trustScore": 88,
    "confidence": "80-86"
  },
  {
    "canonicalName": "Banana",
    "aliases": ["Banana Fruit"],
    "category": "Fruit",
    "region": "India / US",
    "availableCarbohydrates": "unavailable",
    "GI": "unavailable",
    "GL": "unavailable",
    "GIStatus": "unavailable",
    "evidenceLevel": "A",
    "source": "USDA FoodData Central / FAO/WHO Glycemic Index tables (expected)",
    "trustScore": 90,
    "confidence": "85-89"
  },
  {
    "canonicalName": "White Rice",
    "aliases": ["White Rice (cooked)", "Polished Rice"],
    "category": "Grain",
    "region": "India / US",
    "availableCarbohydrates": "unavailable",
    "GI": "unavailable",
    "GL": "unavailable",
    "GIStatus": "unavailable",
    "evidenceLevel": "A",
    "source": "FAO/WHO Glycemic Index tables / USDA FoodData Central (expected)",
    "trustScore": 91,
    "confidence": "86-90"
  },
  {
    "canonicalName": "Brown Rice",
    "aliases": ["Whole Grain Brown Rice"],
    "category": "Grain",
    "region": "US / India",
    "availableCarbohydrates": "unavailable",
    "GI": 55,
    "GL": "unavailable",
    "GIStatus": "Published",
    "evidenceLevel": "A",
    "source": "FAO/WHO Glycemic Index tables",
    "trustScore": 91,
    "confidence": "86-90"
  },
  {
    "canonicalName": "Oats",
    "aliases": ["Rolled Oats", "Old Fashioned Oats"],
    "category": "Grain",
    "region": "US",
    "availableCarbohydrates": "unavailable",
    "GI": 55,
    "GL": "unavailable",
    "GIStatus": "Published",
    "evidenceLevel": "A",
    "source": "USDA FoodData Central",
    "trustScore": 90,
    "confidence": "85-89"
  },
  {
    "canonicalName": "Chickpea",
    "aliases": ["Garbanzo Bean"],
    "category": "Legume",
    "region": "US / India",
    "availableCarbohydrates": "unavailable",
    "GI": 28,
    "GL": "unavailable",
    "GIStatus": "Published",
    "evidenceLevel": "A",
    "source": "FAO/WHO Glycemic Index tables",
    "trustScore": 92,
    "confidence": "88-92"
  }
]
```

#### Ingredient CSV sample

```csv
canonicalName,aliases,category,region,availableCarbohydrates,GI,GL,GIStatus,evidenceLevel,source,trustScore,confidence
Jamun,"Jamun Fruit|Indian Blackberry",Fruit,India,unavailable,unavailable,unavailable,unavailable,B,"India Food Composition Tables (IFCT) / National Institute of Nutrition India (expected)",88,"80-86"
Banana,Banana Fruit,Fruit,India / US,unavailable,unavailable,unavailable,unavailable,A,"USDA FoodData Central / FAO/WHO Glycemic Index tables (expected)",90,"85-89"
White Rice,"White Rice (cooked)|Polished Rice",Grain,India / US,unavailable,unavailable,unavailable,unavailable,A,"FAO/WHO Glycemic Index tables / USDA FoodData Central (expected)",91,"86-90"
Brown Rice,"Whole Grain Brown Rice",Grain,US / India,unavailable,55,unavailable,Published,A,FAO/WHO Glycemic Index tables,91,"86-90"
Oats,"Rolled Oats|Old Fashioned Oats",Grain,US,unavailable,55,unavailable,Published,A,USDA FoodData Central,90,"85-89"
Chickpea,"Garbanzo Bean",Legume,US / India,unavailable,28,unavailable,Published,A,FAO/WHO Glycemic Index tables,92,"88-92"
```

---

## Part 3 – Meal Seed Records

### 3.1 Chicken Biryani

```json
{
  "itemName": "Chicken Biryani",
  "itemType": "food",
  "ingredientList": [
    { "name": "Basmati Rice", "percentage": 60 },
    { "name": "Chicken", "percentage": 20 },
    { "name": "Yogurt", "percentage": 10 },
    { "name": "Oil", "percentage": 5 },
    { "name": "Spices", "percentage": 5 }
  ],
  "preparationMethod": "Slow cooked rice and chicken with yogurt, spices, and rendered oil",
  "preparationNotes": "Mixed meal prepared using basmati rice, chicken, yogurt, oil, and common biryani spices. Recipe assumes typical restaurant-style portion.",
  "evidenceLevel": "B",
  "source": "India Food Composition Tables (IFCT) / National Institute of Nutrition India (expected)",
  "trustScore": 88,
  "confidence": "80-86"
}
```

### 3.2 Masala Dosa

```json
{
  "itemName": "Masala Dosa",
  "itemType": "food",
  "ingredientList": [
    { "name": "Rice Batter", "percentage": 55 },
    { "name": "Urad Dal Batter", "percentage": 25 },
    { "name": "Potato Masala", "percentage": 15 },
    { "name": "Oil", "percentage": 5 }
  ],
  "preparationMethod": "Fermented rice and dal batter cooked on a griddle, filled with potato masala",
  "preparationNotes": "Traditional South Indian dosa prepared from fermented rice/urad dal batter and stuffed with potato-seasoned masala.",
  "evidenceLevel": "B",
  "source": "India Food Composition Tables (IFCT) / FAO/WHO Glycemic Index tables (expected)",
  "trustScore": 88,
  "confidence": "80-86"
}
```

### 3.3 Pongal

```json
{
  "itemName": "Pongal",
  "itemType": "food",
  "ingredientList": [
    { "name": "Rice", "percentage": 60 },
    { "name": "Moong Dal", "percentage": 25 },
    { "name": "Ghee", "percentage": 10 },
    { "name": "Black Pepper", "percentage": 5 }
  ],
  "preparationMethod": "Boiled rice and split moong dal tempered with ghee and black pepper",
  "preparationNotes": "South Indian savory pongal. The recipe uses cooked rice, dal, ghee, and seasoning to capture meal structure for mixed-meal inference.",
  "evidenceLevel": "B",
  "source": "India Food Composition Tables (IFCT) / National Institute of Nutrition India (expected)",
  "trustScore": 88,
  "confidence": "80-86"
}
```

#### Meal CSV sample

```csv
itemName,itemType,ingredientList,ingredientPercentages,preparationMethod,preparationNotes,evidenceLevel,source,trustScore,confidence
Chicken Biryani,food,"Basmati Rice|Chicken|Yogurt|Oil|Spices","60|20|10|5|5","Slow cooked rice and chicken with yogurt, spices, and rendered oil","Mixed meal prepared using basmati rice, chicken, yogurt, oil, and common biryani spices.",B,"India Food Composition Tables (IFCT) / National Institute of Nutrition India (expected)",88,"80-86"
Masala Dosa,food,"Rice Batter|Urad Dal Batter|Potato Masala|Oil","55|25|15|5","Fermented rice and dal batter cooked on a griddle, filled with potato masala","Traditional South Indian dosa prepared from fermented rice/urad dal batter and stuffed with potato-seasoned masala.",B,"India Food Composition Tables (IFCT) / FAO/WHO Glycemic Index tables (expected)",88,"80-86"
Pongal,food,"Rice|Moong Dal|Ghee|Black Pepper","60|25|10|5","Boiled rice and split moong dal tempered with ghee and black pepper","South Indian savory pongal with cooked rice, dal, ghee, and seasoning.",B,"India Food Composition Tables (IFCT) / National Institute of Nutrition India (expected)",88,"80-86"
```

---

## Part 4 – Product Seed Records

### Product records

```json
[
  {
    "brand": "Coca-Cola",
    "productName": "Coke Zero",
    "productCategory": "Beverage",
    "barcode": "placeholder-0001",
    "nutritionSource": "Manufacturer nutrition label",
    "marketingClaims": ["zero sugar", "zero calories"],
    "availableCarbohydrates": 0,
    "GI": 0,
    "GL": 0,
    "GIStatus": "Published",
    "evidenceLevel": "C",
    "source": "Manufacturer nutrition label / product composition",
    "trustScore": 75,
    "confidence": "70-76"
  },
  {
    "brand": "PepsiCo",
    "productName": "Pepsi Zero",
    "productCategory": "Beverage",
    "barcode": "placeholder-0002",
    "nutritionSource": "Manufacturer nutrition label",
    "marketingClaims": ["zero sugar", "zero calories"],
    "availableCarbohydrates": 0,
    "GI": 0,
    "GL": 0,
    "GIStatus": "Published",
    "evidenceLevel": "C",
    "source": "Manufacturer nutrition label / product composition",
    "trustScore": 75,
    "confidence": "70-76"
  },
  {
    "brand": "Britannia",
    "productName": "Britannia NutriChoice",
    "productCategory": "Snack",
    "barcode": "placeholder-0003",
    "nutritionSource": "Manufacturer nutrition label",
    "marketingClaims": ["high fiber", "whole grain"],
    "availableCarbohydrates": "unavailable",
    "GI": "unavailable",
    "GL": "unavailable",
    "GIStatus": "Estimated",
    "evidenceLevel": "C",
    "source": "Manufacturer nutrition label",
    "trustScore": 75,
    "confidence": "70-76"
  },
  {
    "brand": "RiteBite",
    "productName": "RiteBite Protein Bar",
    "productCategory": "Snack",
    "barcode": "placeholder-0004",
    "nutritionSource": "Manufacturer nutrition label",
    "marketingClaims": ["high protein", "low sugar"],
    "availableCarbohydrates": "unavailable",
    "GI": "unavailable",
    "GL": "unavailable",
    "GIStatus": "Estimated",
    "evidenceLevel": "C",
    "source": "Manufacturer nutrition label",
    "trustScore": 75,
    "confidence": "70-76"
  },
  {
    "brand": "Yoga Bar",
    "productName": "Yoga Bar Protein Bar",
    "productCategory": "Snack",
    "barcode": "placeholder-0005",
    "nutritionSource": "Manufacturer nutrition label",
    "marketingClaims": ["high protein", "low sugar"],
    "availableCarbohydrates": "unavailable",
    "GI": "unavailable",
    "GL": "unavailable",
    "GIStatus": "Estimated",
    "evidenceLevel": "C",
    "source": "Manufacturer nutrition label",
    "trustScore": 75,
    "confidence": "70-76"
  }
]
```

#### Product CSV sample

```csv
brand,productName,productCategory,barcode,nutritionSource,marketingClaims,availableCarbohydrates,GI,GL,GIStatus,evidenceLevel,source,trustScore,confidence
Coca-Cola,Coke Zero,Beverage,placeholder-0001,Manufacturer nutrition label,"zero sugar|zero calories",0,0,0,Published,C,"Manufacturer nutrition label / product composition",75,"70-76"
PepsiCo,Pepsi Zero,Beverage,placeholder-0002,Manufacturer nutrition label,"zero sugar|zero calories",0,0,0,Published,C,"Manufacturer nutrition label / product composition",75,"70-76"
Britannia,Britannia NutriChoice,Snack,placeholder-0003,Manufacturer nutrition label,"high fiber|whole grain",unavailable,unavailable,unavailable,Estimated,C,Manufacturer nutrition label,75,"70-76"
RiteBite,RiteBite Protein Bar,Snack,placeholder-0004,Manufacturer nutrition label,"high protein|low sugar",unavailable,unavailable,unavailable,Estimated,C,Manufacturer nutrition label,75,"70-76"
Yoga Bar,Yoga Bar Protein Bar,Snack,placeholder-0005,Manufacturer nutrition label,"high protein|low sugar",unavailable,unavailable,unavailable,Estimated,C,Manufacturer nutrition label,75,"70-76"
```

---

## Part 5 – Seed Dataset Validation

### 5.1 Completeness checks
- Required fields exist for every record.
- Ingredient records include `canonicalName`, `category`, `region`, `GIStatus`, `evidenceLevel`, `source`, `trustScore`, and `confidence`.
- Food records include `ingredientList`, `preparationMethod`, and `preparationNotes`.
- Product records include `brand`, `productName`, `barcode`, `nutritionSource`, and `marketingClaims`.

### 5.2 Evidence checks
- Every record uses approved evidence sources or clearly marks `unavailable` when evidence is missing.
- Ingredient GI values use published/measured evidence only from approved sources.
- Product records with manufacturer label data are assigned evidence level `C`.
- Mixed-meal records are assigned evidence level `B` because they are structured estimates based on approved corpus guidance.

### 5.3 Trust checks
- `trustScore` values fall within the approved ranges:
  - A: 90-95
  - B: 75-90
  - C: 65-80
- Records without full GI/GL evidence do not exceed the trust range for their evidence level.
- Confidence ranges are documented for all records.

### 5.4 Import readiness checks
- JSON arrays are valid and each object contains the required schema fields.
- CSV files include the required header rows and encode unavailable values consistently.
- Import sequencing is respected: sources → ingredients → products → foods → meal decompositions.
- Meal decomposition percentages sum to 100 or are explicitly documented when the composition is partial.

---

Ready for JSON/CSV generation?
