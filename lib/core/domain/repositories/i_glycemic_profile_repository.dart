import '../entities/glycemic_profile.dart';

abstract class IGlycemicProfileRepository {
  Future<GlycemicProfile?> getById(String glycemicProfileId);

  Future<void> save(GlycemicProfile glycemicProfile);
}
