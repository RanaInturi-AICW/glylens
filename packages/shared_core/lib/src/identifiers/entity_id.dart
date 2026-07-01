import '../base/value_object.dart';
import '../errors/domain_exception.dart';
import '../guards/guard.dart';

/// Strongly typed entity identifier.
final class EntityId extends ValueObject<String> {
  EntityId(String value) : super(Guard.againstEmpty(value, name: 'id')) {
    if (value.trim() != value) {
      throw ValidationException(
        field: 'id',
        message: 'Identifier cannot have leading or trailing whitespace.',
        validationCode: 'invalid',
      );
    }
  }

  factory EntityId.fromJson(String value) => EntityId(value);

  String toJson() => value;
}

final class IngredientId extends EntityId {
  IngredientId(super.value);
}

final class FoodId extends EntityId {
  FoodId(super.value);
}

final class FoodVariantId extends EntityId {
  FoodVariantId(super.value);
}

final class ProductId extends EntityId {
  ProductId(super.value);
}

final class MealId extends EntityId {
  MealId(super.value);
}

final class SourceId extends EntityId {
  SourceId(super.value);
}

final class EvidenceId extends EntityId {
  EvidenceId(super.value);
}

final class CitationId extends EntityId {
  CitationId(super.value);
}

final class GlycemicProfileId extends EntityId {
  GlycemicProfileId(super.value);
}

final class NutritionProfileId extends EntityId {
  NutritionProfileId(super.value);
}
