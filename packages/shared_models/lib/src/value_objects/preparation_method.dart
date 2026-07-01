import 'package:shared_core/shared_core.dart';

final class PreparationMethod extends ValueObject<String> {
  PreparationMethod(String value) : super(Guard.againstEmpty(value, name: 'preparationMethod'));

  factory PreparationMethod.fromJson(String value) => PreparationMethod(value);

  String toJson() => value;
}
