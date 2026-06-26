/// Vendor-neutral crash reporting abstraction.
abstract interface class CrashReportingService {
  Future<void> initialize();

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  });

  Future<void> log(String message);
}

class NoOpCrashReportingService implements CrashReportingService {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {}

  @override
  Future<void> log(String message) async {}
}
