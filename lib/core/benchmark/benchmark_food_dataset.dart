import '../domain/entities/food.dart';
import '../domain/entities/glycemic_profile.dart';
import '../domain/entities/ingredient.dart';
import '../domain/entities/source.dart';

class BenchmarkFoodDataset {
  final List<Food> foods;
  final List<Ingredient> ingredients;
  final List<GlycemicProfile> glycemicProfiles;
  final List<Source> sources;

  BenchmarkFoodDataset({
    this.foods = const [],
    this.ingredients = const [],
    this.glycemicProfiles = const [],
    this.sources = const [],
  });

  bool get hasData => foods.isNotEmpty || ingredients.isNotEmpty || glycemicProfiles.isNotEmpty || sources.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'foods': foods.map((food) => food.toJson()).toList(),
        'ingredients': ingredients.map((ingredient) => ingredient.toJson()).toList(),
        'glycemicProfiles': glycemicProfiles.map((profile) => profile.toJson()).toList(),
        'sources': sources.map((source) => source.toJson()).toList(),
      };
}
