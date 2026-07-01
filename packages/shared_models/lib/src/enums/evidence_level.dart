enum EvidenceLevel { a, b, c, d, unknown }

extension EvidenceLevelCodec on EvidenceLevel {
  String get wireName => name.toUpperCase();

  static EvidenceLevel fromWire(String value) {
    return switch (value.toUpperCase()) {
      'A' => EvidenceLevel.a,
      'B' => EvidenceLevel.b,
      'C' => EvidenceLevel.c,
      'D' => EvidenceLevel.d,
      _ => EvidenceLevel.unknown,
    };
  }
}
