

  
  

        SELECT COUNT (distinct user_id)
        FROM
        (SELECT  A.user_id, BA, max (activity_count) Likes
         FROM analytics.dw_user_activity AS A
         INNER JOIN analytics.dw_users  AS U on A.user_id = U.user_id
         LEFT JOIN 
          (SELECT user_id, activity_date as ba
           FROM   analytics.dw_user_activity
           WHERE  activity_name = 'item_purchased'
           AND    activity_count = 1 ) AS B ON A.user_id = B.user_id
         WHERE  A.activity_name = 'like_listing'
         AND    A.activity_date < ba
         AND    U.join_date >= '2014-01-01'
         AND    U.join_date <= '2015-09-01'
         AND    U.date_buyer_activated IS NOT NULL
         GROUP BY 1,2)        
         WHERE Likes = 1
  

     --Liker vs. buyer
     SELECT  
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes IS NULL) THEN 1 ELSE 0 END) AS  B_Zero,
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes = 1) THEN 1 ELSE 0 END) AS  B_One,
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes = 2) THEN 1 ELSE 0 END) AS  B_Two,
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes = 3) THEN 1 ELSE 0 END) AS  B_Three,
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes = 4) THEN 1 ELSE 0 END) AS  B_Four,
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes = 5) THEN 1 ELSE 0 END) AS  B_Five,
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes > 5 AND Likes <= 10) THEN 1 ELSE 0 END) AS  B_Six_Ten,
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes > 10 AND Likes <= 20) THEN 1 ELSE 0 END) AS  B_Eleven_Twenty,
     SUM(CASE WHEN (date_buyer_activated IS NOT NULL AND  Likes > 20 ) THEN 1 ELSE 0 END) AS  B_Twenty_Plus,
     
     SUM(CASE WHEN ( Likes IS NULL) THEN 1 ELSE 0 END) AS  L_Zero,
     SUM(CASE WHEN ( Likes = 1) THEN 1 ELSE 0 END) AS  L_One,
     SUM(CASE WHEN ( Likes = 2) THEN 1 ELSE 0 END) AS  L_Two,
     SUM(CASE WHEN ( Likes = 3) THEN 1 ELSE 0 END) AS  L_Three,
     SUM(CASE WHEN ( Likes = 4) THEN 1 ELSE 0 END) AS  L_Four,
     SUM(CASE WHEN ( Likes = 5) THEN 1 ELSE 0 END) AS  L_Five,
     SUM(CASE WHEN ( Likes > 5 AND Likes <= 10) THEN 1 ELSE 0 END) AS  L_Six_Ten,
     SUM(CASE WHEN ( Likes > 10 AND Likes <= 20) THEN 1 ELSE 0 END) AS L_Elevent_Twenty,
     SUM(CASE WHEN ( Likes > 20) THEN 1 ELSE 0 END) AS  L_Twenty_Plus
     FROM(  
   
       SELECT A.user_id, B.Likes, A.date_buyer_activated
       FROM analytics.dw_users AS A
       LEFT JOIN 
          
         (SELECT u.user_id, max (activity_count) Likes
          FROM   analytics.dw_user_activity A
          INNER JOIN analytics.dw_users as U 
                  ON A.user_id = U.user_id
         WHERE  activity_name = 'like_listing'
         AND    U.join_date >= '2014-01-01'
         AND    U.join_date <= '2015-08-01'
         AND    date(A.activity_date) - date(U.join_date) < 7 
         GROUP BY 1) AS B ON A.user_id = B.user_id        
       WHERE   A.join_date >= '2014-01-01'
       AND     A.join_date <= '2015-08-01'
       AND     A.reg_app = 'iphone'
     )
     

 
 
 
 
 
 
 
 --Buyers who are non-likers
 

  SELECT  COUNT(*)
  FROM analytics.dw_users AS U
  INNER JOIN 
   
   (SELECT user_id, activity_date
    FROM   analytics.dw_user_activity
    WHERE  activity_name = 'like_listing'
    AND    activity_count = 1 ) AS A ON U.user_id = A.user_id
    
  WHERE  U.join_date >= '2014-01-01'
  AND    U.join_date <= '2015-09-01'
  AND   (date_buyer_activated - join_date) <= 1
  AND    date_buyer_activated >= date(activity_date)
  
  


   SELECT  COUNT(*)
  FROM analytics.dw_users AS U
   INNER JOIN analytics.dw_users
  WHERE  U.join_date >= '2014-01-01'
  AND    U.join_date <= '2015-09-01'
  AND   (date_buyer_activated - join_date) <= 1
 

 
 
 
 
  SELECT count(*)
 FROM  analytics.dw_users
 WHERE 
 likes_by_user iS NOT NULL
 AND date_buyer_activated IS NULL
 
 
 
 --Likers Prior to buyer 


    SELECT COUNT(distinct U.user_id)
    FROM   analytics.dw_user_activity AS A
    INNER  JOIN analytics.dw_users AS U ON A.user_id = U.user_id 
    WHERE  activity_name = 'item_purchased'
    AND    activity_count = 1 
    AND    U.reg_app = 'iphone'
    AND    U.join_date >= '2014-01-01'
    AND    U.join_date <= '2015-08-01'
    AND    U.guest_user = 'false'
    AND    date(U.date_buyer_activated) - date(U.join_date) BETWEEN 0 AND 29



    SELECT  count (distinct A.user_id)
    FROM analytics.dw_user_activity AS A
    INNER JOIN analytics.dw_users  AS U on A.user_id = U.user_id
   LEFT JOIN 
   (SELECT user_id, activity_date as ba
    FROM   analytics.dw_user_activity
    WHERE  activity_name = 'item_purchased'
    AND    activity_count = 1 ) AS B ON A.user_id = B.user_id
  WHERE  A.activity_name = 'like_listing'
  AND    A.activity_date < ba
  AND    A.activity_count = 1
  AND    U.reg_app = 'iphone'
  AND    U.guest_user = 'false'
  AND    date(U.date_buyer_activated) - date(U.join_date) BETWEEN 0 AND 29
  AND    U.join_date >= '2014-01-01'
  AND    U.join_date <= '2015-08-01'
  
  
  
  

   select *
   from analytics.
   
   
   
   
    
  SELECT     U.join_date, count(U.user_id), sum(LA)
  FROM       analytics.dw_users  AS U 
  LEFT JOIN  
  (SELECT     A.user_id, 1 AS LA
   FROM       analytics.dw_user_activity AS A 
   INNER JOIN analytics.dw_users  AS V  on A.user_id = V.user_id
   WHERE      A.activity_name = 'like_listing'
   AND        A.activity_date - V.join_date <= 6
   AND        A.activity_count = 1) AS B on U.user_id = B.user_id
   WHERE  --U.reg_app = 'iphone'
       U.join_date >= '2014-01-01'
   AND    U.join_date <= '2015-08-01'
   GROUP BY 1
   ORDER BY 1
  
  LIMIT 10
  





   SELECT COUNT(*), 
   sum(case when likes = 1 THEN 1 ELSE 0 END) AS ONE,
   sum(case when likes = 2 THEN 1 ELSE 0 END) AS TWO,
   sum(case when likes = 3 THEN 1 ELSE 0 END) AS THREE,
   sum(case when likes = 4 THEN 1 ELSE 0 END) AS FOUR,
   sum(case when likes = 5 THEN 1 ELSE 0 END) AS FIVE,
   sum(case when likes BETWEEN 6 AND 10 THEN 1 ELSE 0 END) AS six_ten
   FROM(

    SELECT  V.join_date, V.user_id, Z.*
    FROM analytics.dw_users AS V
    LEFT JOIN 
    (SELECT  A.user_id, max (activity_count) Likes, (U.date_buyer_activated - U.join_date) + 1 AS D 
     FROM analytics.dw_user_activity AS A
     INNER JOIN analytics.dw_users  AS U on A.user_id = U.user_id
     LEFT JOIN 
     (SELECT user_id, activity_date as ba
      FROM   analytics.dw_user_activity
      WHERE  activity_name = 'item_purchased'
      AND    activity_count = 1 ) AS B ON A.user_id = B.user_id
      WHERE  A.activity_name = 'like_listing'
      AND    A.activity_date < ba
      AND    U.date_buyer_activated - U.join_date > 29
      AND    U.reg_app = 'iphone'
      AND    ba is not NULL
      AND    U.join_date >= '2014-01-01'
      AND    U.join_date <= '2015-08-01'
      GROUP BY 1, D) AS Z ON V.user_id = Z.user_id
      WHERE  V.join_date BETWEEN '2014-01-01' AND '2015-08-01')
     -- AND d IS NULL)
      WHERE d = 1
     
     
     
     
      SELECT  V.join_date, V.user_id, Z.*
    FROM analytics.dw_users AS V
    LEFT JOIN 
    (SELECT  A.user_id, max (activity_count) Likes, (U.date_buyer_activated - U.join_date) + 1 AS D 
     FROM analytics.dw_user_activity AS A
     INNER JOIN analytics.dw_users  AS U on A.user_id = U.user_id
     LEFT JOIN 
     (SELECT user_id, activity_date as ba
      FROM   analytics.dw_user_activity
      WHERE  activity_name = 'item_purchased'
      AND    activity_count = 1 ) AS B ON A.user_id = B.user_id
      WHERE  A.activity_name = 'like_listing'
      AND    A.activity_date < ba
      AND    U.date_buyer_activated - U.join_date > 29
      AND    U.reg_app = 'iphone'
      AND    ba is not NULL
      AND    U.join_date >= '2014-01-01'
      AND    U.join_date <= '2015-08-01'
      GROUP BY 1, D) AS Z ON V.user_id = Z.user_id
      WHERE  V.join_date BETWEEN '2014-01-01' AND '2015-08-01'
      limit 100







    (SELECT  A.user_id, max (activity_count) Likes, (U.date_buyer_activated - U.join_date) + 1 AS D 
     FROM analytics.dw_user_activity AS A
     INNER JOIN analytics.dw_users  AS U on A.user_id = U.user_id
     LEFT JOIN 
     (SELECT user_id, activity_date as ba
      FROM   analytics.dw_user_activity
      WHERE  activity_name = 'item_purchased'
      AND    activity_count = 1 ) AS B ON A.user_id = B.user_id
      WHERE  A.activity_name = 'like_listing'
      AND    A.activity_date < ba
      AND    U.date_buyer_activated - U.join_date > 29
      AND    U.reg_app = 'iphone'
      AND    ba is not NULL
      AND    U.join_date >= '2014-01-01'
      AND    U.join_date <= '2015-08-01'
      GROUP BY 1, D) AS Z ON V.user_id = Z.user_id
      WHERE  V.join_date BETWEEN '2014-01-01' AND '2015-08-01'
      limit 100



     --Likers 
     SELECT    U.join_date, U.user_id,max(A.activity_count) AS Likes, (U.date_buyer_activated - U.join_date) + 1 AS D 
     FROM      analytics.dw_users AS U
     LEFT JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
     WHERE     A.activity_name = 'like_listing'
     AND       U.guest_user = 'false'
     AND       A.activity_date < least(U.buyer_activated_at , dateadd(day, 6,  U.join_date)) 
     AND       U.join_date >= '2014-01-01'
     AND       U.join_date <= '2015-08-01'
     AND       U.reg_app = 'iphone'
     GROUP BY 1,2, D




     SELECT    U.join_date, COUNT(distinct U.user_id)
     FROM      analytics.dw_users AS U
     INNER JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
     WHERE     A.activity_name = 'item_purchased'
     AND       U.guest_user = 'false'
     AND       date(A.activity_date) - date(U.join_date) < 7
     AND       U.join_date >= '2014-01-01'
     AND       U.join_date <= '2015-08-01'
  --   AND       U.reg_app = 'iphone'
     AND       A.activity_count = 1
     GROUP BY  1
     ORDER BY  1

    
     SELECT    U.join_date, COUNT(distinct U.user_id)
     FROM      analytics.dw_users AS U
     WHERE     U.guest_user = 'false'
     AND       U.join_date >= '2014-01-01'
     AND       U.join_date <= '2015-08-01'
    --AND       U.reg_app = 'iphone'
     GROUP BY  1
     ORDER BY  1
    
      
 
      
      
     SELECT COUNT (*) 
     FROM(
     SELECT    U.user_id, max(A.activity_count) AS Likes, (U.date_buyer_activated - U.join_date) + 1 AS D 
     FROM      analytics.dw_users AS U
     LEFT JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
     WHERE     A.activity_name = 'like_listing'
     AND       date(A.activity_date)        < dateadd(day, 7,  U.join_date) 
     --AND       U.date_buyer_activated < dateadd(day, 7,  U.join_date) 
     AND       U.join_date >= '2014-01-01'
     AND       U.join_date <= '2015-08-01'
     AND       U.reg_app = 'iphone'
     GROUP BY  1, D
     ORDER BY 1)
     
   
   
   
     SELECT    COUNT (distinct U.user_id)
     FROM      analytics.dw_users AS U

     --AND       U.date_buyer_activated < dateadd(day, 7,  U.join_date) 
     WHERE       U.join_date >= '2014-01-01'
     AND       U.join_date <= '2015-08-01'
     AND       U.reg_app = 'iphone'


      
   
     SELECT    COUNT(distinct U.user_id)
     FROM      analytics.dw_users AS U
     LEFT JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
     WHERE     A.activity_name = 'like_listing'
     AND       A.activity_date   < dateadd(day, 7,  U.join_date) 
     --AND       U.date_buyer_activated < dateadd(day, 7,  U.join_date) 
     AND       U.join_date >= '2014-01-01'
     AND       U.join_date <= '2015-08-01'
     AND       U.reg_app = 'iphone'

 
 
 
 
     SELECT COUNT (distinct user_id) 
     FROM(
     SELECT    U.user_id, U.date_buyer_activated  AS D 
     FROM      analytics.dw_users AS U
     LEFT JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
     WHERE     A.activity_name = 'like_listing'
     AND       date(A.activity_date)  - date(U.join_date) <= 2
     --AND       U.date_buyer_activated < dateadd(day, 7,  U.join_date) 
     AND       U.join_date >= '2015-03-01'
     AND       U.join_date <= '2015-08-01'
    -- AND       U.reg_app = 'iphone'
     ORDER BY 1)
     WHERE D IS NOT NULL
 
 
     SELECT COUNT(distinct user_id) 
     FROM   analytics_scratch.all_new_timestamp
     WHERE  d2_ba = 1
     AND    like_listing > 0
     AND    reg_app = 'iphone'
     AND date(join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     
     
     
     SELECT COUNT(distinct user_id) 
     FROM   analytics_scratch.all_new_timestamp
     WHERE  like_listing > 25
 /*    AND    (discount_buyer IS NULL OR discount_buyer = 0)  */
     AND    reg_app = 'iphone'
     AND   date(join_date) BETWEEN '2015-10-07' AND '2015-11-07'
 
 
     SELECT COUNT(distinct user_id) 
     FROM   analytics_scratch.all_new_timestamp
     WHERE  d2_ba = 1
     AND    like_listing > 25
    /* AND    (discount_buyer IS NULL OR discount_buyer = 0) */
     AND    reg_app = 'iphone'
     AND date(join_date) BETWEEN '2015-10-07' AND '2015-11-07'
     

     
     
     
     
     
     
     
 
     
     
     SELECT COUNT(distinct user_id) 
     FROM   analytics_scratch.all_new_timestamp
     WHERE  like_listing > 0
     AND    discount_buyer != 1
     AND    reg_app = 'iphone'
     AND   date(join_date) BETWEEN '2015-10-07' AND '2015-11-07'
   
   
   
   
   
   
 
 
    SELECT SUM(BA)
 FROM(
 
       SELECT U.user_id, 
        (CASE WHEN  date(U.joined_at) = date(U.buyer_activated_at) THEN 1 ELSE 0 END) AS BA,  
     SUM(CASE WHEN (R."v" = 'l')                     THEN 1 ELSE 0 END) AS Like_Listing
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.e_2016_01_21 as R ON R."a|id" = U.user_id
     WHERE date(U.join_date) BETWEEN '2016-01-20' AND '2016-01-22'
   --  AND   R."at" <  least(U.buyer_activated_at, dateadd(day, 1 , U.join_date))   
     GROUP BY 1,2)
     
     
        SELECT count(BA), sum(BA)
 FROM(
 
     SELECT U.user_id, (CASE WHEN  date(U.joined_at) = date(U.buyer_activated_at) THEN 1 ELSE 0 END) AS BA  
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.e_2016_01_21 as R ON R."a|id" = U.user_id
     WHERE date(U.join_date) = '2016-01-21' 
     AND   R."v" = 'l'
     AND   date(R."at") <=  '2016-01-21' 
     AND   reg_app = 'iphone'
     AND   R."at" <  least(U.buyer_activated_at, dateadd(day, 1 ,U.join_date))   
     GROUP BY 1,2)
    
    
   

 
     SELECT COUNT(distinct U.user_id)
     FROM   analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     WHERE date(U.join_date) >= '2015-12-28' 
     AND   R."v" = 'l'
     AND   date(R."at") BETWEEN '2015-12-28' AND '2016-01-25' 
     AND   reg_app = 'iphone'
     AND   R."at" <  least(U.buyer_activated_at, dateadd(day, 1 ,U.join_date))   



     SELECT COUNT(distinct U.user_id)
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     WHERE date(U.join_date) >= '2015-12-28' 
     AND   R."v" = 'l'
     AND   date(R."at") BETWEEN '2015-12-28' AND '2016-01-25' 
     AND   reg_app = 'iphone'
     AND   date_buyer_activated IS NOT NULL
     AND   R."at" <  least(U.buyer_activated_at, dateadd(day, 1 ,U.join_date))   
     
     
     
     --Keyword Search Query
            SELECT U.user_id, U.buyer_activated_at, SUM(keyword_search) AS KS, SUM(brand_browsing) AS BB, SUM(category_browsing) AS CB
          FROM analytics.dw_users AS U
          LEFT JOIN 
                 (SELECT id, actor_id, at AS action_time , 
                  case when  direct_object_usersearchrequest_query is not null then 1 else 0 end as keyword_search, 
                  case when direct_object_executedSearchRequest_query_and_facet_filters_brand_0 is not null then 1 else 0 end as brand_browsing, 
                  case when direct_object_executedSearchRequest_query_and_facet_filters_category_feature_0 is not null then 1 else 0 end as category_browsing 
                From raw_hive.search_events 
                where   at  >= '2015-10-30' 
                AND     at  <= '2015-11-05'  
                AND   actor_type = 'User') AS B ON U.user_id = B.actor_id   
          WHERE action_time <  least(U.buyer_activated_at, cast(date(joined_at + 1) AS timestamp))       
          AND   U.join_date BETWEEN '2015-10-30' AND '2015-11-04' 
         -- AND   U.reg_app = 'iphone'
          GROUP BY 1,2
          LIMIT 100

     
     