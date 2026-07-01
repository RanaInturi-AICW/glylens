import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreen(
      title: l10n.scanTitle,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(l10n.scanPlaceholder, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
