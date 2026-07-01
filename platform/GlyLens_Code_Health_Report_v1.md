# GlyLens Code Health Report v1.0

_Last Updated: 2026-06-26 (Build Program 1.4)_  
_Score: **STABILIZED** (analyzer 0 / tests 83/83)_

## Analyzer

| Metric | BP1.3 (start) | BP1.4 (end) |
|--------|---------------|-------------|
| Errors | 40+ | **0** |
| Warnings | 70+ | **0** |
| Infos | 2+ | **0** |
| `flutter analyze --fatal-infos` | FAIL | **PASS** |

## Code Quality Remediation

| Category | Action |
|----------|--------|
| Dead imports | Removed from bootstrap, main, cache, DTOs, settings, splash, tests |
| Non-null assertions | Removed unnecessary `!` on `AppLocalizations.of(context)` (16 files) |
| Unnecessary casts | Removed in confidence/gi/gl/source trust engines |
| Pubspec lint | Dependencies sorted alphabetically |
| Duplicate field init | Fixed in 5 value objects (Dart 3) |
| Deprecated patterns | `firstWhere(orElse: () => null)` replaced with `_firstWhereOrNull` |

## Test Health

| Suite | Tests | Status |
|-------|-------|--------|
| application | 6 | PASS |
| benchmark | 2 | PASS |
| core/errors | 3 | PASS |
| data/engines | 20 | PASS |
| domain | 35 | PASS |
| golden | 1 | PASS |
| infrastructure | 3 | PASS |
| policy | 6 | PASS |
| widget | 1 | PASS |
| **Total** | **83** | **PASS** |

Tests were repaired — **none disabled**.

## Domain Consistency Fixes

- `ConfidenceScore` supports `EvidenceLevel.unknown` for refusal/explainability flows (value &lt; 50)
- `GlycemicProfile` allows unknown evidence at entity level (refusal policy contract)
- `SourceType` exhaustiveness in `source_trust_engine` and `source_trust_policy`

## Performance (Review Only — No Premature Optimization)

| Area | Observation | Recommendation |
|------|-------------|----------------|
| Startup | `bootstrap.dart` initializes Hive + providers synchronously | Acceptable for BP1; profile in BP2A |
| Routing | GoRouter declarative routes, no duplicate route tables | OK |
| Riverpod | Providers scoped in `bootstrap/providers.dart` | OK |
| Initialization | Firebase init gated by config | OK for dev without Firebase project |

## Remaining Technical Debt (Non-Blocking)

| ID | Item | Severity |
|----|------|----------|
| TD-RC-01 | `seed_dataset.dart` not wired to `docs/seed_data/` JSON | Low |
| TD-RC-02 | Golden tests are placeholder only | Low |
| TD-RC-03 | Integration tests need device/emulator run | Low |
| TD-RC-04 | Flutter shallow clone shows `[user-branch]` in doctor | Cosmetic |

## Security Code Review

- No secrets in repository
- Auth tokens via `TokenStorage` / `flutter_secure_storage`
- Firebase options are template placeholders
- Logging uses `logger` package (no raw print in lib)

---

_End of Report_
