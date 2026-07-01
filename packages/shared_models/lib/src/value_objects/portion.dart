import 'package:equatable/equatable.dart';

import '../value_objects/serving_size.dart';

/// Named portion with gram weight.
final class Portion extends Equatable {
  const Portion({required this.serving, required this.grams});

  final String serving;
  final ServingSize grams;

  factory Portion.fromJson(Map<String, dynamic> json) => Portion(
        serving: json['serving'] as String,
        grams: ServingSize.fromJson(json['grams'] as num),
      );

  Map<String, dynamic> toJson() => {
        'serving': serving,
        'grams': grams.toJson(),
      };

  Portion copyWith({String? serving, ServingSize? grams}) {
    return Portion(
      serving: serving ?? this.serving,
      grams: grams ?? this.grams,
    );
  }

  @override
  List<Object?> get props => [serving, grams];
}
