import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bootstrap/providers.dart';
import '../domain/entities/auth_user.dart';
import '../domain/repositories/auth_repository.dart';
import '../infrastructure/firebase_auth_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
