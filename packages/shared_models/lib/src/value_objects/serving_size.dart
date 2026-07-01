import 'package:shared_core/shared_core.dart';

/// Positive serving mass in grams.
final class ServingSize extends ValueObject<double> {
  ServingSize(double value) : super(Guard.againstNegative(value, name: 'grams')) {
    if (value == 0) {
      throw ValidationException(
        field: 'grams',
        message: 'Serving size must be greater than zero.',
        validationCode: 'invalid',
      );
    }
  }

  factory ServingSize.fromJson(num value) => ServingSize(value.toDouble());

  num toJson() => value;
}
