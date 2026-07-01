import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../enums/evidence_level.dart';
import '../validation/validators.dart';

final class Evidence extends Equatable {
  const Evidence({
    required this.id,
    required this.level,
    required this.confidence,
    this.sourceIds = const [],
    this.relatedEntityIds = const [],
  });

  final EvidenceId id;
  final EvidenceLevel level;
  final int confidence;
  final List<String> sourceIds;
  final List<String> relatedEntityIds;

  factory Evidence.create({
    required String evidenceId,
    required EvidenceLevel level,
    required int confidence,
    List<String> sourceIds = const [],
    List<String> relatedEntityIds = const [],
  }) {
    Validators.validateEvidenceLevel('level', level);
    Validators.validateConfidenceRange('confidence', confidence);
    Validators.validateSourceIds('sourceIds', sourceIds);
    Validators.validateStringList('relatedEntityIds', relatedEntityIds);
    return Evidence(
      id: EvidenceId(evidenceId),
      level: level,
      confidence: confidence,
      sourceIds: sourceIds,
      relatedEntityIds: relatedEntityIds,
    );
  }

  factory Evidence.fromJson(Map<String, dynamic> json) => Evidence.create(
        evidenceId: json['evidenceId'] as String,
        level: EvidenceLevelCodec.fromWire(json['level'] as String? ?? ''),
        confidence: json['confidence'] as int,
        sourceIds: List<String>.from(json['sourceIds'] as List<dynamic>? ?? []),
        relatedEntityIds: List<String>.from(json['relatedEntityIds'] as List<dynamic>? ?? []),
      );

  Map<String, dynamic> toJson() => {
        'evidenceId': id.value,
        'level': level.wireName,
        'confidence': confidence,
        'sourceIds': sourceIds,
        'relatedEntityIds': relatedEntityIds,
      };

  Evidence copyWith({
    EvidenceId? id,
    EvidenceLevel? level,
    int? confidence,
    List<String>? sourceIds,
    List<String>? relatedEntityIds,
  }) {
    return Evidence(
      id: id ?? this.id,
      level: level ?? this.level,
      confidence: confidence ?? this.confidence,
      sourceIds: sourceIds ?? this.sourceIds,
      relatedEntityIds: relatedEntityIds ?? this.relatedEntityIds,
    );
  }

  @override
  List<Object?> get props => [id, level, confidence, sourceIds, relatedEntityIds];
}
