import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/compare/presentation/compare_page.dart';
import '../../features/developer/presentation/developer_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/legal/presentation/about_page.dart';
import '../../features/legal/presentation/privacy_page.dart';
import '../../features/legal/presentation/terms_page.dart';
import '../../features/onboarding/presentation/anonymous_onboarding_page.dart';
import '../../features/onboarding/presentation/welcome_page.dart';
import '../../features/premium/presentation/premium_page.dart';
import '../../features/scan/presentation/scan_page.dart';
import '../../features/search/presentation/search_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
final _shellNavigatorScanKey = GlobalKey<NavigatorState>(debugLabel: 'shellScan');
final _shellNavigatorHistoryKey = GlobalKey<NavigatorState>(debugLabel: 'shellHistory');
final _shellNavigatorCompareKey = GlobalKey<NavigatorState>(debugLabel: 'shellCompare');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, __) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.anonymousOnboarding,
        builder: (_, __) => const AnonymousOnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, __) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (_, __) => const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorScanKey,
            routes: [
              GoRoute(
                path: AppRoutes.scan,
                builder: (_, __) => const ScanPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHistoryKey,
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (_, __) => const HistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCompareKey,
            routes: [
              GoRoute(
                path: AppRoutes.compare,
                builder: (_, __) => const ComparePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.premium,
        builder: (_, __) => const PremiumPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (_, __) => const AboutPage(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (_, __) => const PrivacyPage(),
      ),
      GoRoute(
        path: AppRoutes.terms,
        builder: (_, __) => const TermsPage(),
      ),
      GoRoute(
        path: AppRoutes.developer,
        builder: (_, __) => const DeveloperPage(),
      ),
    ],
  );
});
