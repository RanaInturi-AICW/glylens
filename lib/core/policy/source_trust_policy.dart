import '../domain/entities/source.dart';
import '../domain/enums/source_type.dart';
import '../domain/value_objects/trust_score.dart';

class SourceTrustPolicy {
  final Map<SourceType, double> _typeWeights = {
    SourceType.government: 1.0,
    SourceType.academic: 0.95,
    SourceType.openData: 0.9,
    SourceType.industry: 0.85,
    SourceType.userGenerated: 0.7,
    SourceType.unknown: 0.6,
  };

  TrustScore evaluate(Source source) {
    final weight = _typeWeights[source.type] ?? 0.6;
    final normalized = (source.trustScore.value * weight).round();
    final bounded = normalized.clamp(50, 100);
    return TrustScore(bounded);
  }

  bool isTrusted(Source source) {
    return evaluate(source).isTrustworthy;
  }
}
