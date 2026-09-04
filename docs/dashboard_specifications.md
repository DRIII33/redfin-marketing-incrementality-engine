# Looker Studio Dashboard Specifications & Configuration Guide

## Data Source Connection
- **GCP Project ID**: `driiiportfolio`
- **Dataset**: `redfin_marketing`
- **Table**: `mart_attribution_kpis`

---

## Visual Elements & Configuration

### PAGE 1: EXECUTIVE SUMMARY & CHANNEL EFFICIENCY

#### 1. Header KPI Scorecards
- **Total Spend**: `SUM(total_channel_cost)` | Currency (`$ USD`)
- **Last-Touch Conversions**: `SUM(total_last_touch_conversions)` | Numeric (`Integer #`)
- **True Incremental Conversions**: `SUM(true_incremental_conv)` | Numeric (`Decimal #.##`)
- **Blended Last-Touch CPA**: `SUM(total_channel_cost) / SUM(total_last_touch_conversions)` | Currency (`$ USD`)
- **Blended Incremental CPA**: `SUM(total_channel_cost) / SUM(true_incremental_conv)` | Currency (`$ USD`)

#### 2. Conversion Volume Comparison Chart
- **Visual Type**: Clustered Bar Chart
- **Dimension**: `channel` (Text)
- **Metrics**: `SUM(total_last_touch_conversions)` (Integer `#`), `SUM(true_incremental_conv)` (Decimal `#.##`)

#### 3. Acquisition Cost Shift Chart
- **Visual Type**: Horizontal Bar Chart
- **Dimension**: `channel` (Text)
- **Metrics**: `AVG(last_touch_cpa)` (Currency `$`), `AVG(true_incremental_cpa)` (Currency `$`)

---

### PAGE 2: CAMPAIGN LEVEL PERFORMANCE & BUDGET OPTIMIZATION

#### 1. Campaign Efficiency & Reallocation Matrix
- **Visual Type**: Table with Heatmap
- **Dimensions**: `campaign_name` (Text), `channel` (Text)
- **Calculated Dimension Attribute**: `reallocation_recommendation` (Text)
- **Metrics**: 
  - `total_channel_cost` | Currency (`$ USD`)
  - `total_last_touch_conversions` | Numeric (`Integer #`)
  - `true_incremental_conv` | Numeric (`Decimal #.##`)
  - `last_touch_cpa` | Currency (`$ USD`)
  - `true_incremental_cpa` | Currency (`$ USD`)

#### 2. Causal Lift Ratio vs. Incremental CPA Scatter Plot
- **Visual Type**: Scatter Plot
- **Dimension**: `campaign_name` (Text)
- **Metric X (Horizontal Axis)**: `SUM(true_incremental_conv) / SUM(total_last_touch_conversions)` | Percent (`%`)
- **Metric Y (Vertical Axis)**: `true_incremental_cpa` | Currency (`$ USD`)
- **Size Metric**: `total_channel_cost` | Currency (`$ USD`)

#### 3. Spend by Recommendation Donut Chart
- **Visual Type**: Donut Chart
- **Dimension Calculated Field (`reallocation_recommendation`)**:
```sql
CASE
  WHEN channel IN ('Organic Search', 'Direct') THEN 'Scale Spend'
  WHEN true_incremental_cpa > 10.0 THEN 'Reduce / Reallocate'
  WHEN (true_incremental_conv / total_last_touch_conversions) < 0.60 THEN 'Reduce / Reallocate'
  ELSE 'Maintain Budget'
END
