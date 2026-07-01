import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

final class MealComponent extends Equatable {
  const MealComponent({
    required this.ingredientId,
    required this.percentage,
  });

  final IngredientId ingredientId;
  final double percentage;

  factory MealComponent.create({
    required String ingredientId,
    required double percentage,
  }) {
    if (percentage <= 0 || percentage > 100) {
      throw ValidationException(
        field: 'percentage',
        message: 'Percentage must be between 0 and 100 exclusive of zero.',
        validationCode: 'out_of_range',
      );
    }
    return MealComponent(
      ingredientId: IngredientId(ingredientId),
      percentage: percentage,
    );
  }

  factory MealComponent.fromJson(Map<String, dynamic> json) => MealComponent.create(
        ingredientId: json['ingredientId'] as String,
        percentage: (json['percentage'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'ingredientId': ingredientId.value,
        'percentage': percentage,
      };

  MealComponent copyWith({IngredientId? ingredientId, double? percentage}) {
    return MealComponent(
      ingredientId: ingredientId ?? this.ingredientId,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  List<Object?> get props => [ingredientId, percentage];
}
