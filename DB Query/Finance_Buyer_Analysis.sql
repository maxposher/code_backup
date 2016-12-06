

--Days since lister activated
--No other logics
--Need to deal with lister, join date issue
SELECT 
	TO_CHAR(DATE(DATEADD(day,(0 - EXTRACT(DOW FROM buyer.joined_at)::integer), buyer.joined_at )), 'YYYY-MM-DD') AS "buyer.joined_week",
	DATEDIFF(week, (DATE(buyer.lister_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 AS "weeks_since_lister_activated",
	COALESCE(SUM((dw_order_items.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"
FROM analytics.dw_order_items AS dw_order_items
LEFT JOIN analytics.dw_orders AS "order" ON dw_order_items.order_id = "order".order_id
LEFT JOIN analytics.dw_users AS buyer ON dw_order_items.buyer_id = buyer.user_id
WHERE ((DATEDIFF(day, (DATE(buyer.lister_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 >= 1 
AND DATEDIFF(day, (DATE(buyer.lister_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 <= 60)) 
AND (buyer.joined_at >= TIMESTAMP '2016-01-01') AND ((("order".order_gmv*0.01) < 50000 
and ("order".booked_at) IS NOT NULL and ("order".order_state) 
IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 
'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND (DATE("order".booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1,2
limit 100



--Weeks since join
SELECT 
	TO_CHAR(DATE(DATEADD(day,(0 - EXTRACT(DOW FROM buyer.joined_at)::integer), buyer.joined_at )), 'YYYY-MM-DD') AS "buyer.joined_week",
	DATEDIFF(week, (DATE(buyer.buyer_activated_at)), (DATE(buyer.joined_at))) + 1 AS "weeks_since_joined",
	COALESCE(SUM((dw_order_items.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"
FROM analytics.dw_order_items AS dw_order_items
LEFT JOIN analytics.dw_orders AS "order" ON dw_order_items.order_id = "order".order_id
LEFT JOIN analytics.dw_users AS buyer ON dw_order_items.buyer_id = buyer.user_id
WHERE ((DATEDIFF(day, (DATE(buyer.joined_at)), (DATE(dw_order_items.booked_at_time))) + 1 >= 1 
AND DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 <= 60)) 
AND (buyer.joined_at >= TIMESTAMP '2016-01-01') AND ((("order".order_gmv*0.01) < 50000 
and ("order".booked_at) IS NOT NULL and ("order".order_state) 
IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 
'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND (DATE("order".booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1,2
limit 100



--Days since Buyer activated
--No other logics
SELECT 
	TO_CHAR(DATE(DATEADD(day,(0 - EXTRACT(DOW FROM buyer.joined_at)::integer), buyer.joined_at )), 'YYYY-MM-DD') AS "buyer.joined_week",
	DATEDIFF(week, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 AS "weeks_since_lister_activated",
	COALESCE(SUM((dw_order_items.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"
FROM analytics.dw_order_items AS dw_order_items
LEFT JOIN analytics.dw_orders AS "order" ON dw_order_items.order_id = "order".order_id
LEFT JOIN analytics.dw_users AS buyer ON dw_order_items.buyer_id = buyer.user_id

WHERE ((DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 >= 1 
AND DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 <= 60)) 
AND (buyer.joined_at >= TIMESTAMP '2016-01-01') AND ((("order".order_gmv*0.01) < 50000 
and ("order".booked_at) IS NOT NULL and ("order".order_state) 
IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 
'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND (DATE("order".booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1,2
limit 100
