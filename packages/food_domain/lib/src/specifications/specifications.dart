import 'package:shared_models/shared_models.dart';

import '../value_objects/confidence_score.dart';
import '../value_objects/trust_score.dart';

/// Determines whether a glycemic profile satisfies publication invariants.
final class TrustedGlycemicProfileSpecification {
  const TrustedGlycemicProfileSpecification({
    this.minimumConfidence = 70,
    this.minimumTrust = 60,
  });

  final int minimumConfidence;
  final int minimumTrust;

  bool isSatisfiedBy({
    required GlycemicProfile profile,
    required TrustScore averageSourceTrust,
    required ConfidenceScore confidenceScore,
  }) {
    return profile.confidenceScore >= minimumConfidence &&
        confidenceScore.isAcceptable &&
        averageSourceTrust.value >= minimumTrust &&
        profile.evidenceLevel != EvidenceLevel.unknown;
  }
}

/// Determines whether a food record is eligible for comparison.
final class ComparableFoodSpecification {
  const ComparableFoodSpecification();

  bool isSatisfiedBy(Food food) {
    return food.ingredientIds.isNotEmpty && food.glycemicProfileId.value.isNotEmpty;
  }
}
