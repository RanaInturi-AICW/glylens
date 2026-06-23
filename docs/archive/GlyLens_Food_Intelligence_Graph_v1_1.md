# GlyLens Food Intelligence Graph Specification v1.1
_Last Updated: 2026-06-20_

## Purpose

The Food Intelligence Graph (FIG) is the foundational intellectual property of GlyLens.

It serves as:

- Source of Truth
- Food Knowledge Graph
- Glycemic Intelligence Layer
- Explainability Engine
- Future API Platform

---

# Design Principles

1. Ingredient-First Modeling
2. Evidence-Based Intelligence
3. Explainability First
4. Cost Optimization
5. Vendor-Neutral Design
6. Global Food Coverage
7. Extensible Ontology

---

# High-Level Entity Model

Ingredient
↓
Food
↓
Food Variant
↓
Product
↓
Glycemic Profile
↓
Evidence
↓
Source

---

# Entity: Ingredient

Represents the smallest nutritional unit.

Examples:
- Basmati Rice
- Brown Rice
- Jamun
- Apple
- Chicken
- Egg
- Yogurt
- Sugar

## Schema

```json
{
  "ingredient_id": "ing_basmati_rice",
  "name": "Basmati Rice",
  "aliases": [],
  "category": "grain",
  "nutrition_profile_id": "",
  "glycemic_profile_id": "",
  "processing_level": "moderate",
  "sources": []
}
```

---

# Entity: Nutrition Profile

```json
{
  "nutrition_profile_id": "",
  "calories": 0,
  "carbohydrates": 0,
  "available_carbohydrates": 0,
  "fiber": 0,
  "protein": 0,
  "fat": 0,
  "sugar": 0,
  "serving_size_grams": 100
}
```

---

# Entity: Glycemic Profile

```json
{
  "glycemic_profile_id": "",
  "gi": 58,
  "gl": 12,
  "impact_score": 72,
  "confidence_score": 82,
  "evidence_level": "A"
}
```

---

# Entity: Food

A food is a composition of ingredients.

Examples:
- Chicken Biryani
- Masala Dosa
- Pizza
- Burger
- Poha

## Schema

```json
{
  "food_id": "",
  "name": "",
  "category": "mixed_meal",
  "region": "global",
  "ingredients": [],
  "portion_profiles": [],
  "food_variants": []
}
```

---

# Food Composition Model

```json
{
  "ingredient_id": "ing_basmati_rice",
  "percentage": 65
}
```

Example:

Chicken Biryani

- Rice 65%
- Chicken 20%
- Oil 10%
- Yogurt 5%

---

# Entity: Food Variant

Examples:

- Hyderabad Biryani
- Lucknow Biryani
- Homemade Biryani

## Schema

```json
{
  "variant_id": "",
  "food_id": "",
  "name": "",
  "ingredients": [],
  "confidence": 75
}
```

---

# Entity: Product

Packaged food item.

Examples:

- Maggi
- Pepsi Zero
- Coke Zero

## Schema

```json
{
  "product_id": "",
  "barcode": "",
  "brand": "",
  "name": "",
  "ingredients": [],
  "nutrition_profile_id": "",
  "glycemic_profile_id": ""
}
```

---

# Entity: Source

Represents trusted sources.

Examples:

- USDA
- Open Food Facts
- GI Foundation

## Schema

```json
{
  "source_id": "",
  "name": "",
  "type": "",
  "url": "",
  "trust_score": 0
}
```

---

# Entity: Evidence

## Levels

A = Measured

B = Published Research

C = Ingredient Mapping

D = AI-Assisted Estimation

## Schema

```json
{
  "evidence_id": "",
  "level": "A",
  "confidence": 95,
  "source_ids": []
}
```

---

# Confidence Engine

## Inputs

- Evidence Level
- Source Quality
- Data Freshness
- Ingredient Coverage
- Portion Certainty

## Output

```json
{
  "confidence_score": 82
}
```

## Rules

A:
90-100

B:
80-90

C:
65-80

D:
50-65

Below 50:
Reject Estimate

---

# Glycemic Impact Engine

Purpose:

Produce a consumer-friendly score.

Users see:

Impact Score = 72

### Inputs

- GI
- GL
- Fiber
- Protein
- Processing Level
- Evidence Quality

### Outputs

```json
{
  "impact_score": 72,
  "impact_level": "moderate"
}
```

Formula remains proprietary.

---

# Explainability Engine

Every result must answer:

1. Why?
2. What contributed?
3. What improved the score?
4. What reduced the score?

Example:

Rice contributed 72% of glycemic load.

Protein reduced glycemic impact.

Large portion increased GL.

---

# Firestore Collections

ingredients

nutrition_profiles

glycemic_profiles

foods

food_variants

products

sources

evidence

users

food_scans

comparisons

assistant_conversations

---

# API Response Contract

```json
{
  "food_name": "",
  "gi": 58,
  "gl": 34,
  "impact_score": 72,
  "confidence_score": 82,
  "evidence_level": "C",
  "sources": [],
  "explanations": []
}
```

---

# Data Acquisition Strategy

Phase 1

- USDA FoodData Central
- Open Food Facts
- Public GI datasets

Phase 2

Normalize and persist.

Phase 3

Food Intelligence Graph becomes primary source.

---

# Non-Negotiable Rules

1. Never fabricate GI values.
2. Always show evidence level.
3. Always show confidence.
4. Always show sources.
5. Reject low-confidence estimates.
6. Preserve vendor neutrality.
7. Keep business logic independent of Firebase.

---

# Future Extensions

Phase 2
- Alternative food graph
- Portion optimization graph

Phase 3
- Personal intelligence layer

Phase 4
- Dietician intelligence layer

Phase 5
- Food Intelligence API Platform
