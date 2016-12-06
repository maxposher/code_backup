
/* Average Purchase next N days */
/* additional purchase */
SELECT join_date, avg(CAST(out_put as FLOAT))
FROM
(
SELECT U.join_date, U.user_id, (max(activity_count) - min(activity_count)) AS out_put
FROM analytics.dw_user_activity AS UA
INNER JOIN analytics.dw_users AS U on UA.user_id = U.user_id
WHERE U.join_date >= '2015-01-01'
AND   U.join_date < '2015-08-12' 
AND U.is_referred_with_code = 1
AND UA.activity_name = 'item_purchased'
AND (DATE(activity_date) - DATE(U.join_date) <= 7)
GROUP BY U.join_date, U.user_id
)
GROUP BY join_date
ORDER BY join_date



SELECT U.join_date, R."at",U.user_id, R."do|tm" 
FROM raw_events as R
INNER JOIN analytics.dw_users AS U ON R."a|id" = U.user_id
ORDER BY U.join_date, R."at"
LIMIT 100



SELECT max(R."at") 
FROM raw_events as R
GROUP BY R."at"
ORDER BY R."at"

LIMIT 20



/* Max # of Buy */
SELECT join_date, avg(CAST(out_put as FLOAT))
FROM
(
SELECT U.join_date, U.user_id, max(activity_count) AS out_put
FROM analytics.dw_user_activity AS UA
INNER JOIN analytics.dw_users AS U on UA.user_id = U.user_id
WHERE U.join_date >= '2015-07-01'
AND   U.join_date < '2015-08-12' 
AND U.is_referred_with_code = 1
AND UA.activity_name = 'item_purchased'
AND (DATE(activity_date) - DATE(U.join_date) <= 7)
GROUP BY U.join_date, U.user_id
)
GROUP BY join_date
ORDER BY join_date






SELECT U.join_date, 
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 0 THEN 1 ELSE 0 END) AS D1,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 1 THEN 1 ELSE 0 END) AS D2,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 2 THEN 1 ELSE 0 END) AS D3,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 3 THEN 1 ELSE 0 END) AS D4,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 4 THEN 1 ELSE 0 END) AS D5,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 5 THEN 1 ELSE 0 END) AS D6,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 6 THEN 1 ELSE 0 END) AS D7,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 7 THEN 1 ELSE 0 END) AS D8,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 8 THEN 1 ELSE 0 END) AS D9,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) = 9 THEN 1 ELSE 0 END) AS D10,
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) >= 10 THEN 1 ELSE 0 END) AS D11_plus, 
       SUM(CASE WHEN (Date(U.date_buyer_activated) - Date(U.join_date)) >= 30 THEN 1 ELSE 0 END) AS D30_plus  
FROM   analytics.dw_users AS U 
WHERE  U.date_buyer_activated IS NOT NULL
AND NOT U.guest_user
AND U.join_date >= '2015-01-01'
AND U.join_date < '2015-05-01'
AND U.reg_app = 'web'
GROUP BY U.join_date
ORDER BY U.join_date








