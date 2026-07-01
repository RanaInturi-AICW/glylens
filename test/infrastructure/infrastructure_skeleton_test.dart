import 'package:glylens/core/data/fake_repositories.dart';
import 'package:glylens/core/domain/entities/food.dart';
import 'package:glylens/core/domain/enums/food_category.dart';
import 'package:glylens/core/infrastructure/datasources/datasource_abstractions.dart';
import 'package:glylens/core/infrastructure/mappers/mapper_abstractions.dart';
import 'package:glylens/core/infrastructure/repositories/repository_contracts.dart';
import 'package:test/test.dart';

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
  Food toDomain(Map<String, dynamic> remote) {
    return Food.fromJson(remote);
  }

  @override
  Map<String, dynamic> fromDomain(Food domain) {
    return domain.toJson();
  }
}

void main() {
  test('RepositoryContracts maps contracts to a map', () {
    final contract = RepositoryContracts(
      foodRepository: FakeFoodRepository(),
      glycemicProfileRepository: FakeGlycemicProfileRepository(),
      ingredientRepository: FakeIngredientRepository(),
      productRepository: FakeProductRepository(),
      sourceRepository: FakeSourceRepository(),
      evidenceRepository: FakeEvidenceRepository(),
    );

    final map = contract.toMap();

    expect(map.containsKey('foodRepository'), isTrue);
    expect(map.containsKey('glycemicProfileRepository'), isTrue);
  });

  test('FoodDatasource implementation can compile and return a list', () async {
    final datasource = FakeFoodDatasource();
    final results = await datasource.searchByName('test');
    expect(results, isEmpty);
  });

  test('Mapper abstraction can be implemented', () {
    final mapper = TestMapper();
    final food = Food(
      foodId: 'food_1',
      name: 'Mapper Food',
      category: FoodCategory.vegetable,
      region: 'global',
      glycemicProfileId: 'profile_1',
    );

    final json = mapper.fromDomain(food);
    expect(json['foodId'], equals('food_1'));
    expect(mapper.toDomain(json).foodId, equals('food_1'));
  });
}
