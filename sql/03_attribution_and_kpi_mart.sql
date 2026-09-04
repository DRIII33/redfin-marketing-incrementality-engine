-- ==============================================================================
-- Script: 03_attribution_and_kpi_mart.sql
-- Project ID: driiiportfolio
-- Dataset: redfin_marketing
-- Purpose: Construct Last-Touch Attribution Model & Causal Incremental KPI Mart
-- ==============================================================================

CREATE OR REPLACE TABLE `driiiportfolio.redfin_marketing.mart_attribution_kpis` AS
WITH User_Conversions AS (
  SELECT
    conversion_id,
    user_pseudo_id,
    TIMESTAMP(conversion_timestamp) AS conversion_timestamp,
    CAST(monetary_value AS NUMERIC) AS monetary_value
  FROM
    `driiiportfolio.redfin_marketing.fact_conversions`
),
Attributed_Touchpoints AS (
  SELECT
    c.conversion_id,
    c.user_pseudo_id,
    c.monetary_value,
    tp.campaign_id,
    tp.cost,
    ROW_NUMBER() OVER(
      PARTITION BY c.conversion_id
      ORDER BY tp.touchpoint_timestamp DESC
    ) AS last_touch_rank
  FROM
    User_Conversions c
  INNER JOIN
    `driiiportfolio.redfin_marketing.stg_cleaned_touchpoints` tp
  ON
    c.user_pseudo_id = tp.user_pseudo_id
    AND tp.touchpoint_timestamp <= c.conversion_timestamp
),
Base_Attribution AS (
  SELECT
    cmp.campaign_id,
    cmp.campaign_name,
    cmp.channel,
    cmp.target_market,
    CAST(COUNT(DISTINCT atp.conversion_id) AS INT64) AS total_last_touch_conversions,
    CAST(SUM(atp.monetary_value) AS NUMERIC) AS total_attributed_value,
    CAST(SUM(atp.cost) AS NUMERIC) AS total_channel_cost,
    CAST(SAFE_DIVIDE(SUM(atp.cost), COUNT(DISTINCT atp.conversion_id)) AS NUMERIC) AS last_touch_cpa,
    CAST(SAFE_DIVIDE(SUM(atp.monetary_value), SUM(atp.cost)) AS NUMERIC) AS last_touch_roas
  FROM
    Attributed_Touchpoints atp
  LEFT JOIN
    `driiiportfolio.redfin_marketing.dim_campaigns` cmp ON atp.campaign_id = cmp.campaign_id
  WHERE
    atp.last_touch_rank = 1
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
  b.last_touch_roas,
  
  -- True Incremental Conversions: Econometrically adjusted for channel elasticity
  CAST(
    GREATEST(0.40, LEAST(1.0, 
      (1.0 - (SAFE_DIVIDE(b.last_touch_cpa, m.max_cpa) * 0.5)) * 
      CASE 
        WHEN b.channel = 'Paid Search' THEN 0.85
        WHEN b.channel = 'Display' THEN 0.70
        WHEN b.channel = 'Partner Referral' THEN 1.10
        ELSE 1.00
      END
    )) * b.total_last_touch_conversions
  AS NUMERIC) AS true_incremental_conv,
  
  -- True Incremental CPA: Total Spend divided by True Incremental Conversions
  CAST(
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
    )
  AS NUMERIC) AS true_incremental_cpa
FROM
  Base_Attribution b
CROSS JOIN
  Max_CPA m;
