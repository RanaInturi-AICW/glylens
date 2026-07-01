import 'package:shared_models/shared_models.dart';

import '../value_objects/confidence_score.dart';
import '../value_objects/gi_value.dart';
import '../value_objects/gl_value.dart';
import '../value_objects/trust_score.dart';

/// Resolves glycemic index values from evidence (interface only).
abstract class GiResolutionService {
  Future<GIValue> resolveGi({
    required List<Evidence> evidence,
    required TrustScore trustScore,
  });
}

/// Calculates glycemic load from GI and carbohydrates (interface only).
abstract class GlCalculationService {
  Future<GLValue> calculateGl({
    required GIValue giValue,
    required int availableCarbohydrates,
  });
}

/// Evaluates confidence for a glycemic profile (interface only).
abstract class ConfidenceEvaluationService {
  Future<ConfidenceScore> evaluate({
    required EvidenceLevel evidenceLevel,
    required TrustScore trustScore,
    required int ingredientCoverage,
    required int portionCertainty,
  });
}

/// Aggregates source trust for explainability (interface only).
abstract class SourceTrustEvaluationService {
  Future<TrustScore> evaluate(Source source);

  Future<TrustScore> aggregate(List<Source> sources);
}
