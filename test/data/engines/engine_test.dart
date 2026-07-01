import 'package:test/test.dart';
import 'package:glylens/core/data/engines/gi_engine.dart';
import 'package:glylens/core/data/engines/gl_engine.dart';
import 'package:glylens/core/data/engines/source_trust_engine.dart';
import 'package:glylens/core/domain/entities/evidence.dart';
import 'package:glylens/core/domain/entities/source.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/enums/processing_level.dart';
import 'package:glylens/core/domain/enums/source_type.dart';
import 'package:glylens/core/domain/value_objects/gi_value.dart';
import 'package:glylens/core/domain/value_objects/trust_score.dart';

void main() {
  group('GIEngine', () {
    test('returns measured GI for A-level evidence', () async {
      final engine = GIEngine();
      final result = await engine.resolveGi(
        evidence: [
          Evidence(
            evidenceId: 'evidence_1',
            level: EvidenceLevel.a,
            confidence: 92,
            sourceIds: ['source_usda'],
            relatedEntityIds: ['food_1'],
          ),
        ],
        trustScore: TrustScore(95),
        processingLevel: ProcessingLevel.moderatelyProcessed,
      );

      expect(result.sourceType, 'measured');
      expect(result.value, inInclusiveRange(70, 100));
      expect(result.confidence, inInclusiveRange(70, 100));
    });

    test('returns estimated GI when no evidence is present', () async {
      final engine = GIEngine();
      final result = await engine.resolveGi(
        evidence: [],
        trustScore: TrustScore(60),
        processingLevel: ProcessingLevel.minimallyProcessed,
      );

      expect(result.sourceType, 'estimated');
      expect(result.value, inInclusiveRange(40, 75));
      expect(result.confidence, inInclusiveRange(30, 75));
    });
  });

  group('GLEngine', () {
    test('calculates GL using GI and available carbohydrates', () async {
      final engine = GLEngine();
      final giValue = GIValue(value: 60, sourceType: 'measured', confidence: 90);
      final result = await engine.calculateGl(giValue: giValue, availableCarbohydrates: 50);

      expect(result.value, 30);
      expect(result.confidence, lessThan(90));
      expect(result.confidence, greaterThanOrEqualTo(60));
    });

    test('preserves confidence when carbohydrate amount is low', () async {
      final engine = GLEngine();
      final giValue = GIValue(value: 55, sourceType: 'measured', confidence: 85);
      final result = await engine.calculateGl(giValue: giValue, availableCarbohydrates: 10);

      expect(result.value, 6);
      expect(result.confidence, 85);
    });

    test('throws for negative carbohydrate values', () async {
      final engine = GLEngine();
      final giValue = GIValue(value: 50, sourceType: 'measured', confidence: 80);

      expect(
        () => engine.calculateGl(giValue: giValue, availableCarbohydrates: -1),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('SourceTrustEngine', () {
    test('evaluates government source trust with type weighting', () async {
      final engine = SourceTrustEngine();
      final source = Source(
        sourceId: 'source_usda',
        name: 'USDA',
        type: SourceType.government,
        url: 'https://www.usda.gov',
        trustScore: TrustScore(95),
      );

      final result = await engine.evaluateTrust(source);

      expect(result.value, equals(95));
    });

    test('evaluates open data source trust with lower raw score', () async {
      final engine = SourceTrustEngine();
      final source = Source(
        sourceId: 'source_off',
        name: 'Open Food Facts',
        type: SourceType.openData,
        url: 'https://world.openfoodfacts.org',
        trustScore: TrustScore(70),
      );

      final result = await engine.evaluateTrust(source);

      expect(result.value, equals(74));
    });

    test('aggregates trust scores deterministically', () async {
      final engine = SourceTrustEngine();
      final sources = [
        Source(
          sourceId: 'source_usda',
          name: 'USDA',
          type: SourceType.government,
          url: 'https://www.usda.gov',
          trustScore: TrustScore(95),
        ),
        Source(
          sourceId: 'source_off',
          name: 'Open Food Facts',
          type: SourceType.openData,
          url: 'https://world.openfoodfacts.org',
          trustScore: TrustScore(80),
        ),
      ];

      final aggregate = await engine.aggregateTrust(sources);

      expect(aggregate.value, equals(88));
    });

    test('returns fallback trust score for empty source collection', () async {
      final engine = SourceTrustEngine();
      final result = await engine.aggregateTrust([]);

      expect(result.value, equals(50));
    });
  });
}
