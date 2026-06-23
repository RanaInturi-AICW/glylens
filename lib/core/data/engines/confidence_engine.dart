import '../../domain/engines/i_confidence_engine.dart';
import '../../domain/enums/evidence_level.dart';
import '../../domain/errors/low_confidence_error.dart';
import '../../domain/value_objects/confidence_score.dart';
import '../../domain/value_objects/trust_score.dart';

class ConfidenceEngine implements IConfidenceEngine {
  const ConfidenceEngine();

  @override
  Future<ConfidenceScore> calculateConfidence({
    required EvidenceLevel evidenceLevel,
    required TrustScore trustScore,
    required int ingredientCoverage,
    required int portionCertainty,
  }) async {
    _validateRanges(ingredientCoverage: ingredientCoverage, portionCertainty: portionCertainty);

    final evidenceBonus = _evidenceLevelBonus(evidenceLevel);
    final rawValue = (trustScore.value * 0.45) +
        (ingredientCoverage * 0.20) +
        (portionCertainty * 0.20) +
        evidenceBonus;

    final calculatedValue = rawValue.round().clamp(0, 100) as int;
    final minThreshold = _minimumThreshold(evidenceLevel);
    final maxThreshold = _maximumThreshold(evidenceLevel);

    if (calculatedValue < minThreshold) {
      throw LowConfidenceError(confidenceScore: calculatedValue, evidenceLevel: evidenceLevel);
    }

    final boundedValue = calculatedValue.clamp(minThreshold, maxThreshold) as int;
    return ConfidenceScore(value: boundedValue, evidenceLevel: evidenceLevel);
  }

  void _validateRanges({required int ingredientCoverage, required int portionCertainty}) {
    if (ingredientCoverage < 0 || ingredientCoverage > 100) {
      throw ArgumentError.value(ingredientCoverage, 'ingredientCoverage', 'Must be between 0 and 100.');
    }
    if (portionCertainty < 0 || portionCertainty > 100) {
      throw ArgumentError.value(portionCertainty, 'portionCertainty', 'Must be between 0 and 100.');
    }
  }

  double _evidenceLevelBonus(EvidenceLevel evidenceLevel) {
    switch (evidenceLevel) {
      case EvidenceLevel.a:
        return 14.0;
      case EvidenceLevel.b:
        return 9.0;
      case EvidenceLevel.c:
        return 3.0;
      case EvidenceLevel.d:
        return -5.0;
      case EvidenceLevel.unknown:
        return -20.0;
    }
  }

  int _minimumThreshold(EvidenceLevel evidenceLevel) {
    switch (evidenceLevel) {
      case EvidenceLevel.a:
        return 90;
      case EvidenceLevel.b:
        return 80;
      case EvidenceLevel.c:
        return 65;
      case EvidenceLevel.d:
        return 50;
      case EvidenceLevel.unknown:
        return 0;
    }
  }

  int _maximumThreshold(EvidenceLevel evidenceLevel) {
    switch (evidenceLevel) {
      case EvidenceLevel.a:
        return 100;
      case EvidenceLevel.b:
        return 89;
      case EvidenceLevel.c:
        return 79;
      case EvidenceLevel.d:
        return 64;
      case EvidenceLevel.unknown:
        return 49;
    }
  }
}
