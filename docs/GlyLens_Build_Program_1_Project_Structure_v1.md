# GlyLens Build Program 1 — Generated Project Structure v1

_Last Updated: 2026-06-26_

```
glylens/
├── .github/workflows/flutter_ci.yml
├── .metadata
├── analysis_options.yaml
├── l10n.yaml
├── pubspec.yaml
├── README.md
├── REPOSITORY_STRUCTURE.md
├── integration_test/
│   └── app_test.dart
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   └── app_routes.dart
│   │   ├── shell/
│   │   │   └── app_shell.dart
│   │   └── theme/
│   │       └── theme_controller.dart
│   ├── bootstrap/
│   │   ├── bootstrap.dart
│   │   ├── firebase_options.dart
│   │   └── providers.dart
│   ├── core/
│   │   ├── analytics/
│   │   │   ├── analytics_service.dart
│   │   │   └── crash_reporting_service.dart
│   │   ├── application/          # Sprint 0 intelligence use cases
│   │   ├── benchmark/
│   │   ├── cache/
│   │   │   ├── cache_store.dart
│   │   │   └── hive_cache_store.dart
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   └── environment.dart
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── data/                 # Sprint 0 engines & repositories
│   │   ├── domain/               # Sprint 0 entities & interfaces
│   │   ├── errors/               # Platform Result / Failure
│   │   ├── infrastructure/
│   │   ├── logging/
│   │   │   └── app_logger.dart
│   │   ├── networking/
│   │   │   └── http_client.dart
│   │   ├── policy/
│   │   └── security/
│   │       ├── certificate_pinning_service.dart
│   │       ├── flutter_secure_storage_service.dart
│   │       ├── secure_storage_service.dart
│   │       └── token_storage.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── application/auth_controller.dart
│   │   │   ├── domain/entities/auth_user.dart
│   │   │   ├── domain/repositories/auth_repository.dart
│   │   │   └── infrastructure/
│   │   │       ├── auth_providers.dart
│   │   │       └── firebase_auth_repository.dart
│   │   ├── compare/presentation/compare_page.dart
│   │   ├── developer/presentation/developer_page.dart
│   │   ├── history/presentation/history_page.dart
│   │   ├── home/presentation/home_page.dart
│   │   ├── legal/presentation/
│   │   ├── onboarding/presentation/
│   │   ├── premium/presentation/premium_page.dart
│   │   ├── scan/presentation/scan_page.dart
│   │   ├── search/presentation/search_page.dart
│   │   ├── settings/presentation/settings_page.dart
│   │   └── splash/presentation/splash_page.dart
│   ├── l10n/
│   │   ├── app_en.arb
│   │   └── app_localizations.dart
│   └── shared/
│       ├── themes/
│       └── widgets/
└── test/
    ├── core/errors/result_test.dart
    ├── widget/app_localizations_test.dart
    ├── golden/
    └── [Sprint 0 intelligence tests]
```

Platform folders `android/` and `ios/` are created by `flutter create` on first setup or CI.
