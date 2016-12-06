


SELECT COUNT(distinct user_id)
FROM(
SELECT seller.user_id, COUNT(distinct order_id) AS "Sales", 
SUM(CASE WHEN order_state = 'cancelled' and cancelled_reason = 'delayed_order' THEN 1 ELSE 0 END) AS "Cancel",
SUM(CASE WHEN order_state = 'cancelled' and cancelled_reason = 'delayed_order' THEN 1 ELSE 0 END) / COUNT(distinct order_id)
::decimal(10,2) AS "Threshold"

FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS seller ON dw_orders.seller_id = seller.user_id
WHERE ((((dw_orders.booked_at) >= (TIMESTAMP '2016-02-01') 
AND (dw_orders.booked_at) < (TIMESTAMP '2016-09-01')))) AND (dw_orders.order_gmv*0.01) < 50000 
and dw_orders.booked_at IS NOT NULL and dw_orders.order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
GROUP BY 1)
WHERE Sales >= 3
AND   Cancel >= 2
AND   Threshold >= 0.5


LIMIT 500


SELECT seller.user_id, COUNT(distinct order_id), 
SUM(CASE WHEN order_state = 'cancelled' and cancelled_reason = 'delayed_order' THEN 1 ELSE 0 END) AS "Cancel",
SUM(CASE WHEN order_state = 'cancelled' and cancelled_reason = 'delayed_order' THEN 1 ELSE 0 END) / COUNT(distinct order_id)
::decimal(10,2) AS "Threshold"
FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS seller ON dw_orders.seller_id = seller.user_id
WHERE (dw_orders.sale_number >= 3) AND ((((dw_orders.booked_at) >= (TIMESTAMP '2016-02-01') 
AND (dw_orders.booked_at) < (TIMESTAMP '2016-09-01')))) AND (dw_orders.order_gmv*0.01) < 50000 
and dw_orders.booked_at IS NOT NULL and dw_orders.order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
GROUP BY 1
HAVING SUM(CASE WHEN order_state = 'cancelled' and cancelled_reason = 'delayed_order' THEN 1 ELSE 0 END)  > 3

limit 10






SELECT distinct cancelled_reason
FROM analytics.dw_orders
LIMIT 10