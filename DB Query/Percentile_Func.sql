


        SELECT  date_trunc('mon', date(O.booked_at)) AS DD,
        sum(O.order_gmv), percentile_cont(0.1) 
        within group (order by date_trunc('mon', date(O.booked_at))) over(partition by O.seller_id) 
        FROM analytics.dw_orders AS O
        WHERE date(O.booked_at) > '2015-01-01' 
        GROUP BY DD, O.seller_id
        LIMIT 50
        
        
        
        SELECT  percentile_cont(0.6) within group (order by sum(O.order_gmv ) desc) over(partition by O.buyer_id)
        FROM analytics.dw_orders AS O
        WHERE date(O.booked_at) between '2016-02-01' AND '2016-02-29'
        LIMIT 50
        
        
        
          SELECT percentile_cont(0.99) within group (order by mn)  over(),
                 percentile_cont(0.5) within group (order by mn)  over()  
          FROM(
                       SELECT buyer_id, max(order_gmv*0.01) AS mn 
                       FROM   analytics.dw_orders AS O
                       WHERE  date(O.booked_at) between '2016-02-01' AND '2016-02-29'
                       GROUP BY 1
              )
          limit 10
          
          
          
         
          
                    SELECT CASE WHEN mn BETWEEN 0 AND 30 THEN COUNT (distinct buyer_id) AS '0 AND 30'
          
                      FROM(
                       SELECT buyer_id, max(order_gmv*0.01) AS mn 
                       FROM   analytics.dw_orders AS O
                       WHERE  date(O.booked_at) between '2016-02-01' AND '2016-02-29'
                       GROUP BY 1)
          
          
          
          /* GMV Tiers */
             SELECT percentile_cont(0.99) within group (order by mn)  over(),
                    percentile_cont(0.95) within group (order by mn)  over(),    
                    percentile_cont(0.9) within group (order by mn)  over(),
                    percentile_cont(0.8) within group (order by mn)  over(), 
                    percentile_cont(0.7) within group (order by mn)  over(), 
                    percentile_cont(0.6) within group (order by mn)  over(), 
                    percentile_cont(0.5) within group (order by mn)  over(), 
                    percentile_cont(0.4) within group (order by mn)  over(), 
                    percentile_cont(0.3) within group (order by mn)  over(), 
                    percentile_cont(0.2) within group (order by mn)  over(), 
                    percentile_cont(0.1) within group (order by mn)  over()    
            FROM(
                    SELECT buyer_id, max(order_gmv*0.01) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE 
                       
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'
                    
                    AND O.order_gmv < 50000 * 100 and O.booked_at IS NOT NULL and O.order_state 
                    IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                        'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
                        'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
                     GROUP BY 1
              )
          limit 1
          
          
          
           SELECT percentile_cont(0.99) within group (order by mn)  over(),
                    percentile_cont(0.95) within group (order by mn)  over(),    
                    percentile_cont(0.9) within group (order by mn)  over(),
                    percentile_cont(0.8) within group (order by mn)  over(), 
                    percentile_cont(0.7) within group (order by mn)  over(), 
                    percentile_cont(0.6) within group (order by mn)  over(), 
                    percentile_cont(0.5) within group (order by mn)  over(), 
                    percentile_cont(0.4) within group (order by mn)  over(), 
                    percentile_cont(0.3) within group (order by mn)  over(), 
                    percentile_cont(0.2) within group (order by mn)  over(), 
                    percentile_cont(0.1) within group (order by mn)  over(),
                    percentile_cont(1) within group (order by mn)  over()      
            FROM(
                    SELECT buyer_id, count(distinct order_id) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE 
                       
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1                 
                    = '2016_2'
                       
                       GROUP BY 1
              )
          limit 1
          
          
          
             SELECT percentile_cont(0.99) within group (order by mn)  over(),
                    percentile_cont(0.95) within group (order by mn)  over(),    
                    percentile_cont(0.9) within group (order by mn)  over(),
                    percentile_cont(0.8) within group (order by mn)  over(), 
                    percentile_cont(0.7) within group (order by mn)  over(), 
                    percentile_cont(0.6) within group (order by mn)  over(), 
                    percentile_cont(0.5) within group (order by mn)  over(), 
                    percentile_cont(0.4) within group (order by mn)  over(), 
                    percentile_cont(0.3) within group (order by mn)  over(), 
                    percentile_cont(0.2) within group (order by mn)  over(), 
                    percentile_cont(0.1) within group (order by mn)  over(),
                    percentile_cont(1) within group (order by mn)  over()   
              FROM
             (
                    SELECT buyer_id, count(distinct date(booked_at)) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1                 
                    = '2016_2'   
                    GROUP BY 1) 
            limit 10
    
    
    
                  SELECT sum(CASE WHEN mn = 1 THEN 1 ELSE 0 END) AS "1", sum(CASE WHEN mn = 2 THEN 1 ELSE 0 END) AS "2"
                         sum(CASE WHEN mn = 1 THEN 3 ELSE 0 END) AS "3", sum(CASE WHEN mn = 4 THEN 1 ELSE 0 END) AS "4"
                         sum(CASE WHEN mn = 1 THEN 5 ELSE 0 END) AS "5", sum(CASE WHEN mn = 6 THEN 1 ELSE 0 END) AS "6"
                         sum(CASE WHEN mn = 1 THEN 7 ELSE 0 END) AS "7", sum(CASE WHEN mn = 8 THEN 1 ELSE 0 END) AS "8"
                         sum(CASE WHEN mn = 1 THEN 9 ELSE 0 END) AS "9", sum(CASE WHEN mn = 10 THEN 1 ELSE 0 END) AS "10"
                         sum(CASE WHEN mn = 1 THEN 11 ELSE 0 END) AS "11", sum(CASE WHEN mn = 12 THEN 1 ELSE 0 END) AS "12"
                         sum(CASE WHEN mn = 1 THEN 13 ELSE 0 END) AS "13", sum(CASE WHEN mn = 14 THEN 1 ELSE 0 END) AS "14"
                         sum(CASE WHEN mn = 1 THEN 15 ELSE 0 END) AS "15", sum(CASE WHEN mn = 16 THEN 1 ELSE 0 END) AS "16"
                         sum(CASE WHEN mn = 1 THEN 17 ELSE 0 END) AS "17", sum(CASE WHEN mn = 18 THEN 1 ELSE 0 END) AS "18"
                         sum(CASE WHEN mn = 1 THEN 17 ELSE 0 END) AS "19", sum(CASE WHEN mn = 18 THEN 1 ELSE 0 END) AS "18"
                         sum(CASE WHEN mn = 1 THEN 17 ELSE 0 END) AS "21", sum(CASE WHEN mn = 18 THEN 1 ELSE 0 END) AS "18"
                         sum(CASE WHEN mn = 1 THEN 17 ELSE 0 END) AS "13", sum(CASE WHEN mn = 18 THEN 1 ELSE 0 END) AS "18"
                   FROM
                   (SELECT buyer_id, count(distinct date(booked_at)) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'   
                    GROUP BY 1) 
                 limit 10
    
         
                 SELECT initcap(mn) AS "Days Appearance", COUNT(*)
                 FROM
                   (SELECT buyer_id, count(distinct date(booked_at)) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'   
                    GROUP BY 1) 
                 GROUP BY 1
                 limit 10
         
    
    
                            SELECT initcap(mn) AS "GMV Tiers", COUNT(*)
                 FROM
                   (SELECT buyer_id, SUM(order_gmv*0.01) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'   
                    GROUP BY 1) 
                 GROUP BY 1
                 limit 10
    
    
                SELECT initcap(mn) AS "Order Tiers", COUNT(*)
                FROM
                   (SELECT buyer_id, COUNT(distinct order_id) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'   
                    GROUP BY 1) 
                 GROUP BY 1
                 limit 10
    
    
    
    
    
          /* Order Tiers more than 10 */
                
                SELECT SUM(Order_Tiers)
                FROM(
                
                SELECT initcap(mn) AS "Order_Tiers", COUNT(*)
                FROM
                   (SELECT buyer_id, COUNT(distinct order_id) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'   
                    GROUP BY 1) 
                 GROUP BY 1)
                 WHERE Order_Tiers > 10
                 
                 
     
           
                SELECT COUNT(distinct buyer_id), SUM(mn) AS "Days_Appearance"
                 FROM
                   (SELECT buyer_id, count(distinct date(booked_at)) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'   
                    GROUP BY 1)  
                    WHERE mn >= 10                 
      
                 
        
                
                SELECT COUNT(distinct buyer_id), SUM(mn)
                FROM
                   (SELECT buyer_id, COUNT(distinct order_id) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'   
                    GROUP BY 1) 
     
                 WHERE mn > 10


    
    
    
    
   
   
   
        explain
        select     date(booked_at), sum(order_gmv/100)
        from       analytics.dw_orders AS O
        INNER JOIN analytics.dw_users  AS U ON O.buyer_id = U.user_id
        Where      date(O.booked_at) >= '2012-01-01'
        AND        date(U.joined_at) >= '2012-01-01'
        GROUP BY 1 ;
   
        
        explain
        SELECT    date(booked_at), sum(order_gmv/100)
        FROM      analytics.dw_orders AS O
        INNER JOIN 
              (SELECT user_id
               FROM analytics.dw_users 
               Where date(joined_at) >= '2012-01-01') AS U ON O.buyer_id = U.user_id   
        WHERE  date(O.booked_at) >= '2012-01-01'
        GROUP BY 1;
          
          
         date(joined_at) >= '2012-01-01'
        
        
        
        explain
        select     date(booked_at), sum(order_gmv/100)
        from       analytics.dw_listings  AS L
        INNER JOIN analytics.dw_orders AS O ON O.listing_id = L.listing_id
        Where     date(O.booked_at) >= '2012-01-01'
        /*AND       date(created_at) >= '2012-01-01'*/
        GROUP BY 1 ;
          
        
        
        EXPLAIN
        SELECT    date(booked_at), sum(order_gmv/100)
        FROM      analytics.dw_orders AS O
        INNER JOIN 
              (SELECT brand, created_at, listing_id
               FROM  analytics.dw_listings
               Where date(created_at) >= '2012-01-01') AS L ON O.listing_id = L.listing_id
        WHERE  date(O.booked_at) >= '2012-01-01'
        GROUP BY 1;
        
        
        
        
        
        
              /* GMV Tiers */
             SELECT percentile_cont(0.99) within group (order by mn)  over(),
                    percentile_cont(0.95) within group (order by mn)  over(),    
                    percentile_cont(0.9) within group (order by mn)  over(),
                    percentile_cont(0.8) within group (order by mn)  over(), 
                    percentile_cont(0.7) within group (order by mn)  over(), 
                    percentile_cont(0.6) within group (order by mn)  over(), 
                    percentile_cont(0.5) within group (order by mn)  over(), 
                    percentile_cont(0.4) within group (order by mn)  over(), 
                    percentile_cont(0.3) within group (order by mn)  over(), 
                    percentile_cont(0.2) within group (order by mn)  over(), 
                    percentile_cont(0.1) within group (order by mn)  over()    
            FROM(
                    SELECT buyer_id, sum(order_gmv*0.01) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                      
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2'
                    
                    AND O.order_gmv < 50000 * 100 and O.booked_at IS NOT NULL and O.order_state 
                    IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                        'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
                        'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
                     GROUP BY 1
              )
          limit 1
        
        
        
        
        
           SELECT count(distinct buyer_id), sum(mn)
           FROM (
                    SELECT buyer_id, sum(order_gmv*0.01) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                      
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2' 
                    AND O.order_gmv < 50000 * 100 and O.booked_at IS NOT NULL and O.order_state 
                    IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                        'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
                        'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
                     GROUP BY 1
                ) 
         WHERE mn BETWEEN 400.000001 and 500
         
         
         
                    SELECT count(distinct buyer_id), sum(mn)
           FROM (
                    SELECT buyer_id, count(distinct order_id) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                      
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 = '2016_2' 
                    AND O.order_gmv < 50000 * 100 and O.booked_at IS NOT NULL and O.order_state 
                    IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                        'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
                        'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
                     GROUP BY 1
                ) 
         WHERE mn = 9
         
         
         
         SELECT last_query_term, like_listing, purchase
         FROM analytics_scratch.search_query_term_parsing
         WHERE last_query_term LIKE '%papell%'
         limit 10
        
         SELECT COUNT(*)
         FROM  analytics_scratch.search_query_term_parsing
         WHERE like_listing = 1
         limit 10
         
         SELECT *
         FROM  analytics_scratch.search_query_term_parsing
         WHERE like_listing = 1
         limit 10
         
        
        