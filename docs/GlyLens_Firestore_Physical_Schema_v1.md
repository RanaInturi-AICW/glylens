# GlyLens Firestore Physical Schema v1.0
_Last Updated: 2026-06-20_

## Design Goals
- Low cost
- Fast reads
- Minimal joins
- Vendor-neutral business logic

## Collections

### ingredients/{ingredientId}
- name
- aliases
- category
- nutritionProfileId
- glycemicProfileId
- evidenceLevel
- sourceIds

### foods/{foodId}
- name
- category
- region
- ingredientRefs[]
- variantRefs[]

### products/{productId}
- barcode
- brand
- name
- ingredientRefs[]
- nutritionProfileId

### users/{userId}
- tier
- preferences
- createdAt

### users/{userId}/food_scans/{scanId}
- inputType
- resultRef
- timestamp

### users/{userId}/comparisons/{comparisonId}
- foodA
- foodB
- timestamp

## Index Strategy
Create indexes for:
- foods.name
- products.barcode
- ingredients.name
- users.food_scans.timestamp desc

## Cost Rules
- Cache lookup results
- Avoid fan-out queries
- Read optimized design
