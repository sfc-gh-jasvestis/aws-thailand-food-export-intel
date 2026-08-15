-- ============================================================================
-- 04_DYNAMIC_TABLES.SQL — Curated layer for Export Market Intelligence
-- ============================================================================
USE DATABASE EXPORT_INTELLIGENCE;
USE SCHEMA CURATED;

-- MARKET_OPPORTUNITY_SCORES: Market attractiveness scoring by product × destination
-- Source: EXPORT_TRANSACTIONS, TARIFF_DATABASE, COMPETITOR_EXPORTS
CREATE OR REPLACE DYNAMIC TABLE CURATED.MARKET_OPPORTUNITY_SCORES
  TARGET_LAG = '5 minutes'
  WAREHOUSE = EXPORT_WH
AS
SELECT * FROM RAW.EXPORT_TRANSACTIONS;
-- TODO: Replace with actual join/aggregation logic per demo

-- EXPORT_TRENDS: Export volume and value trends by market for forecasting
-- Source: EXPORT_TRANSACTIONS
CREATE OR REPLACE DYNAMIC TABLE CURATED.EXPORT_TRENDS
  TARGET_LAG = '5 minutes'
  WAREHOUSE = EXPORT_WH
AS
SELECT * FROM RAW.EXPORT_TRANSACTIONS;
-- TODO: Replace with actual join/aggregation logic per demo

-- TRADE_BARRIER_TRACKER: New and changed trade barriers affecting Thai food exports
-- Source: TRADE_SIGNALS, MARKET_REGULATIONS
CREATE OR REPLACE DYNAMIC TABLE CURATED.TRADE_BARRIER_TRACKER
  TARGET_LAG = '5 minutes'
  WAREHOUSE = EXPORT_WH
AS
SELECT * FROM RAW.TRADE_SIGNALS;
-- TODO: Replace with actual join/aggregation logic per demo

-- COMPETITIVE_POSITION: Thailand market share vs competitors by product and market
-- Source: EXPORT_TRANSACTIONS, COMPETITOR_EXPORTS
CREATE OR REPLACE DYNAMIC TABLE CURATED.COMPETITIVE_POSITION
  TARGET_LAG = '5 minutes'
  WAREHOUSE = EXPORT_WH
AS
SELECT * FROM RAW.EXPORT_TRANSACTIONS;
-- TODO: Replace with actual join/aggregation logic per demo

