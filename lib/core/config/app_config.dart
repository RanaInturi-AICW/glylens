import 'environment.dart';

/// Runtime configuration resolved from compile-time defines and defaults.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.firebaseApiKey,
    required this.firebaseAppId,
    required this.firebaseMessagingSenderId,
    required this.firebaseProjectId,
  });

  final AppEnvironment environment;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final String firebaseApiKey;
  final String firebaseAppId;
  final String firebaseMessagingSenderId;
  final String firebaseProjectId;

  bool get isProduction => environment == AppEnvironment.production;

  /// Resolved from `--dart-define=ENV=development|qa|uat|production`.
  factory AppConfig.fromEnvironment() {
    const envRaw = String.fromEnvironment('ENV', defaultValue: 'development');
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'dev-api-key');
    const appId = String.fromEnvironment('FIREBASE_APP_ID', defaultValue: 'dev-app-id');
    const senderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'dev-sender');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'glylens-dev');

    final environment = AppEnvironment.fromString(envRaw);

    return AppConfig(
      environment: environment,
      enableLogging: environment != AppEnvironment.production,
      enableAnalytics: environment == AppEnvironment.production || environment == AppEnvironment.uat,
      enableCrashReporting: environment != AppEnvironment.development,
      firebaseApiKey: apiKey,
      firebaseAppId: appId,
      firebaseMessagingSenderId: senderId,
      firebaseProjectId: projectId,
    );
  }
}
