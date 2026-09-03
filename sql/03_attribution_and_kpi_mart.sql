-- ==============================================================================
-- Script: 03_attribution_and_kpi_mart.sql
-- Purpose: Construct Last-Touch Attribution Models & Channel KPI Mart
-- ==============================================================================

CREATE OR REPLACE TABLE `driiiportfolio.redfin_marketing.mart_attribution_kpis`
AS
WITH
  User_Conversions AS (
    SELECT
      conversion_id,
      user_pseudo_id,
      -- Column is already TIMESTAMP type based on table metadata
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
      -- Column is already TIMESTAMP type based on table metadata
      t.touchpoint_timestamp,
      t.cost,
      -- Rank touchpoints prior to conversion for attribution assignment
      ROW_NUMBER()
        OVER (PARTITION BY c.conversion_id ORDER BY t.touchpoint_timestamp DESC)
        AS last_touch_rank
    FROM User_Conversions c
    INNER JOIN `driiiportfolio.redfin_marketing.stg_cleaned_touchpoints` t
      ON
        c.user_pseudo_id = t.user_pseudo_id
        AND t.touchpoint_timestamp <= c.conversion_timestamp
  )
SELECT
  attr.campaign_id,
  cmp.campaign_name,
  cmp.channel,
  cmp.target_market,
  COUNT(DISTINCT attr.conversion_id) AS total_last_touch_conversions,
  SUM(attr.monetary_value) AS total_attributed_value,
  SUM(attr.cost) AS total_channel_cost,
  -- Calculate CPA and Last-Touch ROAS
  SAFE_DIVIDE(SUM(attr.cost), COUNT(DISTINCT attr.conversion_id))
    AS last_touch_cpa,
  SAFE_DIVIDE(SUM(attr.monetary_value), SUM(attr.cost)) AS last_touch_roas
FROM Attributed_Touchpoints AS attr
LEFT JOIN `driiiportfolio.redfin_marketing.dim_campaigns` cmp
  ON attr.campaign_id = cmp.campaign_id
WHERE attr.last_touch_rank = 1
GROUP BY 1, 2, 3, 4;

