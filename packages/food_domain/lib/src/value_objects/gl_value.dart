import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

final class GLValue extends Equatable {
  GLValue({
    required this.value,
    required this.confidence,
  }) {
    Guard.againstNegative(value.toDouble(), name: 'gl');
    Guard.againstOutOfRange(confidence, name: 'confidence', min: 0, max: 100);
  }

  final int value;
  final int confidence;

  bool get isLow => value < 10;

  Map<String, dynamic> toJson() => {
        'value': value,
        'confidence': confidence,
      };

  factory GLValue.fromJson(Map<String, dynamic> json) => GLValue(
        value: json['value'] as int,
        confidence: json['confidence'] as int,
      );

  @override
  List<Object?> get props => [value, confidence];
}
