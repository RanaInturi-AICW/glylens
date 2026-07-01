import 'benchmark_food_dataset.dart';
import 'benchmark_report.dart';

class BenchmarkValidator {
  BenchmarkReport validate(BenchmarkFoodDataset dataset) {
    final issues = <String>[];
    final foods = dataset.foods;
    final profiles = dataset.glycemicProfiles;
    final sources = dataset.sources;

    if (!dataset.hasData) {
      issues.add('Benchmark dataset contains no records.');
    }

    final foodIds = <String>{};
    for (final food in foods) {
      if (foodIds.contains(food.foodId)) {
        issues.add('Duplicate food id detected: ${food.foodId}');
      }
      foodIds.add(food.foodId);
      if (!profiles.any((profile) => profile.glycemicProfileId == food.glycemicProfileId)) {
        issues.add('Missing glycemic profile for food: ${food.foodId}');
      }
    }

    final profileIds = <String>{};
    for (final profile in profiles) {
      if (profileIds.contains(profile.glycemicProfileId)) {
        issues.add('Duplicate glycemic profile id detected: ${profile.glycemicProfileId}');
      }
      profileIds.add(profile.glycemicProfileId);
      if (profile.confidenceScore.value < 0 || profile.confidenceScore.value > 100) {
        issues.add('Invalid confidence score for profile: ${profile.glycemicProfileId}');
      }
    }

    final sourceIds = <String>{};
    for (final source in sources) {
      if (sourceIds.contains(source.sourceId)) {
        issues.add('Duplicate source id detected: ${source.sourceId}');
      }
      sourceIds.add(source.sourceId);
      if (source.trustScore.value < 0 || source.trustScore.value > 100) {
        issues.add('Invalid trust score for source: ${source.sourceId}');
      }
    }

    final totalChecks = 4 + foodIds.length + profileIds.length + sourceIds.length;
    return BenchmarkReport(
      passed: issues.isEmpty,
      totalChecks: totalChecks,
      failureCount: issues.length,
      issues: issues,
    );
  }
}
