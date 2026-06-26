# GlyLens AI Engineering Standards v1

_Last Updated: 2026-06-26_  
_Build Program: 1.2_  
_Status: CANONICAL_  
_Owner: Platform Engineering + ARB_

---

## 1. Purpose

Define how AI tools participate in GlyLens development without conflicting with frozen architecture, canonical documentation, or human ownership.

**All AI agents must start at:** `docs/GlyLens_Master_Documentation_Index_v1.md`

---

## 2. Tool Responsibilities

| Tool | Primary Role | May Implement Code | May Change Architecture | Review Required |
|------|--------------|-------------------|------------------------|-----------------|
| **Cursor** | Day-to-day implementation, refactoring, tests | ✅ Yes | ❌ No | Human PR review |
| **Codex** | Batch fixes, CI repair, script generation | ✅ Yes (scoped tasks) | ❌ No | PR + CI green |
| **Claude** | Architecture review, documentation, audits | ⚠️ Docs only unless tasked | ❌ No | ARB for doc changes |
| **ChatGPT** | Research, brainstorming | ❌ Not canonical | ❌ No | N/A — output not binding |

---

## 3. Coding Ownership

| Layer | Owner | AI May Edit |
|-------|-------|-------------|
| `docs/adr/`, Architecture Blueprint, FIG | ARB (frozen) | ❌ Unless explicit governance sprint |
| `platform/` | Platform Engineering | ✅ With Platform PR |
| `lib/core/domain/` | Solution Architect | ✅ Tests and approved fixes only |
| `lib/features/` | Flutter team | ✅ Per sprint scope |
| `docs/seed_data/` | CDO / Data Governance | ⚠️ Via acquisition workflow only |
| `.github/` | DevOps | ✅ Platform Engineering |

---

## 4. Mandatory AI Rules

1. **Read Master Index first** — no cold-start implementation
2. **No architecture redesign** — ADRs are frozen
3. **No fabricated nutritional data** — ADR-0008
4. **No secrets in code** — use `--dart-define`
5. **No `print()`** — use `AppLogger`
6. **Riverpod only** — no Bloc/GetX (Constitution)
7. **Scope discipline** — reject feature creep in platform sprints
8. **Evidence-based claims** — cite file paths in reviews
9. **Run quality gates** before declaring work complete
10. **Update Manifest + Master Index** when adding canonical docs

---

## 5. Review Responsibilities

| Change Type | Reviewer |
|-------------|----------|
| Platform / DevOps | Principal DevOps Engineer |
| Flutter platform code | Principal Flutter Engineer |
| Domain / engines | Solution Architect |
| Corpus / seed data | CDO |
| Security-sensitive | Principal Security Engineer |
| Documentation (canonical) | ARB + doc owner |

---

## 6. Conflict Resolution

When AI outputs conflict:

1. **Canonical docs** beat AI-generated prose
2. **ADR Repository** beats Architecture Blueprint deltas
3. **Reference Catalog** beats Nutritional Completion drafts
4. **Repository Manifest** resolves duplicate file status
5. **Human Principal Engineer review** is final for engineering disputes

**Escalation path:** Developer → Platform Engineering → ARB → PRB

---

## 7. Prompt Library Usage

| Task | Prompt Source |
|------|---------------|
| Cursor implementation | `docs/prompts/GlyLens_Cursor_Codex_Prompt_Library_v1.md` |
| Codex batch work | `docs/prompts/GlyLens_Codex_Ultra_Prompt_v1.md` |
| Engineering constraints | `docs/GlyLens_Cursor_Engineering_Constitution_v1_1.md` |

---

## 8. Prohibited AI Actions

- Creating new Firebase projects without authorization
- Implementing Firestore before Build Program 3
- Implementing Food Intelligence UI before BP2 gate
- Force-pushing `main`
- Committing `.env`, API keys, or `google-services.json` with real credentials
- Auto-installing software on developer machines without consent

---

## 9. Agent Handoff Format

When one AI hands off to another, include:

1. Master Index reading confirmation
2. Sprint / Build Program ID
3. Files changed (paths)
4. Quality gate status
5. Open technical debt IDs (`GlyLens_Technical_Debt_Register_v1.md`)
6. Explicit out-of-scope list

---

_Related: `GlyLens_Platform_Contract_v1.md`, `GlyLens_Local_Quality_Gates_v1.md`_
