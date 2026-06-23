import 'package:test/test.dart';
import 'package:glylens/core/infrastructure/repositories/repository_contracts.dart';
import 'package:glylens/core/infrastructure/datasources/datasource_abstractions.dart';
import 'package:glylens/core/infrastructure/mappers/mapper_abstractions.dart';
import 'package:glylens/core/domain/entities/food.dart';
import 'package:glylens/core/domain/entities/glycemic_profile.dart';
import 'package:glylens/core/domain/entities/ingredient.dart';
import 'package:glylens/core/domain/entities/product.dart';
import 'package:glylens/core/domain/entities/source.dart';
import 'package:glylens/core/domain/entities/evidence.dart';
import 'package:glylens/core/domain/repositories/i_food_repository.dart';
import 'package:glylens/core/domain/repositories/i_glycemic_profile_repository.dart';
import 'package:glylens/core/domain/repositories/i_ingredient_repository.dart';
import 'package:glylens/core/domain/repositories/i_product_repository.dart';
import 'package:glylens/core/domain/repositories/i_source_repository.dart';
import 'package:glylens/core/domain/repositories/i_evidence_repository.dart';

class FakeRepository implements IFoodRepository, IGlycemicProfileRepository, IIngredientRepository, IProductRepository, ISourceRepository, IEvidenceRepository {
  @override
  Future<void> save(Food value) async {}

  @override
  Future<List<Food>> searchByName(String query) async => [];

  @override
  Future<List<Food>> listByRegion(String region) async => [];

  @override
  Future<Food?> getById(String id) async => null;

  @override
  Future<void> saveGlycemicProfile(GlycemicProfile glycemicProfile) async {}

  @override
  Future<GlycemicProfile?> getByIdGlycemicProfile(String glycemicProfileId) async => null;

  @override
  Future<void> saveIngredient(Ingredient ingredient) async {}

  @override
  Future<Ingredient?> getByIdIngredient(String ingredientId) async => null;

  @override
  Future<void> saveProduct(Product product) async {}

  @override
  Future<Product?> getByIdProduct(String productId) async => null;

  @override
  Future<void> saveSource(Source source) async {}

  @override
  Future<Source?> getByIdSource(String sourceId) async => null;

  @override
  Future<List<Source>> listTrustedSources(trust_score) async => [];

  @override
  Future<void> saveEvidence(Evidence evidence) async {}

  @override
  Future<Evidence?> getByIdEvidence(String evidenceId) async => null;
}

class FakeFoodDatasource extends IFoodDatasource {
  @override
  Future<void> save(Food value) async {}

  @override
  Future<List<Food>> listAll() async => [];

  @override
  Future<Food?> fetchById(String id) async => null;

  @override
  Future<List<Food>> searchByName(String query) async => [];

  @override
  Future<List<Food>> listByRegion(String region) async => [];
}

class TestMapper extends IMapper<Map<String, dynamic>, Food> {
  @override
  Food fromDomain(Food domain) {
    return domain;
  }

  @override
  Map<String, dynamic> toDomain(Food domain) {
    return domain.toJson();
  }
}

void main() {
  test('RepositoryContracts maps contracts to a map', () {
    final contract = RepositoryContracts(
      foodRepository: FakeRepository() as IFoodRepository,
      glycemicProfileRepository: FakeRepository() as IGlycemicProfileRepository,
      ingredientRepository: FakeRepository() as IIngredientRepository,
      productRepository: FakeRepository() as IProductRepository,
      sourceRepository: FakeRepository() as ISourceRepository,
      evidenceRepository: FakeRepository() as IEvidenceRepository,
    );

    final map = contract.toMap();

    expect(map.containsKey('foodRepository'), isTrue);
    expect(map.containsKey('glycemicProfileRepository'), isTrue);
  });

  test('FIoodDatasource implementation can compile and return a list', () async {
    final datasource = FakeFoodDatasource();
    final results = await datasource.searchByName('test');
    expect(results, isEmpty);
  });

  test('Mapper abstraction can be implemented', () {
    final mapper = TestMapper();
    final food = Food(
      foodId: 'food_1',
      name: 'Mapper Food',
      category: null,
      region: 'global',
      glycemicProfileId: 'profile_1',
    );

    final json = mapper.toDomain(food);
    expect(json['foodId'], equals('food_1'));
    expect(mapper.fromDomain(food).foodId, equals('food_1'));
  });
}
