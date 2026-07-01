import 'package:equatable/equatable.dart';

/// Base for immutable value objects compared by value.
abstract base class ValueObject<T> extends Equatable {
  const ValueObject(this.value);

  final T value;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => '$runtimeType($value)';
}
