import 'package:equatable/equatable.dart';

/// Platform auth user (distinct from Firebase User).
class AuthUser extends Equatable {
  const AuthUser({
    required this.uid,
    required this.isAnonymous,
    this.email,
    this.displayName,
    this.isPremium = false,
  });

  final String uid;
  final bool isAnonymous;
  final String? email;
  final String? displayName;
  final bool isPremium;

  @override
  List<Object?> get props => [uid, isAnonymous, email, displayName, isPremium];
}

enum AuthProviderType { anonymous, google, apple }
