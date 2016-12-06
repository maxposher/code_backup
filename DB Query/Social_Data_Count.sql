

(SELECT distinct dw_user_activity.user_id, dw_user_activity.activity_date AS booked_at
FROM analytics.dw_user_activity AS dw_user_activity
WHERE dw_user_activity.activity_name = 'item_purchased' 
AND dw_user_activity.activity_count = 1
AND dw_user_activity.activity_date >= '2015-01-01'
GROUP BY dw_user_activity.activity_date, dw_user_activity.user_id)



(SELECT U.join_date AS DD, U.user_id AS ID, 
       SUM(CASE WHEN A.activity_name ='listing_created' THEN 1 ELSE 0 END) AS List,
       SUM(CASE WHEN A.activity_name ='comment_on_community_listing' THEN 1 ELSE 0 END) AS Comm,
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND U.join_date >= '2015-01-01'
AND U.date_buyer_activated IS NOT NULL
AND (DATE(U.date_buyer_activated) - DATE(U.join_date) + 1 = 1) 
AND (DATE(U.date_buyer_activated) >= DATE(A.activity_date)) 
GROUP BY U.join_date, U.user_id
)



SELECT avg(date(A.activity_date) - date(U.join_date))
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U on A.user_id = U.user_id
WHERE A.activity_name = 'item_sold' 
AND A.activity_count = 300
AND A.activity_date >= '2015-01-01'


SELECT count(distinct A.user_id)
FROM analytics.dw_user_activity AS A
WHERE A.activity_name = 'item_sold' 
AND A.activity_count = 300
AND A.activity_date >= '2015-01-01'



SELECT count(distinct U.user_id)
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U on A.user_id = U.user_id
WHERE A.activity_name = 'item_sold' 
AND A.activity_count = 100
AND A.activity_date >= '2015-01-01'





/* # of people reach 5 likes and 2 Comm */
SELECT DD, count (ID)
FROM
(SELECT U.join_date AS DD, U.user_id AS ID, 
       SUM(CASE WHEN A.activity_name ='comment_on_community_listing' THEN 1 ELSE 0 END) AS Comm,
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND U.join_date >= '2015-01-01'
AND U.is_referred_with_code != TRUE
AND ((DATE(A.activity_date) - DATE(U.join_date) + 1 ) <= 1) 
AND (DATE(U.date_buyer_activated) >= DATE(A.activity_date) OR U.date_buyer_activated IS NULL) 
GROUP BY U.join_date, U.user_id
HAVING SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) >= 1
)
GROUP BY DD
ORDER BY DD




AND U.is_referred_with_code != TRUE
HAVING SUM(CASE WHEN A.activity_name ='comment_on_community_listing' THEN 1 ELSE 0 END) = 0

HAVING SUM(CASE WHEN A.activity_name ='comment_on_community_listing' THEN 1 ELSE 0 END) = 0
AND SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) > 0






SELECT U.join_date AS DD, COUNT (distinct U.user_id) AS C
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND U.join_date >= '2015-01-01'
AND (DATE(A.activity_date) - DATE(U.join_date) + 1 = 1) 
AND (DATE(U.date_buyer_activated) >= DATE(A.activity_date) OR U.date_buyer_activated IS NULL) 
GROUP BY U.join_date
HAVING SUM(CASE WHEN A.activity_name ='comment_on_community_listing' THEN 1 ELSE 0 END) = 0
AND SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) >= 3



