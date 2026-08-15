-- ============================================================================
-- 10_ALERTS_NOTIFICATIONS.SQL — Alerts for Export Market Intelligence
-- ============================================================================
USE DATABASE EXPORT_INTELLIGENCE;
USE SCHEMA APP;

-- Notification integration (email)
CREATE OR REPLACE NOTIFICATION INTEGRATION aws_thailand_food_export_intel_EMAIL_INT
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ('jonathan.asvestis@snowflake.com');

-- Alert: TRADE_BARRIER_ALERT
CREATE OR REPLACE ALERT APP.TRADE_BARRIER_ALERT
  WAREHOUSE = EXPORT_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'New trade barrier — assess impact on export operations'
IF (EXISTS (
  SELECT 1 FROM CURATED.MARKET_OPPORTUNITY_SCORES
  WHERE 1=1 -- Condition: New trade barrier detected affecting Thai food exports
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_thailand_food_export_intel_EMAIL_INT',
    'jonathan.asvestis@snowflake.com',
    '[ALERT] Export Market Intelligence: New trade barrier — assess impact on export operations',
    'New trade barrier — assess impact on export operations'
  );

ALTER ALERT APP.TRADE_BARRIER_ALERT RESUME;

-- Alert: MARKET_OPPORTUNITY_ALERT
CREATE OR REPLACE ALERT APP.MARKET_OPPORTUNITY_ALERT
  WAREHOUSE = EXPORT_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'High-potential export opportunity identified'
IF (EXISTS (
  SELECT 1 FROM CURATED.MARKET_OPPORTUNITY_SCORES
  WHERE 1=1 -- Condition: OPPORTUNITY_SCORE > 85 for any new market-product pair
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_thailand_food_export_intel_EMAIL_INT',
    'jonathan.asvestis@snowflake.com',
    '[ALERT] Export Market Intelligence: High-potential export opportunity identified',
    'High-potential export opportunity identified'
  );

ALTER ALERT APP.MARKET_OPPORTUNITY_ALERT RESUME;

