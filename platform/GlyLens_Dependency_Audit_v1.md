# GlyLens Dependency Audit v1.0

_Last Updated: 2026-06-26 (Build Program 1.4)_  
_Policy: Minimum change — no upgrades unless required for green build_

## Environment Constraints

```yaml
environment:
  sdk: ^3.12.0
  flutter: ">=3.44.0"
```

## Direct Dependencies (pubspec.yaml)

| Package | Constraint | Resolved | Action | Risk |
|---------|------------|----------|--------|------|
| `intl` | ^0.20.2 | 0.20.2 | **KEPT** — required by flutter_localizations | None |
| `firebase_core` | ^3.8.1 | 3.15.2 | KEPT — within range | None |
| `firebase_auth` | ^5.3.4 | 5.7.0 | KEPT — within range | None |
| `flutter_riverpod` | ^2.6.1 | 2.6.1 | KEPT — ADR-approved | None |
| `go_router` | ^14.6.2 | 14.8.1 | KEPT | None |
| `hive_flutter` | ^1.1.0 | 1.1.0 | KEPT | None |
| `flutter_secure_storage` | ^9.2.4 | 9.2.4 | KEPT | None |
| `google_sign_in` | ^6.2.2 | 6.3.0 | KEPT | None |
| `sign_in_with_apple` | ^6.1.4 | 6.1.4 | KEPT | None |
| `dynamic_color` | ^1.7.0 | 1.7.0 | KEPT | None |
| `equatable` | ^2.0.7 | 2.0.7 | KEPT | None |
| `logger` | ^2.5.0 | 2.5.0 | KEPT | None |
| `meta` | ^1.15.0 | 1.18.0 | KEPT | None |

## Dev Dependencies

| Package | Constraint | Resolved | Action |
|---------|------------|----------|--------|
| `flutter_lints` | ^5.0.0 | 5.0.0 | KEPT |
| `mocktail` | ^1.0.4 | 1.0.4 | KEPT |
| `test` | ^1.25.8 | 1.31.0 | KEPT (transitive via flutter_test) |

## Compatibility Matrix

| Layer | Required | Verified |
|-------|----------|----------|
| Flutter Stable | 3.44.4 | YES |
| Dart | 3.12.2 | YES |
| Android SDK | API 36 | YES |
| AGP | 9.0.1 | YES (android/) |
| Gradle | 9.1.0 | YES |
| JDK | 17+ | YES |

## Outdated Packages (Informational)

`flutter pub outdated` reports 38 newer versions **incompatible with current constraints**. No upgrades performed — constraints satisfy green analyze/test.

## Removed / Not Added

- No Firestore, Cloud Functions, or analytics SDKs (ADR scope)
- No code generation packages (build_runner, isar_generator) — deferred to BP2
- No duplicate utility packages

## Recommendations

1. Keep `pubspec.lock` committed for reproducible CI.
2. Review Dependabot PRs individually; do not bulk-upgrade before BP2A.
3. Re-audit when enabling Isar structured storage in Build Program 2.

---

_End of Audit_
