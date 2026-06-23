import '../enums/food_category.dart';
import '../enums/processing_level.dart';

class IngredientDto {
  final String ingredientId;
  final String name;
  final List<String> aliases;
  final FoodCategory category;
  final ProcessingLevel processingLevel;
  final String nutritionProfileId;
  final String glycemicProfileId;
  final List<String> sourceIds;

  IngredientDto({
    required this.ingredientId,
    required this.name,
    this.aliases = const [],
    required this.category,
    required this.processingLevel,
    required this.nutritionProfileId,
    required this.glycemicProfileId,
    this.sourceIds = const [],
  });

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

  factory IngredientDto.fromJson(Map<String, dynamic> json) => IngredientDto(
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
