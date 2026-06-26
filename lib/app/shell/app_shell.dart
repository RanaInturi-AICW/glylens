import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: l10n.searchTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: const Icon(Icons.qr_code_scanner),
            label: l10n.scanTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.historyTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.compare_arrows_outlined),
            selectedIcon: const Icon(Icons.compare_arrows),
            label: l10n.compareTitle,
          ),
        ],
      ),
    );
  }
}
