import 'package:shared_core/shared_core.dart';
import 'package:shared_models/shared_models.dart';

import '../value_objects/trust_score.dart';

abstract class FoodRepository {
  Future<Food?> getById(FoodId foodId);

  Future<List<Food>> searchByName(String query);

  Future<List<Food>> listByRegion(Region region);

  Future<void> save(Food food);
}

abstract class IngredientRepository {
  Future<Ingredient?> getById(IngredientId ingredientId);

  Future<List<Ingredient>> searchByName(String query);

  Future<List<Ingredient>> listByCategory(Category category);

  Future<void> save(Ingredient ingredient);
}

abstract class ProductRepository {
  Future<Product?> getById(ProductId productId);

  Future<Product?> getByBarcode(Barcode barcode);

  Future<List<Product>> searchByNameOrBrand(String query);

  Future<void> save(Product product);
}

abstract class SourceRepository {
  Future<Source?> getById(SourceId sourceId);

  Future<List<Source>> listTrustedSources(TrustScore minimumTrustScore);

  Future<void> save(Source source);
}

abstract class EvidenceRepository {
  Future<Evidence?> getById(EvidenceId evidenceId);

  Future<List<Evidence>> listBySource(SourceId sourceId);

  Future<List<Evidence>> listByRelatedEntity(String entityId);

  Future<void> save(Evidence evidence);
}

abstract class MealRepository {
  Future<Meal?> getById(MealId mealId);

  Future<List<Meal>> searchByName(String query);

  Future<void> save(Meal meal);
}
