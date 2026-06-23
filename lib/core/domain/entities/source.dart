import '../enums/source_type.dart';
import '../value_objects/trust_score.dart';
import '../validation/validators.dart';

class Source {
  final String sourceId;
  final String name;
  final SourceType type;
  final String url;
  final TrustScore trustScore;

  Source({
    required this.sourceId,
    required this.name,
    required this.type,
    required this.url,
    required this.trustScore,
  }) {
    Validators.validateId('sourceId', sourceId);
    Validators.validateNonEmptyString('name', name);
    Validators.validateSourceType('type', type);
    Validators.validateNonEmptyString('url', url);
  }

  Map<String, dynamic> toJson() => {
        'sourceId': sourceId,
        'name': name,
        'type': type.name,
        'url': url,
        'trustScore': trustScore.toJson(),
      };

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        sourceId: json['sourceId'] as String,
        name: json['name'] as String,
        type: SourceTypeExtension.fromString(json['type'] as String? ?? ''),
        url: json['url'] as String,
        trustScore: TrustScore((json['trustScore'] as Map<String, dynamic>)['value'] as int),
      );
}
