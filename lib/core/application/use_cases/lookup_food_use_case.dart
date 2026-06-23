import '../../domain/entities/food.dart';
import '../../domain/repositories/i_food_repository.dart';

class LookupFoodUseCase {
  final IFoodRepository foodRepository;

  LookupFoodUseCase({required this.foodRepository});

  Future<Food> executeById(String foodId) async {
    if (foodId.trim().isEmpty) {
      throw ArgumentError.value(foodId, 'foodId', 'Food ID cannot be empty.');
    }

    final food = await foodRepository.getById(foodId);
    if (food == null) {
      throw StateError('Food not found for id: $foodId');
    }

    return food;
  }

  Future<List<Food>> executeByName(String query) async {
    if (query.trim().isEmpty) {
      throw ArgumentError.value(query, 'query', 'Search query cannot be empty.');
    }

    return foodRepository.searchByName(query);
  }
}
