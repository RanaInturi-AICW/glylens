import 'package:shared_models/shared_models.dart';

import '../mothers/object_mothers.dart';

abstract final class SampleDataset {
  static List<Ingredient> get ingredients => [ObjectMothers.basmatiRice()];

  static List<Food> get foods => [ObjectMothers.chickenBiryani()];

  static List<Source> get sources => [ObjectMothers.usdaSource()];

  static List<Evidence> get evidence => [ObjectMothers.measuredGiEvidence()];

  static List<GlycemicProfile> get glycemicProfiles => [ObjectMothers.riceGlycemicProfile()];
}
