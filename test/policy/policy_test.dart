import 'package:test/test.dart';
import 'package:glylens/core/policy/source_trust_policy.dart';
import 'package:glylens/core/policy/confidence_policy.dart';
import 'package:glylens/core/policy/refusal_policy.dart';
import 'package:glylens/core/domain/entities/glycemic_profile.dart';
import 'package:glylens/core/domain/entities/source.dart';
import 'package:glylens/core/domain/enums/evidence_level.dart';
import 'package:glylens/core/domain/enums/source_type.dart';
import 'package:glylens/core/domain/value_objects/confidence_score.dart';
import 'package:glylens/core/domain/value_objects/gl_value.dart';
import 'package:glylens/core/domain/value_objects/gi_value.dart';
import 'package:glylens/core/domain/value_objects/impact_score.dart';
import 'package:glylens/core/domain/value_objects/trust_score.dart';

void main() {
  group('SourceTrustPolicy', () {
    final policy = SourceTrustPolicy();

    test('calculates trust score for government source', () {
      final source = Source(
        sourceId: 'source_gov',
        name: 'Government Data',
        type: SourceType.government,
        url: 'https://gov.example',
        trustScore: TrustScore(92),
      );

      final result = policy.evaluate(source);

      expect(result.value, equals(92));
      expect(result.isTrustworthy, isTrue);
    });

    test('applies weight for open data source', () {
      final source = Source(
        sourceId: 'source_open',
        name: 'Open Source',
        type: SourceType.openData,
        url: 'https://open.example',
        trustScore: TrustScore(80),
      );

      final result = policy.evaluate(source);

      expect(result.value, equals(72));
    });
  });

  group('ConfidencePolicy', () {
    final policy = ConfidencePolicy();

    test('accepts A-level confidence at threshold', () {
      final score = ConfidenceScore(value: 90, evidenceLevel: EvidenceLevel.a);
      expect(policy.isAcceptable(score), isTrue);
    });

    test('rejects unknown-level confidence below required minimum', () {
      final score = ConfidenceScore(value: 44, evidenceLevel: EvidenceLevel.unknown);
      expect(policy.isAcceptable(score), isFalse);
    });
  });

  group('RefusalPolicy', () {
    final confidencePolicy = ConfidencePolicy();
    final policy = RefusalPolicy(confidencePolicy: confidencePolicy);

    test('refuses unknown evidence level profile', () {
      final profile = GlycemicProfile(
        glycemicProfileId: 'profile_unknown',
        giValue: GIValue(value: 60, sourceType: 'estimated', confidence: 50),
        glValue: GLValue(value: 12, confidence: 50),
        impactScore: ImpactScore(value: 50, category: 'low'),
        confidenceScore: ConfidenceScore(value: 44, evidenceLevel: EvidenceLevel.unknown),
        evidenceLevel: EvidenceLevel.unknown,
        sourceIds: [],
      );

      final decision = policy.evaluate(profile);
      expect(decision.refused, isTrue);
      expect(decision.reason, contains('unknown'));
    });

    test('refuses low confidence profile with inadequate trust', () {
      final profile = GlycemicProfile(
        glycemicProfileId: 'profile_low',
        giValue: GIValue(value: 60, sourceType: 'estimated', confidence: 60),
        glValue: GLValue(value: 30, confidence: 60),
        impactScore: ImpactScore(value: 55, category: 'moderate'),
        confidenceScore: ConfidenceScore(value: 80, evidenceLevel: EvidenceLevel.b),
        evidenceLevel: EvidenceLevel.b,
        sourceIds: [],
      );

      final decision = policy.evaluate(profile, averageSourceTrust: TrustScore(55));
      expect(decision.refused, isTrue);
      expect(decision.reason, contains('trust'));
    });
  });
}
