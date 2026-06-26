import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/theme_controller.dart';
import '../../../bootstrap/providers.dart';
import '../../../core/config/app_config.dart';
import '../../../features/auth/application/auth_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/themes/app_theme.dart';
import '../../../shared/widgets/responsive_layout.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themePref = ref.watch(themeModeProvider);
    final config = ref.watch(appConfigProvider);

    return AppScreen(
      title: l10n.settingsTitle,
      child: Column(
        children: [
          ListTile(
            title: Text(l10n.environmentLabel),
            subtitle: Text(config.environment.value),
          ),
          const Divider(),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_themeLabel(themePref, l10n)),
          ),
          SegmentedButton<ThemeModePreference>(
            segments: [
              ButtonSegment(value: ThemeModePreference.system, label: Text(l10n.themeSystem)),
              ButtonSegment(value: ThemeModePreference.light, label: Text(l10n.themeLight)),
              ButtonSegment(value: ThemeModePreference.dark, label: Text(l10n.themeDark)),
            ],
            selected: {themePref},
            onSelectionChanged: (value) =>
                ref.read(themeModeProvider.notifier).state = value.first,
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.aboutTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/about'),
          ),
          ListTile(
            title: Text(l10n.privacyTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/privacy'),
          ),
          ListTile(
            title: Text(l10n.termsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/terms'),
          ),
          ListTile(
            title: Text(l10n.developerTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/developer'),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () async {
              await ref.read(authControllerProvider).signOut();
              if (context.mounted) {
                context.go('/welcome');
              }
            },
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeModePreference pref, AppLocalizations l10n) {
    return switch (pref) {
      ThemeModePreference.system => l10n.themeSystem,
      ThemeModePreference.light => l10n.themeLight,
      ThemeModePreference.dark => l10n.themeDark,
    };
  }
}
