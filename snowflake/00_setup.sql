-- Generated from generator/demo_specs/aws-thailand-food-export-intel.json
-- Regenerate with: python3 generator/gen_repo_docs.py aws-thailand-food-export-intel
-- This is the schema that is actually deployed for THAILAND_FOOD_EXPORT_INTEL.

-- THAILAND_FOOD_EXPORT_INTEL  (Export Market Intelligence)
-- generated from generator/demo_specs/aws-thailand-food-export-intel.json - do not hand-edit
CREATE DATABASE IF NOT EXISTS THAILAND_FOOD_EXPORT_INTEL;
CREATE SCHEMA IF NOT EXISTS THAILAND_FOOD_EXPORT_INTEL.RAW;
CREATE SCHEMA IF NOT EXISTS THAILAND_FOOD_EXPORT_INTEL.CURATED;
CREATE SCHEMA IF NOT EXISTS THAILAND_FOOD_EXPORT_INTEL.APP;
USE DATABASE THAILAND_FOOD_EXPORT_INTEL;

-- 5 real regions; entity names carry their region so the two always agree
