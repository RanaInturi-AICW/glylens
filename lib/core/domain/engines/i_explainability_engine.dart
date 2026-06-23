import '../entities/glycemic_profile.dart';

abstract class IExplainabilityEngine {
  Future<Map<String, dynamic>> generateExplanation({
    required GlycemicProfile glycemicProfile,
    required Map<String, dynamic> context,
  });
}
