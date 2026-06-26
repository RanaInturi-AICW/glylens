import 'package:logger/logger.dart';

import '../config/app_config.dart';

/// Structured application logger — no [print] usage.
class AppLogger {
  AppLogger(this._logger);

  final Logger _logger;

  factory AppLogger.create(AppConfig config) {
    return AppLogger(
      Logger(
        level: config.enableLogging ? Level.debug : Level.warning,
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 100,
          colors: false,
          printEmojis: false,
        ),
      ),
    );
  }

  void debug(String message, {Map<String, Object?>? context}) =>
      _logger.d(_format(message, context));

  void info(String message, {Map<String, Object?>? context}) =>
      _logger.i(_format(message, context));

  void warning(String message, {Map<String, Object?>? context}) =>
      _logger.w(_format(message, context));

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) =>
      _logger.e(_format(message, context), error: error, stackTrace: stackTrace);

  void performance(String operation, Duration duration) =>
      info('perf:$operation', context: {'durationMs': duration.inMilliseconds});

  String _format(String message, Map<String, Object?>? context) {
    if (context == null || context.isEmpty) {
      return message;
    }
    return '$message | ${context.entries.map((e) => '${e.key}=${e.value}').join(', ')}';
  }
}
