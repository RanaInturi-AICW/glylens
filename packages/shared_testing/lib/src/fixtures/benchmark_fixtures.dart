import 'sample_dataset.dart';

abstract final class BenchmarkFixtures {
  static Map<String, Object> minimalBenchmarkSet() => {
        'foods': SampleDataset.foods.map((f) => f.toJson()).toList(),
        'ingredients': SampleDataset.ingredients.map((i) => i.toJson()).toList(),
        'sources': SampleDataset.sources.map((s) => s.toJson()).toList(),
        'glycemicProfiles': SampleDataset.glycemicProfiles.map((p) => p.toJson()).toList(),
      };
}
