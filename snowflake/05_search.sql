-- ============================================================================
-- 05_SEARCH.SQL — Cortex Search for Export Market Intelligence
-- ============================================================================
USE DATABASE EXPORT_INTELLIGENCE;
USE SCHEMA SEARCH;

CREATE OR REPLACE CORTEX SEARCH SERVICE SEARCH.TRADE_REGULATION_SEARCH
  ON REGULATION_TEXT
  ATTRIBUTES MARKET, PRODUCT_CATEGORY, REGULATION_TYPE
  WAREHOUSE = EXPORT_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT * FROM RAW.MARKET_REGULATIONS
);
