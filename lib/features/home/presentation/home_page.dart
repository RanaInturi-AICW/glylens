import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScreen(
      title: l10n.homeTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/settings'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.tagline, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _NavCard(
            icon: Icons.search,
            title: l10n.searchTitle,
            onTap: () => context.go('/search'),
          ),
          _NavCard(
            icon: Icons.qr_code_scanner,
            title: l10n.scanTitle,
            onTap: () => context.go('/scan'),
          ),
          _NavCard(
            icon: Icons.history,
            title: l10n.historyTitle,
            onTap: () => context.go('/history'),
          ),
          _NavCard(
            icon: Icons.compare_arrows,
            title: l10n.compareTitle,
            onTap: () => context.go('/compare'),
          ),
          _NavCard(
            icon: Icons.workspace_premium_outlined,
            title: l10n.premiumTitle,
            onTap: () => context.push('/premium'),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
