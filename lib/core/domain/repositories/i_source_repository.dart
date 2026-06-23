import '../entities/source.dart';
import '../value_objects/trust_score.dart';

abstract class ISourceRepository {
  Future<Source?> getById(String sourceId);

  Future<List<Source>> listTrustedSources(TrustScore minimumTrustScore);

  Future<void> save(Source source);
}
