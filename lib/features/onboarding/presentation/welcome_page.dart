import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreen(
      title: l10n.welcomeTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.welcomeSubtitle, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          FilledButton(
            onPressed: () => context.go('/onboarding/anonymous'),
            child: Text(l10n.continueAnonymously),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/onboarding/anonymous'),
            child: Text(l10n.signInGoogle),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/onboarding/anonymous'),
            child: Text(l10n.signInApple),
          ),
        ],
      ),
    );
  }
}
