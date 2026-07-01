import 'package:test/test.dart';
import 'package:glylens/core/domain/entities/evidence.dart';
import 'package:glylens/core/domain/entities/food.dart';
import 'package:glylens/core/domain/entities/glycemic_profile.dart';
import 'package:glylens/core/domain/entities/ingredient.dart';
import 'package:glylens/core/domain/entities/product.dart';
import 'package:glylens/core/domain/entities/source.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/enums/food_category.dart';
import 'package:glylens/core/domain/enums/processing_level.dart';
import 'package:glylens/core/domain/enums/source_type.dart';
import 'package:glylens/core/domain/errors/validation_error.dart';
import 'package:glylens/core/domain/value_objects/confidence_score.dart';
import 'package:glylens/core/domain/value_objects/gl_value.dart';
import 'package:glylens/core/domain/value_objects/gi_value.dart';
import 'package:glylens/core/domain/value_objects/impact_score.dart';
import 'package:glylens/core/domain/value_objects/trust_score.dart';

void main() {
  group('Ingredient', () {
    test('creates valid ingredient', () {
      final ingredient = Ingredient(
        ingredientId: 'ing_basmati_rice',
        name: 'Basmati Rice',
        aliases: ['Basmati'],
        category: FoodCategory.grain,
        processingLevel: ProcessingLevel.moderatelyProcessed,
        nutritionProfileId: 'nutri_rice',
        glycemicProfileId: 'glycemic_rice',
        sourceIds: ['source_usda'],
      );

      expect(ingredient.name, 'Basmati Rice');
      expect(ingredient.category, FoodCategory.grain);
    });

    test('rejects ingredient with empty name', () {
      expect(
        () => Ingredient(
          ingredientId: 'ing_1',
          name: '',
          category: FoodCategory.grain,
          processingLevel: ProcessingLevel.unprocessed,
          nutritionProfileId: 'nutri_1',
          glycemicProfileId: 'glycemic_1',
        ),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('Food', () {
    test('creates valid food', () {
      final food = Food(
        foodId: 'food_biryani',
        name: 'Chicken Biryani',
        category: FoodCategory.mixedMeal,
        region: 'global',
        ingredientIds: ['ing_rice', 'ing_chicken'],
        foodVariantIds: ['variant_hyderabad'],
        glycemicProfileId: 'glycemic_biryani',
      );

      expect(food.region, 'global');
      expect(food.ingredientIds, contains('ing_rice'));
    });

    test('rejects food with unknown category', () {
      expect(
        () => Food(
          foodId: 'food_1',
          name: 'Unknown Food',
          category: FoodCategory.unknown,
          region: 'global',
          glycemicProfileId: 'glycemic_1',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects food with invalid portion profiles', () {
      expect(
        () => Food(
          foodId: 'food_2',
          name: 'Test Food',
          category: FoodCategory.snack,
          region: 'global',
          glycemicProfileId: 'glycemic_2',
          portionProfiles: [
            {'serving': '', 'grams': 0},
          ],
        ),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('Product', () {
    test('creates valid product', () {
      final product = Product(
        productId: 'prod_maggi',
        barcode: '8901234567890',
        brand: 'Maggi',
        name: 'Maggi Noodles',
        ingredientIds: ['ing_wheat', 'ing_spice'],
        nutritionProfileId: 'nutri_maggi',
        glycemicProfileId: 'glycemic_maggi',
      );

      expect(product.barcode, '8901234567890');
      expect(product.brand, 'Maggi');
    });

    test('rejects product with empty barcode', () {
      expect(
        () => Product(
          productId: 'prod_1',
          barcode: '',
          brand: 'Brand',
          name: 'Name',
          nutritionProfileId: 'nutri_1',
          glycemicProfileId: 'glycemic_1',
        ),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('Evidence', () {
    test('creates valid evidence record', () {
      final evidence = Evidence(
        evidenceId: 'evidence_1',
        level: EvidenceLevel.a,
        confidence: 92,
        sourceIds: ['source_usda'],
      );

      expect(evidence.level, EvidenceLevel.a);
      expect(evidence.confidence, 92);
    });

    test('rejects evidence with missing source IDs', () {
      expect(
        () => Evidence(
          evidenceId: 'evidence_2',
          level: EvidenceLevel.b,
          confidence: 85,
          sourceIds: [],
        ),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('Source', () {
    test('creates valid source', () {
      final source = Source(
        sourceId: 'source_usda',
        name: 'USDA',
        type: SourceType.government,
        url: 'https://www.usda.gov',
        trustScore: TrustScore(88),
      );

      expect(source.name, 'USDA');
      expect(source.trustScore.value, 88);
    });

    test('rejects source with unknown type', () {
      expect(
        () => Source(
          sourceId: 'source_1',
          name: 'Unknown',
          type: SourceType.unknown,
          url: 'https://example.com',
          trustScore: TrustScore(70),
        ),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('GlycemicProfile', () {
    test('creates valid glycemic profile', () {
      final profile = GlycemicProfile(
        glycemicProfileId: 'glycemic_1',
        giValue: GIValue(value: 58, sourceType: 'measured', confidence: 93),
        glValue: GLValue(value: 12, confidence: 93),
        impactScore: ImpactScore(value: 72, category: 'moderate'),
        confidenceScore: ConfidenceScore(value: 93, evidenceLevel: EvidenceLevel.a),
        evidenceLevel: EvidenceLevel.a,
        sourceIds: ['source_gi_dataset'],
      );

      expect(profile.evidenceLevel, EvidenceLevel.a);
      expect(profile.glValue.value, 12);
    });

    test('rejects glycemic profile when confidence evidence level mismatches', () {
      expect(
        () => GlycemicProfile(
          glycemicProfileId: 'glycemic_2',
          giValue: GIValue(value: 58, sourceType: 'measured', confidence: 93),
          glValue: GLValue(value: 12, confidence: 93),
          impactScore: ImpactScore(value: 72, category: 'moderate'),
          confidenceScore: ConfidenceScore(value: 72, evidenceLevel: EvidenceLevel.c),
          evidenceLevel: EvidenceLevel.a,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
