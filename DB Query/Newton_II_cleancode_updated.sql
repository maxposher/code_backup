
     --No need for actor II for this model
     
     --zero and two can be shared be tween 48 and timestamp models
     -- Discount Buyer timestamp
     SELECT  U.user_id, U.join_date, U.reg_app, U.buyer_activated_at, 
             CASE WHEN U.buyer_activated_at IS NOT NULL THEN 1 ELSE 0 END AS buyer_all_time,
             CASE WHEN date(E.date_like_activated) <= least(U.buyer_activated_at, dateadd(day, 1 , U.joined_at)) THEN 1 ELSE 0 END AS Ignite_Liker, 
             Discount_Buyer 
     FROM    analytics.dw_users AS U
             LEFT JOIN (SELECT buyer_id, 
                        CASE WHEN buyer_shipping_fee < 499  THEN 1 ELSE 0 END AS Discount_Buyer
                        FROM    analytics.dw_orders 
                        WHERE   order_number = 1 
                        AND date(booked_at) >= '2015-10-05') AS O ON U.user_id = O.buyer_id                          
             LEFT JOIN (SELECT R."a|id" AS user_id, min(R."at") AS date_like_activated
                        FROM  raw_hive.october_events as R 
                        WHERE R."v" = 'l'
                        AND R."at" >= '2015-10-01'
                        GROUP BY R."a|id"
                       ) AS E ON U.user_id = E.user_id
     WHERE  date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'


    /* Actor_One - Actor Model for data collection - Project Newton II */
     SELECT U.join_date, U.user_id, 
        (CASE WHEN  DATEDIFF(hour, U.joined_at, U.buyer_activated_at) <= 48 THEN 1 ELSE 0 END) AS D2_BA,  
     SUM(CASE WHEN (R."v" = 'l')                     THEN 1 ELSE 0 END) AS Like_Listing,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c')  THEN 1 ELSE 0 END) AS Post_Comment,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'l')  THEN 1 ELSE 0 END) AS Created_Listing,
     SUM(CASE WHEN (R."v" = 'f' AND R."do|t" = 'b')  THEN 1 ELSE 0 END) AS Follow_Brand,
     SUM(CASE WHEN (R."v" = 'f' AND R."do|t" = 'u')  THEN 1 ELSE 0 END) AS Follow_People,
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN 1 ELSE 0 END) AS internal_share,
     SUM(CASE WHEN (R."v" = 'es' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS external_share,
     SUM(CASE WHEN (R."v" = 'sch' AND R."do|f" = 'l') THEN 1 ELSE 0 END) AS search_listing,
     AVG(CASE WHEN (U.seller_activated_at < U.buyer_activated_at AND U.seller_activated_at <=dateadd(hour,48, U.joined_at)) THEN 1 ELSE 0 END) AS Seller_Activated 
     FROM analytics.dw_users AS U
     INNER JOIN raw_hive.october_events as R ON R."a|id" = U.user_id
     WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     AND   R."at" <  least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))   
     GROUP BY 1,2,3
      
     --Actor Two
     SELECT U.user_id, 
     avg(CASE WHEN (R."v" = 'l')                     THEN 1 ELSE NULL END) AS liker,
     avg(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c')  THEN 1 ELSE NULL END) AS commentor,
     avg(CASE WHEN (R."v" = 'p' AND R."do|t" = 'l')  THEN 1 ELSE NULL END) AS listor,
     avg(CASE WHEN (R."v" = 'f' AND R."do|t" = 'b')  THEN 1 ELSE NULL END) AS follower_B,
     avg(CASE WHEN (R."v" = 'f' AND R."do|t" = 'u')  THEN 1 ELSE NULL END) AS follower_P,
     avg(CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN 1 ELSE NULL END) AS  i_share,
     avg(CASE WHEN (R."v" = 'es' AND R."do|t" = 'l') THEN 1 ELSE NULL END) AS  e_share,
     avg(CASE WHEN (R."v" = 'sch' AND R."do|f" = 'l') THEN 1 ELSE NULL END) AS searcher
     FROM analytics.dw_users AS U
     INNER JOIN raw_hive.october_events as R ON R."a|id" = U.user_id
     WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     AND   R."at" <  least(U.buyer_activated_at , dateadd(hour,48, U.joined_at))     
     GROUP BY 1
     
       
      
     /* Actor Three - Done-Listing Performance */
     SELECT U.user_id,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.create_source_type IS NULL)   THEN 1 ELSE 0 END) AS Likes_Received_O,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.create_source_type ='system') THEN 1 ELSE 0 END) AS Likes_Received_Sys,
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l')                                    THEN 1 ELSE 0 END) AS Shares_Received,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c' AND L.create_source_type IS NULL)   THEN 1 ELSE 0 END) AS Intro_Comments_Received,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c' AND L.create_source_type IS NULL)   THEN 1 ELSE 0 END) AS Comments_Received,
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l' AND PS.seller_gmv > 94000)          THEN 1 ELSE 0 END) AS Shares_Received_PowerSeller
     FROM analytics.dw_users AS U 
     INNER JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     INNER JOIN raw_hive.october_events AS R ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     INNER JOIN analytics.dw_users AS PS ON PS.user_id = R."a|id"
     WHERE R."at" <  least(U.buyer_activated_at , dateadd(hour,48, U.joined_at))     /* U is actor  */   
     AND date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     GROUP BY 1
     ORDER BY 1

 
     /* Actor Four - Done Followers */
      SELECT U.user_id, COUNT(distinct R."a|id") AS Followers
      FROM   raw_hive.october_events as R 
      INNER JOIN analytics.dw_users AS U ON U.user_id = R."do|id" 
      WHERE R."at" <  least(U.buyer_activated_at , dateadd(hour,48, U.joined_at))  
      AND   date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'   
      AND   R."v" = 'f' 
      AND   R."do|t" = 'u'
      GROUP BY 1
    
    
      /*Actor Five Done - average buyer rating of buyers who like actor's listing - QA*/
      SELECT E.actor_id, CAST(sum(U2.buyer_rating_value) AS FLOAT)/CAST(sum(U2.buyer_rating_count) AS FLOAT) AS Liker_Buyer_Rating
      FROM analytics.dw_users AS U2
      INNER JOIN ( SELECT R."a|id" AS buyer_id, L.seller_id AS actor_id
                   FROM  raw_hive.october_events as R 
                   INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id  /* People like actor's listing */
                   INNER JOIN analytics.dw_users AS U ON U.user_id = L.seller_id      /* Get actor information */   
                   WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
                   AND   R."at" <  least(U.buyer_activated_at , dateadd(hour,48, U.joined_at)) 
                   AND   R."v" = 'l'                                                    /* People like actors' listings */
                   AND   R."do|t" = 'l'  
                   GROUP BY 2,1
                   ORDER BY 1) AS E ON U2.user_id = E.buyer_id           
      GROUP BY 1  


        
      /* Actor Six - average Seller Rating of the item actor likes */
      SELECT E.user_id, CAST(sum(U.seller_rating_value) AS FLOAT)/nullif(CAST(sum(U.seller_rating_count) AS FLOAT),0) AS Like_Seller_Rating
      FROM   analytics.dw_users AS U
      INNER JOIN ( SELECT U.user_id AS user_id, L.seller_id AS seller_id
                   FROM  raw_hive.october_events as R 
                   INNER JOIN analytics.dw_users AS U ON U.user_id = R."a|id" 
                   INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
                   WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
                   AND  R."at" <  least(U.buyer_activated_at , dateadd(hour,48, U.joined_at)) 
                   AND R."v" = 'l' 
                   AND R."do|t" = 'l'
                   GROUP BY 2,1
                   ORDER BY 1) AS E ON U.user_id = E.seller_id     
      GROUP BY 1  


       /* Actor Seven */
      /* Likes by price range + Likes from closets of Power Seller */
      /* 25, 26-50, 51-150 and >150 */
   
      SELECT U.user_id, 
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND Seller.seller_gmv > 94000) THEN 1 ELSE 0 END) AS Likes_Listing_PowerSeller,
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.listing_price <= 2500) THEN 1 ELSE 0 END) AS Likes_Economical,
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.listing_price Between 2600 AND 5000) THEN 1 ELSE 0 END) AS Likes_Mid_Range,
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.listing_price Between 5100 AND 15000) THEN 1 ELSE 0 END) AS Likes_High,
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.listing_price > 15000) THEN 1 ELSE 0 END) AS Likes_Luxury,
      SUM(CASE WHEN ((R."v" = 's' OR R."v" = 'es') AND R."do|t" = 'l' AND L.listing_price <= 2500) THEN 1 ELSE 0 END) AS Shares_Economical,
      SUM(CASE WHEN ((R."v" = 's' OR R."v" = 'es') AND R."do|t" = 'l' AND L.listing_price Between 2600 AND 5000) THEN 1 ELSE 0 END) AS Shares_Mid_Range,
      SUM(CASE WHEN ((R."v" = 's' OR R."v" = 'es') AND R."do|t" = 'l' AND L.listing_price Between 5100 AND 15000) THEN 1 ELSE 0 END) AS Shares_High_Range,
      SUM(CASE WHEN ((R."v" = 's' OR R."v" = 'es') AND R."do|t" = 'l' AND L.listing_price > 15000) THEN 1 ELSE 0 END) AS Shares_Luxury
      FROM raw_hive.october_events as R 
      INNER JOIN analytics.dw_users AS U ON U.user_id = R."a|id" 
      INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
      INNER JOIN analytics.dw_users AS Seller ON L.seller_id = Seller.user_id      /* Seller is the object */
      WHERE date_trunc('mon', date(U.join_date)) BETWEEN '2015-10-07' AND '2015-11-07'
      AND   R."at" <  least(U.buyer_activated_at , dateadd(hour,48, U.joined_at)) 
      AND   R."do|t" = 'l'
      AND   R."v" IN ('s', 'es', 'l')
      GROUP BY 1
      ORDER BY 1
   

   
    
    
    
    
    
 
    
 