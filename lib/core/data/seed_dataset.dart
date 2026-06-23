import '../domain/entities/evidence.dart';
import '../domain/entities/food.dart';
import '../domain/entities/glycemic_profile.dart';
import '../domain/entities/ingredient.dart';
import '../domain/entities/product.dart';
import '../domain/entities/source.dart';
import '../domain/enums/evidence_level.dart';
import '../domain/enums/food_category.dart';
import '../domain/enums/processing_level.dart';
import '../domain/enums/source_type.dart';
import '../domain/value_objects/confidence_score.dart';
import '../domain/value_objects/gl_value.dart';
import '../domain/value_objects/gi_value.dart';
import '../domain/value_objects/impact_score.dart';
import '../domain/value_objects/trust_score.dart';

class SeedDataset {
  static final List<Ingredient> ingredients = [
    Ingredient(
      ingredientId: 'ing_basmati_rice',
      name: 'Basmati Rice',
      aliases: ['Basmati'],
      category: FoodCategory.grain,
      processingLevel: ProcessingLevel.moderatelyProcessed,
      nutritionProfileId: 'nutri_basmati_rice',
      glycemicProfileId: 'glycemic_basmati_rice',
      sourceIds: ['source_usda'],
    ),
    Ingredient(
      ingredientId: 'ing_chicken',
      name: 'Chicken',
      aliases: ['Chicken Meat'],
      category: FoodCategory.protein,
      processingLevel: ProcessingLevel.minimallyProcessed,
      nutritionProfileId: 'nutri_chicken',
      glycemicProfileId: 'glycemic_chicken',
      sourceIds: ['source_usda'],
    ),
  ];

  static final List<Food> foods = [
    Food(
      foodId: 'food_biryani',
      name: 'Chicken Biryani',
      category: FoodCategory.mixedMeal,
      region: 'global',
      ingredientIds: ['ing_basmati_rice', 'ing_chicken'],
      portionProfiles: [
        {'serving': '1 plate', 'grams': 300},
      ],
      foodVariantIds: ['variant_hyderabad_biryani'],
      glycemicProfileId: 'glycemic_biryani',
    ),
  ];

  static final List<Product> products = [
    Product(
      productId: 'prod_maggi',
      barcode: '8901234567890',
      brand: 'Maggi',
      name: 'Maggi Noodles',
      ingredientIds: ['ing_wheat', 'ing_spice'],
      nutritionProfileId: 'nutri_maggi',
      glycemicProfileId: 'glycemic_maggi',
    ),
  ];

  static final List<Source> sources = [
    Source(
      sourceId: 'source_usda',
      name: 'USDA',
      type: SourceType.government,
      url: 'https://www.usda.gov',
      trustScore: TrustScore(95),
    ),
    Source(
      sourceId: 'source_open_food_facts',
      name: 'Open Food Facts',
      type: SourceType.openData,
      url: 'https://world.openfoodfacts.org',
      trustScore: TrustScore(80),
    ),
  ];

  static final List<Evidence> evidence = [
    Evidence(
      evidenceId: 'evidence_rice_a',
      level: EvidenceLevel.a,
      confidence: 92,
      sourceIds: ['source_usda'],
      relatedEntityIds: ['ing_basmati_rice'],
    ),
    Evidence(
      evidenceId: 'evidence_chicken_b',
      level: EvidenceLevel.b,
      confidence: 85,
      sourceIds: ['source_open_food_facts'],
      relatedEntityIds: ['ing_chicken'],
    ),
    Evidence(
      evidenceId: 'evidence_biryani_c',
      level: EvidenceLevel.c,
      confidence: 72,
      sourceIds: ['source_open_food_facts'],
      relatedEntityIds: ['food_biryani'],
    ),
  ];

  static final List<GlycemicProfile> glycemicProfiles = [
    GlycemicProfile(
      glycemicProfileId: 'glycemic_basmati_rice',
      giValue: GIValue(value: 58, sourceType: 'measured', confidence: 92),
      glValue: GLValue(value: 18, confidence: 92),
      impactScore: ImpactScore(value: 72, category: 'moderate'),
      confidenceScore: ConfidenceScore(value: 92, evidenceLevel: EvidenceLevel.a),
      evidenceLevel: EvidenceLevel.a,
      sourceIds: ['source_usda'],
    ),
    GlycemicProfile(
      glycemicProfileId: 'glycemic_chicken',
      giValue: GIValue(value: 0, sourceType: 'measured', confidence: 92),
      glValue: GLValue(value: 0, confidence: 92),
      impactScore: ImpactScore(value: 10, category: 'low'),
      confidenceScore: ConfidenceScore(value: 92, evidenceLevel: EvidenceLevel.a),
      evidenceLevel: EvidenceLevel.a,
      sourceIds: ['source_usda'],
    ),
    GlycemicProfile(
      glycemicProfileId: 'glycemic_biryani',
      giValue: GIValue(value: 70, sourceType: 'estimated', confidence: 72),
      glValue: GLValue(value: 30, confidence: 72),
      impactScore: ImpactScore(value: 65, category: 'moderate'),
      confidenceScore: ConfidenceScore(value: 72, evidenceLevel: EvidenceLevel.c),
      evidenceLevel: EvidenceLevel.c,
      sourceIds: ['source_open_food_facts'],
    ),
  ];
}
