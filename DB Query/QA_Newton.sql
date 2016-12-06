

     SELECT U.user_id,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS Likes_Received
     FROM analytics.dw_users AS U 
     INNER JOIN raw_hive.october_events AS R ON U.user_id = R."a|id"
     WHERE date_trunc('mon', date(U.join_date)) = '2015-10-01'
     AND R."a|id" = '561a6ea5f9036537840094e8'
     AND  (R."at") < least(U.buyer_activated_at, dateadd(hour,48, U.joined_at)) 
     GROUP BY 1
     ORDER BY 1
     
     
     
     
     
     
     SELECT U.user_id,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.create_source_type = 'system') THEN 1 ELSE 0 END) AS Likes_Received
     FROM analytics.dw_users AS U 
     INNER JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     INNER JOIN raw_hive.october_events R ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     INNER JOIN analytics.dw_users AS PS ON PS.user_id = R."a|id"
     WHERE U.user_id = '561a6ea5f9036537840094e8'
     AND  (R."at") < least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))    /* U is actor  */   
     
     GROUP BY 1
     ORDER BY 1
     
     
     
     
     

     SELECT U.user_id,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.create_source_type IS NULL) THEN 1 ELSE 0 END) AS Likes_Received_O,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.create_source_type ='system') THEN 1 ELSE 0 END) AS Likes_Received_Sys
     FROM analytics.dw_users AS U 
     INNER JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     INNER JOIN raw_hive.october_events AS R ON L.listing_id = R."do|id" 
     WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     AND  (R."at") < least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))    /* U is actor  */   
     GROUP BY 1
     ORDER BY 1
     
     
    SELECT SUM(Likes_Received_O)
    FROM(

     SELECT U.user_id,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.create_source_type IS NULL) THEN 1 ELSE 0 END) AS Likes_Received_O,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.create_source_type ='system') THEN 1 ELSE 0 END) AS Likes_Received_Sys
     FROM analytics.dw_users AS U 
     INNER JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     INNER JOIN raw_hive.october_events AS R ON L.listing_id = R."do|id" 
     WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     AND  (R."at") < least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))    /* U is actor  */   
     AND U.date_lister_activated IS NULL
     GROUP BY 1
     ORDER BY 1
     
   )
    
 
     SELECT Created_Listing, Likes_Received_O
     FROM analytics_scratch.new_actor_one AS A
     INNER join analytics_scratch.likes   AS B on A.user_id = B.user_id
     WHERE A.Created_Listing = 0
     AND   B.Likes_Received_O > 0
     LIMIT 100
     
     
     SELECT *
     FROM raw_hive.october_events
     limit 10
     