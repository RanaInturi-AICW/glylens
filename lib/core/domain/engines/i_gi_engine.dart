import '../entities/evidence.dart';
import '../enums/processing_level.dart';
import '../value_objects/gi_value.dart';
import '../value_objects/trust_score.dart';

abstract class IGIEngine {
  Future<GIValue> resolveGi({
    required List<Evidence> evidence,
    required TrustScore trustScore,
    required ProcessingLevel processingLevel,
  });
}
