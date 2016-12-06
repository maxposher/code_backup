


                                         SELECT COUNT(*)
                                         FROM(
                                         SELECT B.email AS FB_email, A.email AS posh_email
                                         FROM   analytics.dw_users AS U
                                         LEFT JOIN raw_mongo.users AS A ON U.user_id = A."_id"
                                         LEFT JOIN raw_mongo.users_fb_info AS B ON A.fb_user_id = B.ext_user_id
                                         WHERE U.date_buyer_activated IS NULL
                                         AND  facebook_connected IS NOT NULL
                                         GROUP BY 1,2)
                                         
                                  SELECT COUNT(*)
                                  FROM analytics.dw_users
                                  WHERE date_buyer_activated IS NOT NULL
                                
                                         
                                         
                               
                               
                          SELECT *
                          FROM analytics.dw_campaign_calendar
                          order by campaign_date ASC
                              
                              
                              
                              SELECT COUNT (*)
                              FROM(
                              SELECT    coalesce( B.email, U.email)
                              FROM      analytics.dw_users AS U   
                              LEFT JOIN raw_mongo.users AS A  ON U.user_id = A."_id"
                              LEFT JOIN raw_mongo.users_fb_info AS B ON A.fb_user_id = B.ext_user_id
                              WHERE U.date_buyer_activated IS NOT NULL                     
                              AND   U.date_buyer_activated >= '2015-12-04'
                              GROUP BY 1)
                              
                         
                              SELECT    coalesce( B.email, U.email)
                              FROM      analytics.dw_users AS U   
                              LEFT JOIN raw_mongo.users AS A  ON U.user_id = A."_id"
                              LEFT JOIN raw_mongo.users_fb_info AS B ON A.fb_user_id = B.ext_user_id
                              WHERE U.date_buyer_activated IS NOT NULL                     
                              AND   U.date_buyer_activated >= '2015-12-04'
                              GROUP BY 1
                          
                              
                              
                          
                              SELECT    COUNT(*)
                              FROM      analytics.dw_users AS U   
                              WHERE U.date_buyer_activated IS NOT NULL                     
                              AND   U.date_buyer_activated >= '2015-12-04'
                  
                              
                              
             SELECT *
             FROM analytics.dw_listings
             limit 10                
             
             
             
             
             
       SELECT date(a.booked_at),
       sum(a.order_gmv/100) as gmv,
       count(a.listing_id ) as order_cnt,
       count(distinct a.listing_id) as dist_order_cnt,
       sum(a.order_gmv/100)/count(distinct a.listing_id) as aos
       FROM analytics.dw_orders AS a
       WHERE a.listing_id IN
       
             (select distinct SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20)) as listing_id
               from raw_events.all re
               where re.v='v'
               AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
               AND   date(re."at")>= '2015-12-01') 
      AND a.order_state != 'cancelled'
      GROUP BY 1
      ORDER BY 1

labeleed = used for used order


        SELECT TO_CHAR(created_at, 'YYYY-MM'), SUM(final_postage) AS POSTAGE, SUM(payments) as payment 
        from analytics.dw_shipping_labels 
        WHERE date(created_at) >= '2015-01-01'
        AND state = 'used'
        GROUP BY 1
        ORDER BY 1        
        
        limit 10

 
      SELECT *
      FROM  analytics.dw_listings
      WHERE wholesale IS TRUE
      GROUp BY date
      LIMIT 50
       
      SELECT  seller_id 
      FROM    analytics.dw_listings L 
      WHERE   L.listing_condition = 'nwt'
      AND     L.created_date < '2015-12-09'
      AND     L.seller_id IN ('52961e8af024f2441301ea10','5170cbd48ae4a03c2600a1fe',
                              '55ff49677174874dc822c9ff','5634d45bd4486cd54f00c3bd')

      
      SELECT buyer_id
      FROM  analytics.dw_orders 
      WHERE      wholesale IS TRUE
      GROUP BY 1
      
      
     SELECT     B.buyer_id
     FROM analytics.dw_orders AS B 
     WHERE      wholesale IS TRUE
     AND B.buyer_id IN
     
       (SELECT user_id
        FROM   analytics.dw_users
        WHERE  date_seller_activated <'2015-12-09'
        MINUS
        SELECT  seller_id 
        FROM    analytics.dw_listings L 
        WHERE   L.listing_condition = 'nwt'
        AND     L.created_date < '2015-12-09'
        GROUP BY 1)
     GROUP BY 1
     
     
     MINUS 
     
     SELECT seller_id
     FROM   analytics.dw_listings
     WHERE  wholesale IS FALSE
     AND    created_date < '2015-12-09'
     GROUP BY 1
     LIMIT
        

     SELECT *
     FROM analytics.dw_orders
     WHERE order_id IN ('56860d2874d770405e52feac', '5685d3867b65023a470825bc', '5682b2b99ae22dbb3101e333', '5685f9bd02e9173d8a524bde', '5685505c481560d7e50176c1',
     
     '566a704dbe8ab59e8f199809', '5668fb97a0744c1ab8041075', '566a689a6d9a1399fb1833f4', '566a78a3664f6aebd319cb65', '566a890359db7d80041a0b72')
     
     SELECT distinct retailer_state
     FROM analytics.dw_users
     
     SELECT  booked_at, buyer_activated_at
     FROM analytics.dw_users A
     INNER JOIN analytics.dw_orders B on A.user_id = B.buyer_id 
     WHERE order_number = 1
     and   order_state = 'cancelled'
     limit 100
     
     
     SELECT  distinct wholesale
     FROM    analytics.dw_orders  

     limit   100 
     
     
     SELECT  *
     FROM    analytics.dw_listings
     limit 20
     where  listing_id = '510e0b4ae4b0cd7ba661be5f'