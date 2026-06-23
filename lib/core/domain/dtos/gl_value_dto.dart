class GLValueDto {
  final int value;
  final int confidence;

  GLValueDto({
    required this.value,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
        'value': value,
        'confidence': confidence,
      };

  factory GLValueDto.fromJson(Map<String, dynamic> json) => GLValueDto(
        value: json['value'] as int,
        confidence: json['confidence'] as int,
      );
}
