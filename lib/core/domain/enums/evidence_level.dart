enum EvidenceLevel { a, b, c, d, unknown }

extension EvidenceLevelExtension on EvidenceLevel {
  String get name {
    switch (this) {
      case EvidenceLevel.a:
        return 'A';
      case EvidenceLevel.b:
        return 'B';
      case EvidenceLevel.c:
        return 'C';
      case EvidenceLevel.d:
        return 'D';
      case EvidenceLevel.unknown:
        return 'UNKNOWN';
    }
  }

  static EvidenceLevel fromString(String value) {
    switch (value.toUpperCase()) {
      case 'A':
        return EvidenceLevel.a;
      case 'B':
        return EvidenceLevel.b;
      case 'C':
        return EvidenceLevel.c;
      case 'D':
        return EvidenceLevel.d;
      default:
        return EvidenceLevel.unknown;
    }
  }
}
