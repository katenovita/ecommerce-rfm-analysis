-- RFM Prep - November stats
CREATE OR REPLACE VIEW `kaggle-ecommerce-251121.ecommerce_behavior.customer_rfm_nov` AS
WITH user_purchases AS (
  SELECT 
    user_id,
    COUNT(DISTINCT DATE(event_time)) as days_active,  -- Active on how many days
    COUNT(*) as total_purchases,
    ROUND(SUM(price), 2) as total_spent,
    ROUND(AVG(price), 2) as avg_order_value,
    MIN(event_time) as first_purchase,
    MAX(event_time) as last_purchase,
    
    -- Recency within November (days since last purchase as of Nov 30)
    DATE_DIFF('2019-11-30', DATE(MAX(event_time)), DAY) as days_since_last_purchase
    
  FROM `kaggle-ecommerce-251121.ecommerce_behavior.main`
  WHERE event_type = 'purchase'
    AND price IS NOT NULL
  GROUP BY user_id
)

SELECT 
  user_id,
  days_since_last_purchase as recency_days,  -- Lower = more recent
  total_purchases as frequency,
  total_spent as monetary,
  avg_order_value,
  days_active,
  
  -- Additional context
  ROUND(total_spent / days_active, 2) as spend_per_active_day,
  CASE 
    WHEN total_purchases = 1 THEN 'One-time buyer'
    WHEN total_purchases BETWEEN 2 AND 3 THEN 'Repeat buyer'
    ELSE 'Super buyer'
  END as buyer_type

FROM user_purchases
ORDER BY total_spent DESC;

-- little check of count per buyer type
SELECT buyer_type, COUNT(*)
FROM `kaggle-ecommerce-251121.rfm_stats.main`
GROUP BY buyer_type;