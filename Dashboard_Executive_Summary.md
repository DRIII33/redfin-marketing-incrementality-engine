# Dashboard Executive Summary & User Guide

---

#### **Data Analyst:** Daniel Rodriguez III

#### **Date:** September 03, 2026

---

# Dashboard Executive Summary & Audit Guide

## Dashboard Architecture Overview
The Looker Studio Executive Dashboard is structured as a two-page executive reporting suite:
- **Page 1: Executive Summary & Channel Efficiency**
- **Page 2: Campaign Level Performance & Budget Optimization**

## Verified Metric Summary Table

| Metric / KPI | Value | Description |
| :--- | :--- | :--- |
| **Total Spend** | $13,890.46 | Total marketing investment across all 15 campaign slices |
| **Last-Touch Conversions** | 4,500 | Total conversions assigned via standard last-click rule |
| **True Incremental Conversions** | 3,258.29 | Causal conversions driven purely by marketing spend |
| **Blended Last-Touch CPA** | $3.09 | Baseline acquisition cost per last-touch conversion |
| **Blended Incremental CPA** | $4.26 | True acquisition cost per incremental conversion |
| **Overall Lift Ratio** | 72.41% | Proportion of total conversions that are truly incremental |

## Page Structure & Visual Layout

### Page 1: Executive Summary & Channel Efficiency
1. **Header KPI Scorecards (Top Row)**: Six scorecards displaying Spend ($13,890.46), Last-Touch Conversions (4.5K), Incremental Conversions (3,258.29), Last-Touch CPA ($3.09), Incremental CPA ($4.26), and Overall Lift (72.41%).
2. **Conversion Volume Bar Chart (Middle Left)**: Clustered bar chart showing Last-Touch vs. True Incremental Conversions by channel.
3. **Acquisition Cost Shift Bar Chart (Middle Right)**: Horizontal bar chart showing CPA expansion across Display, Paid Social, Paid Search, and Partner Referral.

### Page 2: Campaign Level Performance & Budget Optimization
1. **Campaign Efficiency & Reallocation Matrix (Top Table)**: Granular matrix detailing Campaign Name, Channel, Spend, Conversions, Last-Touch CPA, Incremental CPA, and Recommendation Tag.
2. **Scatter Plot (Lower Left)**: Maps Causal Lift Ratio (%) against Incremental CPA ($) with $10.00 CPA threshold line.
3. **Donut Chart (Lower Right)**: Visualizes spend distribution across budget recommendations (*Scale Spend*, *Maintain Budget*, *Reduce / Reallocate*).
