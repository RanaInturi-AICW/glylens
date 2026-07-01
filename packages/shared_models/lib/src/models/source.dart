import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../enums/source_type.dart';
import '../validation/validators.dart';

final class Source extends Equatable {
  const Source({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.trustScore,
  });

  final SourceId id;
  final String name;
  final SourceType type;
  final String url;
  final int trustScore;

  factory Source.create({
    required String sourceId,
    required String name,
    required SourceType type,
    required String url,
    required int trustScore,
  }) {
    Validators.validateNonEmptyString('name', name);
    Validators.validateNonEmptyString('url', url);
    Validators.validateSourceType('type', type);
    Validators.validateTrustScoreRange('trustScore', trustScore);
    return Source(
      id: SourceId(sourceId),
      name: name,
      type: type,
      url: url,
      trustScore: trustScore,
    );
  }

  factory Source.fromJson(Map<String, dynamic> json) => Source.create(
        sourceId: json['sourceId'] as String,
        name: json['name'] as String,
        type: SourceTypeCodec.fromWire(json['type'] as String? ?? ''),
        url: json['url'] as String,
        trustScore: json['trustScore'] as int,
      );

  Map<String, dynamic> toJson() => {
        'sourceId': id.value,
        'name': name,
        'type': type.wireName,
        'url': url,
        'trustScore': trustScore,
      };

  Source copyWith({
    SourceId? id,
    String? name,
    SourceType? type,
    String? url,
    int? trustScore,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      trustScore: trustScore ?? this.trustScore,
    );
  }

  @override
  List<Object?> get props => [id, name, type, url, trustScore];
}
