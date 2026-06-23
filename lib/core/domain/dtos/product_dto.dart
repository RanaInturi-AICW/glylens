class ProductDto {
  final String productId;
  final String barcode;
  final String brand;
  final String name;
  final List<String> ingredientIds;
  final String nutritionProfileId;
  final String glycemicProfileId;

  ProductDto({
    required this.productId,
    required this.barcode,
    required this.brand,
    required this.name,
    this.ingredientIds = const [],
    required this.nutritionProfileId,
    required this.glycemicProfileId,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'barcode': barcode,
        'brand': brand,
        'name': name,
        'ingredientIds': ingredientIds,
        'nutritionProfileId': nutritionProfileId,
        'glycemicProfileId': glycemicProfileId,
      };

  factory ProductDto.fromJson(Map<String, dynamic> json) => ProductDto(
        productId: json['productId'] as String,
        barcode: json['barcode'] as String,
        brand: json['brand'] as String,
        name: json['name'] as String,
        ingredientIds: List<String>.from(json['ingredientIds'] as List<dynamic>? ?? []),
        nutritionProfileId: json['nutritionProfileId'] as String,
        glycemicProfileId: json['glycemicProfileId'] as String,
      );
}
