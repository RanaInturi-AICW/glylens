import 'domain_error.dart';

class ValidationError extends DomainError {
  final String field;
  final String code;

  ValidationError({
    required this.field,
    required String message,
    required this.code,
  }) : super(message);

  @override
  String toString() => 'ValidationError($field, $code): $message';
}
