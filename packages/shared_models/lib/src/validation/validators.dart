import 'package:shared_core/shared_core.dart';

import '../enums/evidence_level.dart';
import '../enums/source_type.dart';

abstract final class Validators {
  static void validateId(String field, String value) {
    Guard.againstEmpty(value, name: field);
  }

  static void validateNonEmptyString(String field, String value) {
    Guard.againstEmpty(value, name: field);
  }

  static void validateStringList(String field, List<String> values) {
    for (final value in values) {
      if (value.trim().isEmpty) {
        throw ValidationException(
          field: field,
          message: 'All list entries must be non-empty strings.',
          validationCode: 'invalid',
        );
      }
    }
  }

  static void validateConfidenceRange(String field, int value) {
    Guard.againstOutOfRange(value, name: field, min: 0, max: 100);
  }

  static void validateGiRange(String field, int value) {
    Guard.againstOutOfRange(value, name: field, min: 0, max: 100);
  }

  static void validateTrustScoreRange(String field, int value) {
    Guard.againstOutOfRange(value, name: field, min: 0, max: 100);
  }

  static void validateEvidenceLevel(String field, EvidenceLevel level) {
    if (level == EvidenceLevel.unknown) {
      throw ValidationException(
        field: field,
        message: 'Evidence level must be A, B, C, or D.',
        validationCode: 'invalid',
      );
    }
  }

  static void validateSourceType(String field, SourceType type) {
    if (type == SourceType.unknown) {
      throw ValidationException(
        field: field,
        message: 'Source type cannot be unknown.',
        validationCode: 'invalid',
      );
    }
  }

  static void validateSourceIds(String field, List<String> sourceIds) {
    Guard.againstEmptyList(sourceIds, name: field);
    validateStringList(field, sourceIds);
  }
}
