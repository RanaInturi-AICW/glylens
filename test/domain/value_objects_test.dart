import 'package:test/test.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/value_objects/confidence_score.dart';
import 'package:glylens/core/domain/value_objects/gl_value.dart';
import 'package:glylens/core/domain/value_objects/gi_value.dart';
import 'package:glylens/core/domain/value_objects/impact_score.dart';
import 'package:glylens/core/domain/value_objects/trust_score.dart';
import 'package:glylens/core/domain/errors/validation_error.dart';

void main() {
  group('ConfidenceScore', () {
    test('creates valid A-level confidence score', () {
      final score = ConfidenceScore(value: 95, evidenceLevel: EvidenceLevel.a);
      expect(score.value, 95);
      expect(score.evidenceLevel, EvidenceLevel.a);
      expect(score.isAcceptable, isTrue);
    });

    test('throws when score mismatches evidence level', () {
      expect(
        () => ConfidenceScore(value: 70, evidenceLevel: EvidenceLevel.a),
        throwsA(isA<ValidationError>()),
      );
    });

    test('rejects out-of-range confidence', () {
      expect(
        () => ConfidenceScore(value: 120, evidenceLevel: EvidenceLevel.a),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('ImpactScore', () {
    test('creates a moderate impact score', () {
      final score = ImpactScore(value: 52, category: 'moderate');
      expect(score.value, 52);
      expect(score.category, 'moderate');
      expect(score.isModerate, isTrue);
    });

    test('throws when impact category is empty', () {
      expect(
        () => ImpactScore(value: 45, category: ''),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('TrustScore', () {
    test('creates valid trust score', () {
      final score = TrustScore(80);
      expect(score.value, 80);
      expect(score.isTrustworthy, isTrue);
    });

    test('aggregates multiple trust scores', () {
      final aggregated = TrustScore.aggregate([TrustScore(80), TrustScore(90), TrustScore(70)]);
      expect(aggregated.value, 80);
    });

    test('throws when aggregating empty list', () {
      expect(
        () => TrustScore.aggregate([]),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('GIValue', () {
    test('creates measured GI value', () {
      final gi = GIValue(value: 55, sourceType: 'measured', confidence: 90);
      expect(gi.value, 55);
      expect(gi.isMeasured, isTrue);
    });

    test('throws when GI is out of range', () {
      expect(
        () => GIValue(value: 120, sourceType: 'published', confidence: 85),
        throwsA(isA<ValidationError>()),
      );
    });
  });

  group('GLValue', () {
    test('creates valid GL value', () {
      final gl = GLValue(value: 10, confidence: 85);
      expect(gl.value, 10);
      expect(gl.confidence, 85);
      expect(gl.isLow, isTrue);
    });

    test('throws when GL is negative', () {
      expect(
        () => GLValue(value: -1, confidence: 80),
        throwsA(isA<ValidationError>()),
      );
    });
  });
}
