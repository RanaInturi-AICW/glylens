enum ProcessingLevel {
  unprocessed,
  minimallyProcessed,
  moderatelyProcessed,
  highlyProcessed,
  unknown,
}

extension ProcessingLevelExtension on ProcessingLevel {
  String get name {
    switch (this) {
      case ProcessingLevel.unprocessed:
        return 'unprocessed';
      case ProcessingLevel.minimallyProcessed:
        return 'minimally_processed';
      case ProcessingLevel.moderatelyProcessed:
        return 'moderately_processed';
      case ProcessingLevel.highlyProcessed:
        return 'highly_processed';
      case ProcessingLevel.unknown:
        return 'unknown';
    }
  }

  static ProcessingLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'unprocessed':
        return ProcessingLevel.unprocessed;
      case 'minimally_processed':
      case 'minimallyprocessed':
        return ProcessingLevel.minimallyProcessed;
      case 'moderately_processed':
      case 'moderatelyprocessed':
        return ProcessingLevel.moderatelyProcessed;
      case 'highly_processed':
      case 'highlyprocessed':
        return ProcessingLevel.highlyProcessed;
      default:
        return ProcessingLevel.unknown;
    }
  }
}
