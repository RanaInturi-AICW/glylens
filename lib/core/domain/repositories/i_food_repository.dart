import '../entities/food.dart';

abstract class IFoodRepository {
  Future<Food?> getById(String foodId);

  Future<List<Food>> searchByName(String query);

  Future<List<Food>> listByRegion(String region);

  Future<void> save(Food food);
}
