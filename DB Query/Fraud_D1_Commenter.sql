

    SELECT DD, 
    SUM(CASE WHEN Post_Comment = 1 THEN 1 ELSE 0 END) One,
    SUM(CASE WHEN Post_Comment = 2 THEN 1 ELSE 0 END) Two,
    SUM(CASE WHEN Post_Comment = 3 THEN 1 ELSE 0 END) Three,
    SUM(CASE WHEN Post_Comment = 4  OR Post_Comment = 5  THEN 1 ELSE 0 END) Four_Five, 
    SUM(CASE WHEN Post_Comment >= 6  THEN 1 ELSE 0 END) Four_Five
    FROM 
    ( 
     SELECT date(U.joined_at) as DD, U.user_id,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c')  THEN 1 ELSE 0 END) AS  Post_Comment
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     WHERE date(U.joined_at) BETWEEN '2016-05-15' AND '2016-05-22'
     AND   date(R."at") = date(U.joined_at)
     GROUP BY 1,2)
     GROUp By 1
     
     
     SELECT date(U.joined_at) as DD, COUNT (DISTINCT U.user_id)
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     WHERE date(U.joined_at) BETWEEN '2016-05-15' AND '2016-05-22'
     AND   R."v" = 'p' 
     AND R."do|t" = 'c'
     AND   date(R."at") = date(U.joined_at)
     GROUP BY 1
     
     
     
     
     
     
     
     
     SELECT distinct user_id
     FROM(
     

     SELECT date(U.joined_at) as DD, U.user_id
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     WHERE date(U.joined_at) BETWEEN '2016-05-15' AND '2016-05-22'
     AND   date(R."at") = date(U.joined_at)
     GROUP BY 1,2
     HAVING SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c')  THEN 1 ELSE 0 END) > 6
     )
     LIMIT 100
     

     SELECT *
     FROM raw_events.all as R
     WHERE R."v" = 'p'
     AND   R."do|t" = 'c'
     LIMIT 10
     
     SELECT Date(joined_at), CONCAT(user_id)
     FROM analytics.dw_users
     LIMIT 100
     
     
     
     SELECT *
     FROM analytics.dw_comments
     /*WHERE comment_created_at > '2016-03-01'*/
     LIMIT 10
     
     
     
     SELECT comment_text
     FROM   analytics.dw_comments AS C
     INNER JOIN analytics.dw_users AS U on C.creator_id = U.user_id
     WHERE date(comment_created_at) = '2015-04-10' 
   /*  AND   date(U.joined_at) = '2015-04-10' */
     AND creator_id IN
     
    (SELECT creator_id
     FROM   analytics.dw_comments
     WHERE  date(comment_created_at) = '2015-04-10' 
     GROUP BY 1
     HAVING COUNT(*) >= 6)
     
     AND creator_id in
       (SELECT user_id
        FROM analytics.dw_user_activity
        WHERE activity_name in ('comment_on_own_listing', 'comment_on_community_listing')
        AND   activity_count = 1
        GROUP BY 1
        HAVING date(min(activity_at)) = '2015-04-10')
     
     
     SELECT comment_text
     FROM   analytics.dw_comments AS C
     INNER JOIN analytics.dw_users AS U on C.creator_id = U.user_id
     WHERE date(comment_created_at) = '2015-04-10' 
     AND creator_id IN
     
    (SELECT creator_id
     FROM   analytics.dw_comments
     WHERE  date(comment_created_at) = '2015-04-10' 
     GROUP BY 1
     HAVING COUNT(*) >= 6)
     
     
    SELECT user_id, min(activity_at)
    FROM analytics.dw_user_activity
    WHERE activity_name in ('comment_on_own_listing', 'comment_on_community_listing')
    AND   activity_count = 1
    GROUP BY 1
    HAVING date(min(activity_at)) = '2015-04-10'
    LIMIT 10
    
    
    
    
    
    
    
 
    
     SELECT U.user_id, SUM(CASE WHEN (U.user_id = L.seller_id) THEN 1 ELSE 0 END) AS OWN, SUM(CASE WHEN (U.user_id != L.seller_id) THEN 1 ELSE 0 END) AS EX
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = R."to|id" 
     WHERE date(U.joined_at) = '2016-05-22'
     AND   R."do|t" = 'c'
     AND   date(R."at") = date(U.joined_at)
     GROUP BY 1
     HAVING SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c')  THEN 1 ELSE 0 END) BETWEEN 4 and 5

    
    
    SELECT *
    FROM analytics.dw_listings 
    LIMIT 10
    
    
    
     