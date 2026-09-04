# Causal Marketing Incrementality & Attribution Engine

![BigQuery](https://img.shields.io/badge/Google_BigQuery-Data_Warehouse-blue?logo=googlecloud)
![Looker Studio](https://img.shields.io/badge/Looker_Studio-Executive_BI-orange)
![Python](https://img.shields.io/badge/Python-3.10+-yellow?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)

An enterprise-grade analytical framework built for **Redfin / Rocket Companies** to resolve last-touch attribution bias, model true causal channel incrementality, and optimize multi-channel media spend.

---

## Executive Summary & Business Context

Following Redfin’s integration with Rocket Companies, digital marketing leadership required a unified, data-driven approach to evaluate cross-channel acquisition efficiency. Traditional last-touch attribution models misattributed organic baseline traffic (high-intent users who would have converted anyway) to paid ad channels like Paid Search and Retargeting.

This misattribution created three core business challenges:

1. **Ad-Spend Misallocation:** Saturated paid search terms claimed unearned conversion credit.
2. **Inaccurate Acquisition Costs:** Overestimated efficiency on retargeting masked high acquisition costs on new customer prospecting.
3. **Data Disparity:** Touchpoint interaction logs, conversion events, and campaign metadata resided in separate tables without structured causal evaluation.

---

## Technical Architecture

```text
┌───────────────────────────────────────────────────────────────────────────────────┐
│                                ARCHITECTURE DIAGRAM                               │
│                                                                                   │
│  [Google Colab]                                                                   │
│  Synthetic Data Engine ──► CSV Datasets ──► [Google BigQuery]                     │
│  (NumPy, Pandas, SciPy)                     `driiiportfolio.redfin_marketing`     │
│                                                   │                               │
│                                                   ▼                               │
│                                            SQL Transformations                    │
│                                            (ETL, CTEs, Windowing)                 │
│                                                   │                               │
│                        ┌──────────────────────────┴──────────────────────────┐    │
│                        ▼                                                     ▼    │
│  [Google Colab]                                                    [Looker Studio]│
│  Causal Analytics & Modeling                                       Executive BI   │
│  (Statsmodels, DiD Inference, Forecasting)                          Dashboard     │
└───────────────────────────────────────────────────────────────────────────────────┘
```

* **Data Warehouse:** Google BigQuery (`driiiportfolio.redfin_marketing`)
* **Data Processing & Analytics:** Python (Pandas, NumPy, Statsmodels)
* **Business Intelligence:** Looker Studio Executive Dashboard
* **Version Control:** GitHub Actions

---

## Key Business Results

* **Analyzed Scope:** $13,890.46 total ad spend across 4,500 last-touch conversions across 15 campaigns.
* **Baseline Organic Cannibalization:** Identified that **27.6%** of overall last-touch conversions were non-incremental baseline arrivals (3,258.29 true incremental vs. 4,500 last-touch).
* **True Incremental CPA Shift:** Paid Search CPA expanded from $5.51 (Last-Touch) to $10.18 (Incremental CPA), while Paid Social maintained high efficiency at $3.58 Incremental CPA.
* **Budget Optimization:** Framework identifies reallocatable capital from over-saturated Paid Search terms into high-lift Paid Social and Partner Referral channels.

---

## Repository Structure

```text
redfin-marketing-incrementality-engine/
│
├── .gitignore
├── LICENSE
├── README.md
├── Executive_Summary.md
├── Project_Disclaimer.md
├── Dashboard_Executive_Summary.md
│
├── data/
│   ├── raw/
│   │   ├── dim_campaigns.csv
│   │   ├── fact_marketing_touchpoints.csv
│   │   └── fact_conversions.csv
│   └── processed/
│       └── marketing_attribution_kpis.csv
│
├── sql/
│   ├── 01_schema_setup.sql
│   ├── 02_data_cleaning_transformations.sql
│   └── 03_attribution_and_kpi_mart.sql
│
├── notebooks/
│   ├── 01_synthetic_data_generation.ipynb
│   └── 02_causal_incrementality_and_forecasting.ipynb
│
└── docs/
    └── dashboard_specifications.md
```
