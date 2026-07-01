import '../errors/validation_error.dart';
import '../validation/validators.dart';

class TrustScore {
  final int value;

  TrustScore(this.value) {
    Validators.validateTrustScoreRange('trustScore', value);
  }

  bool get isTrustworthy => value >= 70;

  static TrustScore aggregate(List<TrustScore> scores) {
    if (scores.isEmpty) {
      throw ValidationError(field: 'trustScore', message: 'At least one trust score is required to aggregate.', code: 'required');
    }

    final average = scores.map((score) => score.value).reduce((a, b) => a + b) / scores.length;
    return TrustScore(average.round());
  }

  Map<String, dynamic> toJson() => {'value': value};
}
