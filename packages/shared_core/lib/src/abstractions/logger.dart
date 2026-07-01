/// Structured logging abstraction (vendor-neutral).
abstract interface class Logger {
  void debug(String message, {Map<String, Object?>? context});

  void info(String message, {Map<String, Object?>? context});

  void warning(String message, {Map<String, Object?>? context});

  void error(String message, {Object? error, StackTrace? stackTrace});
}

final class NoOpLogger implements Logger {
  const NoOpLogger();

  @override
  void debug(String message, {Map<String, Object?>? context}) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void info(String message, {Map<String, Object?>? context}) {}

  @override
  void warning(String message, {Map<String, Object?>? context}) {}
}
