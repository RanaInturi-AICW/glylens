import '../domain/value_objects/trust_score.dart';
import '../domain/entities/evidence.dart';
import '../domain/entities/food.dart';
import '../domain/entities/ingredient.dart';
import '../domain/entities/product.dart';
import '../domain/entities/source.dart';
import '../domain/entities/glycemic_profile.dart';
import '../domain/enums/food_category.dart';
import '../domain/repositories/i_food_repository.dart';
import '../domain/repositories/i_ingredient_repository.dart';
import '../domain/repositories/i_product_repository.dart';
import '../domain/repositories/i_source_repository.dart';
import '../domain/repositories/i_glycemic_profile_repository.dart';
import '../domain/repositories/i_evidence_repository.dart';
import 'seed_dataset.dart';

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
  for (final item in items) {
    if (test(item)) {
      return item;
    }
  }
  return null;
}

class FakeIngredientRepository implements IIngredientRepository {
  @override
  Future<Ingredient?> getById(String ingredientId) async {
    return _firstWhereOrNull(
      SeedDataset.ingredients,
      (ingredient) => ingredient.ingredientId == ingredientId,
    );
  }

  @override
  Future<List<Ingredient>> listByCategory(FoodCategory category) async {
    return SeedDataset.ingredients.where((ingredient) => ingredient.category == category).toList();
  }

  @override
  Future<List<Ingredient>> searchByName(String query) async {
    return SeedDataset.ingredients
        .where((ingredient) => ingredient.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<void> save(Ingredient ingredient) async {
    throw UnimplementedError('Fake repository supports read-only operations for seed data.');
  }
}

class FakeFoodRepository implements IFoodRepository {
  @override
  Future<Food?> getById(String foodId) async {
    return _firstWhereOrNull(
      SeedDataset.foods,
      (food) => food.foodId == foodId,
    );
  }

  @override
  Future<List<Food>> listByRegion(String region) async {
    return SeedDataset.foods.where((food) => food.region.toLowerCase() == region.toLowerCase()).toList();
  }

  @override
  Future<List<Food>> searchByName(String query) async {
    return SeedDataset.foods.where((food) => food.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Future<void> save(Food food) async {
    throw UnimplementedError('Fake repository supports read-only operations for seed data.');
  }
}

class FakeProductRepository implements IProductRepository {
  @override
  Future<Product?> getByBarcode(String barcode) async {
    return _firstWhereOrNull(
      SeedDataset.products,
      (product) => product.barcode == barcode,
    );
  }

  @override
  Future<Product?> getById(String productId) async {
    return _firstWhereOrNull(
      SeedDataset.products,
      (product) => product.productId == productId,
    );
  }

  @override
  Future<List<Product>> searchByNameOrBrand(String query) async {
    return SeedDataset.products.where((product) {
      final lower = query.toLowerCase();
      return product.name.toLowerCase().contains(lower) || product.brand.toLowerCase().contains(lower);
    }).toList();
  }

  @override
  Future<void> save(Product product) async {
    throw UnimplementedError('Fake repository supports read-only operations for seed data.');
  }
}

class FakeSourceRepository implements ISourceRepository {
  @override
  Future<Source?> getById(String sourceId) async {
    return _firstWhereOrNull(
      SeedDataset.sources,
      (source) => source.sourceId == sourceId,
    );
  }

  @override
  Future<List<Source>> listTrustedSources(TrustScore minimumTrustScore) async {
    return SeedDataset.sources
        .where((source) => source.trustScore.value >= minimumTrustScore.value)
        .toList();
  }

  @override
  Future<void> save(Source source) async {
    throw UnimplementedError('Fake repository supports read-only operations for seed data.');
  }
}

class FakeEvidenceRepository implements IEvidenceRepository {
  @override
  Future<List<Evidence>> listByRelatedEntity(String entityId) async {
    return SeedDataset.evidence.where((evidence) => evidence.relatedEntityIds.contains(entityId)).toList();
  }

  @override
  Future<Evidence?> getById(String evidenceId) async {
    return _firstWhereOrNull(
      SeedDataset.evidence,
      (evidence) => evidence.evidenceId == evidenceId,
    );
  }

  @override
  Future<List<Evidence>> listBySource(String sourceId) async {
    return SeedDataset.evidence.where((evidence) => evidence.sourceIds.contains(sourceId)).toList();
  }

  @override
  Future<void> save(Evidence evidence) async {
    throw UnimplementedError('Fake repository supports read-only operations for seed data.');
  }
}

class FakeGlycemicProfileRepository implements IGlycemicProfileRepository {
  @override
  Future<GlycemicProfile?> getById(String glycemicProfileId) async {
    return _firstWhereOrNull(
      SeedDataset.glycemicProfiles,
      (profile) => profile.glycemicProfileId == glycemicProfileId,
    );
  }

  @override
  Future<void> save(GlycemicProfile glycemicProfile) async {
    throw UnimplementedError('Fake repository supports read-only operations for seed data.');
  }
}
