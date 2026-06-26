#!/usr/bin/env python3
"""Validate GlyLens seed JSON files parse without error."""
from __future__ import annotations

import json
import sys
from pathlib import Path

SEED_DIR = Path('/data/seed')
REQUIRED = [
    'sources.json',
    'citations.json',
    'evidence.json',
    'ingredients.json',
    'products.json',
    'foods.json',
    'meal_decompositions.json',
]


def main() -> int:
    if not SEED_DIR.is_dir():
        print(f'ERROR: seed directory not found: {SEED_DIR}', file=sys.stderr)
        return 1

    errors = 0
    for name in REQUIRED:
        path = SEED_DIR / name
        if not path.exists():
            print(f'MISSING: {name}')
            errors += 1
            continue
        try:
            with path.open(encoding='utf-8') as f:
                data = json.load(f)
            count = len(data) if isinstance(data, list) else len(data.keys())
            print(f'OK: {name} ({count} records)')
        except json.JSONDecodeError as e:
            print(f'INVALID JSON: {name} — {e}')
            errors += 1

    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
