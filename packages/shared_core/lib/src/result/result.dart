import '../errors/domain_exception.dart';
import '../errors/failure.dart';

/// Result pattern for explicit success/failure without exceptions in business logic.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(:final data) => data,
        Error<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Error<T>(:final failure) => failure,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Error<T>(failure: final err) => failure(err),
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

Failure mapExceptionToFailure(DomainException exception) {
  return switch (exception) {
    ValidationException(:final field, :final validationCode) => ValidationFailure(
        exception.message,
        code: validationCode,
        field: field,
      ),
    NotFoundException() => NotFoundFailure(exception.message, code: exception.code),
    InvariantViolationException() => ValidationFailure(exception.message, code: exception.code),
  };
}

Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } on DomainException catch (e) {
    return Error(mapExceptionToFailure(e));
  } catch (e) {
    return Error(UnknownFailure(e.toString()));
  }
}

Result<T> guardSync<T>(T Function() action) {
  try {
    return Success(action());
  } on DomainException catch (e) {
    return Error(mapExceptionToFailure(e));
  } catch (e) {
    return Error(UnknownFailure(e.toString()));
  }
}
