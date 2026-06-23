import '../fake_repositories.dart';
import 'confidence_engine.dart';
import 'explainability_engine.dart';
import 'gi_engine.dart';
import 'gl_engine.dart';
import 'source_trust_engine.dart';

class FakeEngineProvider {
  final GIEngine giEngine;
  final GLEngine glEngine;
  final ConfidenceEngine confidenceEngine;
  final SourceTrustEngine sourceTrustEngine;
  final ExplainabilityEngine explainabilityEngine;

  FakeEngineProvider()
      : giEngine = const GIEngine(),
        glEngine = const GLEngine(),
        confidenceEngine = const ConfidenceEngine(),
        sourceTrustEngine = const SourceTrustEngine(),
        explainabilityEngine = ExplainabilityEngine(FakeSourceRepository());
}
