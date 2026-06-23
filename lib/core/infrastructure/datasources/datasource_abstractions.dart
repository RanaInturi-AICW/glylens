import '../../domain/entities/food.dart';
import '../../domain/entities/glycemic_profile.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/source.dart';
import '../../domain/entities/evidence.dart';

abstract class IDataSource<T> {
  Future<T?> fetchById(String id);
  Future<List<T>> listAll();
  Future<void> save(T value);
}

abstract class IFoodDatasource extends IDataSource<Food> {
  Future<List<Food>> searchByName(String query);
  Future<List<Food>> listByRegion(String region);
}

abstract class IGlycemicProfileDatasource extends IDataSource<GlycemicProfile> {}

abstract class IIngredientDatasource extends IDataSource<Ingredient> {}

abstract class IProductDatasource extends IDataSource<Product> {}

abstract class ISourceDatasource extends IDataSource<Source> {}

abstract class IEvidenceDatasource extends IDataSource<Evidence> {}
