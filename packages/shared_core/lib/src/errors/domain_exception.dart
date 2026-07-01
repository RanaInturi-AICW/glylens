/// Base class for domain-layer exceptions.
sealed class DomainException implements Exception {
  const DomainException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => '$runtimeType: $message';
}

final class InvariantViolationException extends DomainException {
  const InvariantViolationException(super.message, {super.code});
}

final class NotFoundException extends DomainException {
  const NotFoundException(super.message, {super.code});
}

final class ValidationException extends DomainException {
  const ValidationException({
    required this.field,
    required String message,
    required this.validationCode,
  }) : super(message, code: validationCode);

  final String field;
  final String validationCode;

  @override
  String toString() => 'ValidationException($field, $validationCode): $message';
}
