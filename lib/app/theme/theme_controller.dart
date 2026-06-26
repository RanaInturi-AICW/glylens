import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/themes/app_theme.dart';

final themeModeProvider = StateProvider<ThemeModePreference>(
  (ref) => ThemeModePreference.system,
);

ThemeMode resolveThemeMode(ThemeModePreference preference) {
  return switch (preference) {
    ThemeModePreference.system => ThemeMode.system,
    ThemeModePreference.light => ThemeMode.light,
    ThemeModePreference.dark => ThemeMode.dark,
  };
}
