import '../../domain/engines/i_gi_engine.dart';
import '../../domain/entities/evidence.dart';
import '../../domain/enums/evidence_level.dart';
import '../../domain/enums/processing_level.dart';
import '../../domain/value_objects/gi_value.dart';
import '../../domain/value_objects/trust_score.dart';

class GIEngine implements IGIEngine {
  const GIEngine();

  @override
  Future<GIValue> resolveGi({
    required List<Evidence> evidence,
    required TrustScore trustScore,
    required ProcessingLevel processingLevel,
  }) async {
    final evidenceConfidence = evidence.isEmpty
        ? 55.0
        : evidence.map((item) => item.confidence).reduce((a, b) => a + b) / evidence.length;

    final evidenceWeight = evidence.isEmpty
        ? 0.7
        : evidence
            .map((item) => _evidenceLevelWeight(item.level))
            .reduce((a, b) => a + b) / evidence.length;

    final processingModifier = _processingModifier(processingLevel);
    final baseGi = 30.0 + processingModifier;

    final rawGi = (baseGi + evidenceConfidence * 0.2 + trustScore.value * 0.18 + evidenceWeight * 14.0).round();
    final normalizedGi = rawGi.clamp(0, 100) as int;

    final sourceType = evidence.isEmpty
        ? 'estimated'
        : evidence.any((item) => item.level == EvidenceLevel.a)
            ? 'measured'
            : 'estimated';

    final confidence = _calculateConfidence(evidence, trustScore, evidenceConfidence, evidenceWeight);

    return GIValue(value: normalizedGi, sourceType: sourceType, confidence: confidence);
  }

  int _calculateConfidence(
    List<Evidence> evidence,
    TrustScore trustScore,
    double evidenceConfidence,
    double evidenceWeight,
  ) {
    final evidenceBonus = evidence.isEmpty ? 0.0 : evidenceWeight * 12.0;
    final rawConfidence = (evidenceConfidence * 0.45) + (trustScore.value * 0.3) + evidenceBonus;
    return rawConfidence.round().clamp(0, 100) as int;
  }

  double _evidenceLevelWeight(EvidenceLevel level) {
    switch (level) {
      case EvidenceLevel.a:
        return 1.0;
      case EvidenceLevel.b:
        return 0.92;
      case EvidenceLevel.c:
        return 0.78;
      case EvidenceLevel.d:
        return 0.62;
      case EvidenceLevel.unknown:
        return 0.5;
    }
  }

  int _processingModifier(ProcessingLevel processingLevel) {
    switch (processingLevel) {
      case ProcessingLevel.unprocessed:
        return -7;
      case ProcessingLevel.minimallyProcessed:
        return 0;
      case ProcessingLevel.moderatelyProcessed:
        return 8;
      case ProcessingLevel.highlyProcessed:
        return 15;
      case ProcessingLevel.unknown:
        return 3;
    }
  }
}
