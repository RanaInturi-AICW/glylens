import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/analytics/analytics_service.dart';
import '../core/analytics/crash_reporting_service.dart';
import '../core/cache/cache_store.dart';
import '../core/cache/hive_cache_store.dart';
import '../core/config/app_config.dart';
import '../core/logging/app_logger.dart';
import '../core/security/certificate_pinning_service.dart';
import '../core/security/flutter_secure_storage_service.dart';
import '../core/security/secure_storage_service.dart';
import '../core/security/token_storage.dart';
import 'firebase_options.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  final config = ref.watch(appConfigProvider);
  final logger = AppLogger.create(config);
  logger.info('GlyLens starting', context: {'environment': config.environment.value});
  return logger;
});

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return FlutterSecureStorageService();
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage(ref.watch(secureStorageProvider));
});

final cacheStoreProvider = Provider<CacheStore>((ref) {
  return HiveCacheStore(ref.watch(appLoggerProvider));
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return NoOpAnalyticsService();
});

final crashReportingServiceProvider = Provider<CrashReportingService>((ref) {
  return NoOpCrashReportingService();
});

final certificatePinningProvider = Provider<CertificatePinningService>((ref) {
  return NoOpCertificatePinningService();
});

final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// Bootstrap completes before [runApp].
Future<ProviderContainer> bootstrap() async {
  final config = AppConfig.fromEnvironment();
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(config),
    ],
  );

  final logger = container.read(appLoggerProvider);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.fromConfig(config),
    );
    logger.info('Firebase initialized');
  } catch (e, st) {
    logger.error('Firebase initialization failed', error: e, stackTrace: st);
    rethrow;
  }

  await container.read(analyticsServiceProvider).initialize();
  await container.read(crashReportingServiceProvider).initialize();
  await container.read(certificatePinningProvider).initialize(pinnedSha256: []);
  await container.read(cacheStoreProvider).initialize();

  final onboardingFlag = await container.read(cacheStoreProvider).readString(
        'onboarding_complete',
      );
  container.read(onboardingCompleteProvider.notifier).state =
      onboardingFlag == 'true';

  return container;
}
