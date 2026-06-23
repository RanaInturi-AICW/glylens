import '../enums/evidence_level.dart';
import '../value_objects/confidence_score.dart';
import '../value_objects/trust_score.dart';

abstract class IConfidenceEngine {
  Future<ConfidenceScore> calculateConfidence({
    required EvidenceLevel evidenceLevel,
    required TrustScore trustScore,
    required int ingredientCoverage,
    required int portionCertainty,
  });
}
