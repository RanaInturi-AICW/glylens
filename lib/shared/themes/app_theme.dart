import 'package:flutter/material.dart';

import 'theme_extensions.dart';

abstract final class AppTheme {
  static ThemeData light({ColorScheme? dynamicScheme}) {
    final scheme = dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B6B4B),
          brightness: Brightness.light,
        );
    return _theme(scheme);
  }

  static ThemeData dark({ColorScheme? dynamicScheme}) {
    final scheme = dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CD9A0),
          brightness: Brightness.dark,
        );
    return _theme(scheme);
  }

  static ThemeData _theme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      extensions: const [
        AppSpacing(spacing: 16, screenPadding: 20),
      ],
    );
  }
}

enum ThemeModePreference { system, light, dark }
