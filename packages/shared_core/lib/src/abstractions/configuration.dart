/// Environment configuration abstraction.
abstract interface class Configuration {
  String get environment;

  bool get isDevelopment;

  bool get isProduction;

  String? get(String key);
}

final class MapConfiguration implements Configuration {
  MapConfiguration({
    required this.environment,
    Map<String, String>? values,
  }) : _values = Map.unmodifiable(values ?? const {});

  @override
  final String environment;

  final Map<String, String> _values;

  @override
  bool get isDevelopment => environment == 'development';

  @override
  bool get isProduction => environment == 'production';

  @override
  String? get(String key) => _values[key];
}
