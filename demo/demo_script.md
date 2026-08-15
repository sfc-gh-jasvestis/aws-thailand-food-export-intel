# Demo Script: Export Market Intelligence
## ~4-Minute Recorded Walkthrough
**Format**: Screen recording with voiceover
**Target**: Customer meeting / booth loop / social share
**Narrative**: "Snowflake analyzes trade data, extracts market signals from unstructured sources, classifies export opportunities, and generates AI briefs — replacing fragmented trade intelligence with unified analytics"
**Demo Mode**: Open app with `?demo=true` for presenter notes

---

## Two Personas

| Persona | Role | Tool | What they care about |
|---|---|---|---|
| **Apinya Leelanantakul** | VP International Trade | React App (SPCS) | Export revenue by market, trade barrier changes, market diversification, competitive positioning |
| **Piyawat Tongsomchai** | Trade Intelligence Analyst | Amazon QuickSight | Trade flow analysis, tariff changes, competitor movements, regulatory updates |

---

## What's Built

| Layer | Component | Detail |
|---|---|---|
| **RAW** | 8 tables | EXPORT_TRANSACTIONS (350000), TRADE_SIGNALS (80000), TARIFF_DATABASE (25000), COMPETITOR_EXPORTS (200000), MARKET_REGULATIONS (500), BUYER_CONTACTS (3000), FTA_AGREEMENTS (45), THAI_EXPORT_CONTEXT (10) |
| **CURATED** | 4 Dynamic Tables | MARKET_OPPORTUNITY_SCORES, EXPORT_TRENDS, TRADE_BARRIER_TRACKER, COMPETITIVE_POSITION |
| **ML** | ML.FORECAST + ML.ANOMALY_DETECTION | Forecasting + anomaly detection |
| **AI** | AI_EXTRACT, AI_CLASSIFY, COMPLETE | Classification + extraction |
| **Search** | Cortex Search | 500 documents indexed |
| **Agent** | EXPORT_INTEL_AGENT | Semantic View + Search tools |


---

## The Story

Thailand exports ฿1.1 trillion in food products to 50+ markets — but trade intelligence is fragmented across government databases, news sources, and competitor reports. AI-native analytics extracts signals, classifies opportunities, and generates strategic briefs — turning information overload into actionable export strategy.

---

## Script

### [0:00–0:45] EXECUTIVE COCKPIT

**Show**: Executive Cockpit tab

> "Thai food exports: ฿1.1T this year. Top markets: Japan (18%), USA (12%), China (11%), EU (15%)."

**Action**: Point at export revenue by market treemap

### [0:45–1:30] MARKET OPPORTUNITIES

**Show**: Market Opportunities tab

> "AI scores 50+ markets by attractiveness: tariff advantage, demand growth, competitive gap."

**Action**: Show opportunity scoring matrix

### [1:30–2:15] COMPETITIVE & BARRIERS

**Show**: Competitive & Barriers tab

> "Vietnam shrimp exports to Japan up 22% — taking Thai market share. ML detects inflection point."

**Action**: Show Thailand vs Vietnam market share trend

### [2:15–3:00] ASK AI

**Show**: Ask AI tab

> "Apinya asks: 'Where should we focus market development next quarter?'"

**Action**: Type: 'Top market development priorities for next quarter'

### [3:00–3:45] ARCHITECTURE & DATA

**Show**: Architecture & Data tab

> "Seven Snowflake capabilities, six AWS services."

**Action**: Walk through architecture diagram


---

## Key Demo Differentiators

1. **AI_EXTRACT + AI_CLASSIFY on trade signals** — Only demo extracting and classifying trade intelligence from unstructured news in real time
2. **Market opportunity scoring** — Composite attractiveness scoring combining tariffs, demand growth, competitive gap, and FTA benefits
3. **Cortex Complete for strategic briefs** — AI-generated market entry and response briefs with supporting data citations
4. **Thai food export context** — Realistic trade flows across 50+ markets with Thai HS codes and product categories
5. **Competitive position tracking (Thailand vs Vietnam, India)** — ML.ANOMALY_DETECTION on market share shifts identifying competitive inflection points
6. **FTA impact analysis** — Quantified tariff advantage calculation from Thailand's 14 active free trade agreements


---

## Demo Prep Checklist

### Data Verification
- [ ] `SELECT COUNT(*) FROM EXPORT_INTELLIGENCE.RAW.EXPORT_TRANSACTIONS` → 350000
- [ ] `SELECT COUNT(*) FROM EXPORT_INTELLIGENCE.RAW.TRADE_SIGNALS` → 80000
- [ ] `SELECT COUNT(*) FROM EXPORT_INTELLIGENCE.CURATED.MARKET_OPPORTUNITY_SCORES WHERE SCORE > 85` → 12

### ML Model Verification
- [ ] `SELECT COUNT(*) FROM EXPORT_INTELLIGENCE.ML.EXPORT_DEMAND_FORECAST_RESULTS` → >0
- [ ] `SELECT SUM(CASE WHEN IS_ANOMALY THEN 1 ELSE 0 END) FROM EXPORT_INTELLIGENCE.ML.TRADE_SHIFT_RESULTS` → >=5

### AI/Agent Verification
- [ ] `SELECT COUNT(*) FROM EXPORT_INTELLIGENCE.AI.CLASSIFIED_TRADE_SIGNALS` → 80000

