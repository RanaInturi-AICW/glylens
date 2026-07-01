import 'package:shared_core/shared_core.dart';

final class Barcode extends ValueObject<String> {
  Barcode(String value) : super(Guard.againstEmpty(value, name: 'barcode')) {
    if (!RegExp(r'^\d{8,14}$').hasMatch(value)) {
      throw ValidationException(
        field: 'barcode',
        message: 'Barcode must contain 8 to 14 digits.',
        validationCode: 'invalid',
      );
    }
  }

  factory Barcode.fromJson(String value) => Barcode(value);

  String toJson() => value;
}
