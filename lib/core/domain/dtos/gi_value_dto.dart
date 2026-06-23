class GIValueDto {
  final int value;
  final String sourceType;
  final int confidence;

  GIValueDto({
    required this.value,
    required this.sourceType,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
        'value': value,
        'sourceType': sourceType,
        'confidence': confidence,
      };

  factory GIValueDto.fromJson(Map<String, dynamic> json) => GIValueDto(
        value: json['value'] as int,
        sourceType: json['sourceType'] as String,
        confidence: json['confidence'] as int,
      );
}
