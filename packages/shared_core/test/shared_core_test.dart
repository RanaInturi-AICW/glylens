import 'package:shared_core/shared_core.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('Success carries data', () {
      const result = Success<int>(42);
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 42);
    });

    test('Error carries failure', () {
      const result = Error<int>(ValidationFailure('bad', field: 'x'));
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
    });

    test('when dispatches to success branch', () {
      const result = Success('ok');
      expect(
        result.when(success: (v) => v, failure: (_) => 'fail'),
        'ok',
      );
    });

    test('when dispatches to failure branch', () {
      const result = Error<int>(UnknownFailure('err'));
      expect(
        result.when(success: (_) => 'ok', failure: (f) => f.message),
        'err',
      );
    });

    test('guard maps DomainException to failure', () async {
      final result = await guard<int>(() async {
        throw const ValidationException(
          field: 'id',
          message: 'empty',
          validationCode: 'required',
        );
      });
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
    });
  });

  group('EntityId', () {
    test('rejects empty id', () {
      expect(() => EntityId(''), throwsA(isA<ValidationException>()));
    });

    test('accepts valid id', () {
      final id = EntityId('food_1');
      expect(id.value, 'food_1');
    });
  });

  group('Guard', () {
    test('againstOutOfRange throws for invalid values', () {
      expect(
        () => Guard.againstOutOfRange(120, name: 'gi', min: 0, max: 100),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('Clock', () {
    test('FixedClock returns configured instant', () {
      final clock = FixedClock(DateTime.utc(2026, 1, 1));
      expect(clock.now(), DateTime.utc(2026, 1, 1));
    });
  });
}
