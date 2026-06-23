import '../errors/validation_error.dart';
import '../enums/evidence_level.dart';
import '../validation/validators.dart';

class ConfidenceScore {
  final int value;
  final EvidenceLevel evidenceLevel;

  ConfidenceScore({required this.value, required this.evidenceLevel})
      : assert(value >= 0 && value <= 100),
        value = value,
        evidenceLevel = evidenceLevel {
    Validators.validateConfidenceRange('confidence', value);
    Validators.validateEvidenceLevel('evidenceLevel', evidenceLevel);
    final impliedLevel = _impliedEvidenceLevel(value);
    if (impliedLevel != evidenceLevel) {
      throw ValidationError(
        field: 'evidenceLevel',
        message: 'Confidence score $value does not match evidence level ${evidenceLevel.name}.',
        code: 'inconsistent',
      );
    }
  }

  static EvidenceLevel _impliedEvidenceLevel(int value) {
    if (value >= 90) return EvidenceLevel.a;
    if (value >= 80) return EvidenceLevel.b;
    if (value >= 65) return EvidenceLevel.c;
    if (value >= 50) return EvidenceLevel.d;
    return EvidenceLevel.unknown;
  }

  bool get isAcceptable => value >= 50;

  Map<String, dynamic> toJson() => {
        'value': value,
        'evidenceLevel': evidenceLevel.name,
      };
}
