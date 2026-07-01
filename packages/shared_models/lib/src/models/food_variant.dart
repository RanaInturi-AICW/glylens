import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../validation/validators.dart';
import 'meal_component.dart';

final class FoodVariant extends Equatable {
  const FoodVariant({
    required this.id,
    required this.foodId,
    required this.name,
    this.components = const [],
    required this.confidence,
  });

  final FoodVariantId id;
  final FoodId foodId;
  final String name;
  final List<MealComponent> components;
  final int confidence;

  factory FoodVariant.create({
    required String variantId,
    required String foodId,
    required String name,
    List<MealComponent> components = const [],
    required int confidence,
  }) {
    Validators.validateNonEmptyString('name', name);
    Validators.validateConfidenceRange('confidence', confidence);
    return FoodVariant(
      id: FoodVariantId(variantId),
      foodId: FoodId(foodId),
      name: name,
      components: List.unmodifiable(components),
      confidence: confidence,
    );
  }

  factory FoodVariant.fromJson(Map<String, dynamic> json) => FoodVariant.create(
        variantId: json['variantId'] as String,
        foodId: json['foodId'] as String,
        name: json['name'] as String,
        components: (json['components'] as List<dynamic>? ?? [])
            .map((e) => MealComponent.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        confidence: json['confidence'] as int,
      );

  Map<String, dynamic> toJson() => {
        'variantId': id.value,
        'foodId': foodId.value,
        'name': name,
        'components': components.map((c) => c.toJson()).toList(),
        'confidence': confidence,
      };

  FoodVariant copyWith({
    FoodVariantId? id,
    FoodId? foodId,
    String? name,
    List<MealComponent>? components,
    int? confidence,
  }) {
    return FoodVariant(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      name: name ?? this.name,
      components: components ?? this.components,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  List<Object?> get props => [id, foodId, name, components, confidence];
}
