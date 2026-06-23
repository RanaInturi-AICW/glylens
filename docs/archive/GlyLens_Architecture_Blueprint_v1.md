# GlyLens Architecture Blueprint v1.0
_Last Updated: 2026-06-20_

# ADR-0011: No Vendor Lock-In

## Status
Accepted

## Decision
Although Firebase is selected for MVP delivery, all business logic must remain portable and independent of Firebase implementations.

## Rationale
Future migration to:
- Azure
- AWS
- GCP
- Self-hosted

must not require rewriting core Food Intelligence Engine logic.

## Rule
Business Logic → Interfaces → Infrastructure Adapters

Never:

Business Logic → Firebase Direct Dependencies

---

# GlyLens Architecture Blueprint

## Mission

Build a secure, scalable, cost-optimized, evidence-based Food Intelligence Platform.

---

# Architecture Principles

1. Cost Optimization First
2. Security by Design
3. Evidence-Based Intelligence
4. Explainability First
5. Ingredient-First Modeling
6. Cross Platform
7. Vendor-Neutral Business Logic
8. Serverless First

---

# Logical Architecture

User
↓
Flutter Mobile App
↓
Application Layer
↓
Food Intelligence Engine
↓
Food Intelligence Graph
↓
Data Sources + AI Services

---

# Technology Stack

## Mobile

Flutter

Reasons:
- Single codebase
- iOS + Android
- Fast MVP

---

## Backend

Firebase

Services:
- Firebase Auth
- Firestore
- Cloud Functions
- Firebase Storage
- Firebase Analytics
- Cloud Messaging

---

## AI

Development:
- Claude
- Cursor

Production:
- Model Router Ready
- Claude
- OpenAI
- Gemini (future)

---

# Food Intelligence Engine

## Components

### GI Engine

Responsibilities:
- Measured GI lookup
- Published GI lookup
- Estimated GI generation

### GL Engine

Formula:

GL = (GI × Available Carbohydrates) / 100

### Confidence Engine

Inputs:
- Evidence quality
- Source quality
- Ingredient coverage
- Portion certainty

### Impact Score Engine

Inputs:
- GI
- GL
- Fiber
- Protein
- Processing level
- Evidence quality

### Explainability Engine

Produces:
- Why score exists
- Major contributors
- Alternative recommendations

---

# Evidence Framework

## A

Measured

Confidence:
90-100

## B

Published Research

Confidence:
80-90

## C

Ingredient Mapping

Confidence:
65-80

## D

AI-Assisted Estimation

Confidence:
50-65

Below 50:
Reject estimate.

---

# Firestore Collections

ingredients

foods

food_variants

products

sources

users

food_scans

comparisons

assistant_conversations

---

# Security Architecture

## Anonymous Users

- 5 scans/day
- Images deleted after processing

## Registered Users

- Google Sign-In
- Apple Sign-In
- Optional image retention

## Premium Users

- Unlimited scans
- Unlimited comparisons
- Advanced insights

---

# Data Sources

Primary:
- USDA FoodData Central
- Open Food Facts
- GI datasets

Secondary:
- Government datasets
- Peer-reviewed studies

---

# Cost Controls

Rules:

1. Cache aggressively
2. Avoid repeated API calls
3. Store normalized results
4. Use AI only when needed
5. Never use LLMs for calculations

---

# Analytics

Track:

- Food searches
- Food scans
- Barcode scans
- Comparisons
- AI questions

Do NOT track:

- Medical records
- Diagnoses
- Medication information

---

# Founder Build Strategy

Founder:
- Product Owner
- Architect
- Data Steward

Claude:
- Product Strategy
- Architecture
- Reviews

Cursor:
- Flutter Development
- Firebase Development
- Testing

---

# Next Artifacts

1. Food Intelligence Graph Specification v1.1
2. ADR Repository
3. Cursor Engineering Constitution
4. Cursor Prompt Library
5. 30-Day Execution Plan
