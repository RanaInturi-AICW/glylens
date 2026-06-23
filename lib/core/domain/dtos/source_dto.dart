import '../enums/source_type.dart';
import 'trust_score_dto.dart';

class SourceDto {
  final String sourceId;
  final String name;
  final SourceType type;
  final String url;
  final TrustScoreDto trustScore;

  SourceDto({
    required this.sourceId,
    required this.name,
    required this.type,
    required this.url,
    required this.trustScore,
  });

  Map<String, dynamic> toJson() => {
        'sourceId': sourceId,
        'name': name,
        'type': type.name,
        'url': url,
        'trustScore': trustScore.toJson(),
      };

  factory SourceDto.fromJson(Map<String, dynamic> json) => SourceDto(
        sourceId: json['sourceId'] as String,
        name: json['name'] as String,
        type: SourceTypeExtension.fromString(json['type'] as String? ?? ''),
        url: json['url'] as String,
        trustScore: TrustScoreDto.fromJson(json['trustScore'] as Map<String, dynamic>),
      );
}
