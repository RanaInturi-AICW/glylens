import '../errors/validation_error.dart';
import '../enums/evidence_level.dart';
import '../enums/source_type.dart';

class Validators {
  static void validateId(String field, String value) {
    if (value.isEmpty) {
      throw ValidationError(field: field, message: 'Identifier cannot be empty.', code: 'required');
    }
  }

  static void validateNonEmptyString(String field, String value) {
    if (value.trim().isEmpty) {
      throw ValidationError(field: field, message: 'Value cannot be empty.', code: 'required');
    }
  }

  static void validateListHasValues(String field, List<String> values) {
    if (values.isEmpty) {
      throw ValidationError(field: field, message: 'List must contain at least one element.', code: 'required');
    }
  }

  static void validateStringList(String field, List<String> values) {
    for (final value in values) {
      if (value.trim().isEmpty) {
        throw ValidationError(field: field, message: 'All list entries must be non-empty strings.', code: 'invalid');
      }
    }
  }

  static void validatePortionProfiles(String field, List<Map<String, dynamic>> portionProfiles) {
    for (final portion in portionProfiles) {
      if (portion['serving'] is! String || (portion['serving'] as String).trim().isEmpty) {
        throw ValidationError(field: field, message: 'Each portion profile must include a non-empty serving label.', code: 'invalid');
      }
      final grams = portion['grams'];
      if (grams is! num || grams <= 0) {
        throw ValidationError(field: field, message: 'Each portion profile must include a positive grams value.', code: 'invalid');
      }
    }
  }

  static void validateGiRange(String field, int value) {
    if (value < 0 || value > 100) {
      throw ValidationError(field: field, message: 'GI must be between 0 and 100.', code: 'out_of_range');
    }
  }

  static void validateConfidenceRange(String field, int value) {
    if (value < 0 || value > 100) {
      throw ValidationError(field: field, message: 'Confidence must be between 0 and 100.', code: 'out_of_range');
    }
  }

  static void validateTrustScoreRange(String field, int value) {
    if (value < 0 || value > 100) {
      throw ValidationError(field: field, message: 'Trust score must be between 0 and 100.', code: 'out_of_range');
    }
  }

  static void validateEvidenceLevel(String field, EvidenceLevel level) {
    if (level == EvidenceLevel.unknown) {
      throw ValidationError(field: field, message: 'Evidence level must be A, B, C, or D.', code: 'invalid');
    }
  }

  static void validateSourceType(String field, SourceType type) {
    if (type == SourceType.unknown) {
      throw ValidationError(field: field, message: 'Source type cannot be unknown.', code: 'invalid');
    }
  }

  static void validateSourceIds(String field, List<String> sourceIds) {
    validateListHasValues(field, sourceIds);
    for (final id in sourceIds) {
      if (id.trim().isEmpty) {
        throw ValidationError(field: field, message: 'Source IDs must be valid non-empty strings.', code: 'invalid');
      }
    }
  }
}
