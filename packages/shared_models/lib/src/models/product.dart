import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

import '../validation/validators.dart';
import '../value_objects/barcode.dart';
import '../value_objects/brand.dart';

final class Product extends Equatable {
  const Product({
    required this.id,
    required this.barcode,
    required this.brand,
    required this.name,
    this.ingredientIds = const [],
    required this.nutritionProfileId,
    required this.glycemicProfileId,
  });

  final ProductId id;
  final Barcode barcode;
  final Brand brand;
  final String name;
  final List<String> ingredientIds;
  final NutritionProfileId nutritionProfileId;
  final GlycemicProfileId glycemicProfileId;

  factory Product.create({
    required String productId,
    required String barcode,
    required String brand,
    required String name,
    List<String> ingredientIds = const [],
    required String nutritionProfileId,
    required String glycemicProfileId,
  }) {
    Validators.validateNonEmptyString('name', name);
    Validators.validateStringList('ingredientIds', ingredientIds);
    return Product(
      id: ProductId(productId),
      barcode: Barcode(barcode),
      brand: Brand(brand),
      name: name,
      ingredientIds: ingredientIds,
      nutritionProfileId: NutritionProfileId(nutritionProfileId),
      glycemicProfileId: GlycemicProfileId(glycemicProfileId),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product.create(
        productId: json['productId'] as String,
        barcode: json['barcode'] as String,
        brand: json['brand'] as String,
        name: json['name'] as String,
        ingredientIds: List<String>.from(json['ingredientIds'] as List<dynamic>? ?? []),
        nutritionProfileId: json['nutritionProfileId'] as String,
        glycemicProfileId: json['glycemicProfileId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'productId': id.value,
        'barcode': barcode.toJson(),
        'brand': brand.toJson(),
        'name': name,
        'ingredientIds': ingredientIds,
        'nutritionProfileId': nutritionProfileId.value,
        'glycemicProfileId': glycemicProfileId.value,
      };

  Product copyWith({
    ProductId? id,
    Barcode? barcode,
    Brand? brand,
    String? name,
    List<String>? ingredientIds,
    NutritionProfileId? nutritionProfileId,
    GlycemicProfileId? glycemicProfileId,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      name: name ?? this.name,
      ingredientIds: ingredientIds ?? this.ingredientIds,
      nutritionProfileId: nutritionProfileId ?? this.nutritionProfileId,
      glycemicProfileId: glycemicProfileId ?? this.glycemicProfileId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        barcode,
        brand,
        name,
        ingredientIds,
        nutritionProfileId,
        glycemicProfileId,
      ];
}
