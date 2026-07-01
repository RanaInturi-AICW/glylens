import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../enums/category.dart';
import '../validation/validators.dart';
import '../value_objects/portion.dart';
import '../value_objects/region.dart';

final class Food extends Equatable {
  const Food({
    required this.id,
    required this.name,
    required this.category,
    required this.region,
    this.ingredientIds = const [],
    this.portions = const [],
    this.foodVariantIds = const [],
    required this.glycemicProfileId,
  });

  final FoodId id;
  final String name;
  final Category category;
  final Region region;
  final List<String> ingredientIds;
  final List<Portion> portions;
  final List<String> foodVariantIds;
  final GlycemicProfileId glycemicProfileId;

  factory Food.create({
    required String foodId,
    required String name,
    required Category category,
    required String region,
    List<String> ingredientIds = const [],
    List<Portion> portions = const [],
    List<String> foodVariantIds = const [],
    required String glycemicProfileId,
  }) {
    Validators.validateNonEmptyString('name', name);
    if (category == Category.unknown) {
      throw ValidationException(
        field: 'category',
        message: 'Category cannot be unknown.',
        validationCode: 'invalid',
      );
    }
    Validators.validateStringList('ingredientIds', ingredientIds);
    Validators.validateStringList('foodVariantIds', foodVariantIds);
    return Food(
      id: FoodId(foodId),
      name: name,
      category: category,
      region: Region(region),
      ingredientIds: ingredientIds,
      portions: portions,
      foodVariantIds: foodVariantIds,
      glycemicProfileId: GlycemicProfileId(glycemicProfileId),
    );
  }

  factory Food.fromJson(Map<String, dynamic> json) => Food.create(
        foodId: json['foodId'] as String,
        name: json['name'] as String,
        category: CategoryCodec.fromWire(json['category'] as String? ?? ''),
        region: json['region'] as String,
        ingredientIds: List<String>.from(json['ingredientIds'] as List<dynamic>? ?? []),
        portions: (json['portions'] as List<dynamic>? ?? json['portionProfiles'] as List<dynamic>? ?? [])
            .map((e) => Portion.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        foodVariantIds: List<String>.from(json['foodVariantIds'] as List<dynamic>? ?? []),
        glycemicProfileId: json['glycemicProfileId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'foodId': id.value,
        'name': name,
        'category': category.wireName,
        'region': region.value,
        'ingredientIds': ingredientIds,
        'portions': portions.map((p) => p.toJson()).toList(),
        'foodVariantIds': foodVariantIds,
        'glycemicProfileId': glycemicProfileId.value,
      };

  Food copyWith({
    FoodId? id,
    String? name,
    Category? category,
    Region? region,
    List<String>? ingredientIds,
    List<Portion>? portions,
    List<String>? foodVariantIds,
    GlycemicProfileId? glycemicProfileId,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      region: region ?? this.region,
      ingredientIds: ingredientIds ?? this.ingredientIds,
      portions: portions ?? this.portions,
      foodVariantIds: foodVariantIds ?? this.foodVariantIds,
      glycemicProfileId: glycemicProfileId ?? this.glycemicProfileId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        region,
        ingredientIds,
        portions,
        foodVariantIds,
        glycemicProfileId,
      ];
}
