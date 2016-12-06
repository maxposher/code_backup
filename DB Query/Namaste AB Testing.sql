

SELECT dw_users.join_date AS DD, COUNT(distinct dw_users.user_id ) AS ID
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users ON dw_user_activity.user_id = dw_users.user_id
WHERE DATE(dw_user_activity.activity_date) = '2015-08-13'  
AND dw_users.signup_segment IN ('C', 'D', 'F', 'H')
AND (dw_user_activity.activity_name = 'item_purchased') 
AND NOT dw_users.guest_user
AND dw_users.join_date = '2015-08-13'
AND dw_users.user_id IN
                 (
                        SELECT L.seller_id
                        FROM analytics.dw_listings As L
                        INNER JOIN analytics.dw_user_activity AS UA ON UA.activity_detail = L.listing_id
                        WHERE L.create_source_type = 'system'
                        AND UA.activity_name = 'comment_on_community_listing'
                        GROUP BY L.seller_id                  
                                               )                                                             
GROUP BY    dw_users.join_date






SELECT dw_users.join_date AS DD, COUNT(distinct dw_users.user_id ) AS ID
FROM  analytics.dw_users AS dw_users 
WHERE dw_users.signup_segment IN ('C', 'D', 'F', 'H')
AND NOT dw_users.guest_user
AND dw_users.join_date = '2015-08-13'
AND dw_users.user_id IN
                 (
                        SELECT L.seller_id
                        FROM analytics.dw_listings As L
                        INNER JOIN analytics.dw_user_activity AS UA ON UA.activity_detail = L.listing_id
                        WHERE L.create_source_type = 'system'
                        AND UA.activity_name = 'comment_on_community_listing'
                        GROUP BY L.seller_id                  
                                               )                                                             
GROUP BY    dw_users.join_date



    SELECT L.seller_id,
    SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c' AND L.create_source_type = 'system') THEN 1 ELSE 0 END) AS Intro_Comments_Received,
    SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN 1 ELSE 0 END) AS Comments_Received,
    SUM(CASE WHEN (R."v" = 'l' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS Likes_Received
  
    FROM raw_events.all as R 
    INNER JOIN analytics.dw_listings AS L ON R."to|id" = L.listing_id
    INNER JOIN analytics.dw_users AS U ON U.user_id = L.seller_id 
    WHERE U.join_date = '2015-11-01'
    GROUP BY L.seller_id
    LIMIT 100





  
    SELECT R.*
    FROM raw_events.all as R 
    INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
    INNER JOIN analytics.dw_users AS U ON U.user_id = L.seller_id 
    WHERE U.join_date = '2015-10-01'
    LIMIT 50
    
    GROUP BY L.seller_id
    LIMIT 10

    SELECT R.*
    FROM raw_events.all as R 
    WHERE (R."v" = 'p' AND R."do|t" = 'c')
    LIMIT 25


/* New Query */
SELECT dw_users.join_date AS DD, COUNT(distinct dw_users.user_id ) AS ID
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users ON dw_user_activity.user_id = dw_users.user_id
WHERE DATE(dw_user_activity.activity_date) = DATE(dw_users.join_date)
AND dw_users.signup_segment IN ('E', 'G', 'I', 'J')
AND (dw_user_activity.activity_name = 'listing_created') 
AND NOT dw_users.guest_user
AND dw_users.join_date >= '2015-08-06'
AND dw_users.join_date <= '2015-08-21'                                                      
GROUP BY    dw_users.join_date
ORDER BY    dw_users.join_date



SELECT dw_users.join_date AS DD, COUNT(distinct dw_users.user_id ) AS ID
FROM  analytics.dw_users AS dw_users 
WHERE dw_users.signup_segment IN  ('E', 'G', 'I', 'J')
AND NOT dw_users.guest_user
AND dw_users.join_date >= '2015-08-07'
AND dw_users.join_date <= '2015-08-31'
GROUP BY    dw_users.join_date
ORDER BY    dw_users.join_date



select E."at", E."v",E."do|t", E."to|id", E."do|id"
from raw_events.all AS E
where 
E."a|id" = '56364e141d1e9e633101e070'
AND E."v" = 'f'
AND E."at" <= '2015-11-03'
LIMIT 1000