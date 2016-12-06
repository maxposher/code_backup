

SELECT DD, count (ID)
FROM
(SELECT U.join_date AS DD, U.user_id AS ID, 
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes,
       SUM(CASE WHEN A.activity_name = 'listing_created' THEN 1 ELSE 0 END) AS Listing
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND U.join_date >= '2013-01-01'
AND U.join_date <= '2013-01-31'
AND U.is_referred_with_code != TRUE
AND ((DATE(A.activity_date) - DATE(U.join_date) + 1 ) <= 29) 
GROUP BY U.join_date, U.user_id
HAVING SUM(CASE WHEN A.activity_name ='listing_created' THEN 1 ELSE 0 END) >= 1
)
GROUP BY DD
ORDER BY DD




(SELECT COUNT (U.user_id)  AS C_ID, 
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes,
       SUM(CASE WHEN A.activity_name = 'listing_created' THEN 1 ELSE 0 END) AS Listing
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND U.join_date >= '2013-01-01'
AND U.join_date <= '2013-01-31'
AND U.is_referred_with_code != TRUE
AND ((DATE(A.activity_date) - DATE(U.join_date) + 1 ) <= 29) 
GROUP BY U.join_date, U.user_id
)

/* One year later */
SELECT U.user_id AS ID
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND A.activity_date >= '2015-01-01'
AND A.activity_date <= '2015-01-31'
AND A.activity_name = 'active_on_app'
AND U.join_date >= '2013-01-01'
AND U.join_date <= '2013-01-31'
AND U.is_referred_with_code != TRUE


        


(SELECT COUNT (distinct U.user_id)  AS C_ID
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND U.join_date >= '2013-01-01'
AND U.join_date <= '2013-01-31'
AND U.is_referred_with_code != TRUE
AND ((DATE(A.activity_date) - DATE(U.join_date) + 1 ) <= 29) 
AND A.activity_name ='like_listing'
HAVING MAX(A.activity_count) >= 5 )




SELECT COUNT (distinct A.user_id) 
FROM analytics.dw_user_activity AS A
WHERE A.activity_date >= '2015-01-01'
AND A.activity_date <= '2015-01-31'
AND A.activity_name = 'active_on_app'
AND A.user_id IN

(
SELECT U.user_id  
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND U.join_date >= '2013-01-01'
AND U.join_date <= '2013-01-31'
AND U.is_referred_with_code != TRUE
AND ((DATE(A.activity_date) - DATE(U.join_date) + 1 ) <= 29) 
AND A.activity_name ='comment_on_community_listing'
GROUP BY U.user_id
HAVING MAX(A.activity_count)>= 10 )







SELECT COUNT (distinct U.user_id ) 
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND U.join_date >= '2013-01-01'
AND U.join_date <= '2013-01-31'
GROUP BY U.user_id

