class ImpactScoreDto {
  final int value;
  final String category;

  ImpactScoreDto({
    required this.value,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'value': value,
        'category': category,
      };

  factory ImpactScoreDto.fromJson(Map<String, dynamic> json) => ImpactScoreDto(
        value: json['value'] as int,
        category: json['category'] as String,
      );
}
