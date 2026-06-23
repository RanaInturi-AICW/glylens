import '../errors/validation_error.dart';
import '../validation/validators.dart';

class GIValue {
  final int value;
  final String sourceType;
  final int confidence;

  GIValue({required this.value, required this.sourceType, required this.confidence})
      : assert(value >= 0 && value <= 100),
        value = value,
        sourceType = sourceType,
        confidence = confidence {
    Validators.validateGiRange('gi', value);
    Validators.validateConfidenceRange('confidence', confidence);
    if (sourceType.trim().isEmpty) {
      throw ValidationError(field: 'sourceType', message: 'Source type cannot be empty.', code: 'required');
    }
  }

  bool get isMeasured => sourceType.toLowerCase() == 'measured';

  Map<String, dynamic> toJson() => {
        'value': value,
        'sourceType': sourceType,
        'confidence': confidence,
      };
}
