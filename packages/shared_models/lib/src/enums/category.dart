enum Category {
  mixedMeal,
  grain,
  protein,
  fruit,
  vegetable,
  beverage,
  snack,
  dessert,
  unknown,
}

extension CategoryCodec on Category {
  String get wireName {
    return switch (this) {
      Category.mixedMeal => 'mixed_meal',
      Category.grain => 'grain',
      Category.protein => 'protein',
      Category.fruit => 'fruit',
      Category.vegetable => 'vegetable',
      Category.beverage => 'beverage',
      Category.snack => 'snack',
      Category.dessert => 'dessert',
      Category.unknown => 'unknown',
    };
  }

  static Category fromWire(String value) {
    return switch (value.toLowerCase()) {
      'mixed_meal' || 'mixedmeal' => Category.mixedMeal,
      'grain' => Category.grain,
      'protein' => Category.protein,
      'fruit' => Category.fruit,
      'vegetable' => Category.vegetable,
      'beverage' => Category.beverage,
      'snack' => Category.snack,
      'dessert' => Category.dessert,
      _ => Category.unknown,
    };
  }
}
