
/* Correct Code */
SELECT date(A.activity_date), 
       SUM(CASE WHEN A.activity_name ='item_purchased' THEN 1 ELSE 0 END) AS Buyer,
       SUM(CASE WHEN A.activity_name ='listing_created' THEN 1 ELSE 0 END) AS Lister,
       SUM(CASE WHEN A.activity_name ='join_poshmark' THEN 1 ELSE 0 END) AS New_User
FROM analytics.dw_user_activity AS A
WHERE A.activity_date >= '2015-08-01'
AND A.activity_count = 1
GROUP BY date(A.activity_date)
ORDER BY date(A.activity_date)








SELECT U.join_date, 
       SUM(CASE WHEN A.activity_name ='item_purchased' THEN 1 ELSE 0 END) AS Buyer,
       SUM(CASE WHEN A.activity_name ='listing_created' THEN 1 ELSE 0 END) AS Lister,
       SUM(CASE WHEN A.activity_name ='join_poshmark' THEN 1 ELSE 0 END) AS New_User
FROM analytics.dw_user_activity AS A
LEFT JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE   DATE(U.date_buyer_activated) >= DATE(A.activity_date)
AND NOT U.guest_user
AND U.join_date >= '2015-07-01'
AND A.activity_count = 1
GROUP BY U.join_date
ORDER BY U.join_date



SELECT distinct A.activity_name 
FROM analytics.dw_user_activity AS A
LIMIT 20