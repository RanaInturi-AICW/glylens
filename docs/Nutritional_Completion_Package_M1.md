# GlyLens Nutritional Completion Package M1
_Last Updated: 2026-06-20_

> **Repository Status: ACTIVE (Acquisition Draft — NOT CANONICAL)**  
> Published runtime values remain in `docs/GlyLens_Reference_Catalog_v1.md` until validated and published via `docs/GlyLens_Corpus_Acquisition_Workflow_v1.md`.  
> Do not treat this document as runtime truth without workflow Stage 6 publication.

This package completes the nutrition profile for the Top 10 Ingredients already included in the GlyLens M1 corpus population.

It is based on:
- `docs/GlyLens_Reference_Catalog_v1.md`
- `docs/Corpus_Population_Package_M1.md`
- `docs/GI_Reference_Catalog_Framework_v1.md`
- USDA FoodData Central references
- India Food Composition Tables (IFCT) references
- National Institute of Nutrition India references

## Scope

For each top 10 ingredient, this package provides:
1. Available Carbohydrates
2. Fiber
3. Protein
4. Fat
5. Serving Size Standardization
6. GL Value where possible

For every reported field, the package provides:
- Source
- Evidence Level
- Trust Score

All values are anchored to authoritative nutrition reference sources where available.
Unknown values are explicitly marked `unavailable`.

---

## 1. Ingredient Nutrition Completion

### 1.1 Basmati Rice
- canonicalName: Basmati Rice
- servingSize: 1 cup cooked (158 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- availableCarbohydrates: 44.4 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- fiber: 0.6 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- protein: 4.3 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- fat: 0.4 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- glValue: 23.1
  - source: calculated from GI value (52) and available carbohydrates from USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92

### 1.2 Brown Rice
- canonicalName: Brown Rice
- servingSize: 1 cup cooked (195 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- availableCarbohydrates: 41.5 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- fiber: 3.5 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- protein: 5.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- fat: 1.8 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- glValue: 22.8
  - source: calculated from GI value (55) and available carbohydrates from USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91

### 1.3 Rolled Oats
- canonicalName: Rolled Oats
- servingSize: 1 cup cooked (234 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 90
- availableCarbohydrates: 23.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 90
- fiber: 4.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 90
- protein: 5.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 90
- fat: 3.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 90
- glValue: 12.7
  - source: calculated from GI value (55) and available carbohydrates from USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 90

### 1.4 Whole Wheat Flour
- canonicalName: Whole Wheat Flour
- servingSize: 1 cup (120 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 88
- availableCarbohydrates: 72.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 88
- fiber: 15.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 88
- protein: 16.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 88
- fat: 2.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 88
- glValue: unavailable
  - reason: GL is not directly calculable for raw flour without a finished serving context
  - evidenceLevel: B
  - trustScore: 78

### 1.5 Chickpea
- canonicalName: Chickpea
- servingSize: 1 cup cooked (164 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- availableCarbohydrates: 32.5 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- fiber: 12.5 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- protein: 14.5 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- fat: 4.2 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- glValue: 9.1
  - source: calculated from GI value (28) and available carbohydrates from USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92

### 1.6 Red Lentil
- canonicalName: Red Lentil
- servingSize: 1 cup cooked (198 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 93
- availableCarbohydrates: 24.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 93
- fiber: 16.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 93
- protein: 18.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 93
- fat: 1.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 93
- glValue: 5.0
  - source: calculated from GI value (21) and available carbohydrates from USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 93

### 1.7 Green Lentil
- canonicalName: Green Lentil
- servingSize: 1 cup cooked (198 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- availableCarbohydrates: 24.5 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- fiber: 15.5 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- protein: 18.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- fat: 1.1 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- glValue: 7.1
  - source: calculated from GI value (29) and available carbohydrates from USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92

### 1.8 Mung Bean
- canonicalName: Mung Bean
- servingSize: 1 cup cooked (202 g)
  - source: India Food Composition Tables (IFCT)
  - evidenceLevel: B
  - trustScore: 88
- availableCarbohydrates: 24.0 g
  - source: India Food Composition Tables (IFCT)
  - evidenceLevel: B
  - trustScore: 88
- fiber: 15.0 g
  - source: India Food Composition Tables (IFCT)
  - evidenceLevel: B
  - trustScore: 88
- protein: 14.0 g
  - source: India Food Composition Tables (IFCT)
  - evidenceLevel: B
  - trustScore: 88
- fat: 0.8 g
  - source: India Food Composition Tables (IFCT)
  - evidenceLevel: B
  - trustScore: 88
- glValue: 7.4
  - source: calculated from GI value (31) and available carbohydrates from IFCT
  - evidenceLevel: B
  - trustScore: 88

### 1.9 Kidney Bean
- canonicalName: Kidney Bean
- servingSize: 1 cup cooked (177 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- availableCarbohydrates: 27.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- fiber: 13.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- protein: 15.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- fat: 0.9 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92
- glValue: 6.5
  - source: calculated from GI value (24) and available carbohydrates from USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 92

### 1.10 Soybean
- canonicalName: Soybean
- servingSize: 1 cup cooked (172 g)
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- availableCarbohydrates: 6.8 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- fiber: 10.3 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- protein: 29.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- fat: 15.0 g
  - source: USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91
- glValue: 1.0
  - source: calculated from GI value (15) and available carbohydrates from USDA FoodData Central
  - evidenceLevel: A
  - trustScore: 91

---

## 2. Completion Notes

- Serving sizes are standardized to the most common reference portion for the ingredient and are anchored to USDA FoodData Central or IFCT standard servings.
- GL values are calculated where available carbohydrates and GI values are both present.
- Whole Wheat Flour GL is marked `unavailable` because a raw ingredient serving is not a finished food portion for direct glycemic load interpretation.
- All macro values are sourced from authoritative national composition references and assigned evidence and trust metadata based on the GlyLens source registry.
