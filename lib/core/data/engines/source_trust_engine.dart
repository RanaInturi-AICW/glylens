import '../../domain/engines/i_source_trust_engine.dart';
import '../../domain/entities/source.dart';
import '../../domain/enums/source_type.dart';
import '../../domain/errors/validation_error.dart';
import '../../domain/value_objects/trust_score.dart';

class SourceTrustEngine implements ISourceTrustEngine {
  const SourceTrustEngine();

  @override
  Future<TrustScore> evaluateTrust(Source source) async {
    if (source.type == SourceType.unknown) {
      throw ValidationError(field: 'sourceType', message: 'Source type cannot be unknown.', code: 'invalid');
    }

    final normalizedTrust = _normalizeTrustScore(source.type, source.trustScore.value);
    return TrustScore(normalizedTrust);
  }

  @override
  Future<TrustScore> aggregateTrust(List<Source> sources) async {
    if (sources.isEmpty) {
      return TrustScore(50);
    }

    final evaluatedTrustScores = sources
        .map((source) => evaluateTrust(source))
        .toList();

    final values = await Future.wait(evaluatedTrustScores).then((results) => results.map((score) => score.value).toList());
    return TrustScore.aggregate(values.map((value) => TrustScore(value)).toList());
  }

  int _normalizeTrustScore(SourceType type, int rawTrust) {
    final base = _sourceTypeBase(type);
    final normalized = rawTrust.clamp(0, 100);
    final weighted = ((normalized * 0.7) + (base * 0.3)).round();
    return weighted.clamp(0, 100);
  }

  int _sourceTypeBase(SourceType type) {
    switch (type) {
      case SourceType.government:
        return 95;
      case SourceType.academic:
        return 88;
      case SourceType.openData:
        return 82;
      case SourceType.industry:
        return 75;
      case SourceType.aiAssisted:
        return 72;
      case SourceType.userSubmission:
        return 68;
      case SourceType.unknown:
        return 50;
    }
  }
}
