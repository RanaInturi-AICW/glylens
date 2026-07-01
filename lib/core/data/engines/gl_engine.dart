import '../../domain/engines/i_gl_engine.dart';
import '../../domain/value_objects/gl_value.dart';
import '../../domain/value_objects/gi_value.dart';

class GLEngine implements IGLEngine {
  const GLEngine();

  @override
  Future<GLValue> calculateGl({
    required GIValue giValue,
    required int availableCarbohydrates,
  }) async {
    if (availableCarbohydrates < 0) {
      throw ArgumentError.value(availableCarbohydrates, 'availableCarbohydrates', 'Must be zero or positive.');
    }

    final glEstimate = ((giValue.value * availableCarbohydrates) / 100.0).round();
    final confidencePenalty = _carbohydrateConfidencePenalty(availableCarbohydrates);
    final rawConfidence = (giValue.confidence * (1 - confidencePenalty)).round();
    final confidence = rawConfidence.clamp(0, 100);

    return GLValue(value: glEstimate, confidence: confidence);
  }

  double _carbohydrateConfidencePenalty(int availableCarbohydrates) {
    if (availableCarbohydrates <= 15) {
      return 0.0;
    }
    return ((availableCarbohydrates - 15) / 200).clamp(0.0, 0.3);
  }
}
