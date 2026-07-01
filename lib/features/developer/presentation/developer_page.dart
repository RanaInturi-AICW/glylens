import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bootstrap/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class DeveloperPage extends ConsumerWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);

    return AppScreen(
      title: l10n.developerTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Environment: ${config.environment.value}'),
          Text('Logging: ${config.enableLogging}'),
          Text('Analytics: ${config.enableAnalytics}'),
          Text('Crash reporting: ${config.enableCrashReporting}'),
          Text('Firebase project: ${config.firebaseProjectId}'),
        ],
      ),
    );
  }
}
