# GlyLens Docker — Development Infrastructure

Supporting services only. **Do not run Flutter inside Docker.**

## Quick Start

```powershell
cd docker
Copy-Item .env.example .env
docker compose -f docker-compose.dev.yml up -d
```

## Services

| Service | URL | Notes |
|---------|-----|-------|
| Firebase Emulator UI | http://localhost:4000 | Auth on 9099 |
| Mock API | http://localhost:3000/health | BP2 stub |
| python-utils | one-shot | `docker compose run --rm python-utils ...` |
| corpus-validator | one-shot | Validates `docs/seed_data/*.json` |

## Profiles

```powershell
# Emulators only
docker compose -f docker-compose.dev.yml up -d firebase-emulator

# Full dev stack
docker compose -f docker-compose.dev.yml --profile full up -d
```

## Volumes

- `glylens-firebase-data` — persistent emulator state
- Bind mounts: `docs/seed_data`, `scripts` (read-only)

## Troubleshooting

- Ensure Docker Desktop is running with WSL2 integration
- Run `.\scripts\platform\validate-environment.ps1` from repo root
- Port conflicts: edit `.env` port variables

See `platform/GlyLens_Docker_Strategy_v1.md`.
