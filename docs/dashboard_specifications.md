# Looker Studio Dashboard Specifications & Configuration Guide

## Data Source Connection
- **GCP Project ID**: `driiiportfolio`
- **Dataset**: `redfin_marketing`
- **Table**: `mart_attribution_kpis`

---

## Visual Elements & Configuration

### 1. Header KPI Scorecards
- **Total Spend**: `SUM(total_channel_cost)` | Currency ($)
- **Last-Touch Conversions**: `SUM(total_last_touch_conversions)` | Number
- **True Incremental Conversions**: `SUM(true_incremental_conv)` | Number
- **Blended Last-Touch CPA**: `SUM(total_channel_cost) / SUM(total_last_touch_conversions)` | Currency ($)
- **Blended Incremental CPA**: `SUM(total_channel_cost) / SUM(true_incremental_conv)` | Currency ($)

### 2. Conversion Volume Comparison Chart
- **Visual Type**: Clustered Bar Chart
- **Dimension**: `channel`
- **Metrics**: `SUM(total_last_touch_conversions)`, `SUM(true_incremental_conv)`

### 3. Acquisition Cost Shift Chart
- **Visual Type**: Horizontal Bar Chart
- **Dimension**: `channel`
- **Metrics**: `AVG(last_touch_cpa)`, `AVG(true_incremental_cpa)`

### 4. Campaign Table Calculated Fields

#### True Incremental Lift Ratio
```sql
SUM(true_incremental_conv) / SUM(total_last_touch_conversions)
