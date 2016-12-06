
With Sale AS (
SELECT  L.created_at AS "event", L.seller_id, min(O.booked_at) AS "lit_day"
FROM analytics.dw_listings AS L
LEFT JOIN analytics.dw_orders AS O on L.seller_id = O.seller_id
WHERE (L.listing_number = 100) AND date(L.created_at) <= '2016-06-30'
AND (((L.listing_price*.01) <= 75000 AND ( L.create_source_type IS NULL  OR L.parent_listing_id IS NOT NULL)) = TRUE)
--AND date(O.booked_at) <= '2016-06-30'
AND O.booked_at > L.created_at
AND O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
GROUP BY 1, 2) 

SELECT CASE WHEN date(lister.lit_day) -   date(lister.event) + 1 <= 7 THEN '1. 1-7'
            WHEN date(lister.lit_day) -   date(lister.event) + 1 BETWEEN 8 AND 30 THEN '2. 8-30'
            WHEN date(lister.lit_day) -   date(lister.event) + 1 BETWEEN 31 AND 90 THEN '3. 31-90'
            WHEN date(lister.lit_day) -   date(lister.event) + 1 > 90 THEN '4. 90+' END AS Sell_Tiers,
            COUNT (distinct O.buyer_id),
            COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"      
FROM   analytics.dw_users AS U
LEFT JOIN Sale as lister  ON lister.seller_id = U.user_id
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.seller_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  date(U.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.lit_day, O.booked_at_time) + 1 <= 84
AND    DATEDIFF(day, lister.lit_day, O.booked_at_time) + 1 >= 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
GROUP BY 1
ORDER BY 1









SELECT *
FROM(
SELECT  L.created_at AS "event", L.seller_id, min(O.booked_at) AS "lit_day"
FROM analytics.dw_listings AS L
LEFT JOIN analytics.dw_orders AS O on L.seller_id = O.seller_id
WHERE (L.listing_number = 10) AND date(L.created_at) <= '2016-06-30'
AND (((L.listing_price*.01) <= 75000 AND ( L.create_source_type IS NULL  OR L.parent_listing_id IS NOT NULL)) = TRUE)
AND date(O.booked_at) <= '2016-06-30'
AND (O.booked_at > L.created_at OR O.booked_at is null)
--'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
--'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
--'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
GROUP BY 1, 2)

WHERE lit_day is NULL
LIMIT 100



SELECT *
FROM(
SELECT  L.created_at AS "event", L.seller_id, min(O.booked_at) AS "lit_day"
FROM analytics.dw_listings AS L
LEFT JOIN analytics.dw_orders AS O on L.seller_id = O.seller_id
WHERE (L.listing_number = 10) AND date(L.created_at) <= '2016-06-30'
AND (((L.listing_price*.01) <= 75000 AND ( L.create_source_type IS NULL  OR L.parent_listing_id IS NOT NULL)) = TRUE)
AND (date(O.booked_at) <= '2016-06-30' or O.booked_at is null)
AND (O.booked_at > L.created_at OR O.booked_at is null)
GROUP BY 1, 2)

WHERE lit_day is NULL
LIMIT 100




With Sale AS (
SELECT  L.created_at AS "event", L.seller_id, min(O.booked_at) AS "lit_day"
FROM analytics.dw_listings AS L
LEFT JOIN analytics.dw_orders AS O on L.seller_id = O.seller_id
WHERE (L.listing_number = 100) AND date(L.created_at) <= '2016-06-30'
AND (((L.listing_price*.01) <= 75000 AND ( L.create_source_type IS NULL  OR L.parent_listing_id IS NOT NULL)) = TRUE)
AND (O.booked_at is not null or O.booked_at is null)
AND (O.booked_at > L.created_at OR O.booked_at is null)
AND (O.order_state is NULL OR O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')) 
GROUP BY 1, 2) 

SELECT CASE WHEN date(lister.lit_day) -   date(lister.event) + 1 <= 7 THEN '1. 1-7'
            WHEN date(lister.lit_day) -   date(lister.event) + 1 BETWEEN 8 AND 30 THEN '2. 8-30'
            WHEN date(lister.lit_day) -   date(lister.event) + 1 BETWEEN 31 AND 90 THEN '3. 31-90'
            WHEN date(lister.lit_day) -   date(lister.event) + 1 > 90 THEN '4. 90+' END AS Sell_Tiers,
            COUNT (distinct lister.seller_id)  
FROM  Sale AS lister
GROUP BY 1
ORDER BY 1









--Repeat never lit
With Sale as (
        SELECT  L.created_at AS "event", L.seller_id, min(O.booked_at) AS "lit_day"
        FROM analytics.dw_listings AS L
        LEFT JOIN analytics.dw_orders AS O on L.seller_id = O.seller_id
        WHERE (L.listing_number = 10) AND date(L.created_at) <= '2016-06-30'
        AND (((L.listing_price*.01) <= 75000 AND ( L.create_source_type IS NULL  OR L.parent_listing_id IS NOT NULL)) = TRUE)
        AND (O.booked_at > L.created_at OR O.booked_at is null)
        AND (O.order_state is NULL OR O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
        'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
        'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')) 
GROUP BY 1, 2)


SELECT COUNT (distinct O.buyer_id), COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"      
FROM   analytics.dw_users AS U
LEFT JOIN Sale as lister  ON lister.seller_id = U.user_id
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.seller_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE  date(U.joined_at) <= '2016-06-30'
AND    DATEDIFF(day, lister.event, O.booked_at_time) + 1 <= 84 + 90
AND    DATEDIFF(day, lister.event, O.booked_at_time) + 1 >= 1 + 90
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND  (lit_day is null OR date(lit_day) - date(event) + 1 > 90)



GROUP BY 1
ORDER BY 1



-----------------------------------------------------------------------
-----------------------------------------------------------------------
SELECT 
	seller.user_id AS "seller.user_id",
	COALESCE(SUM((O.order_gmv * .01)), 0)
FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS seller ON dw_orders.seller_id = seller.user_id
LEFT JOIN analytics.dw_orders AS O ON O.seller_id = seller.user_id

WHERE seller.joined_at < (TIMESTAMP '2016-07-01')
AND (((O.order_gmv*0.01) < 50000 and O.booked_at IS NOT NULL 
and O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 

GROUP BY 1
ORDER BY 2 DESC
LIMIT 500



SELECT    seller.user_id AS "seller.user_id",
	  COALESCE(SUM((O.order_gmv * .01)), 0) AS "Sale",
	  COALESCE(SUM((O2.order_gmv)), 0) AS "Purchase"
	 
FROM      analytics.dw_users AS seller
LEFT JOIN analytics.dw_orders AS O ON O.seller_id = seller.user_id
LEFT JOIN (Select buyer_id,  COALESCE(SUM((order_gmv * .01)), 0) AS "order_gmv"
           FROM   analytics.dw_orders
           WHERE  order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                                   'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                                    'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
                                    'waiting_seller_kyc_verification')
           GROUP BY 1) AS O2 ON seller.user_id = O2.buyer_id
WHERE  seller.joined_at < (TIMESTAMP '2016-07-01')
AND O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
'waiting_seller_kyc_verification') 

GROUP BY 1
LIMIT 200




SELECT    seller.user_id AS "seller.user_id",
	  COALESCE(SUM((O.order_gmv * .01)), 0) AS "Sale",
	  avg(O2.order_gmv) AS "Purchase"
	 
FROM      analytics.dw_users AS seller
LEFT JOIN analytics.dw_orders AS O ON O.seller_id = seller.user_id
LEFT JOIN (Select buyer_id,  COALESCE(SUM((order_gmv * .01)), 0) AS "order_gmv"
           FROM   analytics.dw_orders
           WHERE  order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                                   'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                                    'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
                                    'waiting_seller_kyc_verification')
           GROUP BY 1) AS O2 ON seller.user_id = O2.buyer_id
WHERE  seller.joined_at < (TIMESTAMP '2016-07-01')
AND    seller.joined_at > (TIMESTAMP '2013-12-31')
AND O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
'waiting_seller_kyc_verification') 

GROUP BY 1









SELECT    seller.user_id AS "seller.user_id",
	  COALESCE(SUM((O.order_gmv * .01)), 0) AS "Sale",
	  avg(O2.order_gmv) AS "Purchase"
	 
FROM      analytics.dw_users AS seller
LEFT JOIN analytics.dw_orders AS O ON O.seller_id = seller.user_id
LEFT JOIN (Select buyer_id,  COALESCE(SUM((order_gmv * .01)), 0) AS "order_gmv"
           FROM   analytics.dw_orders
           WHERE  order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                                   'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                                    'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
                                    'waiting_seller_kyc_verification')
           GROUP BY 1) AS O2 ON seller.user_id = O2.buyer_id
WHERE  seller.joined_at < (TIMESTAMP '2016-07-01')
AND    seller.joined_at > (TIMESTAMP '2013-12-31')
AND O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 
'waiting_seller_kyc_verification') 
GROUP BY 1



-------------------------------------
-------------------------------------

/* Default Code */
      SELECT Booked_L28, COUNT(distinct user_id) AS Return_Buyer
      FROM    
     (
      SELECT user_id, Booked_L28, L28_number, lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order
      FROM                   
       (         
        SELECT U.user_id, O.booked_at, O.order_number,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',         date(U.buyer_activated_at) )/28)), '2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', date(U.buyer_activated_at) )/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00') AS BA_Cohort_L28,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1, '00')           AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00',  date(U.buyer_activated_at)  )/28)+1) + 1                    AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE 
        order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
        )
                )
       WHERE L28_number - last_order = 1
       GROUP BY 1 
       ORDER BY 1
       limit 100



lag(l28_number,1) over(partition by user_id order by L28_number) AS 




/********************************************************************************/


WITH Sale_Day AS (
SELECT seller_id, booked_at AS "lit_day",lag(booked_at,1) over(partition by seller_id order by booked_at) AS "Last_Sale",
       date(booked_at) - date(lag(booked_at,1) over(partition by seller_id order by booked_at)) AS "Day_Since_Last_Sale"
FROM   analytics.dw_orders AS O
LEFT JOIN analytics.dw_users AS U ON O.seller_id = U.user_id 
WHERE date(U.joined_at) <= '2016-06-30'      
AND  order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
     'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
     'seller_kyc_verified', 'seller_notification_initiated', 
     'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
     'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
     'seller_ab_update_failed', 'waiting_seller_kyc_verification')  
order BY 1,2  
)

SELECT CASE WHEN Day_Since_Last_Sale + 1 <= 7 THEN '1. 1-7'
            WHEN Day_Since_Last_Sale + 1 BETWEEN 8 AND 30 THEN '2. 8-30'
            WHEN Day_Since_Last_Sale + 1 BETWEEN 31 AND 90 THEN '3. 31-90'
            WHEN Day_Since_Last_Sale + 1 > 90 THEN '4. 90+' END AS Sell_Tiers,
            COUNT (distinct O.buyer_id),
            COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"      
FROM Sale_Day as lister  
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.seller_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE 
       DATEDIFF(day, lister.lit_day, O.booked_at_time) + 1 <= 84
AND    DATEDIFF(day, lister.lit_day, O.booked_at_time) + 1 >= 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
GROUP BY 1
ORDER BY 1




SELECT CASE WHEN Day_Since_Last_Sale + 1 <= 7 THEN '1. 1-7'
            WHEN Day_Since_Last_Sale + 1 BETWEEN 8 AND 30 THEN '2. 8-30'
            WHEN Day_Since_Last_Sale + 1 BETWEEN 31 AND 90 THEN '3. 31-90'
            WHEN Day_Since_Last_Sale + 1 > 90 THEN '4. 90+' END AS Sell_Tiers,
            COUNT (*)
FROM(
SELECT seller_id, booked_at AS "lit_day",lag(booked_at,1) over(partition by seller_id order by booked_at) AS "Last_Sale",
       date(booked_at) - date(lag(booked_at,1) over(partition by seller_id order by booked_at)) AS "Day_Since_Last_Sale"
FROM   analytics.dw_orders AS O
LEFT JOIN analytics.dw_users AS U ON O.seller_id = U.user_id 
WHERE date(U.joined_at) <= '2016-06-30'      
AND  order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
     'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
     'seller_kyc_verified', 'seller_notification_initiated', 
     'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
     'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
     'seller_ab_update_failed', 'waiting_seller_kyc_verification')  
order BY 1,2 )
GROUP BY 1
ORDER BY 1


limit 10



---------------Seller Data Repeat--------------------------------------------------------
WITH Sale_Day AS (
SELECT seller_id, booked_at AS "lit_day",lag(booked_at,1) over(partition by seller_id order by booked_at) AS "Last_Sale",
       date(booked_at) - date(lag(booked_at,1) over(partition by seller_id order by booked_at)) AS "Day_Since_Last_Sale"
FROM   analytics.dw_orders AS O
LEFT JOIN analytics.dw_users AS U ON O.seller_id = U.user_id 
WHERE date(U.joined_at) <= '2016-06-30'      
AND  order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
     'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
     'seller_kyc_verified', 'seller_notification_initiated', 
     'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
     'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
     'seller_ab_update_failed', 'waiting_seller_kyc_verification')  
order BY 1,2  
)

SELECT CASE WHEN Day_Since_Last_Sale + 1 <= 30 THEN 30
            WHEN Day_Since_Last_Sale + 1 BETWEEN 31 AND 120  THEN Day_Since_Last_Sale + 1
            WHEN Day_Since_Last_Sale + 1 > 120 THEN 121 END AS Sell_Tiers,
            COUNT (distinct O.buyer_id),
            COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"      
FROM Sale_Day as lister  
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.seller_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
WHERE 
       DATEDIFF(day, lister.lit_day, O.booked_at_time) + 1 <= 84
AND    DATEDIFF(day, lister.lit_day, O.booked_at_time) + 1 >= 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
GROUP BY 1
ORDER BY 1



SELECT CASE WHEN Day_Since_Last_Sale + 1 <= 30 THEN 30
            WHEN Day_Since_Last_Sale + 1 BETWEEN 31 AND 120  THEN Day_Since_Last_Sale + 1
            WHEN Day_Since_Last_Sale + 1 > 120 THEN 121 END AS Sell_Tiers,
            COUNT (*)
FROM(
SELECT seller_id, booked_at AS "lit_day",lag(booked_at,1) over(partition by seller_id order by booked_at) AS "Last_Sale",
       date(booked_at) - date(lag(booked_at,1) over(partition by seller_id order by booked_at)) AS "Day_Since_Last_Sale"
FROM   analytics.dw_orders AS O
LEFT JOIN analytics.dw_users AS U ON O.seller_id = U.user_id 
WHERE date(U.joined_at) <= '2016-06-30'      
AND  order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
     'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
     'seller_kyc_verified', 'seller_notification_initiated', 
     'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
     'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
     'seller_ab_update_failed', 'waiting_seller_kyc_verification')  
order BY 1,2 )
GROUP BY 1
ORDER BY 1




---------------------------------------------------------------------------
WITH Sale_Day AS (
SELECT seller_id, booked_at AS "lit_day",lag(booked_at,1) over(partition by seller_id order by booked_at) AS "Last_Sale",
       date(booked_at) - date(lag(booked_at,1) over(partition by seller_id order by booked_at)) AS "Day_Since_Last_Sale"
FROM   analytics.dw_orders AS O
LEFT JOIN analytics.dw_users AS U ON O.seller_id = U.user_id 
WHERE date(U.joined_at) <= '2016-06-30'
AND   date(booked_at)  <=  '2016-06-30'     
AND  order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
     'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
     'seller_kyc_verified', 'seller_notification_initiated', 
     'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
     'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
     'seller_ab_update_failed', 'waiting_seller_kyc_verification')  
--AND sale_number >= 2       
order BY 1,2),

Longest AS (
SELECT seller_id, max(Day_Since_Last_Sale) as m_day
FROM Sale_Day
GROUP BY 1) 


SELECT CASE --WHEN Day_Since_Last_Sale + 1 <= 30 THEN 30
            WHEN Day_Since_Last_Sale + 1 BETWEEN 1 AND 120  THEN Day_Since_Last_Sale + 1
            WHEN Day_Since_Last_Sale + 1 > 120 THEN 121 END AS Sell_Tiers,
            COUNT ( distinct O.buyer_id),
            COALESCE(SUM((O.order_item_gmv * .01)), 0) AS "dw_order_items.total_order_item_gmv"      
FROM Sale_Day as lister  
LEFT JOIN analytics.dw_order_items AS O ON O.buyer_id = lister.seller_id
LEFT JOIN analytics.dw_orders AS O2 ON O2.order_id = O.order_id
INNER JOIN Longest AS L on Lister.seller_id = L.seller_id and Lister.Day_Since_Last_Sale = L.m_day -- and Lister.Last_Sale = l.l_day
WHERE 
       DATEDIFF(day, lister.lit_day, O.booked_at_time) + 1 <= 84
AND    DATEDIFF(day, lister.lit_day, O.booked_at_time) + 1 >= 1
AND    O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                       'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
                       'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 
                       'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
GROUP BY 1
ORDER BY 1



WITH Sale_Day AS (
SELECT seller_id, booked_at AS "lit_day",lag(booked_at,1) over(partition by seller_id order by booked_at) AS "Last_Sale",
       date(booked_at) - date(lag(booked_at,1) over(partition by seller_id order by booked_at)) AS "Day_Since_Last_Sale"
FROM   analytics.dw_orders AS O
LEFT JOIN analytics.dw_users AS U ON O.seller_id = U.user_id 
WHERE date(U.joined_at) <= '2016-06-30'
AND   date(booked_at)  <=  '2016-06-30'        
AND  order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
     'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
     'seller_kyc_verified', 'seller_notification_initiated', 
     'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
     'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
     'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
--AND sale_number >= 2       
order BY 1,2),

Longest AS (
SELECT S.seller_id, max(Day_Since_Last_Sale) AS m_day
FROM Sale_Day AS S
GROUP BY 1)

SELECT CASE WHEN S.Day_Since_Last_Sale + 1 BETWEEN 1 AND 120  THEN S.Day_Since_Last_Sale + 1
            WHEN S.Day_Since_Last_Sale + 1 > 120 THEN 121 END AS Sell_Tiers,
            COUNT (distinct S.seller_id)
FROM Sale_Day AS S
INNER JOIN Longest AS L on S.seller_id = L.seller_id and S.Day_Since_Last_Sale = L.m_day --and S.Last_Sale = l.l_day 
GROUP BY 1
ORDER BY 1
--limit 100





WITH Sale_Day AS (
SELECT seller_id, booked_at AS "lit_day",lag(booked_at,1) over(partition by seller_id order by booked_at) AS "Last_Sale",
       date(booked_at) - date(lag(booked_at,1) over(partition by seller_id order by booked_at)) AS "Day_Since_Last_Sale"
FROM   analytics.dw_orders AS O
LEFT JOIN analytics.dw_users AS U ON O.seller_id = U.user_id 
WHERE date(U.joined_at) <= '2016-06-30'
AND   date(booked_at)  <=  '2016-06-30'        
AND  order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
     'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
     'seller_kyc_verified', 'seller_notification_initiated', 
     'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
     'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
     'seller_ab_update_failed', 'waiting_seller_kyc_verification')  
order BY 1,2),

Longest AS (
SELECT seller_id, max(Day_Since_Last_Sale) AS m_day
FROM Sale_Day
GROUP BY 1)

SELECT S.seller_id, COUNT(*)
FROM Sale_Day AS S
INNER JOIN Longest AS L on S.seller_id = L.seller_id and S.Day_Since_Last_Sale = L.m_day
GROUP BY 1
HAVING COUNT(*) > 1
ORDER BY 1

limit 100