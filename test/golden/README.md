# Golden Tests

Golden tests validate visual regression for core screens.

## Structure

- `test/golden/` — golden image baselines (generated on CI/dev machines with Flutter SDK)
- `test/golden/golden_test.dart` — golden test harness

## Run

```bash
flutter test --update-goldens
flutter test test/golden/
```

Build Program 1 establishes the folder structure; baselines are added when CI Flutter runner is available.
