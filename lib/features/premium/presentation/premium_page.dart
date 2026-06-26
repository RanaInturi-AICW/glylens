import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScreen(
      title: l10n.premiumTitle,
      child: Center(child: Text(l10n.premiumPlaceholder, textAlign: TextAlign.center)),
    );
  }
}
