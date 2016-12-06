   select count(distinct user_id) FROM
   analytics_scratch.new_actor_one
   limit 10

  
   select count(*)
   from analytics.dw_users
   where join_date BETWEEN '2015-10-07' AND '2015-11-07'
   
   SELECT COUNT(*)
   FROM analytics_scratch.new_actor_three
   limit 10
   
   
   from raw_hive.october_events AS R
   date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
   
   
   drop table analytics_scratch.new_actor_three;

   R."at" <= least(dateadd(day,1, U.joined_at), U.buyer_activated_at)



    create table  analytics_scratch.new_actor_three  as select * from 
   (
    SELECT U.user_id,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS Likes_Received,
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS Shares_Received,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c' AND L.create_source_type = 'system') THEN 1 ELSE 0 END) AS Intro_Comments_Received,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c' AND L.create_source_type IS NULL) THEN 1 ELSE 0 END) AS Comments_Received,
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l' AND PS.seller_gmv > 94000) THEN 1 ELSE 0 END) AS Shares_Received_PowerSeller
     FROM analytics.dw_users AS U 
     INNER JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     INNER JOIN raw_hive.october_events AS R ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     INNER JOIN analytics.dw_users AS PS ON PS.user_id = R."a|id"
     WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     AND  (R."at") < least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))    /* U is actor  */   
     GROUP BY 1
     ORDER BY 1
    );
    
    
    
  select CAST(avg(follow_brand) AS FLOAT), avg(CAST (d2_ba AS FLOAT)), avg(CAST(post_comment AS FLOAT))
  from analytics_scratch.new_actor_one
  limit 10
  


  select COUNT(*)
  from analytics_scratch.new_actor_zero
  WHERE discount_buyer = 1
  AND   Ignite_Liker = 0
  limit 100
  
  
  
  select count(distinct user_id)
  from analytics_scratch.new_actor_zero
  WHERE discount_buyer = 1
  
  
  SELECT COUNT(distinct U.user_id)
  FROM  analytics.dw_users AS U
  INNER JOIN analytics.dw_orders AS O ON O.buyer_id = U.user_id
  WHERE O.order_number = 1
  AND   date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
  AND   date(U.buyer_activated_at)- date(U.join_date) <= 1
  AND   buyer_shipping_fee < 499
  
  
  
  
  
  SELECT U.join_date, U.user_id, U.reg_app, 
  CASE WHEN (E.date_like_activated > U.buyer_activated_at AND date(U.buyer_activated_at) - U.join_date = 1) THEN 1 ELSE 0 END AS D1_Liker, 
  Discount_Buyer 
  FROM   analytics.dw_users AS U
           LEFT JOIN (SELECT buyer_id, 
                      CASE WHEN buyer_shipping_fee < 499  THEN 1 ELSE 0 END AS Discount_Buyer
                      FROM    analytics.dw_orders 
                      WHERE   order_number = 1 
                      AND date(booked_at) >= '2015-10-07') AS O ON U.user_id = O.buyer_id                          
           LEFT JOIN (SELECT R."a|id" AS user_id, min(R."at") AS date_like_activated
                      FROM  raw_hive.october_events AS R
                      WHERE R."v" = 'l'
                      AND R."at" >= '2015-10-01'
                      GROUP BY R."a|id"
                      ) AS E ON U.user_id = E.user_id
     WHERE  date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
    
  
  /* Update the unneccesary fields due to D1 likers */
  /****************Latest update for D1 Likers ****************/
   SELECT U.join_date, U.user_id, U.reg_app, 
   CASE 
   WHEN ((E.date_like_activated < U.buyer_activated_at AND date(U.buyer_activated_at) - U.join_date = 1 AND Discount_Buyer = 1) OR    
         (date(E.date_like_activated) - date(U.join_date) <= 1 AND U.buyer_activated_at IS NULL)) 
   THEN 1 ELSE 0 END AS Ignite, 
   Discount_Buyer, d2_ba 
   FROM   analytics.dw_users AS U
            LEFT JOIN (SELECT buyer_id, 
                       CASE WHEN buyer_shipping_fee < 499  THEN 1 ELSE 0 END AS Discount_Buyer
                       FROM    analytics.dw_orders 
                       WHERE   order_number = 1 
                       AND date(booked_at) >= '2015-10-07') AS O ON U.user_id = O.buyer_id                          
            LEFT JOIN (SELECT R."a|id" AS user_id, min(R."at") AS date_like_activated
                       FROM  raw_hive.october_events AS R
                       WHERE R."v" = 'l'
                       AND R."at" >= '2015-10-01'
                       GROUP BY R."a|id"
                       ) AS E ON U.user_id = E.user_id
           LEFT JOIN analytics_scratch.new_actor_one AS L on U.user_id = L.user_id           
    WHERE  date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07')
   

    
    
   
   DROP TABLE analytics_scratch.new_actor_zero;
    
  

   SELECT      U.join_date, U.user_id, U.buyer_activated_at, E.date_like_activated, 
   CASE WHEN ((E.date_like_activated < U.buyer_activated_at AND date(U.buyer_activated_at) - U.join_date = 1 AND Discount_Buyer = 1)
   OR   (date(E.date_like_activated) - date(U.join_date) <= 1 AND U.buyer_activated_at IS NULL) ) THEN 1 ELSE 0 END AS Ignite, 
   Discount_Buyer
   FROM analytics.dw_users AS U
            LEFT JOIN (SELECT buyer_id, 
                       CASE WHEN buyer_shipping_fee < 499  THEN 1 ELSE 0 END AS Discount_Buyer
                       FROM    analytics.dw_orders 
                       WHERE   order_number = 1 
                       AND date(booked_at) >= '2015-10-07') AS O ON U.user_id = O.buyer_id                          
            LEFT JOIN (SELECT R."a|id" AS user_id, min(R."at") AS date_like_activated
                       FROM  raw_hive.october_events AS R
                       WHERE R."v" = 'l'
                       AND R."at" >= '2015-10-01'
                       GROUP BY R."a|id"
                       ) AS E ON U.user_id = E.user_id        
    WHERE  date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
    
    
    
    
    WHERE  Ignite = 1
    AND    d2_ba = 1
    
    LIMIT 100
   
   
   
   
   
   
   
   
   
  
