import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScreen(
      title: l10n.privacyTitle,
      child: const Text(
        'Privacy policy content will be published before production release. '
        'GlyLens follows security-by-design and collects only what is needed for food intelligence features.',
      ),
    );
  }
}
