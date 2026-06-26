import 'package:flutter/material.dart';

@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.spacing,
    required this.screenPadding,
  });

  final double spacing;
  final double screenPadding;

  @override
  AppSpacing copyWith({double? spacing, double? screenPadding}) {
    return AppSpacing(
      spacing: spacing ?? this.spacing,
      screenPadding: screenPadding ?? this.screenPadding,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) {
      return this;
    }
    return AppSpacing(
      spacing: lerpDouble(spacing, other.spacing, t)!,
      screenPadding: lerpDouble(screenPadding, other.screenPadding, t)!,
    );
  }
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;
