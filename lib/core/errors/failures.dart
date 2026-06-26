import 'package:equatable/equatable.dart';

/// Typed failure hierarchy for platform layer (vendor-neutral).
sealed class Failure extends Equatable {
  const Failure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

final class ConfigurationFailure extends Failure {
  const ConfigurationFailure(super.message, {super.code});
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}
