import '../../domain/engines/i_explainability_engine.dart';
import '../../domain/entities/glycemic_profile.dart';
import '../../domain/entities/source.dart';
import '../../domain/enums/evidence_level.dart';
import '../../domain/repositories/i_source_repository.dart';
import '../../domain/value_objects/trust_score.dart';

class ExplainabilityEngine implements IExplainabilityEngine {
  final ISourceRepository sourceRepository;

  const ExplainabilityEngine(this.sourceRepository);

  @override
  Future<Map<String, dynamic>> generateExplanation({
    required GlycemicProfile glycemicProfile,
    required Map<String, dynamic> context,
  }) async {
    final sourceResults = await Future.wait(
      glycemicProfile.sourceIds.map((id) => sourceRepository.getById(id)),
    );

    final sources = sourceResults.whereType<Source>().toList();
    final sourceCount = sources.length;
    final averageTrust = sources.isEmpty
        ? TrustScore(50)
        : TrustScore.aggregate(sources.map((source) => source.trustScore).toList());

    final status = _determineStatus(glycemicProfile, sources, averageTrust);
    final refusalReason = _refusalReason(glycemicProfile, sources, averageTrust, status);

    return {
      'summary': 'Glycemic profile explanation for ${glycemicProfile.glycemicProfileId}.',
      'status': status,
      'refusalReason': refusalReason,
      'sourceCount': sourceCount,
      'averageSourceTrust': averageTrust.toJson(),
      'sourceTrustBreakdown': sources.map((source) => source.toJson()).toList(),
      'gi': glycemicProfile.giValue.toJson(),
      'gl': glycemicProfile.glValue.toJson(),
      'confidence': glycemicProfile.confidenceScore.toJson(),
      'evidenceLevel': glycemicProfile.evidenceLevel.name,
      'impact': glycemicProfile.impactScore.toJson(),
      'sourceIds': glycemicProfile.sourceIds,
      'context': context,
      'explanation': _buildExplanation(glycemicProfile, averageTrust, sourceCount, status, refusalReason),
    };
  }

  String _determineStatus(
    GlycemicProfile glycemicProfile,
    List<Source> sources,
    TrustScore averageTrust,
  ) {
    if (glycemicProfile.evidenceLevel == EvidenceLevel.unknown) {
      return 'refused';
    }
    if (sources.isEmpty) {
      return 'refused';
    }
    if (glycemicProfile.confidenceScore.value < 50) {
      return 'refused';
    }
    if (averageTrust.value < 60) {
      return 'low_confidence';
    }
    if (glycemicProfile.confidenceScore.value < 70 || averageTrust.value < 75) {
      return 'low_confidence';
    }
    return 'accepted';
  }

  String? _refusalReason(
    GlycemicProfile glycemicProfile,
    List<Source> sources,
    TrustScore averageTrust,
    String status,
  ) {
    if (status != 'refused') {
      return null;
    }
    if (glycemicProfile.evidenceLevel == EvidenceLevel.unknown) {
      return 'Evidence level unknown; unable to validate the glycemic profile.';
    }
    if (sources.isEmpty) {
      return 'No valid source metadata was found for the profile source IDs.';
    }
    if (glycemicProfile.confidenceScore.value < 50) {
      return 'Confidence score below the minimum acceptable threshold.';
    }
    if (averageTrust.value < 60) {
      return 'Aggregated source trust is too low for a reliable prediction.';
    }
    return 'Profile does not meet acceptance criteria.';
  }

  String _buildExplanation(
    GlycemicProfile glycemicProfile,
    TrustScore averageTrust,
    int sourceCount,
    String status,
    String? refusalReason,
  ) {
    final buffer = StringBuffer();
    buffer.write('The profile uses $sourceCount source(s) with an average trust of ${averageTrust.value}. ');
    buffer.write('Evidence level ${glycemicProfile.evidenceLevel.name} was applied with confidence ${glycemicProfile.confidenceScore.value}. ');

    if (status == 'accepted') {
      buffer.write('The profile is accepted for use based on the current confidence and trust metrics.');
    } else if (status == 'low_confidence') {
      buffer.write('The profile is flagged as low confidence and should be reviewed before publication.');
    } else {
      buffer.write('The profile is refused.');
      if (refusalReason != null) {
        buffer.write(' Reason: $refusalReason');
      }
    }

    return buffer.toString();
  }
}
