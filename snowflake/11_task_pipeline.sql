-- ============================================================================
-- 11_TASK_PIPELINE.SQL — Task DAG for Export Market Intelligence
-- ============================================================================
USE DATABASE EXPORT_INTELLIGENCE;
USE SCHEMA APP;

CREATE OR REPLACE TASK APP.TASK_EXTRACT_SIGNALS
  WAREHOUSE = EXPORT_WH
  SCHEDULE = 'USING CRON 0 */6 * * * UTC'
  COMMENT = 'Extract trade signals from new content via AI_EXTRACT + AI_CLASSIFY'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_UPDATE_OPPORTUNITIES
  WAREHOUSE = EXPORT_WH
  AFTER APP.TASK_EXTRACT_SIGNALS
  COMMENT = 'Recalculate market opportunity scores'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_GENERATE_BRIEFS
  WAREHOUSE = EXPORT_WH
  SCHEDULE = 'USING CRON 0 6 * * 1 UTC'
  COMMENT = 'Generate weekly market intelligence briefs'
AS
  SELECT 1; -- Replace with actual refresh logic

ALTER TASK APP.TASK_GENERATE_BRIEFS RESUME;
ALTER TASK APP.TASK_UPDATE_OPPORTUNITIES RESUME;
ALTER TASK APP.TASK_EXTRACT_SIGNALS RESUME;
