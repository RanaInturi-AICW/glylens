import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

final class ImpactScore extends Equatable {
  ImpactScore({
    required this.value,
    required this.category,
  }) {
    Guard.againstOutOfRange(value, name: 'impactScore', min: 0, max: 100);
    Guard.againstEmpty(category, name: 'category');
  }

  final int value;
  final String category;

  bool get isHigh => value >= 70;
  bool get isModerate => value >= 40 && value < 70;
  bool get isLow => value < 40;

  Map<String, dynamic> toJson() => {
        'value': value,
        'category': category,
      };

  factory ImpactScore.fromJson(Map<String, dynamic> json) => ImpactScore(
        value: json['value'] as int,
        category: json['category'] as String,
      );

  @override
  List<Object?> get props => [value, category];
}
