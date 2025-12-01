# ecommerce-rfm-analysis
Exercise of RFM and cart abandonment recovery scenario analysis based on eCommerce dataset available on Kaggle (https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store)

Tools used:
  - SQL BigQuery (Data Loading and Extraction; see folder `sql`)
  - Google Looker Studio (Data Visualization; see [Looker eCommerce Nov 2019 Report Dashboard](https://lookerstudio.google.com/reporting/2c303889-1097-4b2b-9da5-f3be275716d6))
  - Python (RFM-based clustering and cart recovery scenario analysis; see `ipynb file`)

## Executive Summary
Analysis of November 2019 eCommerce behavior data (of +3.5 million users) to identify revenue optimization opportunities and actionable customer segments. Key findings:

- There was a full revenue dip on Nov 15, followed by Nov 17 revenue spike which requires business validation - possibly some technical glitch when checking out carts, followed by the company's compensation strategy on the following day(s) to make up for it
- Overall, users mainly visit the eCommerce website before and during working hours (6AM - 5PM), with Mondays and weekends seeing the most traffic
- Smartphone is the most significant contributor of revenue during November 2019, and has the strongest conversion among all other product category
- Found a Total Value at Risk of ~$272 millions (from 970,129 abandoned carts × $281.16 AOV)
- Identified 4 distinct RFM-based customer segments via K-means clustering, including 365 'The Whales' VIP customers (with an avg of 62 purchases/month, with revenue contribution of $34k)
- Simulation example on assessing impact and ROI of various campaign strategies to rescue abandoned carts (Note: requires another business validation on campaign costs assumption)

## Business Questions Asked and Methodology

- Data Source
  - Dataset: Kaggle eCommerce Behavior (November 2019)
  - Storage: Google BigQuery
  - Volume: 3.5 million+ users, millions of events (user sessions, views, cart adds, purchases)

Analysis Approach
1. SQL Analysis (BigQuery)
Created 4 core analytical queries:<br>

| Query | Business Question | Key Metrics |
| ----- | ----------------- | ----------- |
| Daily & Hourly Performance | How does revenue trend daily, and when do customers engage most? | Revenue, sessions, conversion rate, AOV, Hourly/day-of-week sessions |
| Overall Funnel | Where do we lose customers? | View → Cart → Purchase rates, drop-offs |
| Category Funnel | Which categories convert best? | Category-level conversion rates, abandonment |
| Customer RFM | Who are our valuable customers? | Recency, Frequency, Monetary by customer |

2. Business Intelligence (Looker Studio)
Built 2 interactive dashboards:

Dashboard 1 - Performance Overview: Revenue trends, overall funnel, product performance
Dashboard 2 - Funnel Optimization: Cart abandonment analysis, hourly patterns, category conversion

3. Python Analysis

K-means clustering: Segmented 441,638 customers into 4 RFM-based groups

- Standardized features (Recency, Frequency, Monetary, based on SQL extract)
- Tested K=2 to K=10 via Elbow Method, selected K=4 as the final segments based on the method


Scenario modeling: Projected cart recovery revenue across 7 campaign strategies with ROI analysis

## Results
- [Looker eCommerce Nov 2019 Report Dashboard](https://lookerstudio.google.com/reporting/2c303889-1097-4b2b-9da5-f3be275716d6))
  ### **Customer Segmentation Results (K-Means Clustering)**

| Cluster | Segment Name | Customer Count | % of Total | Avg Recency (days) | Avg Frequency | Avg Monetary | Total Revenue |
|:-------:|:-------------|:--------------:|:----------:|:------------------:|:-------------:|:------------:|:-------------:|
| 0 | 🍞 **Bread and Butter** | 292,272 | 66.2% | 8.88 | 1.84 | $500.88 | $146.4M |
| 1 | 💎 **Loyal High-Spenders** | 12,322 | 2.8% | 6.37 | 13.04 | $5,305.94 | $65.4M |
| 2 | 🐋 **The Whales** | 365 | 0.1% | 3.60 | 61.88 | $34,014.61 | $12.4M |
| 3 | ⚠️ **At Risk** | 136,679 | 30.9% | 22.43 | 1.44 | $373.19 | $51.0M |
| | **TOTAL** | **441,638** | **100%** | — | — | — | **$275.2M** |
