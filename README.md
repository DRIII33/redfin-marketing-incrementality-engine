# Causal Marketing Incrementality & Attribution Engine

![BigQuery](https://img.shields.io/badge/Google_BigQuery-Data_Warehouse-blue)
![Google_Colab](https://img.shields.io/badge/Google_Colab-Python_Analytics-orange)
![Looker_Studio](https://img.shields.io/badge/Looker_Studio-Executive_BI-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

## Project Overview
This repository contains the complete end-to-end data engineering and causal analytics code for the **Marketing Incrementality Engine**, built to model media efficiency across Redfin's digital homeownership platform. 

The project addresses last-touch attribution bias by isolating baseline organic conversions from paid incremental lift using SQL transformation pipelines in **Google BigQuery**, Difference-in-Differences causal modeling in **Google Colab**, and executive reporting in **Looker Studio**.

---

## Technical Stack & Architecture
- **Data Warehousing & ETL**: Google BigQuery (`driiiportfolio.redfin_marketing`)
- **Languages**: SQL (Standard BigQuery dialect), Python 3.10+
- **Statistical & Causal Modeling**: `statsmodels` (OLS Difference-in-Differences), `pandas`, `numpy`
- **Business Intelligence**: Looker Studio Interactive Dashboard
- **Version Control**: Git / GitHub Workflow

---

## Key Business Findings & Insights
1. **Paid Search Cannibalization**: Last-touch attribution over-credited Paid Search by **38%**. Causal modeling confirmed that 38% of brand query converters would have arrived organically.
2. **Under-Funded Prospecting**: **Partner Referral** and **Paid Social Prospecting** demonstrated an **88%–91% true incrementality rate**, generating high incremental ROI despite appearing more expensive on a last-touch CPA basis.
3. **Capital Optimization**: Reallocating 20% of low-incrementality Paid Search budget to Partner Referral channels projects a **14.2% reduction in overall platform CAC**.

---

## Repository Navigation
- [`/sql`](./sql): Production SQL scripts for schema setup, cleaning, and attribution modeling.
- [`/notebooks`](./notebooks): Google Colab notebooks for synthetic data generation and causal inference.
- [`Executive_Summary.md`](./Executive_Summary.md): Full C-suite executive briefing.
- [`Project_Disclaimer.md`](./Project_Disclaimer.md): Synthetic data and project boundary disclosure.
- [`Dashboard_Executive_Summary.md`](./Dashboard_Executive_Summary.md): Looker Studio specification and user guide.

---

## Author & Contact
**Daniel Rodriguez III**  
*Data Operations & Insights Professional*  
- Email: DRIIIGistus@gmail.com
