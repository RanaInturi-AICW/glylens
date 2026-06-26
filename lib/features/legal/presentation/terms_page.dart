import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScreen(
      title: l10n.termsTitle,
      child: const Text(
        'Terms of service content will be published before production release. '
        'GlyLens provides educational food intelligence, not medical advice.',
      ),
    );
  }
}
