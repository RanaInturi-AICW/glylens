import '../constants/app_constants.dart';
import 'secure_storage_service.dart';

/// Token persistence abstraction (Firebase ID token / refresh token).
class TokenStorage {
  TokenStorage(this._secureStorage);

  final SecureStorageService _secureStorage;

  Future<void> saveAuthToken(String token) => _secureStorage.write(
        key: AppConstants.secureStorageAuthTokenKey,
        value: token,
      );

  Future<String?> readAuthToken() =>
      _secureStorage.read(key: AppConstants.secureStorageAuthTokenKey);

  Future<void> saveRefreshToken(String token) => _secureStorage.write(
        key: AppConstants.secureStorageRefreshTokenKey,
        value: token,
      );

  Future<String?> readRefreshToken() =>
      _secureStorage.read(key: AppConstants.secureStorageRefreshTokenKey);

  Future<void> clear() => _secureStorage.deleteAll();
}
