import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../enums/category.dart';
import '../validation/validators.dart';
import 'meal_component.dart';

final class Meal extends Equatable {
  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.components,
    required this.glycemicProfileId,
  });

  final MealId id;
  final String name;
  final Category category;
  final List<MealComponent> components;
  final GlycemicProfileId glycemicProfileId;

  factory Meal.create({
    required String mealId,
    required String name,
    required Category category,
    required List<MealComponent> components,
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
    if (components.isEmpty) {
      throw ValidationException(
        field: 'components',
        message: 'Meal must contain at least one component.',
        validationCode: 'required',
      );
    }
    return Meal(
      id: MealId(mealId),
      name: name,
      category: category,
      components: List.unmodifiable(components),
      glycemicProfileId: GlycemicProfileId(glycemicProfileId),
    );
  }

  factory Meal.fromJson(Map<String, dynamic> json) => Meal.create(
        mealId: json['mealId'] as String,
        name: json['name'] as String,
        category: CategoryCodec.fromWire(json['category'] as String? ?? ''),
        components: (json['components'] as List<dynamic>)
            .map((e) => MealComponent.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        glycemicProfileId: json['glycemicProfileId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'mealId': id.value,
        'name': name,
        'category': category.wireName,
        'components': components.map((c) => c.toJson()).toList(),
        'glycemicProfileId': glycemicProfileId.value,
      };

  Meal copyWith({
    MealId? id,
    String? name,
    Category? category,
    List<MealComponent>? components,
    GlycemicProfileId? glycemicProfileId,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      components: components ?? this.components,
      glycemicProfileId: glycemicProfileId ?? this.glycemicProfileId,
    );
  }

  @override
  List<Object?> get props => [id, name, category, components, glycemicProfileId];
}
