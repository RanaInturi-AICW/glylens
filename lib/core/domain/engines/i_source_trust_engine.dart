import '../entities/source.dart';
import '../value_objects/trust_score.dart';

abstract class ISourceTrustEngine {
  Future<TrustScore> evaluateTrust(Source source);

  Future<TrustScore> aggregateTrust(List<Source> sources);
}
