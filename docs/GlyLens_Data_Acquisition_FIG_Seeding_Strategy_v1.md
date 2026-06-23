# GlyLens Data Acquisition & FIG Seeding Strategy v1.0
_Last Updated: 2026-06-20_

## Purpose

Create the initial Food Intelligence Graph (FIG) with high-quality, trusted, evidence-based food data.

---

# Objective

Build a reliable seed dataset before advanced features.

Without quality data:

- Search suffers
- Comparisons suffer
- Explanations suffer
- AI quality suffers

---

# Phase 1 Sources

## Tier 1

USDA FoodData Central

Open Food Facts

Public GI datasets

---

## Tier 2

Government nutrition databases

Peer-reviewed studies

---

# Data Pipeline

Source
↓
Normalize
↓
Validate
↓
Map Ingredients
↓
Attach Evidence
↓
Calculate Confidence
↓
Store in FIG

---

# Initial Seeding Targets

## Ingredients

Target:
1000+

Examples:
- Fruits
- Vegetables
- Grains
- Proteins
- Oils

---

## Foods

Target:
500+

Examples:
- Indian foods
- US foods
- Global foods

---

## Products

Target:
5000+

Via Open Food Facts

---

# Normalization Rules

- Standard naming
- Alias support
- Regional variants
- Ingredient decomposition

---

# Confidence Rules

Every imported record receives:

- Evidence Level
- Confidence Score
- Source Attribution

---

# Data Quality Gates

Reject:

- Missing source
- Unverifiable GI
- Contradictory evidence

---

# Cost Optimization

Import once.

Normalize once.

Serve locally.

Avoid repeated API lookups.

---

# Success Criteria

Seed FIG contains:

- 1000+ ingredients
- 500+ foods
- 5000+ products

With traceable sources and evidence.
