import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../enums/category.dart';
import '../enums/processing_level.dart';
import '../validation/validators.dart';

final class Ingredient extends Equatable {
  const Ingredient({
    required this.id,
    required this.name,
    this.aliases = const [],
    required this.category,
    required this.processingLevel,
    required this.nutritionProfileId,
    required this.glycemicProfileId,
    this.sourceIds = const [],
  });

  final IngredientId id;
  final String name;
  final List<String> aliases;
  final Category category;
  final ProcessingLevel processingLevel;
  final NutritionProfileId nutritionProfileId;
  final GlycemicProfileId glycemicProfileId;
  final List<String> sourceIds;

  factory Ingredient.create({
    required String ingredientId,
    required String name,
    List<String> aliases = const [],
    required Category category,
    required ProcessingLevel processingLevel,
    required String nutritionProfileId,
    required String glycemicProfileId,
    List<String> sourceIds = const [],
  }) {
    Validators.validateNonEmptyString('name', name);
    if (category == Category.unknown) {
      throw ValidationException(
        field: 'category',
        message: 'Category cannot be unknown.',
        validationCode: 'invalid',
      );
    }
    if (processingLevel == ProcessingLevel.unknown) {
      throw ValidationException(
        field: 'processingLevel',
        message: 'Processing level cannot be unknown.',
        validationCode: 'invalid',
      );
    }
    return Ingredient(
      id: IngredientId(ingredientId),
      name: name,
      aliases: aliases,
      category: category,
      processingLevel: processingLevel,
      nutritionProfileId: NutritionProfileId(nutritionProfileId),
      glycemicProfileId: GlycemicProfileId(glycemicProfileId),
      sourceIds: sourceIds,
    );
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient.create(
        ingredientId: json['ingredientId'] as String,
        name: json['name'] as String,
        aliases: List<String>.from(json['aliases'] as List<dynamic>? ?? []),
        category: CategoryCodec.fromWire(json['category'] as String? ?? ''),
        processingLevel: ProcessingLevelCodec.fromWire(json['processingLevel'] as String? ?? ''),
        nutritionProfileId: json['nutritionProfileId'] as String,
        glycemicProfileId: json['glycemicProfileId'] as String,
        sourceIds: List<String>.from(json['sourceIds'] as List<dynamic>? ?? []),
      );

  Map<String, dynamic> toJson() => {
        'ingredientId': id.value,
        'name': name,
        'aliases': aliases,
        'category': category.wireName,
        'processingLevel': processingLevel.wireName,
        'nutritionProfileId': nutritionProfileId.value,
        'glycemicProfileId': glycemicProfileId.value,
        'sourceIds': sourceIds,
      };

  Ingredient copyWith({
    IngredientId? id,
    String? name,
    List<String>? aliases,
    Category? category,
    ProcessingLevel? processingLevel,
    NutritionProfileId? nutritionProfileId,
    GlycemicProfileId? glycemicProfileId,
    List<String>? sourceIds,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      aliases: aliases ?? this.aliases,
      category: category ?? this.category,
      processingLevel: processingLevel ?? this.processingLevel,
      nutritionProfileId: nutritionProfileId ?? this.nutritionProfileId,
      glycemicProfileId: glycemicProfileId ?? this.glycemicProfileId,
      sourceIds: sourceIds ?? this.sourceIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        aliases,
        category,
        processingLevel,
        nutritionProfileId,
        glycemicProfileId,
        sourceIds,
      ];
}
