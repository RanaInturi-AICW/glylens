import 'package:shared_core/shared_core.dart';
import 'package:shared_models/shared_models.dart';
import 'package:test/test.dart';

void main() {
  group('Ingredient', () {
    test('creates valid ingredient', () {
      final ingredient = Ingredient.create(
        ingredientId: 'ing_1',
        name: 'Rice',
        category: Category.grain,
        processingLevel: ProcessingLevel.unprocessed,
        nutritionProfileId: 'nutri_1',
        glycemicProfileId: 'glycemic_1',
      );
      expect(ingredient.name, 'Rice');
    });

    test('rejects unknown category', () {
      expect(
        () => Ingredient.create(
          ingredientId: 'ing_1',
          name: 'Rice',
          category: Category.unknown,
          processingLevel: ProcessingLevel.unprocessed,
          nutritionProfileId: 'nutri_1',
          glycemicProfileId: 'glycemic_1',
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('round trips json', () {
      final ingredient = Ingredient.create(
        ingredientId: 'ing_1',
        name: 'Rice',
        category: Category.grain,
        processingLevel: ProcessingLevel.unprocessed,
        nutritionProfileId: 'nutri_1',
        glycemicProfileId: 'glycemic_1',
      );
      final restored = Ingredient.fromJson(ingredient.toJson());
      expect(restored, equals(ingredient));
    });

    test('copyWith updates fields', () {
      final ingredient = Ingredient.create(
        ingredientId: 'ing_1',
        name: 'Rice',
        category: Category.grain,
        processingLevel: ProcessingLevel.unprocessed,
        nutritionProfileId: 'nutri_1',
        glycemicProfileId: 'glycemic_1',
      );
      final updated = ingredient.copyWith(name: 'Brown Rice');
      expect(updated.name, 'Brown Rice');
      expect(updated.id, ingredient.id);
    });
  });

  group('Food', () {
    test('creates with portions', () {
      final food = Food.create(
        foodId: 'food_1',
        name: 'Biryani',
        category: Category.mixedMeal,
        region: 'global',
        portions: [
          Portion(serving: 'plate', grams: ServingSize(300)),
        ],
        glycemicProfileId: 'glycemic_1',
      );
      expect(food.portions, hasLength(1));
    });
  });

  group('Product', () {
    test('validates barcode', () {
      expect(
        () => Product.create(
          productId: 'p1',
          barcode: 'abc',
          brand: 'Brand',
          name: 'Oats',
          nutritionProfileId: 'n1',
          glycemicProfileId: 'g1',
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('Evidence', () {
    test('requires source ids', () {
      expect(
        () => Evidence.create(
          evidenceId: 'e1',
          level: EvidenceLevel.a,
          confidence: 90,
          sourceIds: const [],
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('Barcode', () {
    test('accepts ean13', () {
      final barcode = Barcode('5901234123457');
      expect(barcode.value, '5901234123457');
    });
  });
}
