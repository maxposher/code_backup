


  SELECT L.create_source_type, L.parent_listing_id 
  FROM analytics.dw_listings as L
  WHERE L.create_source_type = 'system'
  AND   L.parent_listing_id IS NOT NULL
  limit 10
  
  
  
  SELECT  L.create_source_type
  FROM analytics.dw_listings as L
  WHERE L.listing_id = '570c413c9c6fcf44e2011c8a'
  
  
  
  SELECT *
  FROM analytics.dw_listings as L
  WHERE L.parent_listing_id = '570c413c9c6fcf44e2011c8a'
  
  
  
  --Top 10%
  
  SELECT app, percentile_cont(0.1) within group (order by GMV_Diff desc) over(partition by app)
  FROM(
  SELECT 
	DATE(buyer_first_order.booked_at) AS "buyer_first_order.booked_date",
	dw_orders.app,
	COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) - COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)*0.75 AS "GMV_Diff"	
  FROM analytics.dw_orders AS dw_orders
  LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
  LEFT JOIN analytics.dw_orders AS buyer_first_order ON dw_orders.buyer_id = buyer_first_order.buyer_id and buyer_first_order.order_number=1
  WHERE ((((buyer_first_order.booked_at) >= ((DATEADD(day,-30, DATE_TRUNC('day',GETDATE()) ))) 
  AND (buyer_first_order.booked_at) < ((DATEADD(day,31, DATEADD(day,-30, DATE_TRUNC('day',GETDATE()) ) )))))) 
  AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL and dw_orders.order_state 
  IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
  'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
  'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
  'seller_ab_update_failed', 'waiting_seller_kyc_verification') AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
  GROUP BY 1,2
  ORDER BY 1 DESC
  limit 50)
  limit 10


  
   SELECT app, percentile_cont(0.1) within group (order by GMV_Diff desc) over(partition by app)
  FROM(
  
    SELECT 
	DATE(buyer_first_order.booked_at) AS "buyer_first_order.booked_date",
	dw_orders.app,
	COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) - COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)*0.75 AS "GMV_Diff"
	
  FROM analytics.dw_orders AS dw_orders
  LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
  LEFT JOIN analytics.dw_orders AS buyer_first_order ON dw_orders.buyer_id = buyer_first_order.buyer_id and buyer_first_order.order_number=1
  WHERE ((((buyer_first_order.booked_at) >= ((DATEADD(day,-60, DATE_TRUNC('day',GETDATE()) ))) AND (buyer_first_order.booked_at) < ((DATEADD(day,61, DATEADD(day,-60, DATE_TRUNC('day',GETDATE()) ) )))))) 
  AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL 
  and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
  'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
  'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
  AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
  GROUP BY 1,2
  ORDER BY 1 DESC
 -- limit 50
  )
  --WHERE app = 'ipad'
  --limit 1

  
  
  SELECT *
  FROM(
      SELECT 
	DATE(buyer_first_order.booked_at) AS "buyer_first_order.booked_date",
	COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) - COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)*0.75 AS "GMV_Diff",
	percent_rank()  over(order by (COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) - COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)*0.75)) AS per_rank
	
  FROM analytics.dw_orders AS dw_orders
  LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
  LEFT JOIN analytics.dw_orders AS buyer_first_order ON dw_orders.buyer_id = buyer_first_order.buyer_id and buyer_first_order.order_number=1
  WHERE ((((buyer_first_order.booked_at) >= ((DATEADD(day,-60, DATE_TRUNC('day',GETDATE()) ))) AND (buyer_first_order.booked_at) < ((DATEADD(day,61, DATEADD(day,-60, DATE_TRUNC('day',GETDATE()) ) )))))) 
  AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL 
  and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
  'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
  'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
  AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
  GROUP BY 1
  ORDER BY 1 DESC
  limit 50)
  WHERE per_rank >= 0.1
  
  
  SELECT COUNT(*)
  FROM(
  
      SELECT 
	DATE(buyer_first_order.booked_at) AS "buyer_first_order.booked_date",
	dw_orders.app,
	COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) - COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)*0.75 AS "GMV_Diff"
	
  FROM analytics.dw_orders AS dw_orders
  LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
  LEFT JOIN analytics.dw_orders AS buyer_first_order ON dw_orders.buyer_id = buyer_first_order.buyer_id and buyer_first_order.order_number=1
  WHERE ((((buyer_first_order.booked_at) >= ((DATEADD(day,-60, DATE_TRUNC('day',GETDATE()) ))) AND (buyer_first_order.booked_at) < ((DATEADD(day,61, DATEADD(day,-60, DATE_TRUNC('day',GETDATE()) ) )))))) 
  AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL 
  and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
  'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
  'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
  AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
  GROUP BY 1,2
  ORDER BY 1 DESC
  limit 50)
  WHERE GMV_Diff >= 74974.9275
  
  
  
  
  
  select date_part(week, booked_at), booked_at
  FROM analytics.dw_orders AS O
  WHERE date(O.booked_at) = '2016-01-03'
  limit 100
  
  
  
  SELECT app, ranks
  FROM(
     SELECT app, percentile_cont(0.1) within group (order by GMV_Diff desc) over(partition by app) AS "ranks"
  FROM(
  
    SELECT 
	DATE(buyer_first_order.booked_at) AS "buyer_first_order.booked_date",
	dw_orders.app,
	COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) - COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)*0.75 AS "GMV_Diff"
  FROM analytics.dw_orders AS dw_orders
  LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
  LEFT JOIN analytics.dw_orders AS buyer_first_order ON dw_orders.buyer_id = buyer_first_order.buyer_id and buyer_first_order.order_number=1
  WHERE ((((buyer_first_order.booked_at) >= ((DATEADD(day,-60, DATE_TRUNC('day',GETDATE()) ))) AND (buyer_first_order.booked_at) < ((DATEADD(day,61, DATEADD(day,-60, DATE_TRUNC('day',GETDATE()) ) )))))) 
  AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL 
  and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
  'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
  'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
  AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
  GROUP BY 1,2
  ORDER BY 1 DESC
  )
  )
  GROUP BY 1,2
  limit 50
  
  
  
  
  