import 'package:shared_core/shared_core.dart';
import 'package:food_domain/food_domain.dart';
import 'package:shared_models/shared_models.dart';
import 'package:test/test.dart';

void main() {
  group('ConfidenceScore', () {
    test('accepts aligned A-level score', () {
      final score = ConfidenceScore(value: 95, evidenceLevel: EvidenceLevel.a);
      expect(score.isAcceptable, isTrue);
    });

    test('rejects mismatched evidence level', () {
      expect(
        () => ConfidenceScore(value: 70, evidenceLevel: EvidenceLevel.a),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('TrustScore', () {
    test('aggregates values', () {
      final aggregated = TrustScore.aggregate([
        TrustScore(80),
        TrustScore(90),
      ]);
      expect(aggregated.value, 85);
    });
  });

  group('Specifications', () {
    test('ComparableFoodSpecification requires ingredients', () {
      const spec = ComparableFoodSpecification();
      final valid = Food.create(
        foodId: 'food_1',
        name: 'Meal',
        category: Category.mixedMeal,
        region: 'global',
        ingredientIds: const ['ing_1'],
        glycemicProfileId: 'glycemic_1',
      );
      final invalid = Food.create(
        foodId: 'food_2',
        name: 'Empty',
        category: Category.mixedMeal,
        region: 'global',
        glycemicProfileId: 'glycemic_2',
      );
      expect(spec.isSatisfiedBy(valid), isTrue);
      expect(spec.isSatisfiedBy(invalid), isFalse);
    });

    test('TrustedGlycemicProfileSpecification enforces thresholds', () {
      const spec = TrustedGlycemicProfileSpecification();
      final profile = GlycemicProfile.create(
        glycemicProfileId: 'gp1',
        gi: 55,
        gl: 12,
        impactScore: 60,
        confidenceScore: 90,
        evidenceLevel: EvidenceLevel.a,
      );
      final confidence = ConfidenceScore(value: 90, evidenceLevel: EvidenceLevel.a);
      expect(
        spec.isSatisfiedBy(
          profile: profile,
          averageSourceTrust: TrustScore(80),
          confidenceScore: confidence,
        ),
        isTrue,
      );
    });
  });
}
