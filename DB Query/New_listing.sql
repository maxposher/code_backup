
SELECT  DATE(A.activity_date), COUNT(*), SUM(COUNT(*)) OVER(ORDER BY Date(A.activity_date) ROWS BETWEEN 2 PRECEDING AND 0 FOLLOWING) AS AvgA
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE A.activity_name = 'like_listing' 
GROUP BY DATE(A.activity_date)
LIMIT 10


SELECT  DATE(A.activity_date), COUNT(*), COUNT(*) OVER(ORDER BY Date(A.activity_date) ROWS BETWEEN (Date(A.activity_date)-7) PRECEDING AND CURRENT ROW) AS AvgA
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE A.activity_name = 'like_listing'
GROUP BY DATE(A.activity_date)
LIMIT 10



SELECT DATE(A.activity_date), U.user_id 
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE A.activity_name = 'like_listing' 
AND DATE(A.activity_date) > '2015-01-01' 
GROUP BY DATE(A.activity_date), U.user_id



SELECT A.created_at, U.user_id 
FROM analytics.dw_listings AS A
INNER JOIN analytics.dw_users AS U ON A.seller_id = U.user_id
AND DATE(A.created_at) > '2015-06-01' 
GROUP BY A.created_at, U.user_id


SELECT  DATE(A.created_date), COUNT(*), (A.created_date - 7) AS D2,
SUM(CASE WHEN D2 BETWEEN A.created_date - 7 AND A.created_date THEN 1 else 0 END)  
FROM analytics.dw_listings AS A
INNER JOIN analytics.dw_users AS U ON A.seller_id = U.user_id
GROUP BY D2, A.created_date
ORDER BY D2
LIMIT 100




SELECT raw_mongo_user_traces.dt, raw_mongo_user_traces_agg.*
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
INNER JOIN analytics.dw_listings AS L ON dw_users.user_id = L.seller_id
WHERE raw_mongo_user_traces.dt = '2015-06-01' AND L.created_date < '2015-06-01'
AND raw_mongo_user_traces_agg.iba IS NOT NULL 
AND dw_users.date_lister_activated is NOT NULL
AND dw_users.user_id = '51fb74366056d577d1034088'

GROUP BY raw_mongo_user_traces.dt, dw_users.user_id, raw_mongo_user_traces_agg.iba
ORDER BY raw_mongo_user_traces.dt

SELECT *
FROM analytics.dw_listings AS L
WHERE L.seller_id = '51fb74366056d577d1034088'