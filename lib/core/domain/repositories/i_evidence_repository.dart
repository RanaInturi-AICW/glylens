import '../entities/evidence.dart';

abstract class IEvidenceRepository {
  Future<Evidence?> getById(String evidenceId);

  Future<List<Evidence>> listBySource(String sourceId);

  Future<List<Evidence>> listByRelatedEntity(String entityId);

  Future<void> save(Evidence evidence);
}
