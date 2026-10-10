# Thailand Food Export Quality

**Thailand - Food Export Shipment Quality**
Use case: export shipment quality, destination rejections, document discrepancies and export document controls

> Export shipment monitoring for 40 fictional Thai food exporters in Bangkok, Samut Sakhon, Songkhla, Chiang Mai and Chon Buri. The demo covers dynamic tables, a shipment-rejection classifier evaluated on a time-based holdout, a shipment-issue forecast, document discrepancy rate anomaly detection, a Cortex Agent that cites SOPs, a live shipment feed with an alert, and an SPCS app.

## Why Snowflake

- **Dynamic tables** turn exporter-day rows into shipments, shipment issues, rejected shipments, late arrivals and pre-shipment lab test compliance; `run_core.py` reconciles them against RAW on every build
- **Shipment-rejection classification** gives each exporter a next-7-day probability, evaluated on a time-based holdout
- **Shipment-issue forecast** projects 14 days of shipment issues across all exporters with prediction intervals, to plan export quality desk cover
- **Grounded AI**: the Cortex Agent (Analyst over a semantic view, Search over SOPs) shows the SQL it ran and the SOPs it cited
- **Live shipments**: a native simulator (Snowflake only) or Firehose, S3 and Snowpipe (AWS build), feeding an alert and email

## What is built

| | |
|---|---|
| Dimension table | `RAW.EXPORTERS` (40 rows) |
| Fact table | `RAW.EXPORTER_DAILY` (3,600 exporter-days, 90 days) |
| Curated layer | `CURATED.KPI_SUMMARY`, `PERFORMANCE_SUMMARY`, `ISSUE_SUMMARY`, `TREND_ANALYSIS` |
| ML | `ML.REJECT_RISK_SCORES`, `ML.REJECT_RISK_HOLDOUT_METRICS`, `ML.ISSUE_FORECAST`, `ML.DOC_DISCREPANCY_ANOMALIES` |

Currency: THB. Cities: Bangkok, Samut Sakhon, Songkhla, Chiang Mai, Chon Buri.
Product lines: Frozen shrimp, Canned tuna, Jasmine rice, Fresh durian, Cooked chicken.

## KPI cards (live from `CURATED.KPI_SUMMARY`; no fallback values)

| Card | Value from the seeded data |
|---|---|
| Clean Shipment Rate | 96.02% |
| Shipment Issues Raised | 648 |
| Rejected Shipments | 186 |
| Issue Rejection Rate | 28.7% |
| Late Arrivals | 74 |
| Shipment Value (THB M) | 32,483 |
| Shipments Dispatched | 16,277 |
| Lab Test Compliance | 72.1% |
| Exporters Monitored | 40 |
| Compliance Document Coverage | 61.8% |
| Compliance Documents Pending | 18 |

Values are synthetic. The data is HASH-seeded, so a rebuild reproduces them; dates are relative to the build day.

## Demo flow

1. Executive Cockpit: KPI cards, daily shipment issues against rejected shipments, issues and rejections by issue type, and the exporter table
2. Predictive: holdout metrics, risk bands, the 14-day shipment-issue forecast and document discrepancy rate anomalies
3. Controls: lab test compliance, exporter document coverage and pending documents, lab test compliance against rejected shipments, then the action memo
4. Live Shipments: run `CALL APP.SIMULATE_SHIPMENTS(20)` (Snowflake only) or `python aws/publish_shipments.py --count 20` (AWS build), then `EXECUTE ALERT APP.LIVE_SHIPMENT_ALERT`, and show the alert log and email
5. Ask AI: the Cortex Agent answers metric questions through the semantic view, cites SOPs from Cortex Search and shows its SQL
6. QuickSight (AWS build): the same Snowflake tables through DIRECT_QUERY
7. Architecture: both builds side by side

## Talking points

- 96.02% of export shipments go through without an issue. The 648 shipment issues are where the export quality desks spend their time, and more than one in four (28.7%) ends as a shipment rejected at the destination.
- Health certificate mismatches cause the most rejected shipments (53 of 188 issues). The monsoon flood transport disruptions in Songkhla and Samut Sakhon hit every exporter in the city on one day and were all resolved.
- Samut Sakhon exporters have the most rejected shipments (58); Chon Buri has the fewest (16).
- On a time-based holdout the risk model reaches precision 0.42 and recall 0.37 at 0.5, against a 0.24 base rate. Use it to decide which exporter gets a quality review first, not as a verdict on an exporter.
- Monsoon flood transport disruptions are left out of model training because the exporter did not cause them.

## Business impact

Use only the sourced references in `README.md` (Business Impact).
