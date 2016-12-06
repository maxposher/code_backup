
--Buyer D1
SELECT TO_CHAR(DATE_TRUNC('quarter', buyer.buyer_activated_at), 'YYYY-MM') AS "buyer.buyer_activated_quarter",
        buyer.user_id,
	COUNT(DISTINCT dw_orders.buyer_id) AS "dw_orders.buyer_count",
	COUNT(*) AS "dw_orders.count_orders",
	COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) AS "dw_orders.total_order_gmv"
FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
LEFT JOIN analytics.dw_orders AS buyer_first_order ON dw_orders.buyer_id = buyer_first_order.buyer_id and buyer_first_order.order_number=1

WHERE ((DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_orders.booked_at))) + 1 >= 1 
--AND DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_orders.booked_at))) + 1 <= 30)) 
AND (buyer.buyer_activated_at >= TIMESTAMP '2013-01-01') 
AND ((CASE WHEN (buyer.joined_at < '2014-10-01' 
and buyer.acq_channel not in ('rip')) THEN buyer.heuristical_acq_channel 
WHEN buyer.acq_channel IN ('rip') OR buyer.is_referred_with_code in ('Yes') THEN 'rip' ELSE buyer.acq_channel END NOT ILIKE 'rip' 
OR 
CASE WHEN (buyer.joined_at < '2014-10-01' and buyer.acq_channel not in ('rip')) THEN buyer.heuristical_acq_channel WHEN buyer.acq_channel IN ('rip') 
OR buyer.is_referred_with_code in ('Yes') THEN 'rip' ELSE buyer.acq_channel END IS NULL)) 
AND dw_orders.order_gmv*0.01 < 50000 and dw_orders.booked_at IS NOT NULL 
AND dw_orders.order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
'waiting_seller_kyc_verification') 
AND TO_CHAR(DATE_TRUNC('quarter', buyer.buyer_activated_at), 'YYYY-MM') IN ('2013-04', '2014-04', '2015-04')
GROUP BY 1,2
ORDER BY 1 DESC
LIMIT 50