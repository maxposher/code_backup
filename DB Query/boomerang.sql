

--First Week GMV

SELECT COUNT(*)
FROM(

SELECT  buyer.user_id AS "buyer.user_id",
	listing_details.category_v2 AS "category",
        dw_order_items.size_set AS "size_set",
        COUNT(distinct CASE WHEN "order".cancelled_reason is not null THEN dw_order_items.order_id ELSE NULL END) as "cancelled",
	COUNT(DISTINCT dw_order_items.order_id) AS "count_orders",
	SUM("order".order_gmv*0.01)
	
FROM analytics.dw_order_items AS dw_order_items
LEFT JOIN analytics.dw_orders AS "order" ON dw_order_items.order_id = "order".order_id
LEFT JOIN analytics.dw_listings AS listing_details ON dw_order_items.listing_id = listing_details.listing_id 
          AND ((listing_details.listing_price*.01) <= 75000 
          AND ( listing_details.create_source_type IS NULL OR listing_details.parent_listing_id IS NOT NULL)) = TRUE
LEFT JOIN analytics.dw_users AS buyer ON dw_order_items.buyer_id = buyer.user_id
WHERE ((DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 >= 1 
AND DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 <= 28)) 
AND ((((buyer.joined_at) >= (TIMESTAMP '2016-05-01') AND (buyer.joined_at) < (TIMESTAMP '2016-08-01')))) 
AND (buyer.lister_activated_at IS NULL) AND ((("order".order_gmv*0.01) < 50000 
AND buyer.acq_channel_lc not in ('rip')
AND ("order".booked_at) IS NOT NULL and ("order".order_state) IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
'waiting_seller_kyc_verification') AND (DATE("order".booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1,2,3 
ORDER BY 1)

limit 100







SELECT  buyer.user_id AS "buyer.user_id",
	listing_details.category_v2 AS "category",
        dw_order_items.size_set AS "size_set",
        COUNT(distinct CASE WHEN "order".cancelled_reason is not null THEN dw_order_items.order_id ELSE NULL END) as "cancelled",
	COUNT(DISTINCT dw_order_items.order_id) AS "count_orders",
	SUM("order".order_gmv*0.01)
	
FROM analytics.dw_order_items AS dw_order_items
LEFT JOIN analytics.dw_orders AS "order" ON dw_order_items.order_id = "order".order_id
LEFT JOIN analytics.dw_listings AS listing_details ON dw_order_items.listing_id = listing_details.listing_id 
          AND ((listing_details.listing_price*.01) <= 75000 
          AND ( listing_details.create_source_type IS NULL OR listing_details.parent_listing_id IS NOT NULL)) = TRUE
LEFT JOIN analytics.dw_users AS buyer ON dw_order_items.buyer_id = buyer.user_id
WHERE ((DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 >= 1 
AND DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 <= 7)) 
AND ((((buyer.joined_at) >= (TIMESTAMP '2016-05-01') AND (buyer.joined_at) < (TIMESTAMP '2016-08-01')))) 
AND (buyer.lister_activated_at IS NULL) AND ((("order".order_gmv*0.01) < 50000 
AND buyer.acq_channel_lc not in ('rip')
AND ("order".booked_at) IS NOT NULL and ("order".order_state) IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
'waiting_seller_kyc_verification') AND (DATE("order".booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1,2,3 
ORDER BY 1

limit 100





SELECT  buyer.user_id AS "buyer.user_id",
	SUM("order".order_gmv*0.01)
FROM analytics.dw_order_items AS dw_order_items
LEFT JOIN analytics.dw_orders AS "order" ON dw_order_items.order_id = "order".order_id
LEFT JOIN analytics.dw_listings AS listing_details ON dw_order_items.listing_id = listing_details.listing_id 
          AND ((listing_details.listing_price*.01) <= 75000 
          AND ( listing_details.create_source_type IS NULL OR listing_details.parent_listing_id IS NOT NULL)) = TRUE
LEFT JOIN analytics.dw_users AS buyer ON dw_order_items.buyer_id = buyer.user_id
WHERE ((DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 >= 84 
AND DATEDIFF(day, (DATE(buyer.buyer_activated_at)), (DATE(dw_order_items.booked_at_time))) + 1 <= 168)) 
AND ((((buyer.joined_at) >= (TIMESTAMP '2016-05-01') AND (buyer.joined_at) < (TIMESTAMP '2016-08-01')))) 
AND (buyer.lister_activated_at IS NULL) AND ((("order".order_gmv*0.01) < 50000 
AND buyer.acq_channel_lc not in ('rip')
AND ("order".booked_at) IS NOT NULL and ("order".order_state) IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
'waiting_seller_kyc_verification') AND (DATE("order".booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1
ORDER BY 1

limit 100






SELECT 
	TO_CHAR(DATE(DATEADD(day,(0 - EXTRACT(DOW FROM seller.lister_activated_at)::integer), seller.lister_activated_at )), 'YYYY-MM-DD') AS "seller.lister_activated_week",
	DATEDIFF(week, seller.lister_activated_at,dw_order_items.booked_at_time) + 1 AS "dw_order_items.weeks_since_lister_activated",
	COALESCE(SUM((dw_order_items.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"
FROM analytics.dw_order_items AS dw_order_items
LEFT JOIN analytics.dw_orders AS "order" ON dw_order_items.order_id = "order".order_id
LEFT JOIN analytics.dw_users AS seller ON dw_order_items.buyer_id = seller.user_id

WHERE ((DATEDIFF(week, seller.lister_activated_at,dw_order_items.booked_at_time) + 1 >= 1 AND DATEDIFF(week, seller.lister_activated_at,dw_order_items.booked_at_time) + 1 <= 52)) AND ((((seller.lister_activated_at) >= ((DATEADD(week,-51, DATE(DATEADD(day,(0 - EXTRACT(DOW FROM DATE_TRUNC('day',GETDATE()))::integer), DATE_TRUNC('day',GETDATE()) )) ))) AND (seller.lister_activated_at) < ((DATEADD(week,52, DATEADD(week,-51, DATE(DATEADD(day,(0 - EXTRACT(DOW FROM DATE_TRUNC('day',GETDATE()))::integer), DATE_TRUNC('day',GETDATE()) )) ) )))))) AND ((("order".order_gmv*0.01) < 50000 and ("order".booked_at) IS NOT NULL and ("order".order_state) IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') AND (DATE("order".booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1,2
ORDER BY 1
