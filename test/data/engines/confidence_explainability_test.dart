import 'package:test/test.dart';
import 'package:glylens/core/data/engines/confidence_engine.dart';
import 'package:glylens/core/data/engines/explainability_engine.dart';
import 'package:glylens/core/domain/entities/glycemic_profile.dart';
import 'package:glylens/core/domain/entities/source.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/enums/source_type.dart';
import 'package:glylens/core/domain/value_objects/confidence_score.dart';
import 'package:glylens/core/domain/value_objects/gl_value.dart';
import 'package:glylens/core/domain/value_objects/gi_value.dart';
import 'package:glylens/core/domain/value_objects/impact_score.dart';
import 'package:glylens/core/domain/value_objects/trust_score.dart';
import 'package:glylens/core/domain/errors/low_confidence_error.dart';
import 'package:glylens/core/domain/repositories/i_source_repository.dart';

class FakeSourceRepository implements ISourceRepository {
  final Map<String, Source> sources;

  FakeSourceRepository(this.sources);

  @override
  Future<Source?> getById(String sourceId) async => sources[sourceId];

  @override
  Future<List<Source>> listTrustedSources(TrustScore minimumTrustScore) async =>
      sources.values.where((source) => source.trustScore.value >= minimumTrustScore.value).toList();

  @override
  Future<void> save(Source source) async {
    throw UnimplementedError();
  }
}

void main() {
  group('ConfidenceEngine', () {
    final engine = ConfidenceEngine();

    test('calculates A-level confidence when inputs are strong', () async {
      final score = await engine.calculateConfidence(
        evidenceLevel: EvidenceLevel.a,
        trustScore: TrustScore(95),
        ingredientCoverage: 90,
        portionCertainty: 90,
      );

      expect(score.value, inInclusiveRange(90, 100));
      expect(score.evidenceLevel, EvidenceLevel.a);
    });

    test('throws LowConfidenceError for evidence level B when inputs are too low', () async {
      expect(
        () => engine.calculateConfidence(
          evidenceLevel: EvidenceLevel.b,
          trustScore: TrustScore(60),
          ingredientCoverage: 40,
          portionCertainty: 40,
        ),
        throwsA(isA<LowConfidenceError>()),
      );
    });

    test('caps confidence at B-level maximum when raw score is very high', () async {
      final score = await engine.calculateConfidence(
        evidenceLevel: EvidenceLevel.b,
        trustScore: TrustScore(98),
        ingredientCoverage: 95,
        portionCertainty: 95,
      );

      expect(score.value, inInclusiveRange(80, 89));
      expect(score.evidenceLevel, EvidenceLevel.b);
    });

    test('handles unknown evidence with low confidence range', () async {
      final score = await engine.calculateConfidence(
        evidenceLevel: EvidenceLevel.unknown,
        trustScore: TrustScore(50),
        ingredientCoverage: 20,
        portionCertainty: 20,
      );

      expect(score.value, lessThan(50));
      expect(score.evidenceLevel, EvidenceLevel.unknown);
    });

    test('rejects invalid ingredient coverage ranges', () async {
      expect(
        () => engine.calculateConfidence(
          evidenceLevel: EvidenceLevel.c,
          trustScore: TrustScore(75),
          ingredientCoverage: -1,
          portionCertainty: 50,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('ExplainabilityEngine', () {
    final sources = {
      'source_usda': Source(
        sourceId: 'source_usda',
        name: 'USDA',
        type: SourceType.government,
        url: 'https://www.usda.gov',
        trustScore: TrustScore(95),
      ),
      'source_off': Source(
        sourceId: 'source_off',
        name: 'Open Food Facts',
        type: SourceType.openData,
        url: 'https://world.openfoodfacts.org',
        trustScore: TrustScore(75),
      ),
    };
    final engine = ExplainabilityEngine(FakeSourceRepository(sources));

    test('returns accepted status for high-confidence profile', () async {
      final profile = GlycemicProfile(
        glycemicProfileId: 'glycemic_accepted',
        giValue: GIValue(value: 55, sourceType: 'measured', confidence: 92),
        glValue: GLValue(value: 16, confidence: 88),
        impactScore: ImpactScore(value: 60, category: 'moderate'),
        confidenceScore: ConfidenceScore(value: 92, evidenceLevel: EvidenceLevel.a),
        evidenceLevel: EvidenceLevel.a,
        sourceIds: ['source_usda', 'source_off'],
      );

      final result = await engine.generateExplanation(glycemicProfile: profile, context: {'scenario': 'test'});

      expect(result['status'], 'accepted');
      expect(result['sourceCount'], 2);
      expect(result['refusalReason'], isNull);
    });

    test('flags low confidence when average trust is low', () async {
      final profile = GlycemicProfile(
        glycemicProfileId: 'glycemic_low_confidence',
        giValue: GIValue(value: 60, sourceType: 'measured', confidence: 75),
        glValue: GLValue(value: 18, confidence: 75),
        impactScore: ImpactScore(value: 65, category: 'moderate'),
        confidenceScore: ConfidenceScore(value: 69, evidenceLevel: EvidenceLevel.c),
        evidenceLevel: EvidenceLevel.c,
        sourceIds: ['source_off'],
      );

      final result = await engine.generateExplanation(glycemicProfile: profile, context: {'scenario': 'test'});

      expect(result['status'], 'low_confidence');
      expect(result['refusalReason'], isNull);
    });

    test('refuses profile when evidence level is unknown', () async {
      final profile = GlycemicProfile(
        glycemicProfileId: 'glycemic_unknown',
        giValue: GIValue(value: 60, sourceType: 'estimated', confidence: 45),
        glValue: GLValue(value: 12, confidence: 45),
        impactScore: ImpactScore(value: 55, category: 'low'),
        confidenceScore: ConfidenceScore(value: 45, evidenceLevel: EvidenceLevel.unknown),
        evidenceLevel: EvidenceLevel.unknown,
        sourceIds: ['source_usda'],
      );

      final result = await engine.generateExplanation(glycemicProfile: profile, context: {});

      expect(result['status'], 'refused');
      expect(result['refusalReason'], contains('Evidence level unknown'));
    });

    test('refuses profile when no sources are available', () async {
      final profile = GlycemicProfile(
        glycemicProfileId: 'glycemic_no_source',
        giValue: GIValue(value: 50, sourceType: 'estimated', confidence: 65),
        glValue: GLValue(value: 15, confidence: 65),
        impactScore: ImpactScore(value: 58, category: 'moderate'),
        confidenceScore: ConfidenceScore(value: 65, evidenceLevel: EvidenceLevel.c),
        evidenceLevel: EvidenceLevel.c,
        sourceIds: ['missing_source'],
      );

      final result = await engine.generateExplanation(glycemicProfile: profile, context: {});

      expect(result['status'], 'refused');
      expect(result['refusalReason'], contains('No valid source metadata'));
    });
  });
}
