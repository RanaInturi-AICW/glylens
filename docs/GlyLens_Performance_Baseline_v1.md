# GlyLens Performance Baseline v1

_Last Updated: 2026-06-26_  
_Build Program: 1.1 — Engineering Verification_  
_Method: Static analysis + architectural assessment (no runtime profiling — Flutter SDK unavailable locally; CI build blocked)_

---

## Executive Summary

Build Program 1 establishes a lean cold-start path with serialized bootstrap initialization and a shallow widget tree for feature shells. **No runtime measurements were captured** because CI failed at dependency resolution and Flutter is not installed on the review workstation. This document records the **architectural performance profile** and **optimization opportunities** for BP1.2 profiling.

**Performance Score: 68 / 100** (architectural assessment only)

---

## 1. Measurement Status

| Metric | Target (BP1) | Measured | Status |
|--------|--------------|----------|--------|
| Cold start to first frame | < 3s (dev) | Not measured | ⚠️ BLOCKED |
| `flutter pub get` | < 30s | CI fail | ❌ |
| APK size (debug) | Baseline TBD | Not built | ⚠️ BLOCKED |
| Widget rebuild count (home) | Minimal | Not measured | ⚠️ |
| Memory at idle | TBD | Not measured | ⚠️ |

**Profiling plan for BP1.2:**
1. Fix CI; capture debug APK size from artifact
2. Run `flutter run --profile` on physical device
3. Use DevTools Timeline for cold start
4. Record Firebase init + Hive init durations separately

---

## 2. Cold Start Readiness

### 2.1 Bootstrap Sequence

**File:** `lib/bootstrap/providers.dart` → `bootstrap()`

```
WidgetsFlutterBinding.ensureInitialized()
  → AppConfig.fromEnvironment()
  → ProviderContainer(overrides)
  → Firebase.initializeApp()          [async — network/platform]
  → analyticsService.initialize()     [NoOp — fast]
  → crashReporting.initialize()       [NoOp — fast]
  → certificatePinning.initialize()   [NoOp — fast]
  → cacheStore.initialize()           [Hive — disk I/O]
  → read onboarding flag from Hive
  → return container
  → runApp(UncontrolledProviderScope)
```

| Phase | Estimated Cost | Notes |
|-------|----------------|-------|
| Firebase init | 100–500ms | Dominant real cost; platform-dependent |
| Hive init | 20–80ms | Opens box on disk |
| NoOp services | < 5ms each | Negligible |
| ProviderContainer | < 10ms | Synchronous |

**Optimization OP-001:** Parallelize independent NoOp inits with `Future.wait` after Firebase (saves ~10ms — low priority).

**Optimization OP-002:** Defer non-critical Hive reads until after first frame if splash animation allows.

### 2.2 Error Handler Setup

`runGlyLensApp` registers error handlers twice (before and after bootstrap). Second registration adds crash reporting — negligible overhead.

---

## 3. Widget Tree Complexity

### 3.1 App Root

```
GlyLensApp (ConsumerWidget)
  → DynamicColorBuilder (optional Material You)
    → MaterialApp.router
      → GoRouter
```

**Assessment:** Shallow root — good. `DynamicColorBuilder` adds async platform channel call on Android 12+.

### 3.2 Navigation Shell

```
AppShell (StatefulShellRoute.indexedStack)
  → NavigationBar (5 destinations)
  → IndexedStack of 5 branches
    → HomePage / SearchPage / ScanPage / HistoryPage / ComparePage
```

| Aspect | Assessment |
|--------|------------|
| Indexed stack | ✅ Preserves tab state; all 5 shells built at first visit to shell |
| Branch count | 5 — acceptable |
| Per-page complexity | Low — `AppScreen` + placeholder content |

**Optimization OP-003:** Lazy branch building if memory becomes concern (not needed at BP1).

### 3.3 Feature Shell Pages

All feature pages use `AppScreen` → `Scaffold` → `SafeArea` → `ResponsiveLayout` → `Padding` → content.

**Depth:** ~6 widgets before content — acceptable.

---

## 4. Navigation Initialization

| Aspect | Detail |
|--------|--------|
| Router provider | `appRouterProvider` — recreated on invalidation |
| Navigator keys | 6 `GlobalKey<NavigatorState>` (1 root + 5 shell) |
| Route count | ~14 routes |
| Redirect logic | None — zero redirect computation cost |

**Optimization OP-004:** Memoize `GoRouter` with `ref.keepAlive()` if provider churn observed.

---

## 5. Dependency Initialization

### 5.1 Riverpod Providers (Eager vs Lazy)

| Provider | Init timing |
|----------|-------------|
| `appConfigProvider` | First read — bootstrap |
| `appLoggerProvider` | Bootstrap — logs on create |
| `secureStorageProvider` | Lazy until token access |
| `cacheStoreProvider` | Bootstrap — Hive open |
| `authRepositoryProvider` | Lazy until auth feature accessed |
| `appRouterProvider` | First `GlyLensApp` build |

**Assessment:** Reasonable lazy/eager split.

### 5.2 Firebase Auth

`FirebaseAuth.instance` singleton — no duplicate init.

### 5.3 Hive

`HiveCacheStore.initialize()` called once in bootstrap. Box name should be constant (verify in implementation — single box expected).

---

## 6. Rendering & Theme

| Control | Performance impact |
|---------|-------------------|
| Material 3 | Standard — no custom shaders |
| `ColorScheme.fromSeed` fallback | Cheap |
| Dynamic color (Android 12+) | One platform channel round-trip |
| Card elevation 0 + border | Cheaper than shadow elevation |
| `VisualDensity.adaptivePlatformDensity` | Neutral |

---

## 7. Memory Considerations

| Area | Risk | Mitigation |
|------|------|------------|
| IndexedStack (5 tabs) | Medium — all visited tabs stay in memory | Acceptable for BP1 |
| GoRouter page cache | Low | Standard |
| Hive in-memory cache | Low | KV only |
| Image assets | None committed in BP1 | N/A |

---

## 8. Network

**No network calls in BP1 runtime path** — `NoOpHttpClient` throws. Zero network performance impact.

---

## 9. Build Performance (CI)

| Step | Observed (run 28231684317) |
|------|---------------------------|
| Checkout + Flutter setup | ~70s (includes flutter create attempt) |
| pub get | Failed |
| Full pipeline | 1m 15s to failure |

**Optimization OP-005:** Commit `android/`/`ios/` — eliminates `flutter create` (~30s CI savings).

**Optimization OP-006:** Pin Flutter version — avoids surprise SDK resolution changes.

---

## 10. Tablet / Responsive Performance

`ResponsiveLayout` uses `MediaQuery.sizeOf(context).width` — O(1) per build.

Tablet path adds `ConstrainedBox(maxWidth: 960)` — no performance concern.

---

## 11. Baseline Targets (BP1.2 — To Be Measured)

| Metric | Target | Measurement method |
|--------|--------|-------------------|
| Time to first frame (cold) | < 2000ms | DevTools Timeline |
| Firebase init | < 400ms | Custom log timing |
| Hive init | < 100ms | Custom log timing |
| Home tab rebuild | < 16ms | Performance overlay |
| Debug APK size | < 50MB | CI artifact |
| Release APK size | < 25MB | CI (future) |

---

## 12. Optimization Backlog

| ID | Opportunity | Priority | Effort |
|----|-------------|----------|--------|
| OP-001 | Parallelize NoOp service init | Low | 1h |
| OP-002 | Defer Hive onboarding read post-frame | Low | 2h |
| OP-003 | Lazy shell branches | Low | 4h |
| OP-004 | `keepAlive` on router provider | Low | 30m |
| OP-005 | Commit platform folders | Medium | 4h |
| OP-006 | Pin Flutter SDK in CI | Medium | 30m |

---

## 13. Verdict

Architectural performance profile is **appropriate for a platform foundation**. Runtime baseline **cannot be certified** until CI builds successfully and profile-mode measurements are taken in BP1.2.

---

_Related: `GlyLens_Build_Program_1_Engineering_Review_v1.md`, `GlyLens_Technical_Debt_Register_v1.md`_
