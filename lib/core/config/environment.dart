/// Deployment environments (Development, QA, UAT, Production).
enum AppEnvironment {
  development('development'),
  qa('qa'),
  uat('uat'),
  production('production');

  const AppEnvironment(this.value);

  final String value;

  static AppEnvironment fromString(String raw) {
    return AppEnvironment.values.firstWhere(
      (e) => e.value == raw.toLowerCase(),
      orElse: () => AppEnvironment.development,
    );
  }
}
