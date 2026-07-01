# GlyLens Platform Contract v1

_Last Updated: 2026-06-26_  
_Build Program: 1.2 — Enterprise Developer Platform_  
_Status: CANONICAL_  
_Owner: Platform Engineering_

This contract defines what GlyLens officially supports. Work outside this contract is at developer risk and is not eligible for platform support.

---

## 1. Supported Operating Systems

| OS | Role | Support Level |
|----|------|---------------|
| **Windows 11 Professional** (23H2+) | Primary developer workstation | **Fully Supported** |
| **Ubuntu 24.04 LTS** (WSL2) | Docker, Python utilities, emulators | **Fully Supported** |
| **macOS 14+** | iOS CI builds only | **CI Only** (no local mandate) |
| Windows 10 | — | **Not Supported** |
| Linux native (non-WSL) | — | **Not Supported** for Flutter dev |

---

## 2. Supported SDKs & Runtimes

| SDK | Supported Versions | Notes |
|-----|-------------------|-------|
| Flutter | **3.44.4** (pinned); min **3.44.0** | Native Windows install |
| Dart | Bundled with Flutter | No standalone Dart SDK |
| Android SDK | API **36+** | Matches compileSdk 36 |
| Java | **17** (Temurin) | Required for Android builds |
| Node.js | **22 LTS** | Firebase CLI only |
| Python | **3.12** | Corpus scripts; Docker optional |

---

## 3. Supported IDEs

| IDE | Support Level | Notes |
|-----|---------------|-------|
| **Cursor** | Primary | AI-assisted development |
| **Android Studio** | Required component | SDK Manager, Emulator, device tools |
| VS Code | Optional | Same extension set as Cursor |

**Not supported:** IntelliJ IDEA (without Flutter plugin alignment), legacy editors without Dart analysis.

---

## 4. Supported Build Tools

| Tool | Purpose |
|------|---------|
| `flutter` / `dart` | App build, test, analyze |
| `gradle` (wrapper) | Android builds |
| `docker compose` | Supporting infrastructure only |
| `gh` | GitHub operations |
| `git` | Source control |
| `firebase` / `flutterfire` | Future Firebase setup (not yet active) |

**Explicitly excluded from Docker:** Flutter SDK, Android SDK, Gradle daemon, `flutter run`, `flutter build`.

---

## 5. Supported AI Tools

| Tool | Role | Governance |
|------|------|------------|
| **Cursor** | Primary implementation IDE | `GlyLens_AI_Engineering_Standards_v1.md` |
| **Codex** | Batch tasks, CI fixes | Prompt Library |
| **Claude** | Architecture review, documentation | Master Documentation Index entry point |
| **ChatGPT** | Ad-hoc research (non-canonical) | Output not canonical without review |

All AI agents **must** start at `docs/GlyLens_Master_Documentation_Index_v1.md`.

---

## 6. Supported Deployment Targets

| Target | BP1.2 Status | Timeline |
|--------|--------------|----------|
| Android (debug/profile) | **Supported** | Now |
| Android (release) | Prepare only | BP3+ |
| iOS | CI smoke build only | BP3+ |
| Web | Not supported | Future evaluation |
| Desktop (Windows/macOS/Linux) | Not supported | Out of scope |

---

## 7. Minimum Hardware

See `GlyLens_Engineering_BOM_v1.md` §11.

| Tier | RAM | CPU | Storage Free |
|------|-----|-----|--------------|
| Minimum | 16 GB | 4C/8T | 50 GB |
| Recommended | 32 GB | 8C/16T | 100 GB |

---

## 8. Environment Layout Contract

### Windows (Native) — default `D:\glylens-dev`

```
D:\glylens-dev\
  flutter\              # Flutter SDK
  android\sdk\          # ANDROID_HOME
  android-studio\       # Android Studio (optional)
  jdk\                  # JDK 17
  pub-cache\            # PUB_CACHE
  docker\               # Docker Desktop disk image
D:\Rana\AI Crafft Works\Git\...\glylens\   # Repository clone
```

Override: set User env `GLYLENS_DEV_ROOT` or edit `scripts/platform/glylens-paths.config.ps1`.

Legacy C: paths are still detected as fallback during migration.

### PATH Requirements (Windows)

Must include (order matters):

1. `C:\src\flutter\bin`
2. `%LOCALAPPDATA%\Android\Sdk\platform-tools`
3. `%LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\bin`
4. `%JAVA_HOME%\bin`
5. `C:\Program Files\Git\cmd`
6. `C:\Program Files\GitHub CLI\`

### WSL2 (Supporting)

```
/mnt/d/.../glylens/      # Repo via /mnt/ (for Docker volume mounts)
~/glylens-tools/         # Optional Linux-side utilities
```

---

## 9. Version Upgrade Policy

| Category | Policy |
|----------|--------|
| Flutter stable | Upgrade within 30 days of EBOM update; test `flutter doctor` + CI |
| Android SDK | Upgrade API level when EBOM updates; keep N-1 installed |
| Docker Desktop | Auto-update allowed; verify `docker compose` after |
| EBOM patch versions | Apply freely |
| EBOM minor versions | PR + team notification |
| EBOM major versions | Platform Engineering review + re-onboarding |

**Freeze periods:** No toolchain upgrades during release candidate weeks (announced in advance).

---

## 10. Quality Contract

No commit to `main` or `develop` unless local quality gates pass. See `platform/GlyLens_Local_Quality_Gates_v1.md`.

Pre-requisite: Application compile blockers from BP1.1 rework (TD-001, TD-002) must be resolved before gates are achievable.

---

## 11. Security Contract

- No secrets in source control
- `--dart-define` for Firebase keys (when project exists)
- `gh auth login` with org account for push
- Docker containers run as non-root where possible
- Dependabot + CodeQL enabled on repository

---

## 12. Exceptions

Request exceptions via GitHub Issue labeled `platform-exception` with:

1. Component affected
2. Business justification
3. Duration
4. Compensating controls

Approved exceptions are logged in `platform/GlyLens_Platform_Readiness_Assessment_v1.md`.

---

_Related: `GlyLens_Engineering_BOM_v1.md`, `GlyLens_DevOps_Foundation_v1.md`_
