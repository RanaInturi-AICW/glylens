import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_models/shared_models.dart';

final class ConfidenceScore extends Equatable {
  ConfidenceScore({
    required this.value,
    required this.evidenceLevel,
  }) {
    Guard.againstOutOfRange(value, name: 'confidence', min: 0, max: 100);
    if (evidenceLevel == EvidenceLevel.unknown) {
      if (value >= 50) {
        throw ValidationException(
          field: 'evidenceLevel',
          message: 'Confidence score $value is too high for unknown evidence level.',
          validationCode: 'inconsistent',
        );
      }
    } else {
      Validators.validateEvidenceLevel('evidenceLevel', evidenceLevel);
      final implied = _impliedEvidenceLevel(value);
      if (implied != evidenceLevel) {
        throw ValidationException(
          field: 'evidenceLevel',
          message: 'Confidence score $value does not match evidence level ${evidenceLevel.wireName}.',
          validationCode: 'inconsistent',
        );
      }
    }
  }

  final int value;
  final EvidenceLevel evidenceLevel;

  bool get isAcceptable => value >= 50;

  static EvidenceLevel _impliedEvidenceLevel(int value) {
    if (value >= 90) return EvidenceLevel.a;
    if (value >= 80) return EvidenceLevel.b;
    if (value >= 65) return EvidenceLevel.c;
    if (value >= 50) return EvidenceLevel.d;
    return EvidenceLevel.unknown;
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'evidenceLevel': evidenceLevel.wireName,
      };

  factory ConfidenceScore.fromJson(Map<String, dynamic> json) => ConfidenceScore(
        value: json['value'] as int,
        evidenceLevel: EvidenceLevelCodec.fromWire(json['evidenceLevel'] as String? ?? ''),
      );

  @override
  List<Object?> get props => [value, evidenceLevel];
}
