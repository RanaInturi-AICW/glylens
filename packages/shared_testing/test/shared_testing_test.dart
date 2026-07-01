import 'package:shared_core/shared_core.dart';
import 'package:shared_models/shared_models.dart';
import 'package:shared_testing/shared_testing.dart';
import 'package:test/test.dart';

void main() {
  group('Object mothers', () {
    test('provide valid basmati rice ingredient', () {
      final ingredient = ObjectMothers.basmatiRice();
      expect(ingredient.category, Category.grain);
    });
  });

  group('Fake repositories', () {
    test('food repository returns seeded food', () async {
      final repo = InMemoryFoodRepository();
      final food = await repo.getById(FoodId('food_chicken_biryani'));
      expect(food, isNotNull);
      expect(food!.name, contains('Biryani'));
    });

    test('product repository finds by barcode', () async {
      final repo = InMemoryProductRepository();
      final product = await repo.getByBarcode(Barcode('5901234123457'));
      expect(product, isNotNull);
    });
  });

  group('Benchmark fixtures', () {
    test('exports non-empty benchmark map', () {
      final fixture = BenchmarkFixtures.minimalBenchmarkSet();
      expect(fixture['foods'], isNotEmpty);
    });
  });

  group('Domain assertions', () {
    test('expectSuccess passes on success result', () {
      expectSuccess(const Success<int>(1));
    });
  });
}
