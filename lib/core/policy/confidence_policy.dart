import '../domain/enums/evidence_level.dart';
import '../domain/value_objects/confidence_score.dart';

class ConfidencePolicy {
  static const _thresholds = {
    EvidenceLevel.a: 85,
    EvidenceLevel.b: 70,
    EvidenceLevel.c: 55,
    EvidenceLevel.unknown: 45,
  };

  bool isAcceptable(ConfidenceScore confidenceScore) {
    final threshold = _thresholds[confidenceScore.evidenceLevel] ?? 45;
    return confidenceScore.value >= threshold;
  }

  int requiredMinimum(EvidenceLevel evidenceLevel) {
    return _thresholds[evidenceLevel] ?? 45;
  }

  ConfidenceScore normalize(ConfidenceScore confidenceScore) {
    final threshold = requiredMinimum(confidenceScore.evidenceLevel);
    final bounded = confidenceScore.value.clamp(threshold, 100);
    return ConfidenceScore(bounded, evidenceLevel: confidenceScore.evidenceLevel);
  }
}
