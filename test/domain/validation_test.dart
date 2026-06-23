import 'package:test/test.dart';
import 'package:glylens/core/domain/errors/validation_error.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/enums/source_type.dart';
import 'package:glylens/core/domain/validation/validators.dart';

void main() {
  group('Validators', () {
    test('validates GI range within bounds', () {
      expect(() => Validators.validateGiRange('gi', 50), returnsNormally);
    });

    test('rejects GI out of range', () {
      expect(
        () => Validators.validateGiRange('gi', 120),
        throwsA(isA<ValidationError>()),
      );
    });

    test('validates confidence range within bounds', () {
      expect(() => Validators.validateConfidenceRange('confidence', 75), returnsNormally);
    });

    test('rejects invalid confidence range', () {
      expect(
        () => Validators.validateConfidenceRange('confidence', -5),
        throwsA(isA<ValidationError>()),
      );
    });

    test('validates source IDs list', () {
      expect(() => Validators.validateSourceIds('sourceIds', ['source_1']), returnsNormally);
    });

    test('rejects empty source IDs list', () {
      expect(
        () => Validators.validateSourceIds('sourceIds', []),
        throwsA(isA<ValidationError>()),
      );
    });

    test('validates evidence level values', () {
      expect(() => Validators.validateEvidenceLevel('level', EvidenceLevel.a), returnsNormally);
    });

    test('rejects unknown evidence level', () {
      expect(
        () => Validators.validateEvidenceLevel('level', EvidenceLevel.unknown),
        throwsA(isA<ValidationError>()),
      );
    });

    test('validates portion profile structure', () {
      expect(
        () => Validators.validatePortionProfiles('portionProfiles', [
          {'serving': '1 bowl', 'grams': 180},
        ]),
        returnsNormally,
      );
    });

    test('rejects invalid portion profile entries', () {
      expect(
        () => Validators.validatePortionProfiles('portionProfiles', [
          {'serving': '', 'grams': 0},
        ]),
        throwsA(isA<ValidationError>()),
      );
    });

    test('validates source type values', () {
      expect(() => Validators.validateSourceType('type', SourceType.government), returnsNormally);
    });

    test('rejects unknown source type', () {
      expect(
        () => Validators.validateSourceType('type', SourceType.unknown),
        throwsA(isA<ValidationError>()),
      );
    });
  });
}
