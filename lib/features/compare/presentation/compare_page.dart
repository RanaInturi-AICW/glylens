import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreen(
      title: l10n.compareTitle,
      child: Center(child: Text(l10n.comparePlaceholder, textAlign: TextAlign.center)),
    );
  }
}
