# GlyLens - Sprint 0 Specification v1.0

## Vision
GlyLens is a Food Intelligence Platform that helps users make better food decisions through evidence-based glycemic intelligence.

## Non-Negotiable Principles
1. Data > AI
2. Evidence > Opinion
3. Explainability > Raw Scores
4. Cost Optimization First
5. Security by Design
6. Ingredient-First Intelligence
7. Educational, Not Medical
8. Flutter + Firebase
9. Claude + Cursor Founder-Led Development
10. Food Intelligence Graph is the Moat

---

## Product Positioning
**Brand:** GlyLens

**Tagline:** Food Intelligence for Better Decisions

GlyLens is NOT:
- A medical device
- A diabetes treatment app
- A calorie tracker
- A weight loss app

GlyLens IS:
- A Food Intelligence Platform
- An Educational Platform
- An Evidence-Based Platform

---

## Frozen Technology Decisions

### Frontend
- Flutter
- Single codebase
- iOS + Android

### Backend
- Firebase Auth
- Firestore
- Firebase Storage
- Cloud Functions
- Firebase Analytics
- Firebase Cloud Messaging

### AI Development Tools
- Claude
- Cursor

### Avoid Until Product-Market Fit
- Kubernetes
- AKS
- Vector Databases
- Complex Microservices
- Expensive LLM Workflows

---

## Evidence Framework

### A
Measured GI

### B
Published Research

### C
Ingredient Mapping

### D
AI-Assisted Estimation

Below confidence threshold:
- Do not estimate
- Ask user for more information

---

## Food Intelligence Graph

Core Collections:

- ingredients
- foods
- food_variants
- products
- sources
- users
- food_scans
- comparisons
- assistant_conversations

---

## Sprint 0 Goal

Build the Food Intelligence Engine before building the app.

### Deliverables

1. Food Intelligence Graph schema
2. GI model
3. GL calculation engine
4. Glycemic Impact Score framework
5. Confidence engine
6. Evidence engine
7. Source attribution framework
8. API contracts

---

## What NOT To Build In Sprint 0

- Login screens
- Premium subscriptions
- Notifications
- AI chat
- Photo recognition
- Barcode scanning UI
- Fancy UI

Focus only on the intelligence engine.

---

## Day-by-Day Plan

### Day 1
- Finalize Food Intelligence Graph schema
- Define entities and relationships

### Day 2
- Define GI framework
- Define GL framework
- Define confidence model

### Day 3
- Design Impact Score framework
- Define explainability engine

### Day 4
- Design API contracts
- Define JSON response schemas

### Day 5
- Review architecture
- Security review
- Cost review

---

## Cursor Engineering Rules

Cursor must:

- Follow Clean Architecture
- Use Repository Pattern
- Keep modules feature-based
- Add tests
- Avoid unnecessary dependencies

Cursor must never:

- Invent nutrition facts
- Invent GI values
- Provide medical advice
- Introduce infrastructure not approved in architecture

---

## Long-Term Roadmap

### Phase 1
Food Intelligence

### Phase 2
Decision Intelligence

### Phase 3
Personal Intelligence

### Phase 4
Professional Intelligence

### Phase 5
Food Intelligence API Platform

---

## Success Metrics

### MVP
- Working Food Intelligence Engine
- Search capability
- GI/GL calculation
- Impact Score
- Confidence score
- Evidence attribution

### Product
- User trust
- Accuracy
- Explainability
- Low operating cost
