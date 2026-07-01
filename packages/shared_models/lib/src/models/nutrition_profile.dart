import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../value_objects/serving_size.dart';

final class NutritionProfile extends Equatable {
  const NutritionProfile({
    required this.id,
    required this.calories,
    required this.carbohydrates,
    required this.availableCarbohydrates,
    required this.fiber,
    required this.protein,
    required this.fat,
    required this.sugar,
    required this.servingSize,
  });

  final NutritionProfileId id;
  final double calories;
  final double carbohydrates;
  final double availableCarbohydrates;
  final double fiber;
  final double protein;
  final double fat;
  final double sugar;
  final ServingSize servingSize;

  factory NutritionProfile.create({
    required String nutritionProfileId,
    required double calories,
    required double carbohydrates,
    required double availableCarbohydrates,
    required double fiber,
    required double protein,
    required double fat,
    required double sugar,
    required double servingSizeGrams,
  }) {
    return NutritionProfile(
      id: NutritionProfileId(nutritionProfileId),
      calories: calories,
      carbohydrates: carbohydrates,
      availableCarbohydrates: availableCarbohydrates,
      fiber: fiber,
      protein: protein,
      fat: fat,
      sugar: sugar,
      servingSize: ServingSize(servingSizeGrams),
    );
  }

  factory NutritionProfile.fromJson(Map<String, dynamic> json) => NutritionProfile.create(
        nutritionProfileId: json['nutritionProfileId'] as String,
        calories: (json['calories'] as num).toDouble(),
        carbohydrates: (json['carbohydrates'] as num).toDouble(),
        availableCarbohydrates: (json['availableCarbohydrates'] as num).toDouble(),
        fiber: (json['fiber'] as num).toDouble(),
        protein: (json['protein'] as num).toDouble(),
        fat: (json['fat'] as num).toDouble(),
        sugar: (json['sugar'] as num).toDouble(),
        servingSizeGrams: (json['servingSizeGrams'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'nutritionProfileId': id.value,
        'calories': calories,
        'carbohydrates': carbohydrates,
        'availableCarbohydrates': availableCarbohydrates,
        'fiber': fiber,
        'protein': protein,
        'fat': fat,
        'sugar': sugar,
        'servingSizeGrams': servingSize.toJson(),
      };

  NutritionProfile copyWith({
    NutritionProfileId? id,
    double? calories,
    double? carbohydrates,
    double? availableCarbohydrates,
    double? fiber,
    double? protein,
    double? fat,
    double? sugar,
    ServingSize? servingSize,
  }) {
    return NutritionProfile(
      id: id ?? this.id,
      calories: calories ?? this.calories,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      availableCarbohydrates: availableCarbohydrates ?? this.availableCarbohydrates,
      fiber: fiber ?? this.fiber,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      sugar: sugar ?? this.sugar,
      servingSize: servingSize ?? this.servingSize,
    );
  }

  @override
  List<Object?> get props => [
        id,
        calories,
        carbohydrates,
        availableCarbohydrates,
        fiber,
        protein,
        fat,
        sugar,
        servingSize,
      ];
}
