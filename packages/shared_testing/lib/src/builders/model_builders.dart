import 'package:shared_models/shared_models.dart';

import '../mothers/object_mothers.dart';

typedef ModelBuilder<T> = T Function();

final class IngredientBuilder {
  String _id = 'ing_builder';
  String _name = 'Builder Ingredient';
  final Category _category = Category.grain;
  final ProcessingLevel _processing = ProcessingLevel.unprocessed;
  final String _nutritionId = 'nutri_builder';
  final String _glycemicId = 'glycemic_builder';

  IngredientBuilder withId(String value) {
    _id = value;
    return this;
  }

  IngredientBuilder withName(String value) {
    _name = value;
    return this;
  }

  Ingredient build() => Ingredient.create(
        ingredientId: _id,
        name: _name,
        category: _category,
        processingLevel: _processing,
        nutritionProfileId: _nutritionId,
        glycemicProfileId: _glycemicId,
      );
}

final class ModelBuilders {
  static IngredientBuilder ingredient() => IngredientBuilder();

  static Food defaultFood() => ObjectMothers.chickenBiryani();
}
