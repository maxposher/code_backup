

/* Lister made a listing past 7 days */
SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.iba) AS "iPhone_sessions", SUM(raw_mongo_user_traces_agg.aba) AS "Android_sessions",SUM(raw_mongo_user_traces_agg.wba) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-06-30'
AND dw_users.date_lister_activated is NOT NULL
AND dw_users.days_since_last_listing < 8
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt



SELECT U.join_date, U.user_id, (max(activity_count) - min(activity_count)) AS out_put
FROM analytics.dw_user_activity AS UA
INNER JOIN analytics.dw_users AS U on UA.user_id = U.user_id
WHERE U.join_date >= '2015-01-01'
AND   U.join_date < '2015-08-12' 
AND U.is_referred_with_code = 1
AND UA.activity_name = 'item_purchased'
AND (DATE(activity_date) - DATE(U.join_date) <= 7)
GROUP BY U.join_date, U.user_id



SELECT raw_mongo_user_traces.dt, avg(CAST( raw_mongo_user_traces_agg.iba AS float)) AS "iPhone_sessions", avg(CAST(raw_mongo_user_traces_agg.aba AS float)) AS "Android_sessions",avg(CAST(raw_mongo_user_traces_agg.wba AS float)) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
WHERE raw_mongo_user_traces.dt = '2015-08-20'
AND   raw_mongo_user_traces.uid IN 

( SELECT distinct UA.user_id
  FROM analytics.dw_user_activity AS UA
  WHERE UA.activity_date <= '2015-08-20'
  AND   UA.activity_date >= (DATE('2015-08-20') - 30)                           
  AND   UA.activity_name = 'listing_created')

GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt




SELECT distinct UA.user_id
FROM analytics.dw_user_activity AS UA
WHERE UA.activity_date = '2015-06-01'








SELECT distinct UA.activity_name
FROM analytics.dw_user_activity AS UA

'item_sold'
'listing_created'