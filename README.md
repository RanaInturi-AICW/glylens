# GlyLens

**Food Intelligence for Better Decisions**

Enterprise Flutter platform + Food Intelligence Engine (domain layer).

## Build Program 1 — Flutter Platform Foundation ✅

Sprint 1A delivers the production Flutter scaffold: Riverpod, GoRouter, Firebase Auth, Hive offline cache, Material 3 themes, localization framework, and feature shells.

### Quick start

```bash
flutter create . --org com.glylens --project-name glylens --platforms android,ios
flutter pub get
flutter run --dart-define=ENV=development
```

See [Build Program 1 README](docs/GlyLens_Build_Program_1_Flutter_Foundation_README_v1.md) for full instructions.

## Documentation

Start at [docs/GlyLens_Master_Documentation_Index_v1.md](docs/GlyLens_Master_Documentation_Index_v1.md).

## Project layout

```
lib/
  app/              # App shell, router, theme
  bootstrap/        # Init, providers, Firebase
  core/             # Platform + Food Intelligence Engine
  features/         # Feature modules (auth, home, search, …)
  shared/           # Themes, widgets
  main.dart
```

## Tests & CI

```bash
flutter test
```

GitHub Actions: `.github/workflows/flutter_ci.yml`

## Scope

| Included (BP1) | Deferred |
|----------------|----------|
| Flutter foundation | Food Intelligence UI |
| Firebase Auth | Firestore |
| Offline cache (Hive) | Barcode / camera |
| Navigation shells | Search logic |
