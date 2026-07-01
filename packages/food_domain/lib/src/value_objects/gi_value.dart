import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

final class GIValue extends Equatable {
  GIValue({
    required this.value,
    required this.sourceType,
    required this.confidence,
  }) {
    Guard.againstOutOfRange(value, name: 'gi', min: 0, max: 100);
    Guard.againstOutOfRange(confidence, name: 'confidence', min: 0, max: 100);
    Guard.againstEmpty(sourceType, name: 'sourceType');
  }

  final int value;
  final String sourceType;
  final int confidence;

  bool get isMeasured => sourceType.toLowerCase() == 'measured';

  Map<String, dynamic> toJson() => {
        'value': value,
        'sourceType': sourceType,
        'confidence': confidence,
      };

  factory GIValue.fromJson(Map<String, dynamic> json) => GIValue(
        value: json['value'] as int,
        sourceType: json['sourceType'] as String,
        confidence: json['confidence'] as int,
      );

  @override
  List<Object?> get props => [value, sourceType, confidence];
}
