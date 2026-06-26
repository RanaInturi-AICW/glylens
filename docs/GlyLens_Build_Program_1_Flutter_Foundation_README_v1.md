# Build Program 1 — Flutter Platform Foundation

## Quick Start

```bash
# First-time setup (creates android/ and ios/ if missing)
flutter create . --org com.glylens --project-name glylens --platforms android,ios
flutter pub get

# Run (development)
flutter run --dart-define=ENV=development \
  --dart-define=FIREBASE_API_KEY=your-key \
  --dart-define=FIREBASE_APP_ID=your-app-id \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender \
  --dart-define=FIREBASE_PROJECT_ID=your-project
```

## Architecture

Follows `docs/GlyLens_Flutter_Module_Blueprint_v1.md`:

```
lib/
  app/           # MaterialApp, router, shell, theme
  bootstrap/     # Firebase init, providers, error hooks
  core/          # Platform + Food Intelligence Engine (Sprint 0)
  features/      # Feature-first modules (presentation in BP1)
  shared/        # Themes, widgets
  l10n/          # Localization (English; extensible)
  main.dart
```

Clean Architecture per feature: `presentation` → `application` → `domain` → `infrastructure`.

## State Management

**Riverpod only** — all DI via `Provider` / `StreamProvider` (`lib/bootstrap/providers.dart`).

## Navigation

**GoRouter** with `StatefulShellRoute` bottom navigation: Home, Search, Scan, History, Compare.

## Authentication

Firebase Auth via `FirebaseAuthRepository` (anonymous, Google, Apple placeholders).

## Offline Cache

**Hive** (`hive_flutter`) for foundation key-value cache via `CacheStore` abstraction.

| Option | Build Program 1 | Future |
|--------|-----------------|--------|
| Hive | ✅ Foundation preferences/onboarding flags | Key-value |
| Isar | Planned Build Program 2 | Structured corpus entities, indexes |

Isar is architecturally preferred for relational corpus data; Hive avoids codegen friction for Sprint 1A foundation cache.

## Environments

| ENV | Purpose |
|-----|---------|
| development | Local dev, verbose logging |
| qa | QA testing |
| uat | Pre-production |
| production | Store release |

Pass via `--dart-define=ENV=production`.

## Dependencies (key)

| Package | Purpose |
|---------|---------|
| flutter_riverpod | State management |
| go_router | Navigation |
| firebase_core / firebase_auth | Auth only (no Firestore in BP1) |
| hive_flutter | Offline cache |
| flutter_secure_storage | Token storage |
| logger | Structured logging |
| dynamic_color | Material 3 dynamic color |
| google_sign_in / sign_in_with_apple | OAuth placeholders |

## Testing

```bash
flutter test
flutter test integration_test/
```

## CI

GitHub Actions: `.github/workflows/flutter_ci.yml` — analyze, format, test, Android/iOS build.

## Out of Scope (Build Program 1)

Food Intelligence runtime, search logic, barcode, camera, Firestore, nutrition APIs.

See `docs/GlyLens_Build_Program_1_Architecture_Validation_v1.md`.
