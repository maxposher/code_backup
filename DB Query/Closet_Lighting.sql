


--Primary Code
SELECT CASE WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 7 THEN '1. 1-7'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 BETWEEN 8 AND 30 THEN '2. 8-30'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 BETWEEN 31 AND 90 THEN '3. 31-90'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90 THEN '4. 90+' END AS Sell_Tiers,
            COUNT (distinct O.buyer_id),
            COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"     
            
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    lister.seller_activated_at >= lister.lister_activated_at
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.seller_activated_at, O.booked_at_time) + 1 <= 84
AND    DATEDIFF(day, lister.seller_activated_at, O.booked_at_time) + 1 >= 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND date(lister.buyer_activated_at) < date(lister.seller_activated_at) 
GROUP BY 1
ORDER BY 1



--No Buyer
SELECT CASE WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 7 THEN '1-7'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 BETWEEN 8 AND 30 THEN '8-30'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 BETWEEN 31 AND 90 THEN '31-90'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90 THEN '90+' END AS Sell_Tiers,
            COUNT (distinct lister.user_id)
      
FROM   analytics.dw_users as lister
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    lister.seller_activated_at >= lister.lister_activated_at
AND    date(lister.buyer_activated_at) >= date(lister.seller_activated_at)
AND    date(lister.buyer_activated_at) - date(lister.seller_activated_at) <= 84
AND    date(lister.joined_at) <= '2016-06-30'
GROUP BY 1




SELECT CASE WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 7 THEN '1-7'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 BETWEEN 8 AND 30 THEN '8-30'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 BETWEEN 31 AND 90 THEN '31-90'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90 THEN '90+' END AS Sell_Tiers,
            COUNT (distinct lister.user_id)
FROM   analytics.dw_users as lister
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    lister.seller_activated_at >= lister.lister_activated_at
AND    date(lister.seller_activated_at) > date(lister.buyer_activated_at)
AND    lister.buyer_activated_at is not null
--AND    date(lister.buyer_activated_at) - date(lister.seller_activated_at) + 1  <= 84
--AND    date(lister.buyer_activated_at) - date(lister.seller_activated_at) + 1  >= 1
AND    date(lister.joined_at) <= '2016-06-30'
GROUP BY 1



--Count Unique Buyers
SELECT CASE WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 7 THEN '1-7'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 BETWEEN 8 AND 30 THEN '8-30'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 BETWEEN 31 AND 90 THEN '31-90'
            WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90 THEN '90+' END AS Sell_Tiers,
            COUNT (distinct lister.user_id)
FROM   analytics.dw_users as lister
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    lister.seller_activated_at >= lister.lister_activated_at
--AND    date(lister.seller_activated_at) > date(lister.buyer_activated_at)
AND    lister.buyer_activated_at is not null
AND    date(lister.buyer_activated_at) - date(lister.seller_activated_at) + 1  <= 84
AND    date(lister.buyer_activated_at) - date(lister.seller_activated_at) + 1  >= 1
AND    date(lister.joined_at) <= '2016-06-30'
GROUP BY 1







SELECT CASE WHEN date(lister.lister_activated_at) + 1 <= 7 THEN '1-7'
            WHEN date(lister.lister_activated_at) + 1 BETWEEN 8 AND 30 THEN '8-30'
            WHEN date(lister.lister_activated_at) + 1 BETWEEN 31 AND 90 THEN '31-90'
            WHEN date(lister.lister_activated_at) + 1 > 90 THEN '90+' END AS Sell_Tiers,
            COUNT (distinct lister.user_id)
        
SELECT COUNT (distinct lister.user_id)
FROM   analytics.dw_users as lister
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    lister.seller_activated_at IS null

GROUP BY 1
ORDER BY 1




SELECT COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"          
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 <= 84 + 30
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 >= 30
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')


SELECT COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"          
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 <= 84 + 7
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 >= 7
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')


SELECT COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"          
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 <= 84 + 7
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 >= 7
AND    DATEDIFF(day, lister.lister_activated_at, lister.seller_activated_at) + 1 <= 7
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')



SELECT COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"          
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 <= 84 + 90
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 >= 90
AND    DATEDIFF(day, lister.lister_activated_at, lister.seller_activated_at) + 1 <= 90
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
                       
                       
                       
                       
--Everyday chart
-------------------------------------------------------------------------
SELECT CASE 
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 90 THEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90  THEN 91 END AS Lit_Day,
       COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"     
       
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    lister.seller_activated_at > lister.lister_activated_at  
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.seller_activated_at, O.booked_at_time) + 1 <= 84
AND    DATEDIFF(day, lister.seller_activated_at, O.booked_at_time) + 1 >= 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')                    
GROUP BY 1
ORDER BY 1

--Lister cohort
SELECT CASE 
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 90 THEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90  THEN 91 END AS Lit_Day,
       COUNT (distinct lister.user_id)
   
FROM   analytics.dw_users as lister
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    lister.seller_activated_at > lister.lister_activated_at  
AND    date(lister.joined_at) <= '2016-06-30'
        
GROUP BY 1
ORDER BY 1




SELECT CASE 
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 90 THEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90  THEN 91 END AS Lit_Day,
       COUNT (distinct O.seller_id),
       COALESCE(AVG((O.order_item_gmv * .01)), 0) AS "AOS"     
  
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.seller_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    lister.seller_activated_at > lister.lister_activated_at  
AND    date(lister.joined_at) <= '2016-06-30'
AND    O2.sale_number = 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')                    
GROUP BY 1
ORDER BY 1








SELECT CASE 
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 90 THEN  date(lister.seller_activated_at)  -   date(lister.lister_activated_at) + 1
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90  THEN 91 END AS Lit_Day,
       COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"     
            
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
--AND    lister.seller_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.seller_activated_at, booked_at_time) + 1 <= 84 
AND    DATEDIFF(day, lister.seller_activated_at, booked_at_time) + 1 >= 1 
AND    date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 >= 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')                  
GROUP BY 1
ORDER BY 1





SELECT COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"     
            
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 >=  1
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 <= 90
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')                  

GROUP BY 1
ORDER BY 1
             
             
             
             
             
SELECT CASE 
       WHEN date(O.booked_at_time) -   date(lister.lister_activated_at) + 1 <= 90 THEN  date(booked_at_time)  -   date(lister.lister_activated_at) + 1
       WHEN date(O.booked_at_time)  -   date(lister.lister_activated_at) + 1 > 90  THEN 91 END AS Lit_Day,
       COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"     
            
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.lister_activated_at, booked_at_time) + 1 <= 84 
AND    DATEDIFF(day, lister.lister_activated_at, booked_at_time) + 1 >= 1 
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')                  
GROUP BY 1
ORDER BY 1
                                 


--Count Buyers by date
SELECT CASE 
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 90 THEN  date(lister.seller_activated_at)  -   date(lister.lister_activated_at) + 1
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90  THEN 91 END AS Lit_Day,
       COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"     
            
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.seller_activated_at, booked_at_time) + 1 <= 84 
AND    DATEDIFF(day, lister.seller_activated_at, booked_at_time) + 1 >= 1 
AND    date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 >= 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')                  
GROUP BY 1
ORDER BY 1





--listers
SELECT CASE 
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 90 THEN  date(lister.seller_activated_at)  -   date(lister.lister_activated_at) + 1
       WHEN date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 > 90  THEN 91 END AS Lit_Day,
       COUNT (distinct lister.user_id) 
            
FROM   analytics.dw_users as lister
WHERE  lister.lister_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 >= 1
            
GROUP BY 1
ORDER BY 1

















SELECT COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"     
            
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.seller_activated_at, O.booked_at_time) + 1 <= 84
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND  date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 30     
AND  date(lister.seller_activated_at) - date(lister.lister_activated_at) + 1 >= 1                 


GROUP BY 1
ORDER BY 1




SELECT COUNT (distinct O.buyer_id),
       COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"     
            
FROM   analytics.dw_users as lister
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.user_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'

AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 >= 90
AND    DATEDIFF(day, lister.lister_activated_at, O.booked_at_time) + 1 <= 90 + 84
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND  date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 90     
AND  date(lister.seller_activated_at) - date(lister.lister_activated_at)   + 1 >= 1                 





SELECT COUNT (distinct lister.user_id)
            
FROM   analytics.dw_users as lister
WHERE  lister.lister_activated_at IS NOT NULL
AND    lister.seller_activated_at IS NOT NULL
AND    date(lister.joined_at) <= '2016-06-30'
AND  date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 <= 90    
AND  date(lister.seller_activated_at) -   date(lister.lister_activated_at) + 1 >= 1        








SELECT TO_CHAR(DATE(DATEADD(day,(0 - EXTRACT(DOW FROM dw_users.lister_activated_at)::integer), dw_users.lister_activated_at )), 'YYYY-MM-DD') AS "dw_users.lister_activated_week",
       CASE WHEN date(dw_users.seller_activated_at) -  date(dw_users.lister_activated_at) + 1 <= 7 Then 'D7' 
            WHEN date(dw_users.seller_activated_at) -  date(dw_users.lister_activated_at) + 1 <= 30 Then 'D30'
            WHEN date(dw_users.seller_activated_at) -  date(dw_users.lister_activated_at) + 1 <= 90 Then 'D90'
            WHEN date(dw_users.seller_activated_at) -  date(dw_users.lister_activated_at) + 1 > 90 Then '>90'
            ELSE 'Other' END AS "SA_Day",

            COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
WHERE (dw_users.lister_activated_at >= TIMESTAMP '2013-01-01') 
AND (COALESCE(dw_users.delete_reason,'') <> 'guest_secured')
GROUP BY 1,2
ORDER BY 1, 2 DESC
LIMIT 500



SELECT TO_CHAR(DATE(DATEADD(day,(0 - EXTRACT(DOW FROM dw_users.lister_activated_at)::integer), dw_users.lister_activated_at )), 'YYYY-MM-DD') AS "dw_users.lister_activated_week",
            COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
WHERE (dw_users.lister_activated_at >= TIMESTAMP '2013-01-01') 
AND (COALESCE(dw_users.delete_reason,'') <> 'guest_secured')
AND date(dw_users.seller_activated_at) -  date(dw_users.lister_activated_at) + 1 <= 90
AND date(dw_users.seller_activated_at) -  date(dw_users.lister_activated_at) + 1 >= 1
AND (dw_users.seller_activated_at) is not null
GROUP BY 1
ORDER BY 1 ASC
LIMIT 500




SELECT buyer_id,
       SUM(order_gmv*0.01) OVER (PARTITION BY buyer_id ORDER BY booked_at) AS running_total
FROM analytics.dw_orders 
WHERE booked_at > '2016-10-01'
limit 500


