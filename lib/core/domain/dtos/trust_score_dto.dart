class TrustScoreDto {
  final int value;

  TrustScoreDto({required this.value});

  Map<String, dynamic> toJson() => {'value': value};

  factory TrustScoreDto.fromJson(Map<String, dynamic> json) => TrustScoreDto(
        value: json['value'] as int,
      );
}
