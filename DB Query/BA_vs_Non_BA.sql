


SELECT U.date_buyer_activated, U.user_id, (Date(U.date_buyer_activated) - Date(U.join_date)) AS Diff, max(A.activity_count)
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE U.date_buyer_activated >= A.activity_date
AND A.activity_name = 'like_listing'
AND NOT U.guest_user
AND U.join_date >= '2015-01-01'
GROUP BY U.user_id, U.date_buyer_activated, U.join_date
ORDER BY U.date_buyer_activated


SELECT U.date_buyer_activated, U.user_id, (Date(U.date_buyer_activated) - Date(U.join_date)) AS D_Diff, 
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes,
       SUM(CASE WHEN A.activity_name ='comment_on_own_listing' THEN 1 ELSE 0 END) AS Comms,
       SUM(CASE WHEN A.activity_name ='active_on_app' THEN 1 ELSE 0 END) AS Active,
       U.reg_app AS App
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE   DATE(U.date_buyer_activated) >= DATE(A.activity_date)
AND NOT U.guest_user
AND U.join_date >= '2015-01-01'
GROUP BY U.user_id, U.date_buyer_activated, U.join_date, U.reg_app
ORDER BY U.date_buyer_activated



SELECT U.join_date, U.user_id, U.date_buyer_activated, 
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes,
       SUM(CASE WHEN A.activity_name ='comment_on_own_listing' THEN 1 ELSE 0 END) AS Comms,
       SUM(CASE WHEN A.activity_name ='comment_on_own_listing' THEN 1 ELSE 0 END) AS Comms,
       U.reg_app AS App
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE   (DATE(A.activity_date) - DATE(U.join_date)) <= 10
AND NOT U.guest_user
AND U.join_date >= '2015-04-02'
AND U.join_date <= '2015-05-01'
AND U.reg_app = 'iphone'
GROUP BY U.join_date, U.user_id, U.date_buyer_activated, U.reg_app
ORDER BY U.join_date
LIMIT 1000000





SELECT U.join_date, U.user_id, U.date_buyer_activated, U.size_dress, U.acq_channel,U.signup_segment, U.referrals, U.is_referred_with_code,
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes,
       SUM(CASE WHEN A.activity_name ='comment_on_own_listing' THEN 1 ELSE 0 END) AS Comms,
       SUM(CASE WHEN A.activity_name ='active_on_app' THEN 1 ELSE 0 END) AS Active,
       U.reg_app AS App
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE   (DATE(A.activity_date) - DATE(U.join_date)) <= 1
AND NOT U.guest_user
AND U.join_date >= '2015-02-01'
AND U.join_date < '2015-04-01'
AND U.reg_app = 'web'
GROUP BY U.join_date, U.user_id, U.date_buyer_activated, U.reg_app, U.size_dress, U.acq_channel, U.signup_segment, U.referrals, U.is_referred_with_code
ORDER BY U.join_date
LIMIT 1000000


SELECT U.join_date, U.user_id, U.date_buyer_activated, COUNT(distinct B.user_id),
       U.reg_app AS App
FROM analytics.dw_users AS U 
LEFT JOIN analytics.dw_users AS B ON U.user_id = B.referred_by_user_id
WHERE  date(U.join_date) = date(B.join_date)
AND NOT U.guest_user
AND U.join_date >= '2015-03-01'
AND U.join_date < '2015-04-01'
AND U.reg_app = 'iphone'
GROUP BY U.join_date, U.user_id, U.date_buyer_activated, U.reg_app
ORDER BY U.join_date
LIMIT 1000000










SELECT count(U.is_referred_with_code)
FROM analytics.dw_users AS U
WHERE U.is_referred_with_code IS TRUE
AND NOT U.guest_user
AND U.date_buyer_activated IS NULL


SELECT count(distinct U.user_id)
FROM analytics.dw_users AS U
WHERE U.is_referred_with_code IS TRUE
AND NOT U.guest_user
AND U.date_buyer_activated IS NULL



SELECT count(U.referrals)
FROM analytics.dw_users AS U
WHERE U.referrals IS NOT NULL
AND NOT U.guest_user
AND U.date_buyer_activated IS NOT NULL




SELECT avg(U.date_buyer_activated - U.join_date)
FROM analytics.dw_users AS U
WHERE NOT U.guest_user


SELECT avg(U.date_buyer_activated - U.join_date)
FROM analytics.dw_users AS U
WHERE NOT U.guest_user

SELECT U.*
FROM analytics.dw_users AS U
LIMIT 10



SELECT count(distinct U.user_id)
FROM analytics.dw_users AS U
WHERE U.is_referred_with_code IS TRUE
AND NOT U.guest_user
AND U.date_buyer_activated IS NULL






SELECT count(distinct U.user_id)
FROM analytics.dw_users AS U
WHERE NOT U.guest_user
AND U.date_buyer_activated IS NOT NULL



/* Code for Betty */
SELECT COUNT(distinct A.user_id)
FROM analytics.dw_user_activity AS A
WHERE DATEDIFF(DAY, A.activity_date, '2015-08-08') <= 3
AND A.activity_name = 'join_poshmark' 


SELECT O.cancelled_by, O.cancelled_on
FROM analytics.dw_orders AS O
WHERE O.cancelled_by IS NOT NULL
LIMIT 10 











SELECT U.join_date, U.user_id, U.date_buyer_activated,
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes,
       SUM(CASE WHEN A.activity_name ='comment_on_own_listing' THEN 1 ELSE 0 END) AS Comms,
       SUM(CASE WHEN A.activity_name ='active_on_app' THEN 1 ELSE 0 END) AS Active
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE   DATE(U.join_date) >= DATE(A.activity_date)
AND NOT U.guest_user
AND U.join_date = '2015-01-01'
GROUP BY U.join_date, U.user_id, U.date_buyer_activated
ORDER BY U.join_date
LIMIT 300000



SELECT U.join_date, U.user_id, U.date_buyer_activated,
       SUM(CASE WHEN A.activity_name ='like_listing' THEN 1 ELSE 0 END) AS Likes,
       SUM(CASE WHEN A.activity_name ='comment_on_own_listing' THEN 1 ELSE 0 END) AS Comms
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE  DATE(A.activity_date) - DATE(U.join_date) = 1
AND NOT U.guest_user
AND U.join_date >= '2015-01-01'
AND U.join_date >= '2015-01-01'
GROUP BY U.join_date, U.user_id, U.date_buyer_activated
ORDER BY U.join_date
LIMIT 1000000