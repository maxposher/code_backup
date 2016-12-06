


SELECT 
	buyer.cohort_quarter AS "buyer.cohort_quarter",
	DATEDIFF(quarter,date_trunc('quarter', (DATE(buyer.date_buyer_activated))),date_trunc('quarter',dw_orders.booked_at)) + 1 AS "dw_orders.booked_quarter_investor",
	COUNT(DISTINCT dw_orders.buyer_id) AS "dw_orders.buyer_count"
FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
LEFT JOIN analytics.d_dates_full AS booked ON dw_orders.booked_date = booked.full_dt

WHERE ((dw_orders.order_gmv < 50000 * 100 and dw_orders.booked_at IS NOT NULL 
and dw_orders.order_state IN 

('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')))
GROUP BY 1,2
ORDER BY 1 
LIMIT 10



SELECT          date(date_trunc('quarter', U.date_buyer_activated)), 
                DATEDIFF(quarter,date_trunc('quarter', (DATE(U.date_buyer_activated))),date_trunc('quarter', A.activity_date)) + 1,
                COUNT(distinct A.user_id)
FROM            analytics.dw_users AS U
INNER JOIN       analytics.dw_user_activity AS A ON U.user_id = A.user_id
WHERE           A.activity_name = 'item_purchased'
AND             A.activity_date > U.date_buyer_activated
GROUP BY 1,2
ORDER BY 1,2



SELECT          date(date_trunc('year', U.date_buyer_activated)), 
                DATEDIFF(year,date_trunc('year', (DATE(U.date_buyer_activated))),date_trunc('year', A.activity_date)) + 1,
                COUNT(distinct A.user_id)
FROM            analytics.dw_users AS U
INNER JOIN      analytics.dw_user_activity AS A ON U.user_id = A.user_id
WHERE           A.activity_name = 'item_purchased'
AND             A.activity_date > U.date_buyer_activated
GROUP BY 1,2
ORDER BY 1,2




SELECT          date(date_trunc('quarter', U.date_buyer_activated)), 
                COUNT(distinct U.user_id)
FROM            analytics.dw_users AS U


GROUP BY 1
ORDER BY 1








SELECT          date(date_trunc('quarter', U.date_buyer_activated)), 
                DATEDIFF(quarter,date_trunc('quarter', (DATE(U.date_buyer_activated))),date_trunc('quarter', A.booked_at)) + 1,
                COUNT(distinct A.buyer_id) AS Buyer, COUNT(distinct A.order_id) AS Orders, SUM(A.order_gmv/100)
FROM            analytics.dw_users AS U
INNER JOIN      analytics.dw_orders AS A ON U.user_id = A.buyer_id
WHERE           A.booked_at > U.date_buyer_activated
AND             A.order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')

GROUP BY 1,2
ORDER BY 1,2




SELECT date(date_trunc('year', booked_at)), COUNT(distinct buyer_id)
FROM analytics.dw_orders
WHERE
order_number = 1
AND
order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
 GROUP BY 1
 ORDER BY 1


SELECT          date(date_trunc('quarter', U.date_buyer_activated)), 
                DATEDIFF(quarter, date_trunc('quarter', (DATE(U.date_buyer_activated))),date_trunc('quarter', A.booked_at)) + 1,
                COUNT(distinct A.buyer_id) AS Buyer, COUNT(distinct A.order_id) AS Orders, SUM(A.order_gmv/100)
FROM            analytics.dw_users AS U
INNER JOIN      analytics.dw_orders AS A ON U.user_id = A.buyer_id
WHERE           A.booked_at >= U.buyer_activated_at
AND             A.order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')

GROUP BY 1,2
ORDER BY 1,2







SELECT          date(date_trunc('year', U.date_buyer_activated)), 
                DATEDIFF(year, date_trunc('year', (DATE(U.date_buyer_activated))),date_trunc('year', A.booked_at)) + 1,
                COUNT(distinct A.buyer_id) AS Buyer, COUNT(distinct A.order_id) AS Orders, SUM(A.order_gmv/100)
FROM            analytics.dw_users AS U
INNER JOIN      analytics.dw_orders AS A ON U.user_id = A.buyer_id
WHERE           A.booked_at >= U.buyer_activated_at
AND             A.order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')

GROUP BY 1,2
ORDER BY 1,2


SELECT          date(date_trunc('year', U.date_buyer_activated)), 
                DATEDIFF(year,date_trunc('year', (DATE(U.date_buyer_activated))),date_trunc('year', A.activity_date)) + 1,
                COUNT(distinct A.user_id)
FROM            analytics.dw_users AS U
INNER JOIN       analytics.dw_user_activity AS A ON U.user_id = A.user_id
WHERE           A.activity_name = 'active_on_app'
AND             A.activity_date > U.date_buyer_activated
GROUP BY 1,2
ORDER BY 1,2

