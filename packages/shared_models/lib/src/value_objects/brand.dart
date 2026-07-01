import 'package:shared_core/shared_core.dart';

final class Brand extends ValueObject<String> {
  Brand(String value) : super(Guard.againstEmpty(value, name: 'brand'));

  factory Brand.fromJson(String value) => Brand(value);

  String toJson() => value;
}
