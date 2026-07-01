import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/result.dart';
import '../domain/entities/auth_user.dart';
import '../domain/repositories/auth_repository.dart';
import '../infrastructure/auth_providers.dart';

/// Auth actions — auth state is observed via [authStateProvider].
class AuthController {
  AuthController(this._ref);

  final Ref _ref;

  AuthRepository get _repository => _ref.read(authRepositoryProvider);

  Future<Result<AuthUser>> signInAnonymously() =>
      guard(_repository.signInAnonymously);

  Future<Result<AuthUser>> signInWithGoogle() =>
      guard(_repository.signInWithGoogle);

  Future<Result<AuthUser>> signInWithApple() =>
      guard(_repository.signInWithApple);

  Future<Result<void>> signOut() => guard(_repository.signOut);
}

final authControllerProvider = Provider<AuthController>(AuthController.new);

final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
