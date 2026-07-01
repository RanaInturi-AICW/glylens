import 'package:shared_core/shared_core.dart';

final class Region extends ValueObject<String> {
  Region(String value) : super(Guard.againstEmpty(value, name: 'region'));

  factory Region.fromJson(String value) => Region(value);

  String toJson() => value;
}
