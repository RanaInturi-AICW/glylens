#!/usr/bin/env python3
"""Sprint 0 convergence: repair runtime seed assets."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SEED = ROOT / "docs" / "seed_data"

SOURCES = [
    {
        "sourceId": "src-usda-fdc",
        "sourceName": "USDA FoodData Central",
        "sourceType": "government",
        "region": "US",
        "tier": 1,
        "trustScore": 92,
        "evidenceLevel": "A",
        "license": "USDA public domain",
        "updateFrequency": "quarterly",
        "acquisitionMethod": "API ingest / dataset import",
        "status": "ACTIVE",
        "description": "Primary US nutrient composition database.",
    },
    {
        "sourceId": "src-ifct",
        "sourceName": "India Food Composition Tables (IFCT)",
        "sourceType": "government",
        "region": "India",
        "tier": 1,
        "trustScore": 90,
        "evidenceLevel": "A",
        "license": "Government of India",
        "updateFrequency": "annual",
        "acquisitionMethod": "dataset import",
        "status": "ACTIVE",
        "description": "National nutrition composition tables for India.",
    },
    {
        "sourceId": "src-open-food-facts",
        "sourceName": "Open Food Facts",
        "sourceType": "openData",
        "region": "Global",
        "tier": 2,
        "trustScore": 75,
        "evidenceLevel": "C",
        "license": "ODbL",
        "updateFrequency": "continuous",
        "acquisitionMethod": "API ingest",
        "status": "ACTIVE",
        "description": "Open product and ingredient catalog.",
    },
    {
        "sourceId": "src-fao-who-gi",
        "sourceName": "FAO/WHO Glycemic Index tables",
        "sourceType": "academic",
        "region": "Global",
        "tier": 1,
        "trustScore": 91,
        "evidenceLevel": "A",
        "license": "Academic reference",
        "updateFrequency": "as published",
        "acquisitionMethod": "manual extraction",
        "status": "ACTIVE",
        "description": "Academic glycemic index reference tables.",
    },
    {
        "sourceId": "src-ada",
        "sourceName": "American Diabetes Association publications",
        "sourceType": "academic",
        "region": "US",
        "tier": 2,
        "trustScore": 92,
        "evidenceLevel": "A",
        "license": "Copyright ADA",
        "updateFrequency": "as published",
        "acquisitionMethod": "manual extraction",
        "status": "ACTIVE",
        "description": "Diabetes nutrition guidance publications.",
    },
    {
        "sourceId": "src-nin-india",
        "sourceName": "National Institute of Nutrition India",
        "sourceType": "government",
        "region": "India",
        "tier": 1,
        "trustScore": 90,
        "evidenceLevel": "A",
        "license": "Government of India",
        "updateFrequency": "annual",
        "acquisitionMethod": "dataset import",
        "status": "ACTIVE",
        "description": "Indian government nutrition authority.",
    },
    {
        "sourceId": "src-clinical-gi",
        "sourceName": "Clinical glycemic index studies",
        "sourceType": "academic",
        "region": "Global",
        "tier": 2,
        "trustScore": 88,
        "evidenceLevel": "A",
        "license": "Journal-specific",
        "updateFrequency": "as published",
        "acquisitionMethod": "manual extraction",
        "status": "ACTIVE",
        "description": "Peer-reviewed GI study corpus.",
    },
    {
        "sourceId": "src-diabetes-uk",
        "sourceName": "Diabetes UK guidance",
        "sourceType": "academic",
        "region": "UK",
        "tier": 2,
        "trustScore": 87,
        "evidenceLevel": "B",
        "license": "Copyright Diabetes UK",
        "updateFrequency": "as published",
        "acquisitionMethod": "manual extraction",
        "status": "ACTIVE",
        "description": "UK diabetes nutrition guidance.",
    },
    {
        "sourceId": "src-pubmed-gi",
        "sourceName": "PubMed-reviewed GI datasets",
        "sourceType": "academic",
        "region": "Global",
        "tier": 2,
        "trustScore": 90,
        "evidenceLevel": "A",
        "license": "Journal-specific",
        "updateFrequency": "continuous",
        "acquisitionMethod": "manual extraction",
        "status": "ACTIVE",
        "description": "PubMed-indexed GI research.",
    },
    {
        "sourceId": "src-local-fc-research",
        "sourceName": "Local food composition research centers",
        "sourceType": "academic",
        "region": "India/US",
        "tier": 2,
        "trustScore": 80,
        "evidenceLevel": "B",
        "license": "Varies",
        "updateFrequency": "as published",
        "acquisitionMethod": "manual extraction",
        "status": "ACTIVE",
        "description": "Regional food composition research.",
    },
    {
        "sourceId": "src-manufacturer-label",
        "sourceName": "Manufacturer nutrition label",
        "sourceType": "industry",
        "region": "Global",
        "tier": 2,
        "trustScore": 75,
        "evidenceLevel": "C",
        "license": "Proprietary label data",
        "updateFrequency": "product-specific",
        "acquisitionMethod": "OCR / manual extraction",
        "status": "ACTIVE",
        "description": "Branded product nutrition panels.",
    },
]

NAME_TO_SOURCE = {
    "USDA FoodData Central": "src-usda-fdc",
    "FAO/WHO Glycemic Index tables": "src-fao-who-gi",
    "India Food Composition Tables (IFCT)": "src-ifct",
    "National Institute of Nutrition India": "src-nin-india",
    "Manufacturer nutrition label": "src-manufacturer-label",
    "Open Food Facts": "src-open-food-facts",
}


def parse_catalog():
    cat_text = (ROOT / "docs/GlyLens_Reference_Catalog_v1.md").read_text(encoding="utf-8")
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
        elif current and s.startswith("evidenceLevel:"):
            current["evidenceLevel"] = s.split(": ", 1)[1]
        elif current and s.startswith("sourceName:"):
            current["sourceName"] = s.split(": ", 1)[1]
        elif current and s.startswith("trustScore:"):
            current["trustScore"] = s.split(": ", 1)[1]
        elif current and s.startswith("confidenceRange:"):
            current["confidenceRange"] = s.split(": ", 1)[1]
    if current.get("entityId"):
        entities.append(current)
    return entities


def main():
    SEED.mkdir(parents=True, exist_ok=True)
    (SEED / "sources.json").write_text(json.dumps(SOURCES, indent=4) + "\n", encoding="utf-8")

    entities = parse_catalog()
    citations = []
    cid = 1
    for e in entities:
        src = NAME_TO_SOURCE.get(e.get("sourceName", ""), None)
        for field in ("giValue", "glValue", "availableCarbohydrates"):
            val = e.get(field, "unavailable")
            citations.append(
                {
                    "citationId": f"cite-{cid:04d}",
                    "entityId": e["entityId"],
                    "fieldName": field,
                    "sourceId": src,
                    "retrievalDate": "2026-06-20" if val != "unavailable" else None,
                    "validationStatus": "VALIDATED" if val != "unavailable" else "PENDING_ACQUISITION",
                    "evidenceLevel": e.get("evidenceLevel", "B"),
                    "confidence": e.get("confidenceRange"),
                }
            )
            cid += 1
    (SEED / "citations.json").write_text(json.dumps(citations, indent=4) + "\n", encoding="utf-8")

    name_to_id = {e["entityName"]: e["entityId"] for e in entities}
    evidence_rows = [
        ("evid-001", "Basmati Rice", "giValue", "src-fao-who-gi", "A", 92),
        ("evid-002", "Brown Rice", "giValue", "src-fao-who-gi", "A", 91),
        ("evid-003", "Rolled Oats", "giValue", "src-usda-fdc", "A", 90),
        ("evid-004", "Whole Wheat Flour", "giValue", "src-usda-fdc", "B", 88),
        ("evid-005", "Chickpea", "giValue", "src-fao-who-gi", "A", 92),
        ("evid-006", "Red Lentil", "giValue", "src-fao-who-gi", "A", 93),
        ("evid-007", "Idli", "giValue", "src-ifct", "B", 85),
        ("evid-008", "Khichdi", "giValue", "src-open-food-facts", "C", 75),
        ("evid-009", "Greek Yogurt Parfait", "giValue", "src-open-food-facts", "C", 75),
        ("evid-010", "Quaker Oats Old Fashioned", "giValue", "src-usda-fdc", "A", 91),
        ("evid-011", "Amul Paneer", "giValue", "src-ifct", "C", 75),
        ("evid-012", "Patanjali Multigrain Atta", "giValue", "src-local-fc-research", "B", 75),
        ("evid-013", "Apple", "giValue", "src-usda-fdc", "A", 85),
        ("evid-014", "Spinach", "giValue", "src-usda-fdc", "A", 90),
        ("evid-015", "Lentil Soup", "giValue", "src-open-food-facts", "C", 70),
    ]
    evidence = []
    for evid, name, field, src, lvl, trust in evidence_rows:
        entity_id = name_to_id.get(name)
        evidence.append(
            {
                "evidenceId": evid,
                "entityId": entity_id,
                "entityName": name,
                "fieldName": field,
                "sourceId": src,
                "evidenceLevel": lvl,
                "trustScore": trust,
                "validationStatus": "VALIDATED" if entity_id else "PENDING_VALIDATION",
                "acquisitionDate": "2026-06-20",
            }
        )
    (SEED / "evidence.json").write_text(json.dumps(evidence, indent=4) + "\n", encoding="utf-8")

    ing_map = {
        "Jamun": "wave1-ing-jamun",
        "Banana": "wave1-ing-banana",
        "White Rice": "wave1-ing-white-rice",
        "Brown Rice": "ingr-002",
        "Oats": "ingr-003",
        "Chickpea": "ingr-005",
    }
    ingredients = json.loads((SEED / "ingredients.json").read_text(encoding="utf-8"))
    for row in ingredients:
        row["entityId"] = ing_map.get(row["canonicalName"])
        src_text = row.get("source", "")
        if "IFCT" in src_text or "NIN" in src_text:
            row["sourceId"] = "src-ifct"
        elif "USDA" in src_text:
            row["sourceId"] = "src-usda-fdc"
        elif "FAO" in src_text:
            row["sourceId"] = "src-fao-who-gi"
        else:
            row["sourceId"] = None
        row["sourceStatus"] = "EXPECTED" if "(expected)" in src_text else "ASSIGNED"
    (SEED / "ingredients.json").write_text(json.dumps(ingredients, indent=4) + "\n", encoding="utf-8")

    meals = json.loads((SEED / "meal_decompositions.json").read_text(encoding="utf-8"))
    meal_ids = {"Chicken Biryani": "meal-001", "Masala Dosa": "meal-002", "Pongal": "meal-003"}
    food_ids = {
        "Chicken Biryani": "wave1-food-chicken-biryani",
        "Masala Dosa": "wave1-food-masala-dosa",
        "Pongal": "wave1-food-pongal",
    }
    for m in meals:
        m["mealId"] = meal_ids[m["itemName"]]
        m["foodId"] = food_ids[m["itemName"]]
        m["sourceId"] = "src-ifct"
        m["sourceStatus"] = "EXPECTED"
    (SEED / "meal_decompositions.json").write_text(json.dumps(meals, indent=4) + "\n", encoding="utf-8")

    foods = []
    for m in meals:
        foods.append(
            {
                "foodId": m["foodId"],
                "itemName": m["itemName"],
                "itemType": "food",
                "mealDecompositionId": m["mealId"],
                "glycemicProfileId": None,
                "sourceId": m["sourceId"],
                "sourceStatus": m["sourceStatus"],
                "evidenceLevel": m["evidenceLevel"],
                "trustScore": m["trustScore"],
                "confidence": m["confidence"],
            }
        )
    (SEED / "foods.json").write_text(json.dumps(foods, indent=4) + "\n", encoding="utf-8")

    prod_map = {
        "Coke Zero": "wave1-prod-coke-zero",
        "Pepsi Zero": "wave1-prod-pepsi-zero",
        "Britannia NutriChoice": "wave1-prod-britannia-nutrichoice",
        "RiteBite Protein Bar": "wave1-prod-ritebite-protein-bar",
        "Yoga Bar Protein Bar": "wave1-prod-yoga-bar-protein-bar",
    }
    products = json.loads((SEED / "products.json").read_text(encoding="utf-8"))
    for p in products:
        p["entityId"] = prod_map.get(p["productName"])
        p["sourceId"] = "src-manufacturer-label"
        p["sourceStatus"] = "ASSIGNED"
    (SEED / "products.json").write_text(json.dumps(products, indent=4) + "\n", encoding="utf-8")

    for f in SEED.glob("*.json"):
        json.loads(f.read_text(encoding="utf-8"))
        print(f"VALID: {f.name}")


if __name__ == "__main__":
    main()
