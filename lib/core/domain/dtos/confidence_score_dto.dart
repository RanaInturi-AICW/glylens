import '../enums/evidence_level.dart';

class ConfidenceScoreDto {
  final int value;
  final EvidenceLevel evidenceLevel;

  ConfidenceScoreDto({
    required this.value,
    required this.evidenceLevel,
  });

  Map<String, dynamic> toJson() => {
        'value': value,
        'evidenceLevel': evidenceLevel.name,
      };

  factory ConfidenceScoreDto.fromJson(Map<String, dynamic> json) => ConfidenceScoreDto(
        value: json['value'] as int,
        evidenceLevel: EvidenceLevelExtension.fromString(json['evidenceLevel'] as String? ?? ''),
      );
}
