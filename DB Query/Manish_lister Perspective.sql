

count(distinct case when o.order_number=1 then o.listing_id else null end) as listing_sold_new_buyer,
1-2 listings, 3-5 listings, 6-9 listings and 10+ listings.

  
  /* People who made certain number of listings */
  SELECT COUNT (distinct case when A.Order_Count BETWEEN 1 AND 2 then O.order_id else null end) as One_Two_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 3 AND 5 then O.order_id else null end) as Three_Five_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 6 AND 9 then O.order_id else null end) as Six_Nine_Sale,
         COUNT (distinct case when A.Order_Count >= 10 then O.order_id else null end) as Ten_Plus
  FROM   analytics.dw_orders AS O
  INNER JOIN (
              SELECT seller_id, COUNT (distinct order_id) AS Order_Count
              FROM  analytics.dw_orders
              WHERE date(booked_at) BETWEEN '2015-10-01' 
              AND '2015-12-31'
              GROUP BY 1 ) AS A ON O.seller_id = A.seller_id
  WHERE date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
  AND order_gmv < 50000 * 100
  AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')


              
              SELECT COUNT (distinct order_id) AS Order_Count
              FROM   analytics.dw_orders
              WHERE  date(booked_at) BETWEEN '2013-01-01' 
              AND '2015-12-31'
              AND seller_id IN
                        
             (SELECT seller_id
              FROM  analytics.dw_orders
              WHERE date(booked_at) BETWEEN '2013-01-01' AND '2015-12-31'
              GROUP BY 1 
              HAVING COUNT (distinct order_id) >= 10
              )
              
              AND order_gmv < 50000 * 100
              AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')
           
         
             SELECT COUNT (DISTINCT O.order_id)
             FROM analytics.dw_orders AS O
             WHERE O.seller_id IN
             (SELECT seller_id
              FROM  analytics.dw_orders
              WHERE booked_at BETWEEN '2013-01-01' 
              AND '2015-12-31'
              GROUP BY 1
              HAVING COUNT (distinct order_id) >= 10)
              AND O.booked_at BETWEEN '2013-01-01' AND '2015-12-31'

  SELECT booked_quarter
  FROM analytics.dw_orders
  limit 10


/* Old Code */
    SELECT COUNT (distinct case when A.Listing_Count BETWEEN 1 AND 2 then L.listing_id else null end) as One_Two_Sale,
           COUNT (distinct case when A.Listing_Count BETWEEN 3 AND 5 then L.listing_id else null end) as Three_Five_Sale,
           COUNT (distinct case when A.Listing_Count BETWEEN 6 AND 9 then L.listing_id else null end) as Six_Nine_Sale,
           COUNT (distinct case when A.Listing_Count >= 10 then L.listing_id else null end) as Ten_Plus
    FROM   analytics.dw_listings AS L
    INNER JOIN (
                SELECT seller_id, COUNT (distinct listing_id) AS Listing_Count
                FROM  analytics.dw_listings AS A
                WHERE date(created_at) BETWEEN '2013-01-01' AND '2015-12-31'
                AND  ((listing_status = 'published' AND inventory_status= 'available') OR 
                      (listing_status = 'archived'  AND inventory_status= 'available') OR 
                      (inventory_status= 'sold_out'))       
                GROUP BY 1 )  AS A ON L.seller_id = A.seller_id
    WHERE date(L.created_at) BETWEEN '2013-01-01' AND '2015-12-31'
    AND ((L.listing_status = 'published' AND inventory_status= 'available') OR 
                      (L.listing_status = 'archived'  AND inventory_status= 'available') OR 
                      (L.inventory_status= 'sold_out'))




    SELECT COUNT (distinct listing_id) AS Listing_Count
    FROM   analytics.dw_listings AS A
    INNER JOIN (
    
               SELECT seller_id, COUNT (distinct listing_id) AS Listing_Count
                FROM  analytics.dw_listings AS A
                WHERE date(created_at) BETWEEN '2013-01-01' AND '2015-12-31'
                AND  ((listing_status = 'published' AND inventory_status= 'available') OR 
                      (listing_status = 'archived'  AND inventory_status= 'available') OR 
                      (inventory_status= 'sold_out'))             
                GROUP BY 1 
                HAVING COUNT (distinct listing_id) <= 2) AS B ON A.seller_id = B.seller_id
  
    
    WHERE date(created_at) BETWEEN '2013-01-01' AND '2015-12-31'
                AND  ((listing_status = 'published' AND inventory_status= 'available') OR 
                      (listing_status = 'archived'  AND inventory_status= 'available') OR 
                      (inventory_status= 'sold_out'))       
           
     
 
 
                SELECT SUM (case when Listing_Count BETWEEN 1 AND 2 then USER_COUNT else null end) as One_Two_Sale_user,
                       SUM (case when Listing_Count BETWEEN 3 AND 5 then USER_COUNT else null end) as Three_Five_Sale_user,
                       SUM (case when Listing_Count BETWEEN 6 AND 9 then USER_COUNT else null end) as Six_Nine_Sale_user,
                       SUM (case when Listing_Count >= 10 then USER_COUNT else null end) as Ten_Plus_user,
                       SUM (case when Listing_Count BETWEEN 1 AND 2 then ORDER_COUNT else null end) as One_Two_Sale_order,
                       SUM (case when Listing_Count BETWEEN 3 AND 5 then ORDER_COUNT else null end) as Three_Five_Sale_order,
                       SUM (case when Listing_Count BETWEEN 6 AND 9 then ORDER_COUNT else null end) as Six_Nine_Sale_order,
                       SUM (case when Listing_Count >= 10 then ORDER_COUNT else null end) as Ten_Plus_order,
                       SUM (case when Listing_Count BETWEEN 1 AND 2 then GMV else null end) as One_Two_Sale_GMV,
                       SUM (case when Listing_Count BETWEEN 3 AND 5 then GMV else null end) as Three_Five_Sale_GMV,
                       SUM (case when Listing_Count BETWEEN 6 AND 9 then GMV else null end) as Six_Nine_Sale_GMV,
                       SUM (case when Listing_Count >= 10 then GMV else null end) as Ten_Plus_GMV                              
         FROM ( 
                SELECT Listing_Count, COUNT(distinct A.seller_id) AS USER_COUNT, COUNT(distinct O.order_id) AS ORDER_COUNT, SUM(O.order_gmv/100) AS GMV
                FROM analytics.dw_orders AS O
                INNER JOIN (
                   
                  SELECT seller_id, COUNT (distinct listing_id) AS Listing_Count
                  FROM  analytics.dw_listings AS A
                  WHERE date(created_at) BETWEEN '2015-10-01' AND '2015-12-31'
                  AND  ((listing_status = 'published' AND inventory_status= 'available') OR 
                       (listing_status = 'archived'  AND inventory_status= 'available') OR 
                       (inventory_status= 'sold_out'))             
                  GROUP BY 1 ) AS A ON O.buyer_id = A.seller_id
                WHERE  O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')
                 AND date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
                 GROUP BY 1
           )      
           
           
           
           
           
           
           
           
           
                SELECT Listing_Count, COUNT(distinct A.seller_id) AS USER_COUNT, COUNT(distinct O.order_id) AS ORDER_COUNT, SUM(O.order_gmv/100) AS GMV
                FROM analytics.dw_orders AS O
                INNER JOIN (
                   
                  SELECT seller_id, COUNT (distinct listing_id) AS Listing_Count
                  FROM  analytics.dw_listings AS A
                  WHERE date(created_at) BETWEEN '2015-10-01' AND '2015-12-31'
                  AND  ((listing_status = 'published' AND inventory_status= 'available') OR 
                       (listing_status = 'archived'  AND inventory_status= 'available') OR 
                       (inventory_status= 'sold_out'))             
                  GROUP BY 1 ) AS A ON O.buyer_id = A.seller_id
                WHERE  O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')
                 AND date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
                 AND Listing_Count >= 10 
                 GROUP BY 1
           
           
           
              
                SELECT COUNT(*) AS "dw_orders.count_orders"
                FROM analytics.dw_orders AS dw_orders
                WHERE (((dw_orders.booked_at) >= (timestamp '2015-10-01') AND (dw_orders.booked_at) < (timestamp '2016-01-01'))) 
                AND ((dw_orders.order_gmv < 50000 * 100 and dw_orders.booked_at IS NOT NULL and dw_orders.order_state 
                IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
                'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                'seller_ab_update_failed', 'waiting_seller_kyc_verification')))
                AND buyer_id NOT IN (
                  SELECT seller_id
                  FROM  analytics.dw_listings AS A
                  WHERE date(created_at) BETWEEN '2015-10-01' AND '2015-12-31'
                  AND  ((listing_status = 'published' AND inventory_status= 'available') OR 
                       (listing_status = 'archived'  AND inventory_status= 'available') OR 
                       (inventory_status= 'sold_out'))
                  GROUP BY 1)        
                
                
                ORDER BY 1 DESC
                LIMIT 500
           
              
                   
               
               
               
               
          SELECT       SUM (case when Sell_Count BETWEEN 1 AND 2 then USER_COUNT else null end) as One_Two_Sale_user,
                       SUM (case when Sell_Count BETWEEN 3 AND 5 then USER_COUNT else null end) as Three_Five_Sale_user,
                       SUM (case when Sell_Count BETWEEN 6 AND 9 then USER_COUNT else null end) as Six_Nine_Sale_user,
                       SUM (case when Sell_Count >= 10           then USER_COUNT else null end) as Ten_Plus_user,
                       SUM (case when Sell_Count BETWEEN 1 AND 2 then ORDER_COUNT else null end) as One_Two_Sale_order,
                       SUM (case when Sell_Count BETWEEN 3 AND 5 then ORDER_COUNT else null end) as Three_Five_Sale_order,
                       SUM (case when Sell_Count BETWEEN 6 AND 9 then ORDER_COUNT else null end) as Six_Nine_Sale_order,
                       SUM (case when Sell_Count >= 10           then ORDER_COUNT else null end) as Ten_Plus_order,
                       SUM (case when Sell_Count BETWEEN 1 AND 2 then GMV else null end) as One_Two_Sale_GMV,
                       SUM (case when Sell_Count BETWEEN 3 AND 5 then GMV else null end) as Three_Five_Sale_GMV,
                       SUM (case when Sell_Count BETWEEN 6 AND 9 then GMV else null end) as Six_Nine_Sale_GMV,
                       SUM (case when Sell_Count >= 10           then GMV else null end) as Ten_Plus_GMV                              
         FROM ( 
                SELECT Sell_Count, COUNT(distinct A.seller_id) AS USER_COUNT, COUNT(distinct O.order_id) AS ORDER_COUNT, SUM(O.order_gmv/100) AS GMV
                FROM analytics.dw_orders AS O
                INNER JOIN (
                          SELECT seller_id, COUNT (distinct order_id) AS Sell_Count
                          FROM  analytics.dw_orders AS A
                          WHERE date(booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
                          AND A.order_state
                          IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                              'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                              'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                              'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                              'seller_ab_update_failed', 'waiting_seller_kyc_verification')                           
                          GROUP BY 1 ) AS A ON O.buyer_id = A.seller_id          
                                
                WHERE  O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')
                 AND date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
                 GROUP BY 1     )             
               
              
               
               
                       SELECT COUNT(distinct O.buyer_id) AS USER_COUNT, COUNT(distinct O.order_id) AS ORDER_COUNT, SUM(O.order_gmv/100) AS GMV
                       FROM analytics.dw_orders AS O
                       WHERE O.buyer_id IN
                         (SELECT seller_id
                          FROM  analytics.dw_orders AS A
                          WHERE date(booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
                          AND A.order_state
                          IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                              'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                              'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                              'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                              'seller_ab_update_failed', 'waiting_seller_kyc_verification')                           
                          GROUP BY 1 
                          HAVING COUNT (distinct order_id) <= 2  ) 
                       AND  O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                                              'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                                              'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                                              'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                                              'seller_ab_update_failed', 'waiting_seller_kyc_verification')
                       AND date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'  
               
               
               
               
               SELECT COUNT( distinct O.buyer_id)
               FROM analytics.dw_orders AS O 
               WHERE buyer_id IN
               (
                  SELECT seller_id
                  FROM  analytics.dw_orders AS A
                  WHERE date(booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
                  AND A.order_state
                  IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')                           
                  GROUP BY 1 
                  HAVING COUNT (distinct order_id) < 10)
                AND date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31' 
               
               
               
               SELECT COUNT( distinct O.buyer_id)
               FROM analytics.dw_orders AS O 
               WHERE buyer_id IN
                (SELECT seller_id
                 FROM  analytics.dw_listings AS A
                 WHERE date(created_at) BETWEEN '2015-10-01' AND '2015-12-31'
                 AND  ((listing_status = 'published' AND inventory_status= 'available') OR 
                      (listing_status = 'archived'  AND inventory_status= 'available') OR 
                      (inventory_status= 'sold_out'))       
                GROUP BY 1 
                HAVING COUNT (distinct listing_id) < 10 )
                  AND date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31' 
               
               
               
               
               
               
               
               
               
               
               
               
         SELECT COUNT (distinct case when (A.Order_Count <= 2 OR A.Order_Count IS NULL) then O.order_id else null end) as One_Two_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 3 AND 5 then O.order_id else null end) as Three_Five_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 6 AND 9 then O.order_id else null end) as Six_Nine_Sale,
         COUNT (distinct case when A.Order_Count >= 10 then O.order_id else null end) as Ten_Plus
  FROM   analytics.dw_orders AS O
  LEFT JOIN (
              SELECT seller_id, COUNT (distinct order_id) AS Order_Count
              FROM  analytics.dw_orders
              WHERE date(booked_at) < '2015-10-01' 
              GROUP BY 1 ) AS A ON O.seller_id = A.seller_id         
  WHERE date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
  AND order_gmv < 50000 * 100
  AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')
               
               
               
               
               select distinct order_state
               FROM analytics.dw_orders
               WHERE booked_at BETWEEN '2015-10-01' AND '2015-12-31'
               
               
               
               select distinct order_state
               FROM analytics.dw_orders
               WHERE booked_at BETWEEN '2015-10-01' AND '2015-12-31'       
               
               
               
              
              
              SELECT seller_id, COUNT (distinct order_id) AS Q4_Count, Pre_Count
              FROM  analytics.dw_orders
              LEFT JOIN (
                         SELECT seller_id, COUNT (distinct order_id) AS Pre_Count
                         FROM  analytics.dw_orders
                         WHERE date(booked)
              WHERE date(booked_at) BETWEEN '2015-10-01' AND '2015-12-31' 
              GROUP BY 1
               
               
               
              SELECT seller_id, COUNT (distinct order_id) AS Pre_Count
              FROM  analytics.dw_orders
              WHERE date(booked_at) < '2015-10-01' 
              GROUP BY 1
               
           
           
           
         SELECT COUNT (distinct case when A.Order_Count IS NULL then O.seller_id else null end) as Zero_Sale,
         COUNT (distinct case when A.Order_Count <= 2 then O.seller_id else null end) as One_Two_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 3 AND 5 then O.seller_id else null end) as Three_Five_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 6 AND 9 then O.seller_id else null end) as Six_Nine_Sale,
         COUNT (distinct case when A.Order_Count >= 10 then O.seller_id else null end) as Ten_Plus
         FROM   analytics.dw_orders AS O
         LEFT JOIN (
               SELECT seller_id, COUNT (distinct order_id) AS Order_Count
               FROM  analytics.dw_orders
               WHERE date(booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
               GROUP BY 1 ) AS A ON O.seller_id = A.seller_id    
         INNER JOIN analytics.dw_users AS U ON O.seller_id =   U.user_id           
  WHERE date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
  AND order_gmv < 50000 * 100
  AND U.date_seller_activated BETWEEN '2015-10-01' AND '2015-12-31'
  AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')
                      
                      
                      
         SELECT 
         COUNT (distinct case when A.Order_Count <= 2 then O.seller_id else null end) as One_Two_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 3 AND 5 then O.seller_id else null end) as Three_Five_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 6 AND 9 then O.seller_id else null end) as Six_Nine_Sale,
         COUNT (distinct case when A.Order_Count >= 10 then O.seller_id else null end) as Ten_Plus
         FROM   analytics.dw_orders AS O
         LEFT JOIN (
               SELECT seller_id, COUNT (distinct order_id) AS Order_Count
               FROM  analytics.dw_orders
               WHERE date(booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
               GROUP BY 1 ) AS A ON O.seller_id = A.seller_id           
  WHERE date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
  AND order_gmv < 50000 * 100
  AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')         
           
           
           
                
         SELECT COUNT (distinct case when A.Order_Count IS NULL then A.seller_id else null end) as Zero_Sale,
         COUNT (distinct case when A.Order_Count <= 2 then A.seller_id else null end) as One_Two_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 3 AND 5 then A.seller_id else null end) as Three_Five_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 6 AND 9 then A.seller_id else null end) as Six_Nine_Sale,
         COUNT (distinct case when A.Order_Count >= 10 then A.seller_id else null end) as Ten_Plus
         FROM  (
               SELECT seller_id, COUNT (distinct order_id) AS Order_Count
               FROM  analytics.dw_orders
               WHERE date(booked_at) < '2015-10-01'
               GROUP BY 1 ) AS A
           
               select count(*) from
               (
               SELECT seller_id, count (distinct order_id) CC
               FROM  analytics.dw_orders
               WHERE date(booked_at)  BETWEEN '2015-10-01' AND '2015-12-31'
               GROUP BY 1)
               WHERE CC <= 2 
               
               SELECT count(distinct user_id)
               FROM analytics.dw_users
               WHERE date_seller_activated BETWEEN '2015-10-01' AND '2015-12-31'
               
                    SELECT count(distinct user_id)
               FROM analytics.dw_users
               WHERE date_seller_activated <=  '2015-12-31'
               
               
               
               
               
               
               
         SELECT COUNT (distinct case when (A.Order_Count <= 2 OR A.Order_Count IS NULL) then A.seller_id else null end) as One_Two_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 3 AND 5 then A.seller_id else null end) as Three_Five_Sale,
         COUNT (distinct case when A.Order_Count BETWEEN 6 AND 9 then A.seller_id else null end) as Six_Nine_Sale,
         COUNT (distinct case when A.Order_Count >= 10 then A.seller_id else null end) as Ten_Plus
  FROM  
             (
              SELECT seller_id, COUNT (distinct order_id) AS Order_Count
              FROM  analytics.dw_orders
              WHERE date(booked_at) <= '2015-12-31' 
              GROUP BY 1 ) AS A        
 
 
 
 
 
 /*distribution of new buyers */
         SELECT COUNT (distinct case when Order_Count IS NULL then sd else null end) as Zero_Sale,
         COUNT (distinct case when Order_Count <= 2 then sd else null end) as One_Two_Sale,
         COUNT (distinct case when Order_Count BETWEEN 3 AND 5 then sd else null end) as Three_Five_Sale,
         COUNT (distinct case when Order_Count BETWEEN 6 AND 9 then sd else null end) as Six_Nine_Sale,
         COUNT (distinct case when Order_Count >= 10 then sd else null end) as Ten_Plus
         
         FROM(
         SELECT O.seller_id AS sd, COUNT(distinct O.order_id) Order_Count
         FROM   analytics.dw_orders AS O
         INNER JOIN analytics.dw_users AS U ON O.seller_id =   U.user_id           
  WHERE date(O.booked_at) BETWEEN '2015-10-01' AND '2015-12-31'
  AND order_gmv < 50000 * 100
  AND U.date_seller_activated BETWEEN '2015-10-01' AND '2015-12-31'
  AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                      'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                      'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')
  GROUP BY 1                    
                      )
               