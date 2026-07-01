import '../../domain/entities/food.dart';
import '../../domain/repositories/i_food_repository.dart';
import '../../domain/repositories/i_glycemic_profile_repository.dart';
import '../../domain/value_objects/confidence_score.dart';
import '../../policy/confidence_policy.dart';
import '../../policy/refusal_policy.dart';

class FoodComparisonResult {
  final Food? preferredFood;
  final Food? alternativeFood;
  final int scoreDifference;
  final String summary;
  final bool refused;

  FoodComparisonResult({
    required this.preferredFood,
    required this.alternativeFood,
    required this.scoreDifference,
    required this.summary,
    required this.refused,
  });
}

class CompareFoodsUseCase {
  final IFoodRepository foodRepository;
  final IGlycemicProfileRepository glycemicProfileRepository;
  final ConfidencePolicy confidencePolicy;
  final RefusalPolicy refusalPolicy;

  CompareFoodsUseCase({
    required this.foodRepository,
    required this.glycemicProfileRepository,
    required this.confidencePolicy,
    required this.refusalPolicy,
  });

  Future<FoodComparisonResult> execute(String leftFoodId, String rightFoodId) async {
    if (leftFoodId.trim().isEmpty || rightFoodId.trim().isEmpty) {
      throw ArgumentError('Food IDs must be non-empty.');
    }

    final leftFood = await foodRepository.getById(leftFoodId);
    final rightFood = await foodRepository.getById(rightFoodId);

    if (leftFood == null || rightFood == null) {
      throw StateError('Both foods must exist for comparison.');
    }

    final leftProfile = await glycemicProfileRepository.getById(leftFood.glycemicProfileId);
    final rightProfile = await glycemicProfileRepository.getById(rightFood.glycemicProfileId);

    if (leftProfile == null || rightProfile == null) {
      throw StateError('Glycemic profiles are required for both foods.');
    }

    final leftDecision = refusalPolicy.evaluate(leftProfile);
    final rightDecision = refusalPolicy.evaluate(rightProfile);

    final leftScore = _calculateComparisonScore(leftProfile.confidenceScore, leftProfile.glValue.value);
    final rightScore = _calculateComparisonScore(rightProfile.confidenceScore, rightProfile.glValue.value);

    final winner = _selectWinner(
      leftFood: leftFood,
      rightFood: rightFood,
      leftScore: leftScore,
      rightScore: rightScore,
      leftRefused: leftDecision.refused,
      rightRefused: rightDecision.refused,
    );

    return FoodComparisonResult(
      preferredFood: winner.preferredFood,
      alternativeFood: winner.alternativeFood,
      scoreDifference: (leftScore - rightScore).abs(),
      summary: winner.summary,
      refused: leftDecision.refused || rightDecision.refused,
    );
  }

  int _calculateComparisonScore(ConfidenceScore confidenceScore, int glValue) {
    final confidenceBonus = confidencePolicy.isAcceptable(confidenceScore) ? confidenceScore.value : confidenceScore.value ~/ 2;
    return (100 - glValue) + confidenceBonus;
  }

  _ComparisonResult _selectWinner({
    required Food leftFood,
    required Food rightFood,
    required int leftScore,
    required int rightScore,
    required bool leftRefused,
    required bool rightRefused,
  }) {
    if (leftRefused && rightRefused) {
      return _ComparisonResult(
        preferredFood: null,
        alternativeFood: null,
        summary: 'Both foods are refused by the current policy settings.',
      );
    }

    if (leftRefused) {
      return _ComparisonResult(
        preferredFood: rightFood,
        alternativeFood: leftFood,
        summary: 'Left food was refused; right food is preferred.',
      );
    }

    if (rightRefused) {
      return _ComparisonResult(
        preferredFood: leftFood,
        alternativeFood: rightFood,
        summary: 'Right food was refused; left food is preferred.',
      );
    }

    if (leftScore >= rightScore) {
      return _ComparisonResult(
        preferredFood: leftFood,
        alternativeFood: rightFood,
        summary: 'Left food has a stronger glycemic profile and confidence score.',
      );
    }

    return _ComparisonResult(
      preferredFood: rightFood,
      alternativeFood: leftFood,
      summary: 'Right food has a stronger glycemic profile and confidence score.',
    );
  }
}

class _ComparisonResult {
  final Food? preferredFood;
  final Food? alternativeFood;
  final String summary;

  _ComparisonResult({
    required this.preferredFood,
    required this.alternativeFood,
    required this.summary,
  });
}
