import '../enums/evidence_level.dart';
import '../validation/validators.dart';

class Evidence {
  final String evidenceId;
  final EvidenceLevel level;
  final int confidence;
  final List<String> sourceIds;
  final List<String> relatedEntityIds;

  Evidence({
    required this.evidenceId,
    required this.level,
    required this.confidence,
    this.sourceIds = const [],
    this.relatedEntityIds = const [],
  }) {
    Validators.validateId('evidenceId', evidenceId);
    Validators.validateEvidenceLevel('level', level);
    Validators.validateConfidenceRange('confidence', confidence);
    Validators.validateSourceIds('sourceIds', sourceIds);
    if (relatedEntityIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError('Related entity IDs must be non-empty strings.');
    }
  }

  Map<String, dynamic> toJson() => {
        'evidenceId': evidenceId,
        'level': level.name,
        'confidence': confidence,
        'sourceIds': sourceIds,
        'relatedEntityIds': relatedEntityIds,
      };

  factory Evidence.fromJson(Map<String, dynamic> json) => Evidence(
        evidenceId: json['evidenceId'] as String,
        level: EvidenceLevelExtension.fromString(json['level'] as String? ?? ''),
        confidence: json['confidence'] as int,
        sourceIds: List<String>.from(json['sourceIds'] as List<dynamic>? ?? []),
        relatedEntityIds: List<String>.from(json['relatedEntityIds'] as List<dynamic>? ?? []),
      );
}
