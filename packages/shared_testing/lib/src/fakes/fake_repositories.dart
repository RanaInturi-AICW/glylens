import 'package:food_domain/food_domain.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_models/shared_models.dart';

import '../mothers/object_mothers.dart';

final class InMemoryFoodRepository implements FoodRepository {
  final Map<String, Food> _store = {
    ObjectMothers.chickenBiryani().id.value: ObjectMothers.chickenBiryani(),
  };

  @override
  Future<Food?> getById(FoodId foodId) async => _store[foodId.value];

  @override
  Future<List<Food>> listByRegion(Region region) async =>
      _store.values.where((food) => food.region.value == region.value).toList();

  @override
  Future<void> save(Food food) async {
    _store[food.id.value] = food;
  }

  @override
  Future<List<Food>> searchByName(String query) async {
    final lower = query.toLowerCase();
    return _store.values.where((food) => food.name.toLowerCase().contains(lower)).toList();
  }
}

final class InMemoryIngredientRepository implements IngredientRepository {
  final Map<String, Ingredient> _store = {
    ObjectMothers.basmatiRice().id.value: ObjectMothers.basmatiRice(),
  };

  @override
  Future<Ingredient?> getById(IngredientId ingredientId) async => _store[ingredientId.value];

  @override
  Future<List<Ingredient>> listByCategory(Category category) async =>
      _store.values.where((item) => item.category == category).toList();

  @override
  Future<void> save(Ingredient ingredient) async {
    _store[ingredient.id.value] = ingredient;
  }

  @override
  Future<List<Ingredient>> searchByName(String query) async {
    final lower = query.toLowerCase();
    return _store.values.where((item) => item.name.toLowerCase().contains(lower)).toList();
  }
}

final class InMemoryProductRepository implements ProductRepository {
  final Map<String, Product> _store = {
    ObjectMothers.packagedOats().id.value: ObjectMothers.packagedOats(),
  };

  @override
  Future<Product?> getByBarcode(Barcode barcode) async {
    for (final product in _store.values) {
      if (product.barcode.value == barcode.value) {
        return product;
      }
    }
    return null;
  }

  @override
  Future<Product?> getById(ProductId productId) async => _store[productId.value];

  @override
  Future<void> save(Product product) async {
    _store[product.id.value] = product;
  }

  @override
  Future<List<Product>> searchByNameOrBrand(String query) async {
    final lower = query.toLowerCase();
    return _store.values
        .where(
          (product) =>
              product.name.toLowerCase().contains(lower) ||
              product.brand.value.toLowerCase().contains(lower),
        )
        .toList();
  }
}

final class InMemorySourceRepository implements SourceRepository {
  final Map<String, Source> _store = {
    ObjectMothers.usdaSource().id.value: ObjectMothers.usdaSource(),
  };

  @override
  Future<Source?> getById(SourceId sourceId) async => _store[sourceId.value];

  @override
  Future<List<Source>> listTrustedSources(TrustScore minimumTrustScore) async =>
      _store.values.where((source) => source.trustScore >= minimumTrustScore.value).toList();

  @override
  Future<void> save(Source source) async {
    _store[source.id.value] = source;
  }
}

final class InMemoryEvidenceRepository implements EvidenceRepository {
  final Map<String, Evidence> _store = {
    ObjectMothers.measuredGiEvidence().id.value: ObjectMothers.measuredGiEvidence(),
  };

  @override
  Future<Evidence?> getById(EvidenceId evidenceId) async => _store[evidenceId.value];

  @override
  Future<List<Evidence>> listByRelatedEntity(String entityId) async =>
      _store.values.where((evidence) => evidence.relatedEntityIds.contains(entityId)).toList();

  @override
  Future<List<Evidence>> listBySource(SourceId sourceId) async =>
      _store.values.where((evidence) => evidence.sourceIds.contains(sourceId.value)).toList();

  @override
  Future<void> save(Evidence evidence) async {
    _store[evidence.id.value] = evidence;
  }
}

final class InMemoryMealRepository implements MealRepository {
  final Map<String, Meal> _store = {
    ObjectMothers.biryaniMeal().id.value: ObjectMothers.biryaniMeal(),
  };

  @override
  Future<Meal?> getById(MealId mealId) async => _store[mealId.value];

  @override
  Future<void> save(Meal meal) async {
    _store[meal.id.value] = meal;
  }

  @override
  Future<List<Meal>> searchByName(String query) async {
    final lower = query.toLowerCase();
    return _store.values.where((meal) => meal.name.toLowerCase().contains(lower)).toList();
  }
}
