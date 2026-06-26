import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScreen(
      title: l10n.aboutTitle,
      child: Text(
        'GlyLens is a Food Intelligence Platform for educational food decisions. '
        'It is not a medical device.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
