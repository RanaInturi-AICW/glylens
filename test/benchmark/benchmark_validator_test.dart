import 'package:test/test.dart';
import 'package:glylens/core/benchmark/benchmark_food_dataset.dart';
import 'package:glylens/core/benchmark/benchmark_validator.dart';
import 'package:glylens/core/domain/entities/food.dart';
import 'package:glylens/core/domain/entities/glycemic_profile.dart';
import 'package:glylens/core/domain/entities/source.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/enums/food_category.dart';
import 'package:glylens/core/domain/enums/source_type.dart';
import 'package:glylens/core/domain/value_objects/confidence_score.dart';
import 'package:glylens/core/domain/value_objects/gl_value.dart';
import 'package:glylens/core/domain/value_objects/gi_value.dart';
import 'package:glylens/core/domain/value_objects/impact_score.dart';
import 'package:glylens/core/domain/value_objects/trust_score.dart';

void main() {
  group('BenchmarkValidator', () {
    test('passes a valid benchmark dataset', () {
      final dataset = BenchmarkFoodDataset(
        foods: [
          Food(
            foodId: 'food_1',
            name: 'Oatmeal',
            category: FoodCategory.grain,
            region: 'global',
            ingredientIds: ['ingredient_1'],
            portionProfiles: [{'size': 'cup', 'grams': 156}],
            foodVariantIds: [],
            glycemicProfileId: 'profile_1',
          ),
        ],
        glycemicProfiles: [
          GlycemicProfile(
            glycemicProfileId: 'profile_1',
            giValue: GIValue(value: 55, sourceType: 'measured', confidence: 90),
            glValue: GLValue(value: 14, confidence: 85),
            impactScore: ImpactScore(value: 55, category: 'moderate'),
            confidenceScore: ConfidenceScore(value: 90, evidenceLevel: EvidenceLevel.a),
            evidenceLevel: EvidenceLevel.a,
            sourceIds: ['source_1'],
          ),
        ],
        sources: [
          Source(
            sourceId: 'source_1',
            name: 'USDA',
            type: SourceType.government,
            url: 'https://www.usda.gov',
            trustScore: TrustScore(95),
          ),
        ],
      );

      final report = BenchmarkValidator().validate(dataset);

      expect(report.passed, isTrue);
      expect(report.failureCount, equals(0));
      expect(report.summary, contains('valid'));
    });

    test('detects duplicate food ids and missing profile references', () {
      final dataset = BenchmarkFoodDataset(
        foods: [
          Food(
            foodId: 'food_1',
            name: 'Oatmeal',
            category: FoodCategory.grain,
            region: 'global',
            glycemicProfileId: 'profile_missing',
          ),
          Food(
            foodId: 'food_1',
            name: 'Oatmeal Duplicate',
            category: FoodCategory.grain,
            region: 'global',
            glycemicProfileId: 'profile_missing',
          ),
        ],
        glycemicProfiles: [],
        sources: [],
      );

      final report = BenchmarkValidator().validate(dataset);

      expect(report.passed, isFalse);
      expect(report.failureCount, greaterThanOrEqualTo(2));
      expect(report.issues.any((issue) => issue.contains('Duplicate food id')), isTrue);
      expect(report.issues.any((issue) => issue.contains('Missing glycemic profile')), isTrue);
    });
  });
}
