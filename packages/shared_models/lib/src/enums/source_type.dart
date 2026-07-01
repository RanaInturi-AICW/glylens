enum SourceType {
  government,
  academic,
  openData,
  industry,
  userSubmission,
  aiAssisted,
  unknown,
}

extension SourceTypeCodec on SourceType {
  String get wireName {
    return switch (this) {
      SourceType.government => 'government',
      SourceType.academic => 'academic',
      SourceType.openData => 'open_data',
      SourceType.industry => 'industry',
      SourceType.userSubmission => 'user_submission',
      SourceType.aiAssisted => 'ai_assisted',
      SourceType.unknown => 'unknown',
    };
  }

  static SourceType fromWire(String value) {
    return switch (value.toLowerCase()) {
      'government' => SourceType.government,
      'academic' => SourceType.academic,
      'open_data' || 'opendata' => SourceType.openData,
      'industry' => SourceType.industry,
      'user_submission' || 'usergenerated' => SourceType.userSubmission,
      'ai_assisted' => SourceType.aiAssisted,
      _ => SourceType.unknown,
    };
  }
}
