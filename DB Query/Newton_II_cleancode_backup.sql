
/* The works - Actor Model for data collection - Project Newton II */
    SELECT date(U.join_date), U.user_id,
       (CASE WHEN  DATEDIFF(hour, AC.join_date, purchase_date) < 48.01  THEN 1 ELSE 0 END) AS D2_BA,
    SUM(CASE WHEN (R."v" = 'l')                    THEN 1 ELSE 0 END) AS Like_Listing,
    SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN 1 ELSE 0 END) AS Post_Comment,
    SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS Created_Listing,
    SUM(CASE WHEN (R."v" = 'f' AND R."do|t" = 'b') THEN 1 ELSE 0 END) AS Follow_Brand,
    SUM(CASE WHEN (R."v" = 'f' AND R."do|t" = 'u') THEN 1 ELSE 0 END) AS Follow_People,
    SUM(CASE WHEN  R."v" = 's' THEN 1 ELSE 0 END) AS internal_share,
    SUM(CASE WHEN  R."v" = 'es' THEN 1 ELSE 0 END) AS external_share,
    SUM(CASE WHEN (AC.sale_date < AC.purchase_date AND AC.purchase_date <=dateadd(hour,48,AC.join_date)) THEN 1 ELSE 0 END) AS Seller_Activated 
    FROM analytics.dw_users AS U
    INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
    LEFT JOIN (
                            SELECT user_id, DATEDIFF(hour, join_date, purchase_date), join_date, purchase_date, sale_date
                            FROM 
                              (SELECT A.user_id, activity_date AS join_date, purchase_date, sale_date
                               FROM analytics.dw_user_activity AS A
                               LEFT JOIN (SELECT user_id, activity_date AS purchase_date
                                          FROM analytics.dw_user_activity 
                                          WHERE activity_count = 1
                                          AND activity_name = 'item_purchased' 
                                          AND activity_date >= '2015-11-01') AS B ON A.user_id = B.user_id  
                               LEFT JOIN (SELECT user_id, activity_date AS sale_date
                                          FROM analytics.dw_user_activity 
                                          WHERE activity_count = 1
                                          AND activity_name = 'item_sold' 
                                          AND activity_date >= '2015-11-01') AS C ON A.user_id = C.user_id 
                               WHERE activity_count = 1
                               AND activity_name = 'join_poshmark'
                               AND activity_date >= '2015-11-01')  
    ) AS AC ON U.user_id = AC.user_id
    WHERE date(U.join_date) = '2015-11-01'
    AND  (R."at") < least(purchase_date, dateadd(hour,48,AC.join_date))
    GROUP BY 1,2, 3  
    LIMIT 500
    
    
     /* Followers and D1 Likers */
     SELECT U.user_id, COUNT(distinct R."a|id") AS Followers,
     CASE WHEN U.date_like_activated = U.join_date THEN 1 ELSE 0 END AS D1_Liker 
     FROM raw_events.all as R 
     INNER JOIN analytics.dw_users AS U ON U.user_id = R."do|id" 
     WHERE U.join_date = '2015-11-01'
     AND R."v" = 'f' 
     AND R."do|t" = 'u'
     GROUP BY 1,3
     LIMIT 100    
    
    
     /* Listing Performance */
     SELECT U.user_id,
     SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS Likes_Received,
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS Shares_Received,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c' AND L.create_source_type = 'system') THEN 1 ELSE 0 END) AS Intro_Comments_Received,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN 1 ELSE 0 END) AS Comments_Received,
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l' AND PS.seller_gmv > 94000) THEN 1 ELSE 0 END) AS Shares_Received_PowerSeller
     FROM analytics.dw_users AS U 
     INNER JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     INNER JOIN raw_events.all R ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     INNER JOIN analytics.dw_users AS PS ON PS.user_id = R."a|id"
     WHERE U.join_date = '2015-11-01'
     AND U.user_id IN ('5636c9f4929db105b42895e2', '5636a56bd6677641b0054d9d', '5636c59b52cbed375029b5f6')
     GROUP BY U.user_id
     LIMIT 100    
    
    
    /* average buyer rating of buyers who like actor's listing */
    SELECT E.actor_id, CAST(sum(U2.buyer_rating_value) AS FLOAT)/CAST(sum(U2.buyer_rating_count) AS FLOAT) AS Buyer_Rating, COUNT(*) 
    FROM analytics.dw_users AS U2
    INNER JOIN ( SELECT R."a|id" AS buyer_id, L.seller_id AS actor_id
                 FROM raw_events.all as R 
                 INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id  /* People like actor's listing */
                 INNER JOIN analytics.dw_users AS U ON U.user_id = L.seller_id      /* Get actor information */   
                 WHERE U.join_date = '2015-11-01'
                 AND R."v" = 'l'                                                    /* People like actors' listings */
                 AND R."do|t" = 'l'
                 GROUP BY 1,2
                 ORDER BY 1) AS E ON U2.user_id = E.buyer_id
    GROUP BY 1  
    LIMIT 10
    
        
    /* average Seller Rating of the item actor likes */
    SELECT E.user_id, CAST(sum(U.seller_rating_value) AS FLOAT)/CAST(sum(U.seller_rating_count) AS FLOAT) AS Seller_Rating, COUNT(*) 
    FROM analytics.dw_users AS U
    INNER JOIN ( SELECT U.user_id AS user_id, L.seller_id AS seller_id
                 FROM raw_events.all as R 
                 INNER JOIN analytics.dw_users AS U ON U.user_id = R."a|id" 
                 INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
                 WHERE U.join_date = '2015-11-01'
                 AND R."v" = 'l' 
                 AND R."do|t" = 'l'
                 GROUP BY 1,2
                 ORDER BY 1) AS E ON U.user_id = E.seller_id
    WHERE E.user_id = '56366341fd0d40db4a2555ad'      
    GROUP BY 1  
    
    
    
      /* Likes by price range + Likes from closets of Power Seller */
      SELECT U.user_id, 
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.listing_price < 3000) THEN 1 ELSE 0 END) AS Likes_Economical,
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.listing_price Between 3000 AND 10000) THEN 1 ELSE 0 END) AS Likes_Mid_Range,
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND L.listing_price > 10000) THEN 1 ELSE 0 END) AS Likes_Luxury,
      SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l' AND Seller.seller_gmv > 94000) THEN 1 ELSE 0 END) AS Likes_Listing_PowerSeller,
      (CASE WHEN U.date_like_activated = U.join_date THEN 1 ELSE 0 END) AS D1_Liker  /* Maybe move it somewhere */
      FROM raw_events.all as R 
      INNER JOIN analytics.dw_users AS U ON U.user_id = R."a|id" 
      INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
      INNER JOIN analytics.dw_users AS Seller ON L.seller_id = Seller.user_id
      WHERE U.join_date = '2015-11-01'
      AND R."v" = 'l' 
      AND R."do|t" = 'l'
      GROUP BY 1, U.date_like_activated, U.join_date
      Limit 100
    

    