import '../errors/validation_error.dart';
import '../validation/validators.dart';

class GLValue {
  final int value;
  final int confidence;

  GLValue({required this.value, required this.confidence}) {
    if (value < 0) {
      throw ValidationError(field: 'gl', message: 'GL must be zero or positive.', code: 'out_of_range');
    }
    Validators.validateConfidenceRange('confidence', confidence);
  }

  bool get isLow => value < 10;

  Map<String, dynamic> toJson() => {
        'value': value,
        'confidence': confidence,
      };
}
