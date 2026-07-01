import 'confidence_score_dto.dart';
import 'gl_value_dto.dart';
import 'gi_value_dto.dart';
import 'impact_score_dto.dart';
import '../enums/evidence_level.dart';

class GlycemicProfileDto {
  final String glycemicProfileId;
  final GIValueDto giValue;
  final GLValueDto glValue;
  final ImpactScoreDto impactScore;
  final ConfidenceScoreDto confidenceScore;
  final EvidenceLevel evidenceLevel;
  final List<String> sourceIds;

  GlycemicProfileDto({
    required this.glycemicProfileId,
    required this.giValue,
    required this.glValue,
    required this.impactScore,
    required this.confidenceScore,
    required this.evidenceLevel,
    this.sourceIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'glycemicProfileId': glycemicProfileId,
        'giValue': giValue.toJson(),
        'glValue': glValue.toJson(),
        'impactScore': impactScore.toJson(),
        'confidenceScore': confidenceScore.toJson(),
        'evidenceLevel': evidenceLevel.name,
        'sourceIds': sourceIds,
      };

  factory GlycemicProfileDto.fromJson(Map<String, dynamic> json) => GlycemicProfileDto(
        glycemicProfileId: json['glycemicProfileId'] as String,
        giValue: GIValueDto.fromJson(json['giValue'] as Map<String, dynamic>),
        glValue: GLValueDto.fromJson(json['glValue'] as Map<String, dynamic>),
        impactScore: ImpactScoreDto.fromJson(json['impactScore'] as Map<String, dynamic>),
        confidenceScore: ConfidenceScoreDto.fromJson(json['confidenceScore'] as Map<String, dynamic>),
        evidenceLevel: EvidenceLevelExtension.fromString(json['evidenceLevel'] as String? ?? ''),
        sourceIds: List<String>.from(json['sourceIds'] as List<dynamic>? ?? []),
      );
}
