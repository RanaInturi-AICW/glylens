import '../entities/product.dart';

abstract class IProductRepository {
  Future<Product?> getById(String productId);

  Future<Product?> getByBarcode(String barcode);

  Future<List<Product>> searchByNameOrBrand(String query);

  Future<void> save(Product product);
}
