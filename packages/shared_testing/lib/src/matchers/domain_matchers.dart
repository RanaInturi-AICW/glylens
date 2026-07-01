import 'package:shared_models/shared_models.dart';
import 'package:test/test.dart';

Matcher isValidFood() => predicate<Food>(
      (food) => food.name.isNotEmpty && food.category != Category.unknown,
      'valid food',
    );

Matcher hasEvidenceLevel(EvidenceLevel level) => predicate<GlycemicProfile>(
      (profile) => profile.evidenceLevel == level,
      'glycemic profile with evidence level $level',
    );
