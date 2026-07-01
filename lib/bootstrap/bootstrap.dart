import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

Future<void> runGlyLensApp(Widget app) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  final container = await bootstrap();
  final logger = container.read(appLoggerProvider);
  final crashReporting = container.read(crashReportingServiceProvider);

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    unawaited(
      crashReporting.recordError(
        details.exception,
        details.stack ?? StackTrace.current,
        reason: details.context?.toString(),
        fatal: true,
      ),
    );
    logger.error(
      'Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(crashReporting.recordError(error, stack, fatal: true));
    logger.error('Uncaught platform error', error: error, stackTrace: stack);
    return true;
  };

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: app,
    ),
  );
}
