import '../../domain/entities/food.dart';
import '../../domain/entities/glycemic_profile.dart';
import '../../domain/entities/source.dart';
import '../../domain/repositories/i_food_repository.dart';
import '../../domain/repositories/i_glycemic_profile_repository.dart';
import '../../domain/repositories/i_source_repository.dart';
import '../../domain/value_objects/trust_score.dart';
import '../../policy/source_trust_policy.dart';

class FoodIntelligenceResult {
  final Food food;
  final GlycemicProfile glycemicProfile;
  final List<Source> sources;
  final TrustScore? averageTrustScore;

  FoodIntelligenceResult({
    required this.food,
    required this.glycemicProfile,
    required this.sources,
    required this.averageTrustScore,
  });

  bool get hasTrustedSources => averageTrustScore?.isTrustworthy ?? false;

  Map<String, dynamic> toJson() => {
        'food': food.toJson(),
        'glycemicProfile': glycemicProfile.toJson(),
        'sourceCount': sources.length,
        'averageTrustScore': averageTrustScore?.toJson(),
      };
}

class GetFoodIntelligenceUseCase {
  final IFoodRepository foodRepository;
  final IGlycemicProfileRepository glycemicProfileRepository;
  final ISourceRepository sourceRepository;
  final SourceTrustPolicy sourceTrustPolicy;

  GetFoodIntelligenceUseCase({
    required this.foodRepository,
    required this.glycemicProfileRepository,
    required this.sourceRepository,
    required this.sourceTrustPolicy,
  });

  Future<FoodIntelligenceResult> execute(String foodId) async {
    if (foodId.trim().isEmpty) {
      throw ArgumentError.value(foodId, 'foodId', 'Food ID cannot be empty.');
    }

    final food = await foodRepository.getById(foodId);
    if (food == null) {
      throw StateError('Food not found for id: $foodId');
    }

    final glycemicProfile = await glycemicProfileRepository.getById(food.glycemicProfileId);
    if (glycemicProfile == null) {
      throw StateError('Glycemic profile not found for food: ${food.foodId}');
    }

    final sources = <Source>[];
    for (final sourceId in glycemicProfile.sourceIds) {
      final source = await sourceRepository.getById(sourceId);
      if (source != null) {
        sources.add(source);
      }
    }

    final averageTrustScore = sources.isNotEmpty
        ? TrustScore.aggregate(sources.map((source) => sourceTrustPolicy.evaluate(source)).toList())
        : null;

    return FoodIntelligenceResult(
      food: food,
      glycemicProfile: glycemicProfile,
      sources: sources,
      averageTrustScore: averageTrustScore,
    );
  }
}
