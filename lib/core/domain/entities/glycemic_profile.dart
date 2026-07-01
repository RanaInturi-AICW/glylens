import '../enums/evidence_level.dart';
import '../value_objects/confidence_score.dart';
import '../value_objects/gl_value.dart';
import '../value_objects/gi_value.dart';
import '../value_objects/impact_score.dart';
import '../validation/validators.dart';

class GlycemicProfile {
  final String glycemicProfileId;
  final GIValue giValue;
  final GLValue glValue;
  final ImpactScore impactScore;
  final ConfidenceScore confidenceScore;
  final EvidenceLevel evidenceLevel;
  final List<String> sourceIds;

  GlycemicProfile({
    required this.glycemicProfileId,
    required this.giValue,
    required this.glValue,
    required this.impactScore,
    required this.confidenceScore,
    required this.evidenceLevel,
    this.sourceIds = const [],
  }) {
    Validators.validateId('glycemicProfileId', glycemicProfileId);
    if (confidenceScore.evidenceLevel != evidenceLevel) {
      throw ArgumentError('Confidence score evidence level must match glycemic profile evidence level.');
    }
    if (sourceIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError('Source IDs must be non-empty strings.');
    }
  }

  Map<String, dynamic> toJson() => {
        'glycemicProfileId': glycemicProfileId,
        'giValue': giValue.toJson(),
        'glValue': glValue.toJson(),
        'impactScore': impactScore.toJson(),
        'confidenceScore': confidenceScore.toJson(),
        'evidenceLevel': evidenceLevel.name,
        'sourceIds': sourceIds,
      };

  factory GlycemicProfile.fromJson(Map<String, dynamic> json) => GlycemicProfile(
        glycemicProfileId: json['glycemicProfileId'] as String,
        giValue: GIValue(
          value: json['giValue']['value'] as int,
          sourceType: json['giValue']['sourceType'] as String,
          confidence: json['giValue']['confidence'] as int,
        ),
        glValue: GLValue(
          value: json['glValue']['value'] as int,
          confidence: json['glValue']['confidence'] as int,
        ),
        impactScore: ImpactScore(
          value: json['impactScore']['value'] as int,
          category: json['impactScore']['category'] as String,
        ),
        confidenceScore: ConfidenceScore(
          value: json['confidenceScore']['value'] as int,
          evidenceLevel: EvidenceLevelExtension.fromString(json['confidenceScore']['evidenceLevel'] as String? ?? ''),
        ),
        evidenceLevel: EvidenceLevelExtension.fromString(json['evidenceLevel'] as String? ?? ''),
        sourceIds: List<String>.from(json['sourceIds'] as List<dynamic>? ?? []),
      );
}
