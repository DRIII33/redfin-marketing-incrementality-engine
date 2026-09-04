-- ==============================================================================
-- Script: 02_data_cleaning_transformations.sql
-- Purpose: Deduplicate touchpoints, format timestamps, build staging tables
-- ==============================================================================

CREATE OR REPLACE TABLE `driiiportfolio.redfin_marketing.stg_cleaned_touchpoints` AS
WITH Deduplicated_Touchpoints AS (
  SELECT
    touchpoint_id,
    user_pseudo_id,
    campaign_id,
    TIMESTAMP(timestamp) AS touchpoint_timestamp,
    LOWER(device_category) AS device_category,
    CAST(cost AS NUMERIC) AS cost,
    ROW_NUMBER() OVER(
      PARTITION BY touchpoint_id
      ORDER BY TIMESTAMP(timestamp) ASC
    ) AS dup_rank
  FROM
    `driiiportfolio.redfin_marketing.fact_marketing_touchpoints`
)
SELECT
  touchpoint_id,
  user_pseudo_id,
  campaign_id,
  touchpoint_timestamp,
  device_category,
  cost
FROM
  Deduplicated_Touchpoints
WHERE
  dup_rank = 1;
