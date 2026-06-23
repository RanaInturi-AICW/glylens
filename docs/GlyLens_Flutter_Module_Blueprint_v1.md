# GlyLens Flutter Module Blueprint v1.0
_Last Updated: 2026-06-20_

lib/
├── app/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── networking/
│   ├── analytics/
│   └── security/
├── shared/
│   ├── widgets/
│   ├── themes/
│   └── models/
├── features/
│   ├── onboarding/
│   ├── search/
│   ├── barcode/
│   ├── photo/
│   ├── compare/
│   ├── assistant/
│   ├── history/
│   └── profile/
└── bootstrap/

Each feature contains:
- presentation
- application
- domain
- infrastructure

State Management:
- Riverpod (recommended)

Architecture:
- Clean Architecture
- Repository Pattern
- Dependency Injection
