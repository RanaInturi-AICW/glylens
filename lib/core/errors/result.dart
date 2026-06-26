import 'exceptions.dart';
import 'failures.dart';

/// Result pattern for explicit success/failure without exceptions in business logic.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Error<T>(:final failure) => failure(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}

Failure mapExceptionToFailure(AppException exception) {
  return switch (exception) {
    NetworkException() => NetworkFailure(exception.message, code: exception.code),
    CacheException() => CacheFailure(exception.message, code: exception.code),
    AuthException() => AuthFailure(exception.message, code: exception.code),
    ConfigurationException() => ConfigurationFailure(exception.message, code: exception.code),
  };
}

Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } on AppException catch (e) {
    return Error(mapExceptionToFailure(e));
  } catch (e) {
    return Error(UnknownFailure(e.toString()));
  }
}

Result<T> guardSync<T>(T Function() action) {
  try {
    return Success(action());
  } on AppException catch (e) {
    return Error(mapExceptionToFailure(e));
  } catch (e) {
    return Error(UnknownFailure(e.toString()));
  }
}
