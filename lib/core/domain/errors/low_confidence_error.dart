import 'domain_error.dart';
import '../enums/evidence_level.dart';

class LowConfidenceError extends DomainError {
  final int confidenceScore;
  final EvidenceLevel evidenceLevel;

  LowConfidenceError({
    required this.confidenceScore,
    required this.evidenceLevel,
    String? message,
  }) : super(message ?? 'Low confidence score: $confidenceScore for evidence ${evidenceLevel.name}.');

  @override
  String toString() => 'LowConfidenceError($confidenceScore, ${evidenceLevel.name}): $message';
}
