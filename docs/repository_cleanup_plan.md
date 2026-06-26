# GlyLens Repository Cleanup Plan

_Last Updated: 2026-06-20_

> **Repository Status: SUPERSEDED (2026-06-26)**  
> Superseded by Sprint 0 convergence: `GlyLens_Repository_Manifest_v1.md`, `GlyLens_Repository_Synchronization_Report_v1.md`.

## Purpose

This plan defines the repository cleanup approach for GlyLens, including document consolidation, archive creation, and master index updates.

## Goals

- Remove duplicate documents from the top-level `docs/` folder.
- Create focused documentation categories for ADR, architecture, product, prompts, and archive.
- Preserve legacy and obsolete documents in `docs/archive`.
- Update `docs/GlyLens_Master_Documentation_Index_v1.md` to reflect the new structure.
- Keep the repository vendor-neutral, Firebase-independent, and AI/system architecture-focused.

## Proposed `docs/` structure

- `docs/adr/`
  - Authoritative Decision Records and branch-level architecture decisions.
- `docs/architecture/`
  - High-level architecture blueprints, component diagrams, and system design notes.
- `docs/product/`
  - Product specifications, success metrics, and onboarding guides.
- `docs/prompts/`
  - Prompt libraries, Codex/Claude/Cursor instructions, and AI agent guidance.
- `docs/archive/`
  - Legacy copies, duplicates, and vendor-specific or deprecated artifacts.

## Duplicate document candidates

The following files should be reviewed and moved into `docs/archive/` if they are confirmed duplicates or older versions:

- `GlyLens_ADR_Repository_v1 (1).md`
- `GlyLens_Architecture_Blueprint_v1 (1).md`
- `GlyLens_Architecture_Blueprint_v1 (2).md`
- `GlyLens_Cursor_Engineering_Constitution_v1_1 (1).md`
- `GlyLens_Food_Intelligence_Graph_v1_1 (1).md`
- `GlyLens_Food_Intelligence_Graph_v1_1 (2).md`
- `GlyLens_Food_Intelligence_Graph_v1_1 (3).md`
- `GlyLens_Sprint0_Specification_v1 (1).md`
- `GlyLens_Sprint0_Specification_v1 (2).md`

## Vendor-specific / archive candidates

- `GlyLens_Firebase_Security_Rules_Spec_v1.md`
- `GlyLens_Firestore_Physical_Schema_v1.md`
- `GlyLens_Flutter_Module_Blueprint_v1.md`

These files should remain accessible but may be relocated to `docs/archive/` if the current roadmap is explicitly platform- and vendor-neutral.

## Action steps

1. Create the directory categories in `docs/`:
   - `docs/adr/`
   - `docs/architecture/`
   - `docs/product/`
   - `docs/prompts/`
   - `docs/archive/`
2. Move authoritative single-source documents into the new categories.
3. Move legacy or duplicate documents into `docs/archive/`.
4. Update `GlyLens_Master_Documentation_Index_v1.md` to point to the new folders and document categories.
5. Keep the top-level `docs/` folder lean by limiting it to active canonical content and category README files.

## Recommended canonical mapping

- ADR
  - `docs/adr/GlyLens_ADR_Repository_v1.md`
- Architecture
  - `docs/architecture/GlyLens_Architecture_Blueprint_v1.md`
  - `docs/architecture/GlyLens_Food_Intelligence_Graph_v1_1.md`
- Product
  - `docs/product/GlyLens_Sprint0_Specification_v1.md`
  - `docs/product/GlyLens_MVP_Success_Metrics_v1.md`
  - `docs/product/GlyLens_Developer_Onboarding_Guide_v1.md`
- Prompts
  - `docs/prompts/GlyLens_Cursor_Codex_Prompt_Library_v1.md`
  - `docs/prompts/GlyLens_Codex_Ultra_Prompt_v1.md`
- Planning
  - `docs/GlyLens_30_Day_Execution_Plan_v1.md`

## Notes

- Preserve the original file names when moving content to archive for auditability.
- Maintain a single authoritative version for each document family.
- Avoid deleting files until the archive move is validated.
