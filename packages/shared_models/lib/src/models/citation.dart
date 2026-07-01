import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../validation/validators.dart';

final class Citation extends Equatable {
  const Citation({
    required this.id,
    required this.sourceId,
    required this.title,
    required this.reference,
    this.fieldPath,
  });

  final CitationId id;
  final SourceId sourceId;
  final String title;
  final String reference;
  final String? fieldPath;

  factory Citation.create({
    required String citationId,
    required String sourceId,
    required String title,
    required String reference,
    String? fieldPath,
  }) {
    Validators.validateNonEmptyString('title', title);
    Validators.validateNonEmptyString('reference', reference);
    return Citation(
      id: CitationId(citationId),
      sourceId: SourceId(sourceId),
      title: title,
      reference: reference,
      fieldPath: fieldPath,
    );
  }

  factory Citation.fromJson(Map<String, dynamic> json) => Citation.create(
        citationId: json['citationId'] as String,
        sourceId: json['sourceId'] as String,
        title: json['title'] as String,
        reference: json['reference'] as String,
        fieldPath: json['fieldPath'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'citationId': id.value,
        'sourceId': sourceId.value,
        'title': title,
        'reference': reference,
        if (fieldPath != null) 'fieldPath': fieldPath,
      };

  Citation copyWith({
    CitationId? id,
    SourceId? sourceId,
    String? title,
    String? reference,
    String? fieldPath,
  }) {
    return Citation(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      reference: reference ?? this.reference,
      fieldPath: fieldPath ?? this.fieldPath,
    );
  }

  @override
  List<Object?> get props => [id, sourceId, title, reference, fieldPath];
}
