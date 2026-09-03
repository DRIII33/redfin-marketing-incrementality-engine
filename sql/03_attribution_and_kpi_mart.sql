-- ==============================================================================
-- Script: 03_attribution_and_kpi_mart.sql
-- Project ID: driiiportfolio
-- Dataset: redfin_marketing
-- Purpose: Construct Last-Touch Attribution Models, Incremental Lift Calculations,
--          and Executive KPI Data Mart for Looker Studio Ingestion.
-- ==============================================================================

CREATE OR REPLACE TABLE `driiiportfolio.redfin_marketing.mart_attribution_kpis` AS
WITH User_Conversions AS (
  SELECT
    conversion_id,
    user_pseudo_id,
    conversion_timestamp,
    conversion_type,
    CAST(monetary_value AS NUMERIC) AS monetary_value
  FROM `driiiportfolio.redfin_marketing.fact_conversions`
),
Attributed_Touchpoints AS (
  SELECT
    c.conversion_id,
    c.user_pseudo_id,
    c.conversion_type,
    c.monetary_value,
    c.conversion_timestamp,
    t.touchpoint_id,
    t.campaign_id,
    t.touchpoint_timestamp,
    t.cost,
    -- Rank touchpoints prior to conversion for attribution assignment
    ROW_NUMBER() OVER (
      PARTITION BY c.conversion_id 
      ORDER BY t.touchpoint_timestamp DESC
    ) AS last_touch_rank
  FROM User_Conversions c
  INNER JOIN `driiiportfolio.redfin_marketing.stg_cleaned_touchpoints` t
    ON c.user_pseudo_id = t.user_pseudo_id
    AND t.touchpoint_timestamp <= c.conversion_timestamp
),
Base_Attribution_Mart AS (
  SELECT
    attr.campaign_id,
    cmp.campaign_name,
    cmp.channel,
    cmp.target_market,
    COUNT(DISTINCT attr.conversion_id) AS total_last_touch_conversions,
    SUM(attr.monetary_value) AS total_attributed_value,
    SUM(attr.cost) AS total_channel_cost,
    -- Calculate Last-Touch CPA and ROAS safely
    SAFE_DIVIDE(SUM(attr.cost), COUNT(DISTINCT attr.conversion_id)) AS last_touch_cpa,
    SAFE_DIVIDE(SUM(attr.monetary_value), SUM(attr.cost)) AS last_touch_roas
  FROM Attributed_Touchpoints AS attr
  LEFT JOIN `driiiportfolio.redfin_marketing.dim_campaigns` cmp
    ON attr.campaign_id = cmp.campaign_id
  WHERE attr.last_touch_rank = 1
  GROUP BY 1, 2, 3, 4
)
SELECT
  campaign_id,
  campaign_name,
  channel,
  target_market,
  total_last_touch_conversions,
  total_attributed_value,
  total_channel_cost,
  last_touch_cpa,
  last_touch_roas,
  
  -- 1. True Incremental Conversions (Applying Channel-Specific Calibration Factors)
  CAST(
    ROUND(
      total_last_touch_conversions * CASE 
        WHEN channel = 'Paid Search' THEN 0.62 
        WHEN channel = 'Paid Social' THEN 0.88 
        WHEN channel = 'Display' THEN 0.45 
        WHEN channel = 'Partner Referral' THEN 0.91 
        ELSE 1.00 
      END
    ) AS INT64
  ) AS true_incremental_conv,

  -- 2. Causal Incremental CPA (Safe handling for zero-cost organic/direct channels)
  SAFE_DIVIDE(
    total_channel_cost, 
    (total_last_touch_conversions * CASE 
      WHEN channel = 'Paid Search' THEN 0.62 
      WHEN channel = 'Paid Social' THEN 0.88 
      WHEN channel = 'Display' THEN 0.45 
      WHEN channel = 'Partner Referral' THEN 0.91 
      ELSE 1.00 
    END)
  ) AS true_incremental_cpa,

  -- 3. True Incremental Lift Ratio
  CASE 
    WHEN channel = 'Paid Search' THEN 0.62 
    WHEN channel = 'Paid Social' THEN 0.88 
    WHEN channel = 'Display' THEN 0.45 
    WHEN channel = 'Partner Referral' THEN 0.91 
    ELSE 1.00 
  END AS true_incremental_lift_ratio,

  -- 4. Automated Reallocation Recommendation (Calibrated to realistic channel CPAs)
  CASE
    WHEN SAFE_DIVIDE(total_channel_cost, (total_last_touch_conversions * CASE WHEN channel = 'Paid Search' THEN 0.62 WHEN channel = 'Paid Social' THEN 0.88 WHEN channel = 'Display' THEN 0.45 WHEN channel = 'Partner Referral' THEN 0.91 ELSE 1.00 END)) < 3.00 
         AND CASE WHEN channel = 'Paid Search' THEN 0.62 WHEN channel = 'Paid Social' THEN 0.88 WHEN channel = 'Display' THEN 0.45 WHEN channel = 'Partner Referral' THEN 0.91 ELSE 1.00 END >= 0.80
      THEN 'Scale Spend: High Incrementality & Low CPA'
    WHEN SAFE_DIVIDE(total_channel_cost, (total_last_touch_conversions * CASE WHEN channel = 'Paid Search' THEN 0.62 WHEN channel = 'Paid Social' THEN 0.88 WHEN channel = 'Display' THEN 0.45 WHEN channel = 'Partner Referral' THEN 0.91 ELSE 1.00 END)) BETWEEN 3.00 AND 10.00 
         AND CASE WHEN channel = 'Paid Search' THEN 0.62 WHEN channel = 'Paid Social' THEN 0.88 WHEN channel = 'Display' THEN 0.45 WHEN channel = 'Partner Referral' THEN 0.91 ELSE 1.00 END >= 0.60
      THEN 'Maintain Budget: Moderate Efficiency'
    WHEN SAFE_DIVIDE(total_channel_cost, (total_last_touch_conversions * CASE WHEN channel = 'Paid Search' THEN 0.62 WHEN channel = 'Paid Social' THEN 0.88 WHEN channel = 'Display' THEN 0.45 WHEN channel = 'Partner Referral' THEN 0.91 ELSE 1.00 END)) > 10.00 
         OR CASE WHEN channel = 'Paid Search' THEN 0.62 WHEN channel = 'Paid Social' THEN 0.88 WHEN channel = 'Display' THEN 0.45 WHEN channel = 'Partner Referral' THEN 0.91 ELSE 1.00 END < 0.50
      THEN 'Reduce / Reallocate: High Cannibalization'
    ELSE 'Evaluate Further'
  END AS reallocation_recommendation

FROM Base_Attribution_Mart;
