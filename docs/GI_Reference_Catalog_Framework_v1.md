# GlyLens GI Reference Catalog Framework v1.0
_Last Updated: 2026-06-20_

This document defines the GlyLens GI/GL Reference Catalog Framework for the approved corpus package and gap analysis. It captures the metadata structure required to support a tiered food intelligence catalog for:

- 50 Ingredients
- 50 Foods
- 50 Products

Every catalog item supports:

- GI (Glycemic Index)
- GL (Glycemic Load)
- Evidence
- Source
- Trust Score
- Confidence Score
- Measured vs Estimated flag
- Acquisition Date

## 1. Framework Overview

The GI Reference Catalog Framework is designed for evidence-first food intelligence. It separates core reference values from provenance, source citation, preparation metadata, serving definition, and confidence calibration.

Key design goals:

- Standardized metadata across Ingredients, Foods, and Products
- Explicit support for measured vs estimated values
- Trust and confidence scores linked to source and evidence provenance
- Clear preparation and serving context for GI/GL interpretation
- Scalability to an initial catalog of 50 ingredient, 50 food, and 50 product records

## 2. GI Reference Schema

### 2.1 Purpose

The GI Reference Schema captures the glycemic index value, measurement metadata, and item-level linking for each catalog record.

### 2.2 Fields

- `giReferenceId` — Unique identifier for the GI reference record
- `itemType` — `ingredient`, `food`, or `product`
- `itemId` — Linked item identifier from the catalog
- `itemName` — Canonical name of the ingredient, food, or product
- `itemCategory` — Food category or product class (e.g. `grain`, `dairy`, `mixed meal`, `snack`)
- `giValue` — Numeric GI value
- `giUnit` — Unit descriptor (`GI index`)
- `giMeasurementMethod` — `in vivo`, `in vitro`, `reference food protocol`, `calculated`
- `measuredFlag` — `measured` or `estimated`
- `measuredDate` — Date of measurement or estimation
- `sourceId` — Primary source identifier
- `citationIds` — Array of linked source citations
- `evidenceLevel` — Evidence grade (`A`, `B`, `C`, `D`)
- `trustScore` — Trust score (0-100)
- `confidenceScore` — Confidence score (0-100)
- `acquisitionDate` — Date the GI value entered the catalog
- `notes` — Free-text notes on condition, population, or experiment

### 2.3 Example

```yaml
giReferenceId: gi-ref-001
itemType: ingredient
itemId: ingr-001
itemName: Basmati Rice
itemCategory: grain
giValue: 52
giUnit: GI index
giMeasurementMethod: in vivo
measuredFlag: measured
measuredDate: 2025-08-12
sourceId: src-001
citationIds: [cite-001, cite-007]
evidenceLevel: A
trustScore: 92
confidenceScore: 88
acquisitionDate: 2026-06-20
notes: Low-GI basmati reference from USDA and FAO/WHO combined sources.
```

## 3. GL Reference Schema

### 3.1 Purpose

The GL Reference Schema captures glycemic load and associated carbohydrate and serving size metadata for accurate meal-level assessment.

### 3.2 Fields

- `glReferenceId` — Unique identifier for the GL reference record
- `itemType` — `ingredient`, `food`, or `product`
- `itemId` — Linked item identifier from the catalog
- `itemName` — Canonical name of the item
- `glValue` — Numeric GL value
- `glUnit` — Unit descriptor (`GL per serving`)
- `availableCarbs` — Available carbohydrates per serving in grams
- `digestibleCarbs` — Digestible carbohydrate measurement if available
- `servingSizeId` — Linked serving size metadata identifier
- `servingDescription` — Human-readable serving description
- `glCalculationMethod` — `measured`, `calculated`, `estimated`
- `measuredFlag` — `measured` or `estimated`
- `sourceId` — Primary source identifier
- `citationIds` — Array of linked source citations
- `evidenceLevel` — Evidence grade (`A`, `B`, `C`, `D`)
- `trustScore` — Trust score (0-100)
- `confidenceScore` — Confidence score (0-100)
- `acquisitionDate` — Date the GL value entered the catalog
- `notes` — Free-text context for calculation assumptions

### 3.3 Example

```yaml
glReferenceId: gl-ref-012
itemType: food
itemId: food-012
itemName: Oats Porridge
glValue: 14
glUnit: GL per serving
availableCarbs: 27
digestibleCarbs: 24
servingSizeId: serving-014
servingDescription: 1 cup cooked
glCalculationMethod: measured
measuredFlag: measured
sourceId: src-001
citationIds: [cite-002]
evidenceLevel: A
trustScore: 90
confidenceScore: 86
acquisitionDate: 2026-06-20
notes: GL derived from USDA nutrient profile matched to measured GI.
```

## 4. Source Citation Schema

### 4.1 Purpose

The Source Citation Schema standardizes provenance and trust metadata for all supporting references.

### 4.2 Fields

- `citationId` — Unique identifier for the citation record
- `sourceId` — Primary source identifier
- `sourceName` — Name of the dataset, publication, or database
- `sourceType` — `government`, `academic`, `industry`, `openData`, `clinical study`
- `publisher` — Organization or author
- `publicationDate` — Date of publication or dataset release
- `datasetVersion` — Version string if available
- `url` — Source URL or DOI
- `geographicCoverage` — `global`, `US`, `India`, or region-specific descriptor
- `evidenceGrade` — Evidence grade (`A`, `B`, `C`, `D`)
- `trustScore` — Trust score (0-100)
- `sourceConfidence` — Confidence in the source itself (0-100)
- `extractionMethod` — `manual extraction`, `API ingest`, `OCR`, `dataset import`
- `acquisitionDate` — Date the citation was ingested
- `notes` — Context about the citation or data quality

### 4.3 Example

```yaml
citationId: cite-001
sourceId: src-001
sourceName: USDA FoodData Central
sourceType: government
publisher: United States Department of Agriculture
publicationDate: 2025-07-01
datasetVersion: 4.2
url: https://fdc.nal.usda.gov/
geographicCoverage: US
evidenceGrade: A
trustScore: 93
sourceConfidence: 92
extractionMethod: dataset import
acquisitionDate: 2026-06-20
notes: Primary nutrient composition and GI supporting source for US foods.
```

## 5. Evidence Provenance Schema

### 5.1 Purpose

The Evidence Provenance Schema links catalog records to the exact evidence chain behind GI/GL values.

### 5.2 Fields

- `provenanceId` — Unique identifier for the provenance record
- `itemId` — Linked ingredient, food, or product identifier
- `referenceType` — `GI`, `GL`, or `combined`
- `sourceId` — Primary source identifier
- `citationIds` — Array of linked citation identifiers
- `rawDataReference` — Path or URL to raw evidence dataset
- `publicationId` — Journal article, report, or dataset identifier
- `extractionDate` — Date evidence was extracted from source
- `evidenceType` — `measured`, `estimated`, `meta-analysis`, `compilation`
- `measuredFlag` — `measured` or `estimated`
- `analysisTechnique` — `GI protocol`, `GL calculation`, `nutrient model`
- `populationContext` — Study population or sample description
- `preparationContext` — Preparation metadata identifier or description
- `confidenceScore` — Confidence score (0-100)
- `trustScore` — Trust score (0-100)
- `acquisitionDate` — Date provenance record was added
- `notes` — Additional provenance commentary

### 5.3 Example

```yaml
provenanceId: prov-001
itemId: food-009
referenceType: GI
sourceId: src-004
citationIds: [cite-005]
rawDataReference: https://faowho.org/gi-tables/2024
publicationId: pub-2024-gi-001
extractionDate: 2025-09-15
evidenceType: measured
measuredFlag: measured
analysisTechnique: GI protocol with glucose reference food
populationContext: healthy adult volunteers
temperature: 37 C
preparationContext: preparation-004
confidenceScore: 89
trustScore: 91
acquisitionDate: 2026-06-20
notes: Reference from FAO/WHO GI tables for Indian idli.
```

## 6. Food Preparation Metadata Schema

### 6.1 Purpose

Food Preparation Metadata provides cooking, ingredient, and recipe context needed to interpret GI/GL values accurately.

### 6.2 Fields

- `preparationId` — Unique identifier for the preparation metadata record
- `itemId` — Linked food or product identifier
- `itemType` — `food` or `product`
- `preparationMethod` — `boiled`, `steamed`, `grilled`, `baked`, `fried`, `powdered`, `raw`
- `cookingTechnique` — `pressure cooking`, `pan fry`, `roasting`, `steaming`, `stir fry`
- `ingredientList` — Array of key ingredients and proportions
- `recipeVariant` — `traditional`, `low-oil`, `sprouted`, `fermented`, `gluten-free`
- `regionalCuisine` — `Indian`, `US`, `South Asian`, `Mediterranean`
- `mealType` — `breakfast`, `lunch`, `dinner`, `snack`, `beverage`
- `servingContext` — `restaurant`, `home`, `ready-to-eat`, `prepared`
- `additives` — `oil`, `sugar`, `salt`, `spices`, `sweetener`
- `preparationNotes` — Free-text description of preparation specifics
- `preparationDate` — Date the preparation metadata was recorded
- `acquisitionDate` — Date the preparation metadata entered the catalog

### 6.3 Example

```yaml
preparationId: preparation-004
itemId: food-009
itemType: food
preparationMethod: steamed
cookingTechnique: batter fermentation and griddle cook
ingredientList:
  - dosa batter (rice, urad dal)
  - water
  - salt
recipeVariant: sprouted lentil dosa
regionalCuisine: Indian
mealType: breakfast
servingContext: restaurant
additives:
  - oil
  - salt
preparationNotes: Low-oil dosa made from sprouted lentil and rice batter.
preparationDate: 2026-06-20
acquisitionDate: 2026-06-20
```

## 7. Serving Size Metadata Schema

### 7.1 Purpose

Serving Size Metadata defines the portion size used to calculate GL and to normalize GI data.

### 7.2 Fields

- `servingSizeId` — Unique identifier for the serving size record
- `itemId` — Linked ingredient, food, or product identifier
- `itemType` — `ingredient`, `food`, or `product`
- `servingName` — `standard serving`, `cup`, `piece`, `slice`, `packet`
- `weightGrams` — Weight in grams
- `volumeMilliliters` — Volume in milliliters where applicable
- `householdMeasure` — `1 cup`, `1 tablespoon`, `1 medium`, `1 slice`
- `servingCount` — Quantity count when multiple units are grouped
- `calculationBasis` — `average`, `measured`, `manufacturer label`
- `precision` — `exact`, `rounded`, `estimated`
- `referencePerson` — `adult`, `child`, `diabetic`, `pregnant`
- `measurementMethod` — `direct weigh`, `nutrient label`, `literature`
- `sourceId` — Source identifier for serving size metadata
- `acquisitionDate` — Date the serving size record entered catalog
- `notes` — Additional serving context

### 7.3 Example

```yaml
servingSizeId: serving-014
itemId: food-012
itemType: food
servingName: 1 cup cooked
type: standard serving
weightGrams: 240
volumeMilliliters: 240
householdMeasure: 1 cup
servingCount: 1
calculationBasis: measured
precision: exact
referencePerson: adult
measurementMethod: direct weigh
sourceId: src-001
acquisitionDate: 2026-06-20
notes: Standard US serving size for cooked oats porridge.
```

## 8. Confidence Calibration Metadata Schema

### 8.1 Purpose

Confidence Calibration Metadata records how trust and confidence are determined for each catalog reference.

### 8.2 Fields

- `confidenceCalibrationId` — Unique identifier for the calibration record
- `itemId` — Linked ingredient, food, or product identifier
- `itemType` — `ingredient`, `food`, `product`, or `reference`
- `referenceId` — Linked GI or GL reference identifier
- `confidenceScore` — Confidence score (0-100)
- `trustScore` — Trust score (0-100)
- `calibrationBasis` — `source quality`, `measurement method`, `sample size`, `population match`, `preparation match`
- `calibrationSource` — `USDA`, `IFCT`, `FAO/WHO`, `clinical trial`, `vendor label`
- `scoreRange` — `0-100`
- `errorMargin` — `± value`
- `dateCalibrated` — Date calibration was performed
- `calibratedBy` — Analyst, team, or automated process
- `notes` — Calibration rationale or caveats

### 8.3 Example

```yaml
confidenceCalibrationId: calib-001
itemId: food-012
itemType: food
referenceId: gl-ref-012
confidenceScore: 86
trustScore: 90
calibrationBasis: measurement method and source quality
calibrationSource: USDA FoodData Central
scoreRange: 0-100
errorMargin: ±4
dateCalibrated: 2026-06-20
calibratedBy: GlyLens evidence team
notes: Confidence calibrated against source trust and GI/GL measurement protocol.
```

## 9. Item Templates

These templates provide the canonical structure for Ingredients, Foods, and Products in the GI Reference Catalog.

### 9.1 Ingredient Template

- `ingredientId`
- `ingredientName`
- `ingredientCategory`
- `synonyms`
- `regionCoverage`
- `dietaryTags`
- `giReferenceId`
- `glReferenceId`
- `sourceId`
- `citationIds`
- `provenanceId`
- `servingSizeId`
- `confidenceCalibrationId`
- `measuredFlag`
- `trustScore`
- `confidenceScore`
- `acquisitionDate`
- `notes`

### 9.2 Food Template

- `foodId`
- `foodName`
- `foodCategory`
- `mealType`
- `regionalCuisine`
- `ingredientIds`
- `recipeVariant`
- `preparationId`
- `giReferenceId`
- `glReferenceId`
- `sourceId`
- `citationIds`
- `provenanceId`
- `servingSizeId`
- `confidenceCalibrationId`
- `measuredFlag`
- `trustScore`
- `confidenceScore`
- `acquisitionDate`
- `notes`

### 9.3 Product Template

- `productId`
- `productName`
- `brandName`
- `productCategory`
- `packagingFormat`
- `nutritionClaim`
- `ingredientIds`
- `preparationId`
- `giReferenceId`
- `glReferenceId`
- `sourceId`
- `citationIds`
- `provenanceId`
- `servingSizeId`
- `confidenceCalibrationId`
- `measuredFlag`
- `trustScore`
- `confidenceScore`
- `acquisitionDate`
- `notes`

## 10. Catalog Scale and Capacity

The GI Reference Catalog Framework is intentionally designed to support an initial seed corpus of:

- 50 Ingredient records
- 50 Food records
- 50 Product records

Each record contains standardized GI, GL, evidence, source, trust, confidence, measured status, and acquisition date metadata.

## 11. Implementation Notes

- All numeric scores use a 0-100 scale.
- `measuredFlag` must be present for all GI/GL references.
- Every item record should link to at least one `sourceId` and one `citationId`.
- Preparation and serving metadata are required for meal and product references to avoid GI/GL misclassification.
- Confidence calibration is mandatory for all catalog entries used in decisioning or scoring.
