#!/usr/bin/env python3
"""Generate acquisition backlog and sync CSV from JSON."""
import csv
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SEED = ROOT / "docs" / "seed_data"
DOCS = ROOT / "docs"


def parse_catalog():
    cat_text = (DOCS / "GlyLens_Reference_Catalog_v1.md").read_text(encoding="utf-8")
    entities = []
    current = {}
    for line in cat_text.splitlines():
        s = line.strip()
        if re.match(r"- (ingredient|food|product)Id:", s):
            if current.get("entityId"):
                entities.append(current)
            tag, eid = s.split(": ", 1)
            etype = "ingredient" if "ingredient" in tag else ("food" if "food" in tag else "product")
            current = {"entityId": eid, "entityType": etype, "entityName": None}
        elif current and s.startswith("canonicalName:"):
            current["entityName"] = s.split(": ", 1)[1]
        elif current and s.startswith("availableCarbohydrates:"):
            current["availableCarbohydrates"] = s.split(": ", 1)[1]
        elif current and s.startswith("giValue:"):
            current["giValue"] = s.split(": ", 1)[1]
        elif current and s.startswith("glValue:"):
            current["glValue"] = s.split(": ", 1)[1]
        elif current and s.startswith("sourceName:"):
            current["sourceName"] = s.split(": ", 1)[1]
    if current.get("entityId"):
        entities.append(current)
    return entities


WAVE1 = [
    ("wave1-ing-jamun", "ingredient", "Jamun", "src-ifct"),
    ("wave1-ing-banana", "ingredient", "Banana", "src-usda-fdc"),
    ("wave1-ing-white-rice", "ingredient", "White Rice", "src-fao-who-gi"),
    ("wave1-ing-foxtail-millet", "ingredient", "Foxtail Millet", "src-ifct"),
    ("wave1-ing-ragi", "ingredient", "Ragi", "src-ifct"),
    ("wave1-ing-jowar", "ingredient", "Jowar", "src-ifct"),
    ("wave1-food-chicken-biryani", "food", "Chicken Biryani", "src-ifct"),
    ("wave1-food-masala-dosa", "food", "Masala Dosa", "src-ifct"),
    ("wave1-food-pongal", "food", "Pongal", "src-ifct"),
    ("wave1-food-medu-vada", "food", "Medu Vada", "src-ifct"),
    ("wave1-food-ragi-mudde", "food", "Ragi Mudde", "src-ifct"),
    ("wave1-food-foxtail-upma", "food", "Foxtail Millet Upma", "src-ifct"),
    ("wave1-prod-coke-zero", "product", "Coke Zero", "src-manufacturer-label"),
    ("wave1-prod-pepsi-zero", "product", "Pepsi Zero", "src-manufacturer-label"),
    ("wave1-prod-sugar-free-biscuits", "product", "Sugar Free Biscuits", "src-manufacturer-label"),
    ("wave1-prod-diabetic-atta", "product", "Diabetic Atta", "src-manufacturer-label"),
    ("wave1-prod-protein-bars", "product", "Protein Bars", "src-manufacturer-label"),
]

SOURCE_MAP = {
    "USDA FoodData Central": "src-usda-fdc",
    "FAO/WHO Glycemic Index tables": "src-fao-who-gi",
    "India Food Composition Tables (IFCT)": "src-ifct",
    "National Institute of Nutrition India": "src-nin-india",
    "Manufacturer nutrition label": "src-manufacturer-label",
}


def classify(e):
    c, g, gl = e.get("availableCarbohydrates"), e.get("giValue"), e.get("glValue")
    if c not in (None, "unavailable") and g not in (None, "unavailable") and gl not in (None, "unavailable"):
        return "READY", True
    if c == "unavailable" and g == "unavailable":
        return "PENDING_ACQUISITION", False
    return "PENDING_VALIDATION", False


def main():
    entities = parse_catalog()
    names = {e["entityName"] for e in entities}
    for eid, et, name, src in WAVE1:
        if name not in names:
            entities.append(
                {
                    "entityId": eid,
                    "entityType": et,
                    "entityName": name,
                    "availableCarbohydrates": "unavailable",
                    "giValue": "unavailable",
                    "glValue": "unavailable",
                    "sourceName": src,
                }
            )

    lines = [
        "# GlyLens Acquisition Backlog v1",
        "",
        "_Last Updated: 2026-06-26_",
        "_Owner: Chief Data Officer_",
        "_Canonical catalog baseline: `GlyLens_Reference_Catalog_v1.md`_",
        "",
        "## Summary",
        "",
    ]

    stats = {"READY": 0, "PENDING_ACQUISITION": 0, "PENDING_VALIDATION": 0, "BLOCKED": 0}
    for i, e in enumerate(entities, 1):
        st, ready = classify(e)
        stats[st] += 1
    total = len(entities)
    lines.append(f"- Total entities: **{total}**")
    lines.append(f"- READY: **{stats['READY']}** ({round(100*stats['READY']/total,1)}%)")
    lines.append(f"- PENDING_ACQUISITION: **{stats['PENDING_ACQUISITION']}** ({round(100*stats['PENDING_ACQUISITION']/total,1)}%)")
    lines.append(f"- PENDING_VALIDATION: **{stats['PENDING_VALIDATION']}** ({round(100*stats['PENDING_VALIDATION']/total,1)}%)")
    lines.append(f"- BLOCKED: **{stats['BLOCKED']}**")
    lines.append("")
    lines.append("## Entity Backlog")
    lines.append("")
    lines.append("| taskId | entityId | entityName | entityType | priority | status | assignedSource | requiredFields | blockingDependencies | readyForImport |")
    lines.append("|--------|----------|------------|------------|----------|--------|----------------|----------------|----------------------|----------------|")

    nutr_top10 = {
        "Basmati Rice", "Brown Rice", "Rolled Oats", "Whole Wheat Flour", "Chickpea",
        "Red Lentil", "Green Lentil", "Mung Bean", "Kidney Bean", "Soybean",
    }

    for i, e in enumerate(entities, 1):
        st, ready = classify(e)
        src_name = e.get("sourceName", "")
        if isinstance(src_name, str) and src_name.startswith("src-"):
            assigned = src_name
        else:
            assigned = SOURCE_MAP.get(src_name, src_name if str(src_name).startswith("src-") else "src-unassigned")
        priority = "CRITICAL" if e["entityName"] in nutr_top10 or e["entityId"].startswith("wave1-") else "HIGH"
        req = "availableCarbohydrates,giValue,glValue,evidenceLevel,sourceId,citationId"
        blockers = "none" if st == "READY" else "authoritative source acquisition"
        if e["entityName"] in nutr_top10 and st != "READY":
            blockers += "; Nutritional_Completion_Package_M1 draft pending validation publish"
        lines.append(
            f"| ACQ-{i:04d} | {e['entityId']} | {e['entityName']} | {e['entityType']} | {priority} | {st} | {assigned} | {req} | {blockers} | {str(ready).lower()} |"
        )

    (DOCS / "GlyLens_Acquisition_Backlog_v1.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    # CSV sync for ingredients
    ing = json.loads((SEED / "ingredients.json").read_text(encoding="utf-8"))
    with (SEED / "ingredients.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow([
            "entityId", "canonicalName", "aliases", "category", "region",
            "availableCarbohydrates", "GI", "GL", "GIStatus", "evidenceLevel",
            "sourceId", "sourceStatus", "trustScore", "confidence",
        ])
        for r in ing:
            w.writerow([
                r.get("entityId"), r["canonicalName"], "|".join(r["aliases"]), r["category"], r["region"],
                r["availableCarbohydrates"], r["GI"], r["GL"], r["GIStatus"], r["evidenceLevel"],
                r.get("sourceId"), r.get("sourceStatus"), r["trustScore"], r["confidence"],
            ])

    foods = json.loads((SEED / "foods.json").read_text(encoding="utf-8"))
    with (SEED / "foods.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow([
            "foodId", "itemName", "itemType", "mealDecompositionId", "glycemicProfileId",
            "sourceId", "sourceStatus", "evidenceLevel", "trustScore", "confidence",
        ])
        for r in foods:
            w.writerow([
                r["foodId"], r["itemName"], r["itemType"], r["mealDecompositionId"], r["glycemicProfileId"],
                r["sourceId"], r["sourceStatus"], r["evidenceLevel"], r["trustScore"], r["confidence"],
            ])

    products = json.loads((SEED / "products.json").read_text(encoding="utf-8"))
    with (SEED / "products.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow([
            "entityId", "brand", "productName", "productCategory", "barcode", "nutritionSource",
            "marketingClaims", "availableCarbohydrates", "GI", "GL", "GIStatus", "evidenceLevel",
            "sourceId", "sourceStatus", "trustScore", "confidence",
        ])
        for r in products:
            w.writerow([
                r.get("entityId"), r["brand"], r["productName"], r["productCategory"], r["barcode"],
                r["nutritionSource"], "|".join(r["marketingClaims"]), r["availableCarbohydrates"],
                r["GI"], r["GL"], r["GIStatus"], r["evidenceLevel"], r.get("sourceId"),
                r.get("sourceStatus"), r["trustScore"], r["confidence"],
            ])

    print("Wrote backlog and CSV files")


if __name__ == "__main__":
    main()
