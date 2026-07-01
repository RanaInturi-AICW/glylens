enum ProcessingLevel {
  unprocessed,
  minimallyProcessed,
  moderatelyProcessed,
  highlyProcessed,
  unknown,
}

extension ProcessingLevelCodec on ProcessingLevel {
  String get wireName {
    return switch (this) {
      ProcessingLevel.unprocessed => 'unprocessed',
      ProcessingLevel.minimallyProcessed => 'minimally_processed',
      ProcessingLevel.moderatelyProcessed => 'moderately_processed',
      ProcessingLevel.highlyProcessed => 'highly_processed',
      ProcessingLevel.unknown => 'unknown',
    };
  }

  static ProcessingLevel fromWire(String value) {
    return switch (value.toLowerCase()) {
      'unprocessed' => ProcessingLevel.unprocessed,
      'minimally_processed' || 'minimallyprocessed' => ProcessingLevel.minimallyProcessed,
      'moderately_processed' || 'moderatelyprocessed' || 'moderate' => ProcessingLevel.moderatelyProcessed,
      'highly_processed' || 'highlyprocessed' => ProcessingLevel.highlyProcessed,
      _ => ProcessingLevel.unknown,
    };
  }
}
