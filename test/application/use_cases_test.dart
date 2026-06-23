import 'package:test/test.dart';
import 'package:glylens/core/application/use_cases/compare_foods_use_case.dart';
import 'package:glylens/core/application/use_cases/get_food_intelligence_use_case.dart';
import 'package:glylens/core/application/use_cases/lookup_food_use_case.dart';
import 'package:glylens/core/domain/entities/food.dart';
import 'package:glylens/core/domain/entities/glycemic_profile.dart';
import 'package:glylens/core/domain/entities/source.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/enums/food_category.dart';
import 'package:glylens/core/domain/enums/source_type.dart';
import 'package:glylens/core/domain/value_objects/confidence_score.dart';
import 'package:glylens/core/domain/value_objects/gl_value.dart';
import 'package:glylens/core/domain/value_objects/gi_value.dart';
import 'package:glylens/core/domain/value_objects/impact_score.dart';
import 'package:glylens/core/domain/value_objects/trust_score.dart';
import 'package:glylens/core/domain/repositories/i_food_repository.dart';
import 'package:glylens/core/domain/repositories/i_glycemic_profile_repository.dart';
import 'package:glylens/core/domain/repositories/i_source_repository.dart';
import 'package:glylens/core/policy/confidence_policy.dart';
import 'package:glylens/core/policy/refusal_policy.dart';
import 'package:glylens/core/policy/source_trust_policy.dart';

class FakeFoodRepository implements IFoodRepository {
  final Map<String, Food> _store;

  FakeFoodRepository(this._store);

  @override
  Future<void> save(Food food) async => _store[food.foodId] = food;

  @override
  Future<List<Food>> searchByName(String query) async => _store.values.where((food) => food.name.toLowerCase().contains(query.toLowerCase())).toList();

  @override
  Future<List<Food>> listByRegion(String region) async => _store.values.where((food) => food.region == region).toList();

  @override
  Future<Food?> getById(String foodId) async => _store[foodId];
}

class FakeGlycemicProfileRepository implements IGlycemicProfileRepository {
  final Map<String, GlycemicProfile> _store;

  FakeGlycemicProfileRepository(this._store);

  @override
  Future<void> save(GlycemicProfile glycemicProfile) async => _store[glycemicProfile.glycemicProfileId] = glycemicProfile;

  @override
  Future<GlycemicProfile?> getById(String glycemicProfileId) async => _store[glycemicProfileId];
}

class FakeSourceRepository implements ISourceRepository {
  final Map<String, Source> _store;

  FakeSourceRepository(this._store);

  @override
  Future<void> save(Source source) async => _store[source.sourceId] = source;

  @override
  Future<Source?> getById(String sourceId) async => _store[sourceId];

  @override
  Future<List<Source>> listTrustedSources(TrustScore minimumTrustScore) async =>
      _store.values.where((source) => source.trustScore.value >= minimumTrustScore.value).toList();
}

void main() {
  final food = Food(
    foodId: 'food_1',
    name: 'Brown Rice',
    category: FoodCategory.grain,
    region: 'global',
    ingredientIds: ['ingredient_1'],
    portionProfiles: [{'size': 'cup', 'grams': 195}],
    foodVariantIds: [],
    glycemicProfileId: 'profile_1',
  );

  final profile = GlycemicProfile(
    glycemicProfileId: 'profile_1',
    giValue: GIValue(value: 55, sourceType: 'measured', confidence: 90),
    glValue: GLValue(value: 16, confidence: 88),
    impactScore: ImpactScore(value: 60, category: 'moderate'),
    confidenceScore: ConfidenceScore(value: 88, evidenceLevel: EvidenceLevel.a),
    evidenceLevel: EvidenceLevel.a,
    sourceIds: ['source_1'],
  );

  final source = Source(
    sourceId: 'source_1',
    name: 'USDA',
    type: SourceType.government,
    url: 'https://www.usda.gov',
    trustScore: TrustScore(95),
  );

  group('GetFoodIntelligenceUseCase', () {
    test('returns food intelligence for an existing food', () async {
      final useCase = GetFoodIntelligenceUseCase(
        foodRepository: FakeFoodRepository({'food_1': food}),
        glycemicProfileRepository: FakeGlycemicProfileRepository({'profile_1': profile}),
        sourceRepository: FakeSourceRepository({'source_1': source}),
        sourceTrustPolicy: SourceTrustPolicy(),
      );

      final result = await useCase.execute('food_1');

      expect(result.food.foodId, equals('food_1'));
      expect(result.glycemicProfile.glycemicProfileId, equals('profile_1'));
      expect(result.sources, hasLength(1));
      expect(result.averageTrustScore?.isTrustworthy, isTrue);
    });

    test('throws when food id is missing', () async {
      final useCase = GetFoodIntelligenceUseCase(
        foodRepository: FakeFoodRepository({}),
        glycemicProfileRepository: FakeGlycemicProfileRepository({}),
        sourceRepository: FakeSourceRepository({}),
        sourceTrustPolicy: SourceTrustPolicy(),
      );

      expect(() => useCase.execute(''), throwsArgumentError);
    });
  });

  group('LookupFoodUseCase', () {
    final repository = FakeFoodRepository({'food_1': food, 'food_2': food});
    final useCase = LookupFoodUseCase(foodRepository: repository);

    test('returns a food by id', () async {
      final result = await useCase.executeById('food_1');
      expect(result.name, equals('Brown Rice'));
    });

    test('returns matching foods by name query', () async {
      final results = await useCase.executeByName('brown');
      expect(results, isNotEmpty);
    });
  });

  group('CompareFoodsUseCase', () {
    final leftFood = Food(
      foodId: 'food_left',
      name: 'Left Rice',
      category: FoodCategory.grain,
      region: 'global',
      ingredientIds: ['ingredient_a'],
      portionProfiles: [{'size': 'cup', 'grams': 185}],
      foodVariantIds: [],
      glycemicProfileId: 'profile_left',
    );

    final rightFood = Food(
      foodId: 'food_right',
      name: 'Right Rice',
      category: FoodCategory.grain,
      region: 'global',
      ingredientIds: ['ingredient_b'],
      portionProfiles: [{'size': 'cup', 'grams': 195}],
      foodVariantIds: [],
      glycemicProfileId: 'profile_right',
    );

    final leftProfile = GlycemicProfile(
      glycemicProfileId: 'profile_left',
      giValue: GIValue(value: 50, sourceType: 'measured', confidence: 88),
      glValue: GLValue(value: 14, confidence: 85),
      impactScore: ImpactScore(value: 55, category: 'moderate'),
      confidenceScore: ConfidenceScore(value: 85, evidenceLevel: EvidenceLevel.b),
      evidenceLevel: EvidenceLevel.b,
      sourceIds: [],
    );

    final rightProfile = GlycemicProfile(
      glycemicProfileId: 'profile_right',
      giValue: GIValue(value: 65, sourceType: 'measured', confidence: 80),
      glValue: GLValue(value: 18, confidence: 80),
      impactScore: ImpactScore(value: 65, category: 'moderate'),
      confidenceScore: ConfidenceScore(value: 80, evidenceLevel: EvidenceLevel.b),
      evidenceLevel: EvidenceLevel.b,
      sourceIds: [],
    );

    final useCase = CompareFoodsUseCase(
      foodRepository: FakeFoodRepository({'food_left': leftFood, 'food_right': rightFood}),
      glycemicProfileRepository: FakeGlycemicProfileRepository({'profile_left': leftProfile, 'profile_right': rightProfile}),
      confidencePolicy: ConfidencePolicy(),
      refusalPolicy: RefusalPolicy(confidencePolicy: ConfidencePolicy()),
    );

    test('prefers the lower glycemic load food when both are acceptable', () async {
      final result = await useCase.execute('food_left', 'food_right');
      expect(result.preferredFood?.foodId, equals('food_left'));
      expect(result.scoreDifference, greaterThan(0));
      expect(result.refused, isFalse);
    });

    test('throws when one food is missing', () async {
      expect(() => useCase.execute('food_left', 'missing_food'), throwsStateError);
    });
  });
}
