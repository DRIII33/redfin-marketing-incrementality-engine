-- ==============================================================================
-- Script: 01_schema_setup.sql
-- Project ID: driiiportfolio
-- Dataset: redfin_marketing
-- Purpose: Schema verification and table constraint setup
-- ==============================================================================

CREATE SCHEMA IF NOT EXISTS `driiiportfolio.redfin_marketing`
OPTIONS(location="US");

-- Validate raw data ingestion counts
SELECT 'dim_campaigns' AS table_name, COUNT(*) AS record_count FROM `driiiportfolio.redfin_marketing.dim_campaigns`
UNION ALL
SELECT 'fact_marketing_touchpoints', COUNT(*) FROM `driiiportfolio.redfin_marketing.fact_marketing_touchpoints`
UNION ALL
SELECT 'fact_conversions', COUNT(*) FROM `driiiportfolio.redfin_marketing.fact_conversions`;
