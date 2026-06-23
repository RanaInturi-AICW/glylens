# Domain Layer Folder Structure

This document describes the domain-layer-only folder structure and files generated for the GlyLens project.

## lib/core/domain

- `entities/`
  - `evidence.dart`
  - `food.dart`
  - `glycemic_profile.dart`
  - `ingredient.dart`
  - `product.dart`
  - `source.dart`

- `enums/`
  - `evidence_level.dart`
  - `food_category.dart`
  - `processing_level.dart`
  - `source_type.dart`

- `errors/`
  - `domain_error.dart`
  - `low_confidence_error.dart`
  - `missing_gi_error.dart`
  - `validation_error.dart`

- `validation/`
  - `validators.dart`

- `value_objects/`
  - `confidence_score.dart`
  - `gl_value.dart`
  - `gi_value.dart`
  - `impact_score.dart`
  - `trust_score.dart`

## test/domain

- `entities_test.dart`
- `validation_test.dart`
- `value_objects_test.dart`
