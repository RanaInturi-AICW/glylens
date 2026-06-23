import 'domain_error.dart';

class MissingGiError extends DomainError {
  final String entityId;

  MissingGiError({
    required this.entityId,
    String? message,
  }) : super(message ?? 'Missing GI value for entity $entityId.');

  @override
  String toString() => 'MissingGiError($entityId): $message';
}
