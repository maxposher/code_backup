

SELECT  buyer_shipping_fee
FROM    analytics.dw_orders
LIMIT 10




SELECT 
	DATE(dw_users.date_buyer_activated) AS "dw_users.buyer_activated_date",
	COUNT(DISTINCT CASE WHEN (dw_user_activity.activity_name ILIKE 'active_on_app') THEN dw_user_activity.user_id ELSE NULL END) AS "dw_user_activity.count_active_users"
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users ON dw_user_activity.user_id = dw_users.user_id
LEFT JOIN analytics.dw_orders AS buyer_info ON (dw_user_activity.user_id = dw_orders.buyer_id and dw_orders.order_gmv < 50000 * 100 and dw_orders.booked_at IS NOT NULL and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification'))

WHERE (buyer_info.order_number = 1 AND ((buyer_info.buyer_shipping_fee < 499 AND buyer_info.booked_at <  '2016-02-17 18:00:00') OR   (buyer_info.buyer_shipping_fee < 595 AND buyer_info.booked_at >= '2016-02-17 18:00:00'))) AND (dw_user_activity.activity_name ILIKE 'active_on_app') AND ((((dw_users.date_buyer_activated) >= (DATEADD(day,-89, DATE_TRUNC('day',GETDATE()) )) AND (dw_users.date_buyer_activated) < (DATEADD(day,90, DATEADD(day,-89, DATE_TRUNC('day',GETDATE()) ) )))))
GROUP BY 1
ORDER BY 1 DESC
LIMIT 5000



SELECT SUM(order_gmv*0.01)
FROM  analytics.dw_orders
WHERE date(booked_at) BETWEEN '2015-01-01' AND '2015-01-07' 
AND buyer_id IN


  (SELECT buyer_id
   From   analytics.dw_orders
   WHERE  order_number = 1
   AND    order_gmv*0.01 >= 10
   AND    buyer_shipping_fee < 499
   AND    date(booked_at) = '2015-01-01')

AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                    'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                    'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
                    'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND order_gmv < 50000 * 100 
and booked_at IS NOT NULL
 
 
  LIMIT 10
  
  
  
  SELECT COUNT(distinct user_id)
  FROM(
  SELECT U.user_id, activity_date, joined_at  
  FROM  analytics.dw_users as U
  INNER JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
  WHERE A.activity_name = 'active_on_app'
  AND   date(U.joined_at) BETWEEN '2016-02-01' AND '2016-02-29'
  AND   A.activity_count =  1
  AND   date(U.joined_at) != date(A.activity_date)
  LIMIT 20
  
  
  
  SELECT COUNT(distinct user_id)
  FROM(
  SELECT U.user_id
  FROM  analytics.dw_users as U
  WHERE date(U.joined_at) BETWEEN '2016-02-01' AND '2016-02-29')
  LIMIT 20
  
  
  
  
  SELECT A.user_id, A.activity_date, B.activity_date, A.activity_count, B.activity_count
  FROM   analytics.dw_user_activity AS A 
  INNER  JOIN analytics.dw_user_activity AS B on A.user_id = B.user_id
  WHERE  A.activity_name = 'active_on_app'
  AND    B.activity_name = 'active_on_app'
  AND   date(A.activity_date) BETWEEN '2016-02-01' AND '2016-02-29'
  AND   A.activity_count =  1
  AND   B.activity_count =  2
  AND   date(A.activity_date) = date(B.activity_date)
  LIMIT 25
  
  
  
  
  
  SELECT U.user_id, date(activity_date) 
  FROM  analytics.dw_users as U
  INNER JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
  WHERE A.activity_name = 'active_on_app'
  AND   date(U.joined_at) BETWEEN '2016-02-01' AND '2016-02-29'
  GROUP BY 1, 2
  LIMIT 20
  
  
  
  SELECT COUNT(*)
  FROM
  (
 
  SELECT user_id
  FROM(
  SELECT U.user_id, date(activity_date), 
  row_number() over (partition by U.user_id order by date(activity_date) asc) as row_number,
  date(activity_date) - date(joined_at) + 1 AS D_day
  FROM  analytics.dw_users as U
  INNER JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
  WHERE A.activity_name = 'active_on_app'
  AND   date(U.joined_at) BETWEEN '2016-02-01' AND '2016-02-29'
  AND  (date(A.activity_date) <= date(U.buyer_activated_at) OR U.buyer_activated_at IS NULL) 
  AND date(A.activity_date)  BETWEEN '2016-02-01' AND '2016-04-30'
  GROUP BY 1, 2, 4)
  WHERE row_number > 1  
  GROUP BY 1 
 
  
  minus
  
  SELECT user_id
  FROM(

  SELECT U.user_id, date(activity_date), 
  row_number() over (partition by U.user_id order by date(activity_date) asc) as row_number,
  date(activity_date) - date(joined_at) + 1 AS D_day
  FROM  analytics.dw_users as U
  INNER JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
  WHERE A.activity_name = 'active_on_app'
  AND   date(U.joined_at) BETWEEN '2016-02-01' AND '2016-02-29'
  AND  (date(A.activity_date) <= date(U.buyer_activated_at) OR U.buyer_activated_at IS NULL) 
  AND date(A.activity_date)  BETWEEN '2016-02-01' AND '2016-04-30'
  GROUP BY 1, 2, 4)
  WHERE d_day IN (2,5,7)
  GROUP BY 1)
  
  
  
  
  
  