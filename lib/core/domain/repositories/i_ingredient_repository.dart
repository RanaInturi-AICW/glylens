import '../entities/ingredient.dart';
import '../enums/food_category.dart';

abstract class IIngredientRepository {
  Future<Ingredient?> getById(String ingredientId);

  Future<List<Ingredient>> searchByName(String query);

  Future<List<Ingredient>> listByCategory(FoodCategory category);

  Future<void> save(Ingredient ingredient);
}
