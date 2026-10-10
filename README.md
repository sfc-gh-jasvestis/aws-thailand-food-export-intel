# Thailand Food Export Quality - Shipment Rejection Risk

Export shipment monitoring for **40 fictional Thai food exporters**, each one export plant shipping one of five product lines (frozen shrimp, canned tuna, jasmine rice, fresh durian, cooked chicken) from five real Thai cities used as regions (Bangkok, Samut Sakhon, Songkhla, Chiang Mai, Chon Buri). Snowflake, optionally with AWS, takes the export quality team from a live shipment issue to a 7-day destination-rejection risk score per exporter, an alert email and an AI action memo.

## Architecture

The pipeline runs on **Snowflake** (Dynamic Tables, Snowflake ML, Cortex Search, Cortex Agent, Cortex AI_COMPLETE, SPCS) and, in the full build, also uses **AWS** (Amazon Data Firehose, S3, Bedrock Claude, QuickSight + Amazon Q). Shipment events arrive in `RAW.LIVE_SHIPMENTS`. Dynamic tables roll 90 days of exporter-day rows into export shipments, shipment value in THB, shipment issues, shipments rejected at the destination, late arrivals, clean shipment rate and pre-shipment lab test compliance. Snowflake ML predicts which exporters are likely to have a rejected shipment in the next 7 days, forecasts shipment issues across all exporters and flags unusual document discrepancy rates. A Cortex Agent answers with SQL and SOP citations, and an LLM drafts the export quality team's action memo.

Interactive diagrams (hover for object names): [Snowflake only](docs/architecture-snowflake.html) | [AWS + Snowflake](docs/architecture-aws.html). The app's Architecture & Data tab shows both, the current build first. Regenerate them with `python3 docs/build_architecture.py aws snowflake`.

```mermaid
flowchart LR
    subgraph AWS
      SIM[publish_shipments.py] --> FH[Amazon Data Firehose<br/>stream th-food-export-intel-shipments]
      FH -->|batched JSON| S3[(Amazon S3<br/>shipments/ landing)]
      BR[Amazon Bedrock<br/>Claude Sonnet 4.5]
      QS[Amazon QuickSight<br/>dashboard + Q topic]
    end
    subgraph Snowflake
      S3 -->|SQS event| PIPE[Snowpipe AUTO_INGEST] --> LIVE[RAW.LIVE_SHIPMENTS]
      GEN[02_raw_tables.sql<br/>seeded generator] --> RAW[RAW.EXPORTERS / EXPORTER_DAILY / COMPLIANCE_DOCUMENTS]
      RAW --> DT[CURATED dynamic tables]
      RAW --> ML[Snowflake ML<br/>CLASSIFICATION risk, FORECAST,<br/>ANOMALY_DETECTION]
      DT --> SV[Semantic view<br/>APP.FOOD_EXPORT_ANALYTICS]
      RAW --> CS[Cortex Search<br/>shipment-issue SOPs]
      SV --> AG[Cortex Agent<br/>APP.FOOD_EXPORT_AGENT]
      CS --> AG
      LIVE --> AL[Alert APP.LIVE_SHIPMENT_ALERT<br/>+ email]
      UDF[APP.BEDROCK_GENERATE<br/>external access UDF]
      TK[Task graph: refresh, then rescore]
      APP[Next.js app on SPCS]
    end
    BR <--> UDF
    DT --> APP
    ML --> APP
    LIVE --> APP
    AG --> APP
    UDF --> APP
    DT --> QS
    ML --> QS
    LIVE --> QS
```

In the Snowflake-only build there is no AWS subgraph: `APP.SIMULATE_SHIPMENTS` writes to `RAW.LIVE_SHIPMENTS`, and the app calls Cortex `AI_COMPLETE` in place of the Bedrock UDF.

## Snowflake Capabilities

| Capability | Implementation |
|-----------|---------------|
| Dynamic Tables | `CURATED.KPI_SUMMARY`, `PERFORMANCE_SUMMARY`, `ISSUE_SUMMARY`, `TREND_ANALYSIS`, built from the RAW tables |
| Snowflake ML | CLASSIFICATION of 7-day shipment-rejection risk (`ML.REJECT_RISK_SCORES`), a 14-day shipment-issue FORECAST, and document discrepancy rate ANOMALY_DETECTION |
| Cortex Search | 13 synthetic shipment-issue SOPs (one per product line and issue type with a rejection) in `SEARCH.ISSUE_SOP_SEARCH` |
| Semantic View | `APP.FOOD_EXPORT_ANALYTICS` over exporters, issue types, daily totals and risk |
| Cortex Agent | `APP.FOOD_EXPORT_AGENT`: Cortex Analyst over the semantic view, plus Cortex Search for SOP citations |
| Cortex AI | `AI_COMPLETE('claude-sonnet-4-5')` for grounded answers, and for the action memo in the Snowflake-only build |
| Alerts + Tasks | `APP.LIVE_SHIPMENT_ALERT` logs ISSUE events and sends email; task graph `TASK_REFRESH_CURATED`, then `TASK_RESCORE_RISK` |
| Snowpark Container Services | Next.js app `APP.TH_FOOD_EXPORT_INTEL_APP` with 6 tabs: Executive Cockpit, Predictive, Controls, Live Shipments, Ask AI, Architecture & Data |
| Snowpipe | `RAW.LIVE_SHIPMENTS_PIPE` AUTO_INGEST from S3 (AWS build only) |

## AWS Services

These run only in the AWS + Snowflake build.

| Service | Role in Demo |
|---------|-------------|
| Amazon Data Firehose | Direct PUT stream `th-food-export-intel-shipments` takes simulated shipment events and writes them to S3 in batches |
| Amazon S3 | Landing bucket (`shipments/`); an event notification goes to the Snowpipe SQS queue |
| Amazon Bedrock | Claude Sonnet 4.5 drafts the action memo, called from Snowflake through an external-access UDF |
| Amazon QuickSight | DIRECT_QUERY export quality dashboard over Snowflake (daily shipment issues, rejected shipments by exporter, shipment-rejection risk) |
| Amazon Q | Natural-language questions over the QuickSight topic `th-food-export-intel-topic` |
| AWS IAM | Least-privilege roles for S3, Firehose and Bedrock |

## Personas

Both personas are fictional.

| Persona | Role | Key Questions |
|---------|------|---------------|
| **Siriporn Chaiyasit** | Head of Export Quality | "How many export shipments go through without an issue?" "Which issue types end in a rejected shipment most often?" |
| **Nattapong Srisuk** | Export Quality Analyst | "Which exporters need a quality review this week, and what does the SOP say to do?" |

## Data

Every table is synthetic and HASH-seeded, so a rebuild reproduces it. The exporters, buyers and all names are fictional; the five cities are real Thai cities used only as regions. No real company, border agency or regulation is described.

| Table | Rows | Description |
|-------|------|-------------|
| RAW.EXPORTERS | 40 | Exporters in 5 Thai cities and 5 product lines (Frozen shrimp, Canned tuna, Jasmine rice, Fresh durian, Cooked chicken), with an operating risk tier |
| RAW.EXPORTER_DAILY | 3,600 | One row per exporter per day for 90 days: shipments, shipment value (THB), shipment issues, shipments rejected at the destination, late arrivals, issue type, pre-shipment lab tests, document discrepancy rate and certificate turnaround time |
| RAW.COMPLIANCE_DOCUMENTS | 40 | Required, on-file and pending export certificates and records per exporter |
| SEARCH.ISSUE_DOCS | 13 | Synthetic shipment-issue SOPs indexed for Cortex Search |
| RAW.LIVE_SHIPMENTS | Grows during the demo | Live shipment events from Firehose (AWS build) or `APP.SIMULATE_SHIPMENTS` (Snowflake-only build) |
| ML.REJECT_RISK_SCORES | 40 | 7-day shipment-rejection probability and risk band per exporter |

## Build Instructions

### Prerequisites
- Snowflake account with ACCOUNTADMIN access, and Cortex AI enabled (AI_COMPLETE, Search, Agent).
- An X-Small warehouse with auto-suspend at or below 120 s, and an existing SPCS compute pool.
- Python 3.11+, `snowflake-connector-python`, Node.js 22+, Docker and the `snow` CLI.
- App image: run `snow spcs image-registry login`, then build and push `th-food-export-intel-app:v1` to the database's `APP.IMAGES` repository (see the header of `snowflake/07_deploy_app.sql`).
- AWS build only: `boto3`, AWS credentials for the target account (us-west-2) with Bedrock access, and QuickSight Enterprise.

### SPCS App
```
<DATABASE>.APP.TH_FOOD_EXPORT_INTEL_APP
```

### Tests
```bash
python -m pytest aws snowflake quicksight
```

For a local run, put `SNOWFLAKE_ACCOUNT`, `SNOWFLAKE_USER`, `SNOWFLAKE_DATABASE`, `SNOWFLAKE_WAREHOUSE`, `SNOWFLAKE_AUTHENTICATOR=PROGRAMMATIC_ACCESS_TOKEN`, `SNOWFLAKE_TOKEN` and `DEMO_PLATFORM` in the environment, then run `npm --prefix app run build && npm --prefix app start`.

## Build Modes

The two modes run on one shared core and differ in three layers. The `DEMO_PLATFORM` value in the app SPCS spec selects the memo provider and the Live Shipments copy.

| Layer | Snowflake Only | Full AWS + Snowflake |
|---|---|---|
| Live shipments | `CALL APP.SIMULATE_SHIPMENTS(n)` inserts simulated shipment events into `RAW.LIVE_SHIPMENTS`. This simulates a shipment feed; it is not Snowpipe Streaming | `aws/publish_shipments.py` to Amazon Data Firehose, then S3, SQS and Snowpipe AUTO_INGEST |
| Action memo | Cortex `AI_COMPLETE('claude-sonnet-4-5')` | Amazon Bedrock Claude Sonnet 4.5 through `APP.BEDROCK_GENERATE` |
| BI and natural-language questions | The SPCS app is the dashboard; questions go to the Cortex Agent | Also a QuickSight dashboard and an Amazon Q topic |
| App setting | `DEMO_PLATFORM: snowflake` | `DEMO_PLATFORM: aws` |

### Snowflake Only

```bash
# 1. Core data and dynamic tables (guarded: new isolated database only)
python snowflake/run_core.py --database THAILAND_FOOD_EXPORT_INTEL_SNOWFLAKE --warehouse <XS_WAREHOUSE> --connection <CONNECTION> --apply
# 2. Native shipment feed, ML, search, semantic view, agent, alert and task graph
python snowflake/run_intelligence.py --database THAILAND_FOOD_EXPORT_INTEL_SNOWFLAKE --platform snowflake --warehouse <XS_WAREHOUSE> --connection <CONNECTION> --alert-email you@example.com
# 3. App on SPCS with DEMO_PLATFORM=snowflake (push the image first)
python snowflake/run_intelligence.py --database THAILAND_FOOD_EXPORT_INTEL_SNOWFLAKE --platform snowflake --warehouse <XS_WAREHOUSE> --connection <CONNECTION> --alert-email you@example.com --files 07_deploy_app.sql --compute-pool <COMPUTE_POOL>
```

During the demo:
- Run `CALL APP.SIMULATE_SHIPMENTS(20)` to add live shipment events. For a continuous feed, run `ALTER TASK APP.TASK_SIMULATE_SHIPMENTS RESUME`, and `SUSPEND` it afterwards.
- Run `EXECUTE ALERT APP.LIVE_SHIPMENT_ALERT` to raise the alert email.
- Run `EXECUTE TASK APP.TASK_REFRESH_CURATED` to refresh the curated tables and rescore risk.

Afterwards, drop the database or run `ALTER SERVICE APP.TH_FOOD_EXPORT_INTEL_APP SUSPEND`.

### Full AWS + Snowflake

```bash
# 1. Core data and dynamic tables (guarded: new isolated database only)
python snowflake/run_core.py --database THAILAND_FOOD_EXPORT_INTEL_AWS --warehouse <XS_WAREHOUSE> --connection <CONNECTION> --apply
# 2. AWS ingestion and Bedrock (dry run first, then --apply)
python aws/setup_aws.py --database THAILAND_FOOD_EXPORT_INTEL_AWS --account <AWS_ACCOUNT_ID> --connection <CONNECTION> --apply
# 3. ML, search, semantic view, agent, alert and task graph
python snowflake/run_intelligence.py --database THAILAND_FOOD_EXPORT_INTEL_AWS --platform aws --warehouse <XS_WAREHOUSE> --connection <CONNECTION> --alert-email you@example.com
# 4. App on SPCS with DEMO_PLATFORM=aws (push the image first)
python snowflake/run_intelligence.py --database THAILAND_FOOD_EXPORT_INTEL_AWS --platform aws --warehouse <XS_WAREHOUSE> --connection <CONNECTION> --alert-email you@example.com --files 07_deploy_app.sql --compute-pool <COMPUTE_POOL>
# 5. QuickSight dashboard and Q topic (needs an existing Snowflake data source)
python quicksight/build_dashboards.py --database THAILAND_FOOD_EXPORT_INTEL_AWS --account <AWS_ACCOUNT_ID> --principal-arn <QUICKSIGHT_USER_ARN> --data-source-arn <DATA_SOURCE_ARN> --prefix th-food-export-intel --apply --update --with-topic
```

QuickSight objects must be shared with the QuickSight user who signs in (`--principal-arn`); otherwise the console shows nothing.

During the demo:
- Run `python aws/publish_shipments.py --count 20` to send live shipment events. Firehose buffers for up to 60 seconds before writing to S3.
- Run `EXECUTE ALERT APP.LIVE_SHIPMENT_ALERT` to raise the alert email.
- Run `EXECUTE TASK APP.TASK_REFRESH_CURATED` to refresh the curated tables and rescore risk.


When you are done, `python aws/teardown_aws.py --database THAILAND_FOOD_EXPORT_INTEL_AWS --account <AWS_ACCOUNT_ID> --connection <CONNECTION> --apply` deletes the AWS resources plus the account-level Bedrock external-access and S3 storage integrations. The email integration `TH_FOOD_EXPORT_INTEL_EMAIL_INT` stays, because the Snowflake-only build uses it too.

## Business Impact

Industry research and a Snowflake customer outcome:
- **Unsafe food carries a large economic cost**: "US$ 310 billion is lost each year in productivity and medical expenses resulting from unsafe food worldwide." -- [World Health Organization, Food safety fact sheet](https://www.who.int/news-room/fact-sheets/detail/food-safety)
- **Food safety failures reach trade**: "Foodborne diseases impede socioeconomic development by straining health-care systems and harming national economies, tourism, and trade." -- [World Health Organization, Food safety fact sheet](https://www.who.int/news-room/fact-sheets/detail/food-safety)
- **Penske Logistics** (Snowflake customer): "business analysts create BI reports with companywide data spanning five years in just 15 minutes" -- [Snowflake customer story: Penske](https://www.snowflake.com/en/customers/all-customers/case-study/penske/)

## Key Demo Numbers

All figures are synthetic and come from the seeded demo data. Forecast and anomaly figures can shift slightly with the build day.

- **40 exporters** in 5 Thai cities and 5 product lines, 3,600 exporter-days over 90 days: **16,277 export shipments** worth THB 32.48 B
- **Clean shipment rate 96.02%**: **648 shipment issues**, of which **186** ended as shipments rejected at the destination (issue rejection rate 28.7%), and **74 late arrivals**
- **Health certificate mismatch** causes the most rejected shipments (53 of 188 issues); the 16 monsoon flood transport disruption issues (Songkhla and Samut Sakhon) were all resolved without a rejection
- Exporters in **Samut Sakhon** have the most rejected shipments (58); Chon Buri has the fewest (16)
- **Shipment-rejection model**, out-of-time holdout: precision 0.42 and recall 0.37 at a 0.5 threshold, against a 0.24 base rate. 8 exporters are high risk; the top one, EXP-0009, scores 94.5%
- **14-day shipment-issue forecast** with prediction intervals; **35 of 640** recent exporter-days flagged as document discrepancy rate anomalies
- **Lab test compliance 72.1%**; export document coverage 61.8%, with 18 documents pending
- **13 SOPs** indexed in Cortex Search and cited by ID in agent answers

## License

Apache 2.0 — See [LICENSE](LICENSE) for details.

This is a personal demo project and is not an official Snowflake offering. It comes with no support or warranty. Industry metrics cited are from publicly available third-party research and Snowflake customer stories; they represent reported outcomes and are not guarantees of results.
