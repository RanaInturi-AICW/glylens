import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/theme_controller.dart';
import '../shared/themes/app_theme.dart';

class GlyLensApp extends ConsumerWidget {
  const GlyLensApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themePref = ref.watch(themeModeProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp.router(
          title: 'GlyLens',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(dynamicScheme: lightDynamic),
          darkTheme: AppTheme.dark(dynamicScheme: darkDynamic),
          themeMode: resolveThemeMode(themePref),
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
