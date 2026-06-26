/// Vendor-neutral analytics abstraction (ADR-0011).
abstract interface class AnalyticsService {
  Future<void> initialize();

  Future<void> logEvent(String name, {Map<String, Object?>? parameters});

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty(String name, String? value);
}

class NoOpAnalyticsService implements AnalyticsService {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty(String name, String? value) async {}
}
