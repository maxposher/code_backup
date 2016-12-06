

    create table  analytics_scratch.two  as select * from 
   (
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
     AND   R."at" <  least(U.buyer_activated_at, dateadd(hour,48, U.joined_at))     
     GROUP BY 1
    );
    
    
    drop table analytics_scratch.all_new;
     

    create table  analytics_scratch.all_new_timestamp  as              
    SELECT Z.*, 
  /*1*/    D2_BA, Like_Listing, Post_Comment, Created_Listing, Follow_Brand, Follow_People, internal_share, external_share, search_listing, Seller_Activated,
  /*2*/    commentor, listor, follower_b, follower_p, i_share, e_share, searcher,
  /*3*/    likes_Received_o, likes_Received_sys, shares_received, intro_comments_received, comments_received, shares_received_powerSeller,
  /*4*/    Followers,
  /*5*/    Liker_Buyer_Rating,
  /*6*/    Like_Seller_Rating,
  /*7*/    Likes_Listing_PowerSeller, Likes_Economical, Likes_Mid_Range, Likes_High, Likes_Luxury, Shares_Economical, Shares_Mid_Range, Shares_High_Range, Shares_Luxury
    FROM analytics_scratch.zero AS Z
    LEFT JOIN analytics_scratch.new_one    AS A ON Z.user_id = A.user_id
    LEFT JOIN analytics_scratch.two        AS B ON Z.user_id = B.user_id
    LEFT JOIN analytics_scratch.new_three  AS C ON Z.user_id = C.user_id
    LEFT JOIN analytics_scratch.new_four   AS D ON Z.user_id = D.user_id
    LEFT JOIN analytics_scratch.new_five   AS E ON Z.user_id = E.actor_id
    LEFT JOIN analytics_scratch.new_six    AS F ON Z.user_id = F.user_id
    LEFT JOIN analytics_scratch.new_seven  AS G ON Z.user_id = G.user_id
    ;
   
   
       create table  analytics_scratch.all_new  as              
    SELECT Z.*, 
  /*1*/    D2_BA, Like_Listing, Post_Comment, Created_Listing, Follow_Brand, Follow_People, internal_share, external_share, search_listing, Seller_Activated,
  /*2*/    commentor, listor, follower_b, follower_p, i_share, e_share, searcher,
  /*3*/    likes_Received_o, likes_Received_sys, shares_received, intro_comments_received, comments_received, shares_received_powerSeller,
  /*4*/    Followers,
  /*5*/    Liker_Buyer_Rating,
  /*6*/    Like_Seller_Rating,
  /*7*/    Likes_Listing_PowerSeller, Likes_Economical, Likes_Mid_Range, Likes_High, Likes_Luxury, Shares_Economical, Shares_Mid_Range, Shares_High_Range, Shares_Luxury
    FROM analytics_scratch.zero AS Z
    LEFT JOIN analytics_scratch.one    AS A ON Z.user_id = A.user_id
    LEFT JOIN analytics_scratch.two    AS B ON Z.user_id = B.user_id
    LEFT JOIN analytics_scratch.three  AS C ON Z.user_id = C.user_id
    LEFT JOIN analytics_scratch.four   AS D ON Z.user_id = D.user_id
    LEFT JOIN analytics_scratch.five   AS E ON Z.user_id = E.actor_id
    LEFT JOIN analytics_scratch.six    AS F ON Z.user_id = F.user_id
    LEFT JOIN analytics_scratch.seven  AS G ON Z.user_id = G.user_id
    ;
   
     
   
   
    create table  analytics_scratch.newton_ignite  as select * from 
   (    
    SELECT U.user_id,  1 AS Ingite_Promo
    FROM analytics.dw_users AS U
    INNER JOIN raw_hive.october_events as R ON R."a|id" = U.user_id
    WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'  
    AND ( (R."at" < U.buyer_activated_at AND date(U.buyer_activated_at) - date(join_date) = 1 AND U.buyer_activated_at IS NOT NULL )
                                         OR                    
          (U.buyer_activated_at IS NULL  AND  R."at" < dateadd(day, 2, date(U.joined_at))  )                                       ) 
    AND (R."v" = 'l')   
    GROUP BY 1,2 
   );
   
   
   
    SELECT U.user_id,  1 AS Ingite_Promo
    FROM analytics.dw_users AS U
    INNER JOIN raw_hive.october_events as R ON R."a|id" = U.user_id
    WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'  
    AND ( (R."at" < U.buyer_activated_at AND date(U.buyer_activated_at) - date(join_date) = 1 AND U.buyer_activated_at IS NOT NULL )
                                         OR                    
          (U.buyer_activated_at IS NULL  AND  R."at" < dateadd(day, 2, date(U.joined_at))  )                                       ) 
    AND (R."v" = 'l')   
    GROUP BY 1,2 

    
     SELECT count(*)
     FROM (
     SELECT U.user_id, R.* 
     FROM   analytics.dw_users AS U
     INNER JOIN raw_hive.october_events as R ON R."a|id" = U.user_id
     WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     AND   R."v" IN ('l', 'p', 'f', 'sch')
     AND   R."at" <  dateadd(hour,48, U.joined_at) )
   
   
   
     SELECT *
     FROM analytics_scratch.all_new_timestamp 
     WHERE search_listing > 0 
     AND searcher = 0
     limit 50
     
   
   
    drop table analytics_scratch.two;
   
   
   
   
    select count(*) from
    analytics_scratch.all_new
    WHERE
      d2_ba = 1
    
    
    /* How to join Ignite */
    
    SELECT COUNT(*)
    FROM(
    select A.*, B.Ingite_Promo
    from      analytics_scratch.all_new_timestamp AS A
    LEFT JOIN analytics_scratch.newton_ignite AS B ON A.user_id = B.user_id
    WHERE d2_ba = 1
    AND discount_buyer = 1
    AND date(buyer_activated_at) != date(join_date)
    AND (Ingite_Promo IS NULL OR Ingite_Promo != 1)   
    )
   
   
    SELECT COUNT(*)
    FROM(
    select A.*, B.Ingite_Promo
    from      analytics_scratch.all_new_timestamp AS A
    LEFT JOIN analytics_scratch.newton_ignite AS B ON A.user_id = B.user_id
    WHERE d2_ba = 1
    AND discount_buyer = 1
    AND (date(buyer_activated_at) - date(join_date)) = 1
  -- AND (Ingite_Promo IS NULL OR Ingite_Promo != 1)   
    )
    
    
    
    --Backup code for BA
    SELECT U.user_id,  1 AS Ingite_Promo
    FROM analytics.dw_users AS U
    INNER JOIN raw_hive.october_events as R ON R."a|id" = U.user_id
    WHERE date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'
    AND  R."at" <= least(dateadd(day,1, U.joined_at), U.buyer_activated_at)
    AND (U.buyer_activated_at IS NULL OR U.buyer_activated_at != dateadd(day, 0, U.joined_at))
    AND (R."v" = 'l')   
    GROUP BY 1,2)

    
    

    
    
 
    
    
    
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
    
