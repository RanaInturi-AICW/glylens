import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glylens/core/errors/exceptions.dart';
import 'package:glylens/core/errors/failures.dart';
import 'package:glylens/core/errors/result.dart';

void main() {
  group('Result', () {
    test('guard returns success', () async {
      final result = await guard(() async => 42);
      expect(result, isA<Success<int>>());
      expect((result as Success<int>).data, 42);
    });

    test('guard maps AppException to failure', () async {
      final result = await guard<int>(() async {
        throw const AuthException('denied', code: 'auth');
      });
      expect(result, isA<Error<int>>());
      final failure = (result as Error<int>).failure;
      expect(failure, isA<AuthFailure>());
    });

    test('mapExceptionToFailure covers auth', () {
      const ex = AuthException('x');
      final failure = mapExceptionToFailure(ex);
      expect(failure, isA<AuthFailure>());
    });
  });
}
