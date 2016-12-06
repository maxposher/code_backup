

SELECT DD, AVG(CAST(List as float)), AVG(CAST(Comm as float)), AVG(CAST(Likes as float))
FROM
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
GROUP BY DD
ORDER BY DD



SELECT join_date, avg(CAST(out_put as FLOAT))
FROM
(
SELECT U.join_date, U.user_id, (max(activity_count) - min(activity_count)) AS out_put
FROM analytics.dw_user_activity AS UA
INNER JOIN analytics.dw_users AS U on UA.user_id = U.user_id
WHERE U.join_date >= '2015-07-04'
AND   U.join_date < '2015-08-15' 
AND   UA.activity_name = 'active_on_app'
AND  U.signup_segment IN ('A','B')
AND (DATE(U.date_buyer_activated) - DATE(U.join_date)) = 2 
AND (DATE(activity_date) - DATE(U.date_buyer_activated) <= 29)
GROUP BY U.join_date, U.user_id
)
GROUP BY join_date
ORDER BY join_date



AND   U.signup_segment IN ('C','E','F','G')
AND  U.signup_segment IN ('D','H','I','J')  /* 2.99 */
AND  U.signup_segment IN ('A','B')




SELECT join_date, avg(CAST(out_put as FLOAT))
FROM
(
SELECT U.join_date, U.user_id, (max(activity_count) - min(activity_count)) AS out_put
FROM analytics.dw_user_activity AS UA
INNER JOIN analytics.dw_users AS U on UA.user_id = U.user_id
WHERE U.join_date = '2015-07-04'
AND   UA.activity_name = 'item_purchased'
AND   U.signup_segment IN ('C')
AND (DATE(U.date_buyer_activated) - DATE(U.join_date)) = 2 
AND (DATE(activity_date) - DATE(U.date_buyer_activated) <= 29)
GROUP BY U.join_date, U.user_id
)
GROUP BY join_date
ORDER BY join_date
