enum SourceType {
  government,
  academic,
  industry,
  openData,
  aiAssisted,
  userSubmission,
  unknown,
}

extension SourceTypeExtension on SourceType {
  String get name {
    switch (this) {
      case SourceType.government:
        return 'government';
      case SourceType.academic:
        return 'academic';
      case SourceType.industry:
        return 'industry';
      case SourceType.openData:
        return 'open_data';
      case SourceType.aiAssisted:
        return 'ai_assisted';
      case SourceType.userSubmission:
        return 'user_submission';
      case SourceType.unknown:
        return 'unknown';
    }
  }

  static SourceType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'government':
        return SourceType.government;
      case 'academic':
        return SourceType.academic;
      case 'industry':
        return SourceType.industry;
      case 'open_data':
      case 'opendata':
        return SourceType.openData;
      case 'ai_assisted':
      case 'ai-assisted':
        return SourceType.aiAssisted;
      case 'user_submission':
      case 'usersubmission':
        return SourceType.userSubmission;
      default:
        return SourceType.unknown;
    }
  }
}
