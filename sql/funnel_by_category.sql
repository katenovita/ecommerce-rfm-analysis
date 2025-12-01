-- Window shopper - Find top 20 categories with many views but few purchases
CREATE OR REPLACE VIEW `kaggle-ecommerce-251121.ecommerce_behavior.category_funnel` AS
WITH category_funnel AS (
  SELECT 
    category_code,
    user_session,
    MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) as had_view,
    MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) as had_cart,
    MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) as had_purchase,
    SUM(CASE WHEN event_type = 'purchase' THEN price END) as revenue
  FROM `kaggle-ecommerce-251121.ecommerce_behavior.main`
  WHERE category_code IS NOT NULL
  GROUP BY category_code, user_session
)

SELECT 
  category_code,
  
  -- Volume
  COUNT(DISTINCT user_session) as total_sessions,
  SUM(had_purchase) as total_purchases,
  ROUND(SUM(revenue), 2) as total_revenue,
  
  -- Conversion
  ROUND(SUM(had_cart) / SUM(had_view) * 100, 2) as view_to_cart_pct,
  ROUND(SUM(had_purchase) / SUM(had_cart) * 100, 2) as cart_to_purchase_pct,
  ROUND(SUM(had_purchase) / SUM(had_view) * 100, 2) as overall_conversion_pct,
  
  -- Efficiency metric
  ROUND(SUM(revenue) / COUNT(DISTINCT user_session), 2) as revenue_per_session

FROM category_funnel
GROUP BY category_code
HAVING SUM(had_view) > 100  -- Filter for categories with meaningful traffic
ORDER BY total_revenue DESC
LIMIT 20;
