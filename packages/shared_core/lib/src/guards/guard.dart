import '../errors/domain_exception.dart';

/// Guard clauses for domain invariants.
abstract final class Guard {
  static String againstEmpty(String? value, {required String name}) {
    if (value == null || value.trim().isEmpty) {
      throw ValidationException(
        field: name,
        message: 'Value cannot be empty.',
        validationCode: 'required',
      );
    }
    return value;
  }

  static int againstOutOfRange(
    int value, {
    required String name,
    required int min,
    required int max,
  }) {
    if (value < min || value > max) {
      throw ValidationException(
        field: name,
        message: 'Value must be between $min and $max.',
        validationCode: 'out_of_range',
      );
    }
    return value;
  }

  static double againstNegative(double value, {required String name}) {
    if (value < 0) {
      throw ValidationException(
        field: name,
        message: 'Value must be zero or positive.',
        validationCode: 'out_of_range',
      );
    }
    return value;
  }

  static List<T> againstEmptyList<T>(List<T> values, {required String name}) {
    if (values.isEmpty) {
      throw ValidationException(
        field: name,
        message: 'List must contain at least one element.',
        validationCode: 'required',
      );
    }
    return values;
  }
}
