import '../entities/auth_user.dart';

/// Auth repository contract (vendor-neutral per ADR-0011).
abstract interface class AuthRepository {
  Stream<AuthUser?> authStateChanges();

  AuthUser? get currentUser;

  Future<AuthUser> signInAnonymously();

  /// Google Sign-In placeholder — requires platform configuration.
  Future<AuthUser> signInWithGoogle();

  /// Apple Sign-In placeholder — requires platform configuration.
  Future<AuthUser> signInWithApple();

  Future<void> signOut();

  Future<String?> getIdToken();
}
