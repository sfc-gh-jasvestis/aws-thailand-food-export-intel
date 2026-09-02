# Export Market Intelligence

**Thailand - Food & Agribusiness**
Use case: Export Intelligence & Market Analysis

> AI-powered export market intelligence for Thai food companies — Comprehend extracts trade signals, AI_CLASSIFY categorizes market opportunities, and Cortex Complete generates actionable export briefs for 50+ destination markets.

## Why Snowflake

Snowflake analyzes trade data, extracts market signals from unstructured sources, classifies export opportunities, and generates AI briefs — replacing fragmented trade intelligence with unified analytics

- **AI_EXTRACT + AI_CLASSIFY on trade signals** - Only demo extracting and classifying trade intelligence from unstructured news in real time
- **Market opportunity scoring** - Composite attractiveness scoring combining tariffs, demand growth, competitive gap, and FTA benefits
- **Cortex Complete for strategic briefs** - AI-generated market entry and response briefs with supporting data citations
- **Thai food export context** - Realistic trade flows across 50+ markets with Thai HS codes and product categories
- **Competitive position tracking (Thailand vs Vietnam, India)** - ML.ANOMALY_DETECTION on market share shifts identifying competitive inflection points
- **FTA impact analysis** - Quantified tariff advantage calculation from Thailand's 14 active free trade agreements

## What is deployed

| | |
|---|---|
| Database | `THAILAND_FOOD_EXPORT_INTEL` |
| Service | `THAILAND_FOOD_EXPORT_INTEL_APP` |
| Compute pool | `SEA_DEMOS_THAILAND_POOL` |
| Dimension table | `RAW.THAI_EXPORT_CONTEXT` (20 rows) |
| Fact table | `RAW.EXPORT_TRANSACTIONS` (250,000 rows, 90 days) |
| Curated layer | `CURATED.PERFORMANCE_SUMMARY`, `CURATED.TREND_ANALYSIS`, `CURATED.KPI_SUMMARY` |
| Currency | THB (฿) |

Regions in play: Bangkok, Chonburi, Rayong, Chiang Mai, Songkhla
Segments: EU Market, China Market, Japan Market, ASEAN Market

Dynamic tables are created suspended and refreshed on demand:

```bash
./refresh_demo_data.sh THAILAND_FOOD_EXPORT_INTEL
```

## KPI cards

Every card below is served live from `CURATED.KPI_SUMMARY`. The app keeps the
original literal as a fallback, so it still renders if Snowflake is unreachable.

| Card | Value | Backed by |
|---|---|---|
| Export Revenue (MTD) | `฿4.2B` | total across Thai Export Context |
| Markets at Risk | `3` | average per event |
| Compliance Flags | `8` | average per event |
| Active Shipments | `1,247` | total across Thai Export Context |
| Japan Demand Index | `↑ 8.2%` | average per event |
| EU Rejection Rate | `0.3%` | average per event |
| China Tariff Impact | `-฿120M` | total across Thai Export Context |


## Demo flow

1. Executive Cockpit
2. Market Opportunities
3. Competitive & Barriers
4. Ask AI
5. Architecture & Data

## Talking points

- **฿1.1T** - Thai food exports across 50+ destination markets
- **7 barriers** - new trade barriers detected this quarter affecting ฿45B
- **12 opportunities** - high-potential market-product pairs identified (score > 85)
- **80K signals** - trade news items analyzed by AI_EXTRACT + AI_CLASSIFY
- **50+ markets** - monitored for opportunities and threats
- **350K transactions** - export records analyzed for pattern detection

## Business impact

- Thailand's food exports reached ฿1.1 trillion in 2023, ranking 13th globally (National Food Institute Thailand)
- AI-powered trade intelligence accelerates market entry decisions by 60% and reduces research costs by 40% (McKinsey Global Trade)
- Thailand has 14 active FTAs covering 80%+ of its food export markets (Thai Ministry of Commerce)
- Real-time trade barrier monitoring prevents $5-15M in annual compliance penalties per exporter (WTO Trade Facilitation)

---
Generated from `generator/demo_specs/aws-thailand-food-export-intel.json`. Do not hand-edit: run
`python3 generator/gen_repo_docs.py aws-thailand-food-export-intel` instead.
