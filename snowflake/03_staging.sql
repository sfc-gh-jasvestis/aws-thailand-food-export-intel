-- ============================================================================
-- 03_STAGING.SQL — Generate synthetic data for Export Market Intelligence
-- Country: THAILAND | Currency: THB
-- ============================================================================
USE DATABASE EXPORT_INTELLIGENCE;
USE SCHEMA RAW;

-- Data generation scripts are demo-specific.
-- See the handcrafted SQL in the aws-malaysia-semiconductor-yield demo for
-- the full pattern: GENERATOR + UNIFORM + LATERAL for distribution,
-- Cortex Complete for text generation, engineered key demo numbers.

-- Target row counts:
-- EXPORT_TRANSACTIONS: 350,000 rows — Thai food export records by product, destination, and value
-- TRADE_SIGNALS: 80,000 rows — Trade news, regulatory updates, and market reports (unstructured)
-- TARIFF_DATABASE: 25,000 rows — Import tariff rates by HS code and destination market
-- COMPETITOR_EXPORTS: 200,000 rows — Competitor country export data (Vietnam, India, Indonesia)
-- MARKET_REGULATIONS: 500 rows — Import regulations, SPS measures, labeling requirements by market
-- BUYER_CONTACTS: 3,000 rows — International buyer database with trade history
-- FTA_AGREEMENTS: 45 rows — Free trade agreements and preferential access terms
-- THAI_EXPORT_CONTEXT: 10 rows — Thailand food export industry overview
