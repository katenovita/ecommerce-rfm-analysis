-- -- This query calculates the overall funnel based on unique user sessions
-- CREATE OR REPLACE VIEW `kaggle-ecommerce-251121.ecommerce_behavior.overall_funnel` AS
WITH session_funnel AS (
  SELECT 
    user_session,
    MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) as had_view,
    MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) as had_cart,
    MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) as had_purchase,
    SUM(CASE WHEN event_type = 'purchase' THEN price ELSE 0 END) as revenue
  FROM `kaggle-ecommerce-251121.ecommerce_behavior.main`
  GROUP BY 1
)

SELECT 
  -- Funnel stages
  SUM(had_view) as sessions_with_views,
  SUM(had_cart) as sessions_with_cart,
  SUM(had_purchase) as sessions_with_purchase,
  SUM(revenue) as total_revenue,
  
  -- Conversion rates
  ROUND(SUM(had_cart) / SUM(had_view) * 100, 2) as view_to_cart_pct,
  ROUND(SUM(had_purchase) / SUM(had_cart) * 100, 2) as cart_to_purchase_pct,
  ROUND(SUM(had_purchase) / SUM(had_view) * 100, 2) as overall_conversion_pct,
  
  -- Drop-offs
  SUM(had_view) - SUM(had_cart) as lost_at_cart,
  SUM(had_cart) - SUM(had_purchase) as lost_at_purchase,
  
  -- Drop-off rates
  ROUND((1 - SUM(had_cart) / SUM(had_view)) * 100, 2) as cart_dropoff_pct,
  ROUND((1 - SUM(had_purchase) / SUM(had_cart)) * 100, 2) as purchase_dropoff_pct

FROM session_funnel;
