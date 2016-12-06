



     SELECT date(R."at"), U.user_id,   
     SUM(CASE WHEN (R."v" = 'l' AND (L.inventory_status = 'available' OR L.inventory_status = 'sold_out'))   THEN 1 ELSE 0 END) AS Like_Avail_Listing,
     SUM(CASE WHEN (R."v" = 'l'AND L.inventory_status = 'not_for_sale' )  THEN 1 ELSE 0 END) AS Like_NFS_Listing,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c')  THEN 1 ELSE 0 END) AS  Post_Comment,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'l')  THEN 1 ELSE 0 END) AS  Created_Listing,
     SUM(CASE WHEN (R."v" = 'sch' AND R."do|f" = 'l') THEN 1 ELSE 0 END) AS Search_Listing
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     LEFT  JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
     WHERE date(R."at") <= '2016-04-28'
     GROUP BY 1,2,3,4,5,6
     
     
     
     SELECT date(R."at"),
     CASE WHEN (R."v" = 'l') THEN 'Liker'
          WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN 'Commenter'
     ELSE 'Other' END,
     COUNT (distinct R."a|id")   
     
     FROM raw_events.all as R 
     LEFT  JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
     WHERE date(R."at") = '2016-04-28'
     AND   R."v" in ('l', 'p')
     GROUP BY 1, 2
     LIMIT 100
  
     
     
      SELECT date(R."at"),
             count(distinct (CASE WHEN (R."v" = 'l')                    THEN R."a|id" end)) AS Wholesale_Liker,
             count(distinct (CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN R."a|id" end)) AS Wholesale_Commenter,
             count(distinct (CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN R."a|id" end)) AS Internal_Sharer,
             count(distinct (CASE WHEN (R."v" = 'es' AND R."do|t" = 'l') THEN R."a|id" end)) AS External_Sharer                    
      
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") > '2016-04-09'
     AND   L.wholesale
     AND   R."v" in ('l', 'p', 's', 'es')
     GROUP BY 1
     LIMIT 100
     
     
     /* Social Activity */
     SELECT date(R."at"),
            count(distinct (CASE WHEN (R."v" = 'l')                    THEN R."a|id" end)) AS WS_Liker,
            count(distinct (CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN R."a|id" end)) AS WS_Commenter,
            count(distinct (CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN R."a|id" end)) AS WS_Internal_Sharer,
            count(distinct (CASE WHEN (R."v" = 'es' AND R."do|t" = 'l') THEN R."a|id" end)) AS WS_External_Sharer                    
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") > '2016-03-19'
     AND   L.wholesale
     AND   R."v" in ('l', 'p', 's', 'es')
     GROUP BY 1
     ORDER BY 1
     

     
          /* Social Activity */
     SELECT date(R."at"),
            count(distinct (CASE WHEN (R."v" = 'l')                    THEN R."a|id" end)) AS WS_Liker,
            count(distinct (CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN R."a|id" end)) AS WS_Commenter,
            count(distinct (CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN R."a|id" end)) AS WS_Internal_Sharer,
            count(distinct (CASE WHEN (R."v" = 'es' AND R."do|t" = 'l') THEN R."a|id" end)) AS WS_External_Sharer                    
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") > '2016-04-15'
     AND   L.wholesale
     AND   R."v" in ('l', 'p', 's', 'es')
     GROUP BY 1
     ORDER BY 1
     
    
    SELECT date(R."at"),
           count(distinct (CASE WHEN (R."v" = 'l')                    THEN R."a|id" end)) AS WS_Liker,
           count(distinct (CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN R."a|id" end)) AS WS_Commenter,
           count(distinct (CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN R."a|id" end)) AS WS_Internal_Sharer,
           count(distinct (CASE WHEN (R."v" = 'es' AND R."do|t" = 'l') THEN R."a|id" end)) AS WS_External_Sharer                    
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") >= '2016-03-29'
     AND   L.wholesale
     AND   R."v" in ('l', 'p', 's', 'es')
     GROUP BY 1
     ORDER BY 1
    
    
     /* Follower */
     SELECT date(R."at"),
            count(distinct (CASE WHEN (R."v" = 'f' AND R."do|t" = 'u') THEN R."a|id" end)) AS WS_Follower             
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_users AS U ON U.user_id = R."do|id"
     WHERE date(R."at") >= '2016-03-29'
     AND   R."v" = 'f'
     AND   U.user_id IN  
          (SELECT distinct (seller_id)
           FROM  analytics.dw_orders
           WHERE wholesale)
     GROUP BY 1
     ORDER BY 1


     /* Make an offer */
     SELECT     date(R."at"), 
                count(distinct (CASE WHEN (R."v" = 'p' AND R."do|t" = 'of') THEN R."a|id" end)) AS  WS_Offer    
     FROM       raw_events.all as R 
     INNER JOIN analytics.dw_offers AS O ON R."do|id" = O.offer_id
     WHERE date(R."at") >= '2016-03-29'
     AND   R."v" in ('p')
     AND   O.lister_id IN    
           (SELECT distinct (seller_id)
            FROM  analytics.dw_orders
            WHERE wholesale)
     GROUP BY 1
     ORDER BY 1    

     
     /* Booked Orders */
     SELECT date(R."at"),
           /* count(distinct (CASE WHEN (R."v" = 'p' AND R."do|t" = 'of') THEN R."a|id" end)) AS  WS_Offer,*/
            count(distinct (CASE WHEN (R."v" = 'b' AND R."do|t" = 'o') THEN R."a|id" end))  AS WS_Booker                    
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_orders AS O ON O.order_id = R."do|id" 
     WHERE date(R."at") >= '2016-03-29'
     AND   O.wholesale
     AND   R."v" in ('b')
     GROUP BY 1
     
    

    SELECT DD, sum(num) over (order by DD rows unbounded preceding) 
    FROM(
     
    SELECT DD, COUNT(buyer_id) AS Num
     FROM (
       SELECT O.buyer_id, min(date(booked_at)) AS DD
       FROM   analytics.dw_orders AS O
       WHERE  wholesale
       GROUP BY 1)
    GROUP BY 1)
    ORDER BY 1
    
    
 /************************************************Union Funciton to look at all eventer**********************************/
 
      /* COUNT DISTINCT Wholesale qualified users */
     
     SELECT D, COUNT(distinct ID)
     FROM ( 
     SELECT date(R."at") AS D, R."a|id" AS ID                
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") > '2016-04-15'
     AND   L.wholesale
     AND   R."v" in ('l', 'p', 's', 'es')
     
     UNION
     
     SELECT date(R."at"), R."a|id" AS ID       
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_users AS U ON U.user_id = R."do|id"
     WHERE date(R."at") > '2016-04-15'
     AND   R."v" = 'f'
     AND   R."do|t" = 'u'
     AND   U.user_id IN  
          (SELECT distinct (seller_id)
           FROM  analytics.dw_orders
           WHERE wholesale)

     UNION

     SELECT     date(R."at"), R."a|id" AS ID
     FROM       raw_events.all as R 
     INNER JOIN analytics.dw_offers AS O ON R."do|id" = O.offer_id
     WHERE date(R."at") > '2016-04-15'
     AND   R."v" in ('p')
     AND R."do|t" = 'of'
     AND   O.lister_id IN    
           (SELECT distinct (seller_id)
            FROM  analytics.dw_orders
            WHERE wholesale)
    
     UNION
     
     SELECT date(R."at"), R."a|id" AS ID                 
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_orders AS O ON O.order_id = R."do|id" 
     WHERE date(R."at") > '2016-04-15'
     AND   O.wholesale
     AND   R."v" in ('b')
     GROUP BY 1, 2  )
     GROUP By 1
     ORDER By 1


  /********************************************************/

     SELECT date(R."at"), COUNT(distinct R."a|id") AS ID                
     FROM  raw_events.all as R 
     WHERE date(R."at") >= '2016-03-29' 
     AND   R."v" in ('l', 'p', 's', 'es','f', 'b')
     AND   R."do|t" != 'b'
     GROUP BY 1
     ORDER BY 1
     
     
     
     SELECT dw_orders.received_at, DATE(dw_orders.cancelled_on)
     FROM analytics.dw_orders
     WHERE order_id = '52a4bdb70b47d36c4207bee9'
     
     
     
     
   /***************************************************/
   
   SELECT date(DD), extract(hour from DD) AS DD_HOUR, count(distinct buyer_id)
   FROM
       (SELECT buyer_id, min(booked_at) AS DD
        FROM   analytics.dw_orders
        WHERE  wholesale
        GROUP BY 1
        ORDER BY 2)
   GROUP BY 1,2   
   ORDER BY 1,2  
        
   LIMIT 10
     
     
     
     SELECT COUNT(distinct buyer_id)
     FROM analytics.dw_orders
     WHERE wholesale
     AND date(booked_at) = '2016-05-05'
     AND buyer_id IN
     
     (
     SELECT buyer_id, min(booked_at)
     FROM analytics.dw_orders
     WHERE wholesale
     GROUP BY 1
     HAVING date(min(booked_at)) = '2016-05-05' 
     )
     
     
     
     SELECT date(booked_at), sum(order_gmv*0.01), count(distinct buyer_id)
     FROM 
       (SELECT buyer_id, booked_at, order_gmv
        FROM analytics.dw_orders
        WHERE wholesale
        GROUP BY 1,2,3
        HAVING booked_at =  min(booked_at))
     GROUP BY 1
     ORDER BY 1
     
     
     
     
     SELECT date(booked_at), sum(order_gmv*0.01), COUNT(distinct O.buyer_id)
     FROM   analytics.dw_orders AS O
     INNER JOIN 
       (SELECT buyer_id, min(booked_at) AS DD
        FROM   analytics.dw_orders
        WHERE  wholesale
        GROUP BY 1
        ORDER BY 2) AS B ON O.buyer_id = B.buyer_id AND O.booked_at = B.DD
     GROUP BY 1   
     ORDER BY 1
        
     
  /* First time buyer */   
 /* Choose GMV and buyer count for wholesale order */    
     SELECT date(booked_at), sum(GMV), COUNT(distinct buyer_id)
     FROM (   
        SELECT booked_at, buyer_id, order_gmv*0.01 AS GMV, rank() over (partition by buyer_id order by booked_at ASC) as rank
        FROM   analytics.dw_orders
        WHERE  wholesale)
     WHERE rank = 1
     GROUP BY 1
     ORDER BY 1


   SELECT TO_CHAR(DATEADD(day,(0 - EXTRACT(DOW FROM o.booked_at)::integer), o.booked_at ), 'YYYY-MM-DD') AS "dw_orders.booked_week",
   sum(GMV), COUNT(distinct buyer_id)
     FROM (   
        SELECT booked_at, buyer_id, order_gmv*0.01 AS GMV, rank() over (partition by buyer_id order by booked_at ASC) as rank
        FROM   analytics.dw_orders 
        WHERE  wholesale) AS O
     WHERE rank = 1
     GROUP BY 1
     ORDER BY 1


    
       SELECT booked_at, buyer_id, order_gmv*0.01 AS GMV, rank() over (partition by buyer_id order by booked_at ASC) as rank
        FROM   analytics.dw_orders
        WHERE  wholesale
        LIMIT 100
   
   
   SELECT *
   FROM analytics.dw_redeemable_credits
   LIMIT 50
        
        
        
   SELECT *
   FROM   analytics.dw_daily_store_data
   WHERE  date(activity_at) > '2016-03-01'
   AND os = 'ios'
   ORDER BY 1
   LIMIT 100
   
      
     SELECT *                 
     FROM  raw_events.all as R 
     WHERE date(R."at") = '2016-05-09'
     AND   R."v" in ('b')
     LIMIT 50
     
     
     SELECT 
	TO_CHAR(dw_orders.booked_at, 'YYYY-MM') AS "dw_orders.booked_month",
	COALESCE(SUM((dw_orders.order_gmv*0.01)),0) AS "dw_orders.total_order_gmv"
FROM analytics.dw_orders AS dw_orders

WHERE ((dw_orders.booked_at >= (TIMESTAMP '2016-01-01'))) AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL and 
dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1
ORDER BY 1 
LIMIT 500



SELECT sum(O2.order_gmv*0.01), count(O2.order_id)
FROM analytics.dw_order_items AS O
INNER JOIN analytics.dw_listings AS L on O.listing_id = L.listing_id
INNER JOIN analytics.dw_orders  AS O2 on O.order_id = O2.order_id
WHERE O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND date(O2.booked_at) BETWEEN '2016-05-01' AND '2016-05-31'
AND (O2.order_gmv*0.01) < 50000 and O2.booked_at IS NOT NULL
        
GROUP BY 1
     
        
SELECT sum(O2.order_gmv*0.01), count(O2.order_id)
FROM analytics.dw_order_items AS O
INNER JOIN analytics.dw_listings AS L on O.listing_id = L.listing_id
INNER JOIN analytics.dw_orders  AS O2 on O.order_id = O2.order_id
WHERE O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND date(O2.booked_at) BETWEEN '2016-05-01' AND '2016-05-31'
AND (O2.order_gmv*0.01) < 50000 and O2.booked_at IS NOT NULL        
        
        
        


SELECT sum(O2.order_gmv*0.01), count(O2.order_id)
FROM analytics.dw_orders  AS O2 
WHERE O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND date(O2.booked_at) BETWEEN '2016-05-01' AND '2016-05-31'
AND (O2.order_gmv*0.01) < 50000 and O2.booked_at IS NOT NULL



SELECT     max(O.booked_at_time)
FROM       analytics.dw_order_items AS O
INNER JOIN raw_mongo.orders AS ro      on    O.order_id = ro."_id"
INNER JOIN raw_mongo.orders_dscs AS R  on    ro.generated_id = R.generated_id
INNER JOIN raw_mongo.orders_dscs_amt AS R2 on    R.generated_id  = R2.generated_id

WHERE      date(O.booked_at_time), sum(R2.val)
date(O.booked_at_time) BETWEEN '2016-05-01' AND '2016-05-31'
GROUP BY 1

LIMIT 10

#INNER JOIN raw_mongo.orders_dscs_amt AS R2 ON O.order_id = R2.orders_id
INNER JOIN raw_mongo.orders_dscs AS R on     ro."_id"= R.generated_id