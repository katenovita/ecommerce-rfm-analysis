# ecommerce-rfm-analysis
Exercise of RFM and cart abandonment recovery scenario analysis based on eCommerce dataset available on Kaggle (https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store)

🔎 On progress

Tools used:
  - SQL BigQuery (Data Loading and Extraction; see folder `sql`)
  - Google Looker Studio (Data Visualization; see [Looker Dashboard](https://lookerstudio.google.com/reporting/2c303889-1097-4b2b-9da5-f3be275716d6))
  - Python (RFM-based clustering and cart recovery scenario analysis; see `ipynb file`)

## Executive Summary
Analysis of November 2019 eCommerce behavior data (of +3.5 million users) to identify revenue optimization opportunities and actionable customer segments. Key findings:

- There was a full revenue dip on Nov 15, followed by Nov 17 revenue spike which requires business validation - possibly some technical glitch when checking out carts, followed by the company's compensation strategy on the following day(s) to make up for it
- $279K abandoned cart recovery potential (32% cart abandonment rate, 2,795 sessions)
- 4 distinct RFM-based customer segments identified via K-means clustering, including 365 ultra-high-value VIP customers (62 purchases/month avg)
- Assuming correct campaign costs based on market benchmark, recommended actions include Cart recovery email campaigns (5-18% recovery rate, $14K-$50K monthly impact) and segment-specific retention strategies

## Business Questions Asked and Methodology

- Data Source
  - Dataset: Kaggle eCommerce Behavior (November 2019)
  - Storage: Google BigQuery
  - Volume: 3.5 million+ users, millions of events (user sessions, views, cart adds, purchases)

Analysis Approach
1. SQL Analysis (BigQuery)
Created 8 core analytical queries:
|Query|Business Question|Key Metrics|
|---|---|---|
|Daily & Hourly Performance|How does revenue trend daily, and when do customers engage most?|Revenue, sessions, conversion rate, AOV, Hourly/day-of-week sessions|
|Overall Funnel|Where do we lose customers?|View → Cart → Purchase rates, drop-offs|
|Category Funnel|Which categories convert best?|Category-level conversion rates, abandonment|
|Customer RFM|Who are our valuable customers?|Recency, Frequency, Monetary by customer|

3. Business Intelligence (Looker Studio)
Built 2 interactive dashboards:

Dashboard 1 - Performance Overview: Revenue trends, overall funnel, product performance
Dashboard 2 - Funnel Optimization: Cart abandonment analysis, hourly patterns, category conversion
