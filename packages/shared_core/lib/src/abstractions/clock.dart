/// Injectable clock abstraction for testable time.
abstract interface class Clock {
  DateTime now();

  static final Clock system = _SystemClock();
}

final class _SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now().toUtc();
}

final class FixedClock implements Clock {
  FixedClock(this.fixed);

  DateTime fixed;

  @override
  DateTime now() => fixed;
}
