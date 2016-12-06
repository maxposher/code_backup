

    create table  analytics_scratch.new_actor_zero  as select * from 
   (
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
    );
    
 
 


    create table  analytics_scratch.newton_all  as              
    SELECT Z.*, 
           D2_BA, Like_Listing, Post_Comment, Created_Listing, Follow_Brand, Follow_People, internal_share, external_share, search_listing, Seller_Activated,
           joined_at, Buyer_non_timestamp,  
           Likes_Received, Shares_Received, Intro_Comments_Received, Comments_Received, Shares_Received_PowerSeller,
           Followers,
           Liker_Buyer_Rating,
           Like_Seller_Rating,
           Likes_Listing_PowerSeller, Likes_Economical, Likes_Mid_Range, Likes_High, Likes_Luxury, Shares_Economical, Shares_Mid_Range, Shares_High_Range, Shares_Luxury
    FROM analytics_scratch.new_actor_zero AS Z
    LEFT JOIN analytics_scratch.new_actor_one    AS A ON Z.user_id = A.user_id
    LEFT JOIN analytics_scratch.new_actor_two    AS B ON Z.user_id = B.user_id
    LEFT JOIN analytics_scratch.new_actor_three  AS C ON Z.user_id = C.user_id
    LEFT JOIN analytics_scratch.new_actor_four   AS D ON Z.user_id = D.user_id
    LEFT JOIN analytics_scratch.new_actor_five   AS E ON Z.user_id = E.actor_id
    LEFT JOIN analytics_scratch.new_actor_six    AS F ON Z.user_id = F.user_id
    LEFT JOIN analytics_scratch.new_actor_seven  AS G ON Z.user_id = G.user_id
    ;
   
   
    select * from
    analytics_scratch.newton_all
    limit 100
    
    
    
    
      SELECT E.actor_id, CAST(sum(U2.buyer_rating_value) AS FLOAT)/CAST(sum(U2.buyer_rating_count) AS FLOAT) AS Liker_Buyer_Rating
      FROM analytics.dw_users AS U2
      INNER JOIN ( SELECT R."a|id" AS buyer_id, L.seller_id AS actor_id
                 FROM raw_events.all as R 
                 INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id  /* People like actor's listing */
                 INNER JOIN analytics.dw_users AS U ON U.user_id = L.seller_id      /* Get actor information */   
                 WHERE date_trunc('mon', date(U.join_date)) = '2015-10-01'
                 AND  (R."at") < least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))   /* U is actor */ 
                 AND R."v" = 'l'                                                    /* People like actors' listings */
                 AND R."do|t" = 'l'  
                 GROUP BY 2,1
                 ORDER BY 1) AS E ON U2.user_id = E.buyer_id           
      GROUP BY 1  
    
    
    

    
    
 
    
    
    
     create table  analytics_scratch.newton_ignite  as select * from 
   (    
    SELECT U.user_id,  1 AS Ingite_Promo
    FROM analytics.dw_users AS U
    INNER JOIN raw_hive.october_events as R ON R."a|id" = U.user_id
    WHERE date_trunc('mon', date(U.join_date)) = '2015-10-01'
    AND  R."at" <= least(dateadd(day,1, U.joined_at), U.buyer_activated_at)
    AND (R."v" = 'l')   
    GROUP BY 1,2);
    

      
    
    
          /*Actor Five Done - average buyer rating of buyers who like actor's listing - QA*/
      SELECT E.actor_id, CAST(sum(U2.buyer_rating_value) AS FLOAT)/CAST(sum(U2.buyer_rating_count) AS FLOAT) AS Liker_Buyer_Rating
      FROM analytics.dw_users AS U2
      INNER JOIN ( SELECT R."a|id" AS buyer_id, L.seller_id AS actor_id
                 FROM raw_events.all as R 
                 INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id  /* People like actor's listing */
                 INNER JOIN analytics.dw_users AS U ON U.user_id = L.seller_id      /* Get actor information */   
                 WHERE date_trunc('mon', date(U.join_date)) = '2015-10-01'
                 AND  (R."at") < least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))   /* U is actor */ 
                 AND R."v" = 'l'                                                    /* People like actors' listings */
                 AND R."do|t" = 'l'  
                 GROUP BY 2,1
                 ORDER BY 1) AS E ON U2.user_id = E.buyer_id           
      GROUP BY 1  
 
    
    
         create table  analytics_scratch.newton_actor_five  as select * from 
   (
      SELECT E.actor_id, CAST(sum(U2.buyer_rating_value) AS FLOAT)/CAST(sum(U2.buyer_rating_count) AS FLOAT) AS Liker_Buyer_Rating
      FROM analytics.dw_users AS U2
      INNER JOIN ( SELECT R."a|id" AS buyer_id, L.seller_id AS actor_id
                 FROM raw_events.all as R 
                 INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id  /* People like actor's listing */
                 INNER JOIN analytics.dw_users AS U ON U.user_id = L.seller_id      /* Get actor information */   
                 WHERE date_trunc('mon', date(U.join_date)) = '2015-10-01'
                 AND  (R."at") < least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))   /* U is actor */ 
                 AND R."v" = 'l'                                                    /* People like actors' listings */
                 AND R."do|t" = 'l'  
                 GROUP BY 2,1
                 ORDER BY 1) AS E ON U2.user_id = E.buyer_id           
      GROUP BY 1  
    );
    
    
    
    SELECT A.*, B.ingite_promo AS ignite_promo
    FROM analytics_scratch.newton_all A
    LEFT JOIN analytics_scratch.newton_ignite B ON A.user_id = B.user_id
    WHERE d1_liker = 0
    AND   join_date between '2015-10-10' AND '2015-10-12' 
    AND   A.reg_app = 'iphone'
   
    
    
   
   SELECT      U.user_id, U.reg_app 
   FROM analytics.dw_users AS U
   WHERE  date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
   AND user_id = '5614c30cfd0d405e91327744' 
    
    
    
    
    

  SELECT *
  FROM raw_hive.october_events AS R
  WHERE R."a|id" = '5622a21af8a073258e02d4ac'
  AND (R."v" = 'l' OR R."v" = 'b')
  ORDER BY R."at"
  LIMIT 100
  
  
  alter table users
  drop column feedback_score cascade;