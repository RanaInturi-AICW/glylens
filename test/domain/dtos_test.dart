import 'package:test/test.dart';
import 'package:glylens/core/domain/dtos/food_dto.dart';
import 'package:glylens/core/domain/dtos/glycemic_profile_dto.dart';
import 'package:glylens/core/domain/dtos/gi_value_dto.dart';
import 'package:glylens/core/domain/dtos/gl_value_dto.dart';
import 'package:glylens/core/domain/dtos/impact_score_dto.dart';
import 'package:glylens/core/domain/dtos/confidence_score_dto.dart';
import 'package:glylens/core/domain/dtos/trust_score_dto.dart';
import 'package:glylens/core/domain/dtos/source_dto.dart';
import 'package:glylens/core/domain/dtos/evidence_dto.dart';
import 'package:glylens/core/domain/dtos/ingredient_dto.dart';
import 'package:glylens/core/domain/dtos/product_dto.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/enums/food_category.dart';
import 'package:glylens/core/domain/enums/processing_level.dart';
import 'package:glylens/core/domain/enums/source_type.dart';

void main() {
  group('DTO Contracts', () {
    test('FoodDto round trips successfully', () {
      final food = FoodDto(
        foodId: 'food_1',
        name: 'Sample Food',
        category: FoodCategory.grain,
        region: 'global',
        ingredientIds: ['ing_1'],
        portionProfiles: [
          {'serving': '1 bowl', 'grams': 150},
        ],
        foodVariantIds: ['variant_1'],
        glycemicProfileId: 'glycemic_1',
      );

      final json = food.toJson();
      final restored = FoodDto.fromJson(json);

      expect(restored.foodId, food.foodId);
      expect(restored.name, food.name);
      expect(restored.category, food.category);
      expect(restored.portionProfiles, food.portionProfiles);
    });

    test('GlycemicProfileDto round trips successfully', () {
      final profile = GlycemicProfileDto(
        glycemicProfileId: 'glycemic_1',
        giValue: GIValueDto(value: 55, sourceType: 'measured', confidence: 90),
        glValue: GLValueDto(value: 18, confidence: 90),
        impactScore: ImpactScoreDto(value: 65, category: 'moderate'),
        confidenceScore: ConfidenceScoreDto(value: 90, evidenceLevel: EvidenceLevel.a),
        evidenceLevel: EvidenceLevel.a,
        sourceIds: ['source_1'],
      );

      final json = profile.toJson();
      final restored = GlycemicProfileDto.fromJson(json);

      expect(restored.glycemicProfileId, profile.glycemicProfileId);
      expect(restored.giValue.value, profile.giValue.value);
      expect(restored.glValue.value, profile.glValue.value);
      expect(restored.confidenceScore.evidenceLevel, profile.confidenceScore.evidenceLevel);
    });

    test('SourceDto round trips successfully', () {
      final source = SourceDto(
        sourceId: 'source_1',
        name: 'Test Source',
        type: SourceType.government,
        url: 'https://example.com',
        trustScore: TrustScoreDto(value: 92),
      );

      final json = source.toJson();
      final restored = SourceDto.fromJson(json);

      expect(restored.sourceId, source.sourceId);
      expect(restored.trustScore.value, source.trustScore.value);
      expect(restored.type, source.type);
    });

    test('EvidenceDto round trips successfully', () {
      final evidence = EvidenceDto(
        evidenceId: 'evidence_1',
        level: EvidenceLevel.b,
        confidence: 85,
        sourceIds: ['source_1'],
        relatedEntityIds: ['food_1'],
      );

      final json = evidence.toJson();
      final restored = EvidenceDto.fromJson(json);

      expect(restored.level, evidence.level);
      expect(restored.relatedEntityIds, evidence.relatedEntityIds);
    });

    test('IngredientDto round trips successfully', () {
      final ingredient = IngredientDto(
        ingredientId: 'ing_1',
        name: 'Ingredient',
        aliases: ['Alias'],
        category: FoodCategory.protein,
        processingLevel: ProcessingLevel.minimallyProcessed,
        nutritionProfileId: 'nutri_1',
        glycemicProfileId: 'glycemic_1',
        sourceIds: ['source_1'],
      );

      final json = ingredient.toJson();
      final restored = IngredientDto.fromJson(json);

      expect(restored.category, ingredient.category);
      expect(restored.processingLevel, ingredient.processingLevel);
    });

    test('ProductDto round trips successfully', () {
      final product = ProductDto(
        productId: 'prod_1',
        barcode: '1234567890123',
        brand: 'Brand',
        name: 'Product',
        ingredientIds: ['ing_1'],
        nutritionProfileId: 'nutri_1',
        glycemicProfileId: 'glycemic_1',
      );

      final json = product.toJson();
      final restored = ProductDto.fromJson(json);

      expect(restored.brand, product.brand);
      expect(restored.barcode, product.barcode);
    });
  });
}
