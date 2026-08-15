-- ============================================================================
-- Export Market Intelligence
-- AI-powered export market intelligence for Thai food companies — Comprehend extracts trade signals, AI_CLASSIFY categorizes market opportunities, and Cortex Complete generates actionable export briefs for 50+ destination markets.
-- ============================================================================
USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS EXPORT_INTELLIGENCE;
CREATE WAREHOUSE IF NOT EXISTS EXPORT_WH WAREHOUSE_SIZE = 'MEDIUM' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE;
USE DATABASE EXPORT_INTELLIGENCE;
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS CURATED;
CREATE SCHEMA IF NOT EXISTS ML;
CREATE SCHEMA IF NOT EXISTS AI;
CREATE SCHEMA IF NOT EXISTS SEARCH;
CREATE SCHEMA IF NOT EXISTS APP;

USE WAREHOUSE EXPORT_WH;
