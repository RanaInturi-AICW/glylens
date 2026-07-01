import '../errors/validation_error.dart';
import '../validation/validators.dart';

class ImpactScore {
  final int value;
  final String category;

  ImpactScore({required this.value, required this.category}) {
    Validators.validateConfidenceRange('impactScore', value);
    if (category.trim().isEmpty) {
      throw ValidationError(field: 'category', message: 'Impact category cannot be empty.', code: 'required');
    }
  }

  bool get isHigh => value >= 70;
  bool get isModerate => value >= 40 && value < 70;
  bool get isLow => value < 40;

  Map<String, dynamic> toJson() => {
        'value': value,
        'category': category,
      };
}
