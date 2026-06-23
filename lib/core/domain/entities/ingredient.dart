import '../enums/food_category.dart';
import '../enums/processing_level.dart';
import '../validation/validators.dart';

class Ingredient {
  final String ingredientId;
  final String name;
  final List<String> aliases;
  final FoodCategory category;
  final ProcessingLevel processingLevel;
  final String nutritionProfileId;
  final String glycemicProfileId;
  final List<String> sourceIds;

  Ingredient({
    required this.ingredientId,
    required this.name,
    this.aliases = const [],
    required this.category,
    required this.processingLevel,
    required this.nutritionProfileId,
    required this.glycemicProfileId,
    this.sourceIds = const [],
  }) {
    Validators.validateId('ingredientId', ingredientId);
    Validators.validateNonEmptyString('name', name);
    if (category == FoodCategory.unknown) {
      throw ArgumentError.value(category, 'category', 'Category cannot be unknown.');
    }
    if (processingLevel == ProcessingLevel.unknown) {
      throw ArgumentError.value(processingLevel, 'processingLevel', 'Processing level cannot be unknown.');
    }
    if (nutritionProfileId.trim().isEmpty) {
      throw ArgumentError.value(nutritionProfileId, 'nutritionProfileId', 'Nutrition profile reference cannot be empty.');
    }
    if (glycemicProfileId.trim().isEmpty) {
      throw ArgumentError.value(glycemicProfileId, 'glycemicProfileId', 'Glycemic profile reference cannot be empty.');
    }
  }

  Map<String, dynamic> toJson() => {
        'ingredientId': ingredientId,
        'name': name,
        'aliases': aliases,
        'category': category.name,
        'processingLevel': processingLevel.name,
        'nutritionProfileId': nutritionProfileId,
        'glycemicProfileId': glycemicProfileId,
        'sourceIds': sourceIds,
      };

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        ingredientId: json['ingredientId'] as String,
        name: json['name'] as String,
        aliases: List<String>.from(json['aliases'] as List<dynamic>? ?? []),
        category: FoodCategoryExtension.fromString(json['category'] as String? ?? ''),
        processingLevel: ProcessingLevelExtension.fromString(json['processingLevel'] as String? ?? ''),
        nutritionProfileId: json['nutritionProfileId'] as String,
        glycemicProfileId: json['glycemicProfileId'] as String,
        sourceIds: List<String>.from(json['sourceIds'] as List<dynamic>? ?? []),
      );
}
