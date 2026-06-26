import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/security/token_storage.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth firebaseAuth,
    required TokenStorage tokenStorage,
    required AppLogger logger,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth,
        _tokenStorage = tokenStorage,
        _logger = logger,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final TokenStorage _tokenStorage;
  final AppLogger _logger;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<AuthUser?> authStateChanges() =>
      _auth.authStateChanges().map(_mapUser);

  @override
  AuthUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Future<AuthUser> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Anonymous sign-in returned no user');
      }
      await _persistToken(user);
      return _mapUser(user)!;
    } on FirebaseAuthException catch (e) {
      _logger.error('Anonymous sign-in failed', error: e);
      throw AuthException(e.message ?? 'Anonymous sign-in failed', code: e.code);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in cancelled', code: 'cancelled');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException('Google sign-in returned no user');
      }
      await _persistToken(user);
      return _mapUser(user)!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google sign-in failed', code: e.code);
    } catch (e) {
      throw AuthException('Google sign-in failed: $e');
    }
  }

  @override
  Future<AuthUser> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException('Apple sign-in returned no user');
      }
      await _persistToken(user);
      return _mapUser(user)!;
    } on SignInWithAppleAuthorizationException catch (e) {
      throw AuthException(e.message, code: e.code.name);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Apple sign-in failed', code: e.code);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
      _tokenStorage.clear(),
    ]);
  }

  @override
  Future<String?> getIdToken() async {
    final token = await _auth.currentUser?.getIdToken();
    if (token != null) {
      await _tokenStorage.saveAuthToken(token);
    }
    return token;
  }

  Future<void> _persistToken(User user) async {
    final token = await user.getIdToken();
    if (token != null) {
      await _tokenStorage.saveAuthToken(token);
    }
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    return AuthUser(
      uid: user.uid,
      isAnonymous: user.isAnonymous,
      email: user.email,
      displayName: user.displayName,
      isPremium: false,
    );
  }
}
