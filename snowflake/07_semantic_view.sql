-- ============================================================================
-- 07_SEMANTIC_VIEW.SQL — Semantic View for Export Market Intelligence
-- ============================================================================
USE DATABASE EXPORT_INTELLIGENCE;
USE SCHEMA APP;

CREATE OR REPLACE SEMANTIC VIEW APP.EXPORT_ANALYTICS
  COMMENT = 'Export market intelligence, trade flow analysis, and opportunity scoring'
AS
  TABLES (
    CURATED.MARKET_OPPORTUNITY_SCORES AS market_opportunity_scores,CURATED.EXPORT_TRENDS AS export_trends,CURATED.TRADE_BARRIER_TRACKER AS trade_barrier_tracker,CURATED.COMPETITIVE_POSITION AS competitive_position
  );
