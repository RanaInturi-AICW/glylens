import 'package:shared_core/shared_core.dart';
import 'package:test/test.dart';

void expectValidationFailure(void Function() action, {String? field}) {
  expect(action, throwsA(isA<ValidationException>().having(
    (e) => e.field,
    'field',
    field ?? isNotEmpty,
  )));
}

void expectSuccess<T>(Result<T> result) {
  expect(result.isSuccess, isTrue, reason: result.failureOrNull?.message);
}
