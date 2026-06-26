import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../bootstrap/providers.dart';
import '../../../core/cache/cache_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../features/auth/application/auth_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/responsive_layout.dart';

class AnonymousOnboardingPage extends ConsumerStatefulWidget {
  const AnonymousOnboardingPage({super.key});

  @override
  ConsumerState<AnonymousOnboardingPage> createState() =>
      _AnonymousOnboardingPageState();
}

class _AnonymousOnboardingPageState extends ConsumerState<AnonymousOnboardingPage> {
  bool _loading = false;
  String? _error;

  Future<void> _continueAnonymously() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await ref.read(authControllerProvider).signInAnonymously();
    await result.when(
      success: (_) async {
        final cache = ref.read(cacheStoreProvider);
        await cache.writeString(AppConstants.onboardingCompleteKey, 'true');
        ref.read(onboardingCompleteProvider.notifier).state = true;
        if (mounted) {
          context.go('/home');
        }
      },
      failure: (failure) {
        setState(() => _error = failure.message);
      },
    );

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScreen(
      title: l10n.continueAnonymously,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'GlyLens lets you explore food intelligence before creating an account. '
            'Anonymous sessions are limited and educational only.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          if (_error != null) ...[
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 12),
          ],
          FilledButton(
            onPressed: _loading ? null : _continueAnonymously,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.continueAnonymously),
          ),
        ],
      ),
    );
  }
}
