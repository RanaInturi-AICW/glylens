import 'package:shared_core/shared_core.dart';

import '../enums/category.dart';

final class FoodCategoryValue extends ValueObject<Category> {
  FoodCategoryValue(Category value) : super(value) {
    if (value == Category.unknown) {
      throw ValidationException(
        field: 'category',
        message: 'Category cannot be unknown.',
        validationCode: 'invalid',
      );
    }
  }

  factory FoodCategoryValue.fromJson(String value) => FoodCategoryValue(CategoryCodec.fromWire(value));

  String toJson() => value.wireName;
}
