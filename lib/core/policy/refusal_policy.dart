import '../domain/entities/glycemic_profile.dart';
import '../domain/enums/evidence_level.dart';
import '../domain/value_objects/trust_score.dart';
import '../policy/confidence_policy.dart';

class RefusalDecision {
  final bool refused;
  final String reason;

  RefusalDecision({required this.refused, required this.reason});
}

class RefusalPolicy {
  final ConfidencePolicy confidencePolicy;
  final int minimumTrustScore;

  RefusalPolicy({required this.confidencePolicy, this.minimumTrustScore = 60});

  RefusalDecision evaluate(GlycemicProfile glycemicProfile, {TrustScore? averageSourceTrust}) {
    if (glycemicProfile.evidenceLevel == EvidenceLevel.unknown) {
      return RefusalDecision(refused: true, reason: 'Evidence level unknown for glycemic profile.');
    }

    if (!confidencePolicy.isAcceptable(glycemicProfile.confidenceScore)) {
      return RefusalDecision(refused: true, reason: 'Confidence score does not meet policy threshold.');
    }

    if (averageSourceTrust != null && averageSourceTrust.value < minimumTrustScore) {
      return RefusalDecision(refused: true, reason: 'Average source trust falls below minimum threshold.');
    }

    if (glycemicProfile.glValue.value > 80 && glycemicProfile.confidenceScore.value < 60) {
      return RefusalDecision(refused: true, reason: 'High glycemic load and low confidence triggers refusal.');
    }

    return RefusalDecision(refused: false, reason: 'Profile accepted by refusal policy.');
  }
}
