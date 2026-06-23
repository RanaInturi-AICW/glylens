import '../enums/evidence_level.dart';

class EvidenceDto {
  final String evidenceId;
  final EvidenceLevel level;
  final int confidence;
  final List<String> sourceIds;
  final List<String> relatedEntityIds;

  EvidenceDto({
    required this.evidenceId,
    required this.level,
    required this.confidence,
    this.sourceIds = const [],
    this.relatedEntityIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'evidenceId': evidenceId,
        'level': level.name,
        'confidence': confidence,
        'sourceIds': sourceIds,
        'relatedEntityIds': relatedEntityIds,
      };

  factory EvidenceDto.fromJson(Map<String, dynamic> json) => EvidenceDto(
        evidenceId: json['evidenceId'] as String,
        level: EvidenceLevelExtension.fromString(json['level'] as String? ?? ''),
        confidence: json['confidence'] as int,
        sourceIds: List<String>.from(json['sourceIds'] as List<dynamic>? ?? []),
        relatedEntityIds: List<String>.from(json['relatedEntityIds'] as List<dynamic>? ?? []),
      );
}
