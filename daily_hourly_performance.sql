-- Check daily performance
CREATE OR REPLACE VIEW `kaggle-ecommerce-251121.ecommerce_behavior.daily_performance` AS
SELECT 
  DATE(event_time) as event_date,
  CASE 
    WHEN DATE(event_time) = '2019-11-29' THEN 'BLACK FRIDAY'
    WHEN DATE(event_time) BETWEEN '2019-11-29' AND '2019-12-02' THEN 'Cyber Weekend'
    WHEN DATE(event_time) < '2019-11-29' THEN 'Pre-Black Friday'
    ELSE 'Regular Day'
  END as day_type,
  
  -- Performance metrics
  COUNT(DISTINCT user_session) as total_sessions,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) as sessions_with_purchase,
  COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) as total_purchases,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) as unique_buyers,
  
  -- Revenue
  ROUND(SUM(CASE WHEN event_type = 'purchase' THEN price END), 2) as daily_revenue,
  ROUND(AVG(CASE WHEN event_type = 'purchase' THEN price END), 2) as avg_order_value,
  
  -- Conversion
  ROUND(
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) 
    / COUNT(DISTINCT user_session) * 100, 
    2
  ) as conversion_rate

FROM `kaggle-ecommerce-251121.ecommerce_behavior.main`
GROUP BY event_date, day_type
ORDER BY event_date;

-- Check hourly performance
CREATE OR REPLACE VIEW `kaggle-ecommerce-251121.ecommerce_behavior.dow_performance` AS
SELECT 
  EXTRACT(DAYOFWEEK FROM event_time) as day_of_week,
  EXTRACT(HOUR FROM event_time) as hour_of_day,
  
  -- Activity levels
  COUNT(*) as total_events,
  COUNT(DISTINCT user_session) as total_sessions,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) as purchase_sessions,
  
  -- Revenue
  ROUND(SUM(CASE WHEN event_type = 'purchase' THEN price END), 2) as hourly_revenue,
  
  -- Conversion
  ROUND(
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) 
    / COUNT(DISTINCT user_session) * 100, 
    2
  ) as conversion_rate

FROM `kaggle-ecommerce-251121.ecommerce_behavior.main`
GROUP BY day_of_week, hour_of_day
ORDER BY day_of_week, hour_of_day;