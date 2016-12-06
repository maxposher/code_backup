----------------------------------------------
--Male User filtered by average order price---
----------------------------------------------
SELECT buyer.user_id  AS "buyer.user_id", buyer.email
FROM analytics.dw_order_items  AS dw_order_items
LEFT JOIN analytics.dw_orders  AS "order" ON dw_order_items.order_id  = "order".order_id 
LEFT JOIN analytics.dw_users  AS buyer ON dw_order_items.buyer_id  = buyer.user_id 
WHERE ((((dw_order_items.booked_at_time ) >= ((DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ))) 
AND (dw_order_items.booked_at_time ) < ((DATEADD(day,90, DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ) ))))))
AND ((("order".order_gmv*0.01) < 50000 and ("order".booked_at) IS NOT NULL and ("order".order_state) IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND (DATE("order".booked_at ))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
AND buyer.gender ILIKE 'male'
GROUP BY 1, 2
HAVING (AVG((dw_order_items.order_item_gmv * .01) ) >= 100)   --Average Price of items purchased >= 100, adjust your value here
ORDER BY 1 
LIMIT 5000



---------------------------------------------------
--Male who bought atheletic brand in past 90 days--
---------------------------------------------------
SELECT buyer.user_id  AS "buyer.user_id", buyer.email
FROM analytics.dw_order_items  AS dw_order_items
LEFT JOIN analytics.dw_orders  AS "order" ON dw_order_items.order_id  = "order".order_id 
LEFT JOIN analytics.dw_listings  AS listing_details ON dw_order_items.listing_id = listing_details.listing_id 
AND ((listing_details.listing_price*.01) <= 75000 AND ( listing_details.create_source_type IS NULL  OR listing_details.parent_listing_id IS NOT NULL)) = TRUE 
LEFT JOIN analytics.dw_users  AS buyer ON dw_order_items.buyer_id  = buyer.user_id 
WHERE ((((dw_order_items.booked_at_time ) >= ((DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ))) 
AND (dw_order_items.booked_at_time ) < ((DATEADD(day,90, DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ) )))))) 

   AND (((initcap(listing_details.brand)) ILIKE 'Under  Armour' OR (initcap(listing_details.brand)) ILIKE 'nike'))      --Update your brand here, case insensitive, current Nike and Under Armour

AND (buyer.gender ILIKE 'male') AND ((("order".order_gmv*0.01) < 50000 
and ("order".booked_at) IS NOT NULL and ("order".order_state) IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND (DATE("order".booked_at ))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
AND buyer.gender ILIKE 'male' 
GROUP BY 1,2
ORDER BY 1 
LIMIT 5000



-----------------------------------------
--Male user who listed in past 90 days---
-----------------------------------------
SELECT lister.user_id  AS "lister.user_id", lister.email
FROM analytics.dw_listings  AS dw_listings
LEFT JOIN analytics.dw_users  AS lister ON dw_listings.seller_id  = lister.user_id 
WHERE ((((dw_listings.created_at ) >= ((DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ))) 
AND (dw_listings.created_at ) < ((DATEADD(day,90, DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ) )))))) 
AND (lister.gender ILIKE 'male') 
AND (((dw_listings.listing_price*.01) <= 75000 
AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
GROUP BY 1, 2
ORDER BY 1 
LIMIT 5000
