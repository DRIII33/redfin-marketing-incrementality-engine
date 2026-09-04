-- ==============================================================================
-- Script: 03_attribution_and_kpi_mart.sql
-- Project ID: driiiportfolio
-- Dataset: redfin_marketing
-- Purpose: Construct Last-Touch Attribution Models, Incremental Lift Calculations,
--          and Executive KPI Data Mart for Looker Studio Ingestion.
-- ==============================================================================

CREATE OR REPLACE TABLE `driiiportfolio.redfin_marketing.mart_attribution_kpis` AS
WITH Base_Attribution AS (
  SELECT
    cmp.campaign_id,
    cmp.campaign_name,
    cmp.channel,
    cmp.target_market,
    COUNT(DISTINCT at.conversion_id) AS total_last_touch_conversions,
    SUM(at.monetary_value) AS total_attributed_value,
    SUM(at.cost) AS total_channel_cost,
    SAFE_DIVIDE(SUM(at.cost), COUNT(DISTINCT at.conversion_id)) AS last_touch_cpa
  FROM
    `driiiportfolio.redfin_marketing.stg_cleaned_touchpoints` at
  LEFT JOIN
    `driiiportfolio.redfin_marketing.dim_campaigns` cmp ON at.campaign_id = cmp.campaign_id
  WHERE
    at.last_touch_rank = 1
  GROUP BY
    1, 2, 3, 4
),
Max_CPA AS (
  SELECT MAX(last_touch_cpa) AS max_cpa FROM Base_Attribution
)
SELECT
  b.campaign_id,
  b.campaign_name,
  b.channel,
  b.target_market,
  b.total_last_touch_conversions,
  b.total_attributed_value,
  b.total_channel_cost,
  b.last_touch_cpa,
  -- Calculate dynamic factor in BigQuery warehouse
  GREATEST(0.40, LEAST(1.0, 
    (1.0 - (SAFE_DIVIDE(b.last_touch_cpa, m.max_cpa) * 0.5)) * 
    CASE 
      WHEN b.channel = 'Paid Search' THEN 0.85
      WHEN b.channel = 'Display' THEN 0.70
      WHEN b.channel = 'Partner Referral' THEN 1.10
      ELSE 1.00
    END
  )) * b.total_last_touch_conversions AS true_incremental_conv,
  
  SAFE_DIVIDE(
    b.total_channel_cost, 
    GREATEST(0.40, LEAST(1.0, 
      (1.0 - (SAFE_DIVIDE(b.last_touch_cpa, m.max_cpa) * 0.5)) * 
      CASE 
        WHEN b.channel = 'Paid Search' THEN 0.85
        WHEN b.channel = 'Display' THEN 0.70
        WHEN b.channel = 'Partner Referral' THEN 1.10
        ELSE 1.00
      END
    )) * b.total_last_touch_conversions
  ) AS true_incremental_cpa
FROM
  Base_Attribution b
CROSS JOIN
  Max_CPA m;
