import '../enums/food_category.dart';
import '../validation/validators.dart';

class Food {
  final String foodId;
  final String name;
  final FoodCategory category;
  final String region;
  final List<String> ingredientIds;
  final List<Map<String, dynamic>> portionProfiles;
  final List<String> foodVariantIds;
  final String glycemicProfileId;

  Food({
    required this.foodId,
    required this.name,
    required this.category,
    required this.region,
    this.ingredientIds = const [],
    this.portionProfiles = const [],
    this.foodVariantIds = const [],
    required this.glycemicProfileId,
  }) {
    Validators.validateId('foodId', foodId);
    Validators.validateNonEmptyString('name', name);
    if (category == FoodCategory.unknown) {
      throw ArgumentError.value(category, 'category', 'Category cannot be unknown.');
    }
    Validators.validateNonEmptyString('region', region);
    if (glycemicProfileId.trim().isEmpty) {
      throw ArgumentError.value(glycemicProfileId, 'glycemicProfileId', 'Glycemic profile reference cannot be empty.');
    }
    Validators.validateStringList('ingredientIds', ingredientIds);
    Validators.validateStringList('foodVariantIds', foodVariantIds);
    Validators.validatePortionProfiles('portionProfiles', portionProfiles);
  }

  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'name': name,
        'category': category.name,
        'region': region,
        'ingredientIds': ingredientIds,
        'portionProfiles': portionProfiles,
        'foodVariantIds': foodVariantIds,
        'glycemicProfileId': glycemicProfileId,
      };

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        foodId: json['foodId'] as String,
        name: json['name'] as String,
        category: FoodCategoryExtension.fromString(json['category'] as String? ?? ''),
        region: json['region'] as String,
        ingredientIds: List<String>.from(json['ingredientIds'] as List<dynamic>? ?? []),
        portionProfiles: List<Map<String, dynamic>>.from(json['portionProfiles'] as List<dynamic>? ?? []),
        foodVariantIds: List<String>.from(json['foodVariantIds'] as List<dynamic>? ?? []),
        glycemicProfileId: json['glycemicProfileId'] as String,
      );
}
