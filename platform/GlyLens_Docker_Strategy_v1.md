# GlyLens Docker Strategy v1

_Last Updated: 2026-06-26_  
_Build Program: 1.2_  
_Status: CANONICAL_

---

## Principle

**Flutter development is native on Windows.** Docker supports infrastructure only.

| Use Docker | Do NOT Use Docker |
|------------|-------------------|
| Firebase Emulator Suite | `flutter run` |
| Mock REST APIs | `flutter build` |
| Python corpus processing | Android SDK |
| Data validation scripts | Gradle |
| Future backend services | Dart analysis |

---

## Services (`docker-compose.dev.yml`)

| Service | Image | Port | Purpose |
|---------|-------|------|---------|
| `firebase-emulator` | Custom | 4000, 9099, 8080, 9199 | Auth (+ future Firestore) |
| `mock-api` | Custom | 3000 | Stub Food Intelligence API |
| `python-utils` | Custom | — | Corpus repair / backlog generation |
| `corpus-validator` | Custom | — | Seed JSON validation (batch) |

---

## Environment Strategy

- `.env.example` — template (no secrets)
- `.env` — local only (gitignored)
- Compose uses `env_file: .env` where needed

---

## Volume Strategy

| Volume | Mount | Purpose |
|--------|-------|---------|
| `glylens-firebase-data` | `/firebase/data` | Emulator export/import |
| `../docs/seed_data` | `/data/seed` (ro) | Corpus validation input |
| `../scripts` | `/app/scripts` (ro) | Python utilities |

---

## Networking

- Network: `glylens-dev` (bridge)
- Emulator UI: `http://localhost:4000`
- Mock API: `http://localhost:3000`
- App connects via `10.0.2.2` (Android emulator) or host IP (physical device)

---

## Commands

```powershell
cd docker
copy .env.example .env
docker compose -f docker-compose.dev.yml up -d firebase-emulator mock-api
docker compose -f docker-compose.dev.yml run --rm python-utils python scripts/convergence_repair.py
docker compose -f docker-compose.dev.yml down
```

---

_See `docker/README.md` for operational detail._
