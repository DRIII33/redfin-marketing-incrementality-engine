# Executive Summary: Causal Marketing Incrementality & Media Optimization

---

#### **Data Analyst:** Daniel Rodriguez III

#### **Date:** September 03, 2026

---

## Executive Overview
This project delivers an end-to-end analytical framework designed to resolve last-touch attribution bias and optimize multi-channel media spend for Redfin's digital homeownership platform. By unifying marketing interaction telemetry and executing causal inference models, this solution isolates organic baseline conversions from true incremental paid media lift.

## Technical Architecture & Workflow
- **Data Warehouse**: Star-schema architecture built in Google BigQuery (`driiiportfolio.redfin_marketing`).
- **Causal Analytics**: Difference-in-Differences (DiD) synthetic control evaluation and econometric modeling in Python, isolating non-incremental baseline arrivals.
- **Executive Business Intelligence**: Interactive 2-page Looker Studio dashboard communicating dynamic incremental CPA, true incremental lift ratios, and budget reallocation recommendations.

## Core Financial Metrics Summary

| Metric | Value |
| :--- | :--- |
| **Total Marketing Spend** | $13,890.46 |
| **Total Last-Touch Conversions** | 4,500 |
| **True Incremental Conversions** | 3,258.29 |
| **Blended Last-Touch CPA** | $3.09 |
| **Blended Incremental CPA** | $4.26 |
| **Overall Incrementality Lift Ratio** | 72.41% |

## Strategic Recommendations
1. **Paid Search Optimization**: Reallocate spend from low-intent generic keywords where Incremental CPA exceeds $10.00.
2. **Paid Social Scaling**: Expand budget in Paid Social prospecting campaigns exhibiting high incremental lift ratios (>80%) and favorable Incremental CPA ($3.58).
3. **Partner Referral Restructuring**: Restructure partner agreements to pay on true incremental mortgage inquiries ($13.71 Incremental CPA) rather than top-of-funnel last clicks ($7.57 Last-Touch CPA).
