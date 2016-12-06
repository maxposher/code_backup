---------
SELECT CASE WHEN liker.activated_at < buyer.buyer_activated_at THEN 'like_before_buy' 
            WHEN  liker.activated_at IS NULL THEN 'No' 
            ELSE 'No' END AS lister_activation_status,
TO_CHAR(buyer.buyer_activated_at, 'YYYY-MM') AS "buyer.buyer_activated_month",
DATEDIFF(month,buyer.buyer_activated_at,dw_orders.booked_at) + 1 AS "dw_orders.months_since_buyer_activated",
COUNT(DISTINCT dw_orders.buyer_id) AS "dw_orders.buyer_count",
COUNT(Distinct dw_orders.order_id) AS "dw_orders.count_orders",
COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) AS "dw_orders.total_order_gmv"
FROM      analytics.dw_users AS buyer
LEFT JOIN analytics.dw_orders AS dw_orders ON dw_orders.buyer_id = buyer.user_id
LEFT JOIN raw_spark.liker_activation AS liker on buyer_id = liker.user_id
WHERE DATEDIFF(month,buyer.buyer_activated_at,dw_orders.booked_at) + 1 <= 2
AND (buyer.buyer_activated_at >= TIMESTAMP '2015-01-01') 
AND dw_orders.order_gmv*0.01 < 50000 and dw_orders.booked_at IS NOT NULL 
and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
GROUP BY 1,2,3
ORDER BY 2,3
--------
SELECT 
TO_CHAR(buyer.buyer_activated_at, 'YYYY-MM') AS "buyer.buyer_activated_month",
DATEDIFF(month,buyer.buyer_activated_at,dw_orders.booked_at) + 1 AS "dw_orders.months_since_buyer_activated",
O2.first_shipping_fee,
COUNT(DISTINCT dw_orders.buyer_id) AS "dw_orders.buyer_count",
COUNT(Distinct dw_orders.order_id) AS "dw_orders.count_orders",
COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) AS "dw_orders.total_order_gmv"

FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
LEFT JOIN 
         (SELECT O.buyer_shipping_fee*.01 AS "first_shipping_fee", O.buyer_id
          FROM analytics.dw_orders AS O 
          WHERE date(booked_at) >= '2013-01-01'
          AND  O.order_number = 1 ) AS O2 ON  O2.buyer_id = buyer.user_id
WHERE DATEDIFF(month,buyer.buyer_activated_at,dw_orders.booked_at) + 1 <= 2
AND (buyer.buyer_activated_at >= TIMESTAMP '2013-01-01') 
AND  buyer.acq_channel not in ('rip')
AND dw_orders.order_gmv*0.01 < 50000 and dw_orders.booked_at IS NOT NULL 
and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
GROUP BY 1,2,3
ORDER BY 1

-----------------
SELECT CASE WHEN Liker.activated_at < buyer.buyer_activated_at THEN 'Liker_before_buy' ELSE 'NO' END AS Liker_activation_status,
TO_CHAR(buyer.buyer_activated_at, 'YYYY-MM') AS "buyer.buyer_activated_month",
DATEDIFF(month,buyer.buyer_activated_at,dw_orders.booked_at) + 1 AS "dw_orders.months_since_buyer_activated",
COUNT(DISTINCT dw_orders.buyer_id) AS "dw_orders.buyer_count",
COUNT(Distinct dw_orders.order_id) AS "dw_orders.count_orders",
COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) AS "dw_orders.total_order_gmv"

FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
LEFT JOIN raw_spark.liker_activation AS Liker ON Liker.user_id = dw_orders.buyer_id
WHERE DATEDIFF(month,buyer.buyer_activated_at,dw_orders.booked_at) + 1 <= 2
AND (buyer.buyer_activated_at >= TIMESTAMP '2016-01-01') 
AND dw_orders.order_gmv*0.01 < 50000 and dw_orders.booked_at IS NOT NULL 
and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
GROUP BY 1,2,3
ORDER BY 1
-------------------





--Lister Activation
SELECT CASE WHEN lister_activated_at < buyer.buyer_activated_at THEN 'list_before_buy' ELSE 'No' END AS lister_activation_status,
TO_CHAR(buyer.buyer_activated_at, 'YYYY-MM') AS "buyer.buyer_activated_month",
DATEDIFF(month,buyer.buyer_activated_at,dw_orders.booked_at) + 1 AS "dw_orders.months_since_buyer_activated",
COUNT(DISTINCT dw_orders.buyer_id) AS "dw_orders.buyer_count",
COUNT(Distinct dw_orders.order_id) AS "dw_orders.count_orders",
COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) AS "dw_orders.total_order_gmv"

FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
WHERE DATEDIFF(month,buyer.buyer_activated_at,dw_orders.booked_at) + 1 <= 2
AND (buyer.buyer_activated_at >= TIMESTAMP '2016-01-01') 
AND  buyer.acq_channel not in ('rip')
AND dw_orders.order_gmv*0.01 < 50000 and dw_orders.booked_at IS NOT NULL 
and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
GROUP BY 1,2,3
ORDER BY 1





SELECT activity_at
FROM analytics.dw_user_activity
WHERE activity_name = 'like_listing'
AND   activity_count = 1
LIMIT 10



SELECT distinct activity_name
FROM analytics.dw_user_activity
WHERE activity_count = 1
LIMIT 10


SELECT lister_activated_at
FROM   analytics.dw_users
LIMIT 10



SELECT *
FROM raw_spark.liker_activation
LIMIT 10