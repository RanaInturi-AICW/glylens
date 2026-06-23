import '../validation/validators.dart';

class Product {
  final String productId;
  final String barcode;
  final String brand;
  final String name;
  final List<String> ingredientIds;
  final String nutritionProfileId;
  final String glycemicProfileId;

  Product({
    required this.productId,
    required this.barcode,
    required this.brand,
    required this.name,
    this.ingredientIds = const [],
    required this.nutritionProfileId,
    required this.glycemicProfileId,
  }) {
    Validators.validateId('productId', productId);
    Validators.validateNonEmptyString('barcode', barcode);
    Validators.validateNonEmptyString('brand', brand);
    Validators.validateNonEmptyString('name', name);
    if (ingredientIds.any((id) => id.trim().isEmpty)) {
      throw ArgumentError('Ingredient IDs must be non-empty strings.');
    }
    if (nutritionProfileId.trim().isEmpty) {
      throw ArgumentError.value(nutritionProfileId, 'nutritionProfileId', 'Nutrition profile reference cannot be empty.');
    }
    if (glycemicProfileId.trim().isEmpty) {
      throw ArgumentError.value(glycemicProfileId, 'glycemicProfileId', 'Glycemic profile reference cannot be empty.');
    }
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'barcode': barcode,
        'brand': brand,
        'name': name,
        'ingredientIds': ingredientIds,
        'nutritionProfileId': nutritionProfileId,
        'glycemicProfileId': glycemicProfileId,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json['productId'] as String,
        barcode: json['barcode'] as String,
        brand: json['brand'] as String,
        name: json['name'] as String,
        ingredientIds: List<String>.from(json['ingredientIds'] as List<dynamic>? ?? []),
        nutritionProfileId: json['nutritionProfileId'] as String,
        glycemicProfileId: json['glycemicProfileId'] as String,
      );
}
