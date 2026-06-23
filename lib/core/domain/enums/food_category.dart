enum FoodCategory {
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

extension FoodCategoryExtension on FoodCategory {
  String get name {
    switch (this) {
      case FoodCategory.mixedMeal:
        return 'mixed_meal';
      case FoodCategory.grain:
        return 'grain';
      case FoodCategory.protein:
        return 'protein';
      case FoodCategory.fruit:
        return 'fruit';
      case FoodCategory.vegetable:
        return 'vegetable';
      case FoodCategory.beverage:
        return 'beverage';
      case FoodCategory.snack:
        return 'snack';
      case FoodCategory.dessert:
        return 'dessert';
      case FoodCategory.unknown:
        return 'unknown';
    }
  }

  static FoodCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'mixed_meal':
      case 'mixedmeal':
        return FoodCategory.mixedMeal;
      case 'grain':
        return FoodCategory.grain;
      case 'protein':
        return FoodCategory.protein;
      case 'fruit':
        return FoodCategory.fruit;
      case 'vegetable':
        return FoodCategory.vegetable;
      case 'beverage':
        return FoodCategory.beverage;
      case 'snack':
        return FoodCategory.snack;
      case 'dessert':
        return FoodCategory.dessert;
      default:
        return FoodCategory.unknown;
    }
  }
}
