import 'package:shared_models/shared_models.dart';

/// Canonical sample objects for tests and benchmarks.
abstract final class ObjectMothers {
  static Ingredient basmatiRice() => Ingredient.create(
        ingredientId: 'ing_basmati_rice',
        name: 'Basmati Rice',
        category: Category.grain,
        processingLevel: ProcessingLevel.moderatelyProcessed,
        nutritionProfileId: 'nutri_rice',
        glycemicProfileId: 'glycemic_rice',
        sourceIds: const ['source_usda'],
      );

  static Food chickenBiryani() => Food.create(
        foodId: 'food_chicken_biryani',
        name: 'Chicken Biryani',
        category: Category.mixedMeal,
        region: 'south_asia',
        ingredientIds: const ['ing_basmati_rice', 'ing_chicken'],
        portions: [
          Portion(serving: 'plate', grams: ServingSize(350)),
        ],
        glycemicProfileId: 'glycemic_biryani',
      );

  static Product packagedOats() => Product.create(
        productId: 'product_oats_1',
        barcode: '5901234123457',
        brand: 'GlyLens Pantry',
        name: 'Rolled Oats',
        ingredientIds: const ['ing_oats'],
        nutritionProfileId: 'nutri_oats',
        glycemicProfileId: 'glycemic_oats',
      );

  static Source usdaSource() => Source.create(
        sourceId: 'source_usda',
        name: 'USDA FoodData Central',
        type: SourceType.government,
        url: 'https://fdc.nal.usda.gov',
        trustScore: 95,
      );

  static Evidence measuredGiEvidence() => Evidence.create(
        evidenceId: 'evidence_gi_a',
        level: EvidenceLevel.a,
        confidence: 92,
        sourceIds: const ['source_usda'],
        relatedEntityIds: const ['glycemic_rice'],
      );

  static GlycemicProfile riceGlycemicProfile() => GlycemicProfile.create(
        glycemicProfileId: 'glycemic_rice',
        gi: 58,
        gl: 14,
        impactScore: 55,
        confidenceScore: 90,
        evidenceLevel: EvidenceLevel.a,
        sourceIds: const ['source_usda'],
      );

  static Meal biryaniMeal() => Meal.create(
        mealId: 'meal_biryani',
        name: 'Chicken Biryani',
        category: Category.mixedMeal,
        components: [
          MealComponent.create(ingredientId: 'ing_basmati_rice', percentage: 65),
          MealComponent.create(ingredientId: 'ing_chicken', percentage: 20),
        ],
        glycemicProfileId: 'glycemic_biryani',
      );
}
