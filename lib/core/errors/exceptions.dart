/// Typed exceptions mapped to [Failure] at application boundaries.
sealed class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

final class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

final class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

final class ConfigurationException extends AppException {
  const ConfigurationException(super.message, {super.code});
}
