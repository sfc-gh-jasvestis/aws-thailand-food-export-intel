-- ============================================================================
-- 08_AGENT.SQL — Cortex Agent for Export Market Intelligence
-- ============================================================================
USE DATABASE EXPORT_INTELLIGENCE;
USE SCHEMA APP;

CREATE OR REPLACE CORTEX AGENT APP.EXPORT_INTEL_AGENT
  COMMENT = 'Export Market Intelligence AI Assistant'
  MODEL = 'claude-opus-4-8'
  TOOLS = (
    SEMANTIC_VIEW_TOOL(SEMANTIC_VIEW => 'EXPORT_INTELLIGENCE.APP.EXPORT_ANALYTICS'),    CORTEX_SEARCH_TOOL(CORTEX_SEARCH_SERVICE => 'EXPORT_INTELLIGENCE.SEARCH.TRADE_REGULATION_SEARCH', TOOL_DESCRIPTION => 'Search documents for Food & Agribusiness information')
  )
  SYSTEM_PROMPT = 'You are the Export Market Intelligence Agent for Thai food companies, analyzing trade opportunities across 50+ destination markets.';
