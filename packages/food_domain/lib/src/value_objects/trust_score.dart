import 'package:shared_core/shared_core.dart';

final class TrustScore extends ValueObject<int> {
  TrustScore(int value)
      : super(Guard.againstOutOfRange(value, name: 'trustScore', min: 0, max: 100));

  bool get isTrustworthy => value >= 70;

  static TrustScore aggregate(List<TrustScore> scores) {
    Guard.againstEmptyList(scores, name: 'trustScore');
    final average = scores.map((s) => s.value).reduce((a, b) => a + b) / scores.length;
    return TrustScore(average.round());
  }

  Map<String, dynamic> toJson() => {'value': value};

  factory TrustScore.fromJson(Map<String, dynamic> json) => TrustScore(json['value'] as int);
}
