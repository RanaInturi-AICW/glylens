import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../enums/evidence_level.dart';
import '../validation/validators.dart';

final class GlycemicProfile extends Equatable {
  const GlycemicProfile({
    required this.id,
    required this.gi,
    required this.gl,
    required this.impactScore,
    required this.confidenceScore,
    required this.evidenceLevel,
    this.sourceIds = const [],
  });

  final GlycemicProfileId id;
  final int gi;
  final int gl;
  final int impactScore;
  final int confidenceScore;
  final EvidenceLevel evidenceLevel;
  final List<String> sourceIds;

  factory GlycemicProfile.create({
    required String glycemicProfileId,
    required int gi,
    required int gl,
    required int impactScore,
    required int confidenceScore,
    required EvidenceLevel evidenceLevel,
    List<String> sourceIds = const [],
  }) {
    Validators.validateGiRange('gi', gi);
    Guard.againstNegative(gl.toDouble(), name: 'gl');
    Validators.validateConfidenceRange('impactScore', impactScore);
    Validators.validateConfidenceRange('confidenceScore', confidenceScore);
    Validators.validateEvidenceLevel('evidenceLevel', evidenceLevel);
    Validators.validateStringList('sourceIds', sourceIds);
    return GlycemicProfile(
      id: GlycemicProfileId(glycemicProfileId),
      gi: gi,
      gl: gl,
      impactScore: impactScore,
      confidenceScore: confidenceScore,
      evidenceLevel: evidenceLevel,
      sourceIds: sourceIds,
    );
  }

  factory GlycemicProfile.fromJson(Map<String, dynamic> json) => GlycemicProfile.create(
        glycemicProfileId: json['glycemicProfileId'] as String,
        gi: json['gi'] as int,
        gl: json['gl'] as int,
        impactScore: json['impactScore'] as int,
        confidenceScore: json['confidenceScore'] as int,
        evidenceLevel: EvidenceLevelCodec.fromWire(json['evidenceLevel'] as String? ?? ''),
        sourceIds: List<String>.from(json['sourceIds'] as List<dynamic>? ?? []),
      );

  Map<String, dynamic> toJson() => {
        'glycemicProfileId': id.value,
        'gi': gi,
        'gl': gl,
        'impactScore': impactScore,
        'confidenceScore': confidenceScore,
        'evidenceLevel': evidenceLevel.wireName,
        'sourceIds': sourceIds,
      };

  GlycemicProfile copyWith({
    GlycemicProfileId? id,
    int? gi,
    int? gl,
    int? impactScore,
    int? confidenceScore,
    EvidenceLevel? evidenceLevel,
    List<String>? sourceIds,
  }) {
    return GlycemicProfile(
      id: id ?? this.id,
      gi: gi ?? this.gi,
      gl: gl ?? this.gl,
      impactScore: impactScore ?? this.impactScore,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      evidenceLevel: evidenceLevel ?? this.evidenceLevel,
      sourceIds: sourceIds ?? this.sourceIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        gi,
        gl,
        impactScore,
        confidenceScore,
        evidenceLevel,
        sourceIds,
      ];
}
