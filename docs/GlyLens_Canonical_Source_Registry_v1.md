# GlyLens Canonical Source Registry v1

_Last Updated: 2026-06-26_  
_Status: CANONICAL_  
_Owner: Chief Data Governance Officer_  
_Runtime mirror: `docs/seed_data/sources.json`_

This registry is the **single authoritative source list** for GlyLens.  
Supersedes source registry prose in `corpus_build_package_v1.md` §6 and legacy `sources.json` `src-001`–`src-004` identifiers.

---

| sourceId | sourceName | sourceType | tier | trustScore | evidenceLevel | license | updateFrequency | acquisitionMethod | status |
|----------|------------|------------|------|------------|---------------|---------|-----------------|-------------------|--------|
| src-usda-fdc | USDA FoodData Central | government | 1 | 92 | A | USDA public domain | quarterly | API ingest / dataset import | ACTIVE |
| src-ifct | India Food Composition Tables (IFCT) | government | 1 | 90 | A | Government of India | annual | dataset import | ACTIVE |
| src-fao-who-gi | FAO/WHO Glycemic Index tables | academic | 1 | 91 | A | Academic reference | as published | manual extraction | ACTIVE |
| src-nin-india | National Institute of Nutrition India | government | 1 | 90 | A | Government of India | annual | dataset import | ACTIVE |
| src-ada | American Diabetes Association publications | academic | 2 | 92 | A | Copyright ADA | as published | manual extraction | ACTIVE |
| src-clinical-gi | Clinical glycemic index studies | academic | 2 | 88 | A | Journal-specific | as published | manual extraction | ACTIVE |
| src-pubmed-gi | PubMed-reviewed GI datasets | academic | 2 | 90 | A | Journal-specific | continuous | manual extraction | ACTIVE |
| src-diabetes-uk | Diabetes UK guidance | academic | 2 | 87 | B | Copyright Diabetes UK | as published | manual extraction | ACTIVE |
| src-local-fc-research | Local food composition research centers | academic | 2 | 80 | B | Varies | as published | manual extraction | ACTIVE |
| src-open-food-facts | Open Food Facts | openData | 2 | 75 | C | ODbL | continuous | API ingest | ACTIVE |
| src-manufacturer-label | Manufacturer nutrition label | industry | 2 | 75 | C | Proprietary label data | product-specific | OCR / manual extraction | ACTIVE |

---

## Governance Rules

1. Every nutritional field citation must reference a `sourceId` from this registry.
2. No duplicate source names. No alternate IDs for the same source.
3. New sources require Architecture Review Board approval and manifest update.
4. Runtime imports must use `docs/seed_data/sources.json` generated from this registry.

## Dependencies

- ADR-0005 Evidence Hierarchy
- ADR-0008 AI Assists, Data Governs
- `docs/GI_Reference_Catalog_Framework_v1.md` §4 Source Citation Schema
