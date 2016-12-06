/* Sessions for users without a closet */
SELECT DATE(raw_mongo_user_traces.dt),   count(distinct raw_mongo_user_traces.uid)
FROM raw_mongo.user_traces AS raw_mongo_user_traces
INNER JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
INNER JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-06-30'
AND dw_users.date_lister_activated is NULL
AND raw_mongo_user_traces_agg.aba > 0
GROUP BY DATE(raw_mongo_user_traces.dt) 
ORDER BY DATE(raw_mongo_user_traces.dt)



 sum(raw_mongo_user_traces_agg.iba) 



AND dw_users.date_lister_activated IS NOT NULL

AND dw_users.date_lister_activated IS NULL
count(distinct dw_users.user_id)

AND dw_users.date_lister_activated IS NULL

/* Sessions for users with a closet */
SELECT raw_mongo_user_traces.dt, avg(raw_mongo_user_traces_agg.iba) AS "iPhone_sessions", count(distinct raw_mongo_user_traces.uid) AS "Android_sessions",avg(raw_mongo_user_traces_agg.wba) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-04-30'
AND dw_users.date_lister_activated is NOT NULL
AND dw_users.date_lister_activated < raw_mongo_user_traces.dt
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt


/* Lister made a listing past 7 days */
SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.iba) AS "iPhone_sessions", SUM(raw_mongo_user_traces_agg.aba) AS "Android_sessions",SUM(raw_mongo_user_traces_agg.wba) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-04-30'
AND dw_users.date_lister_activated is NOT NULL
AND dw_users.days_since_last_listing < 8
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt

/* Lister made a listing past 30 days */
SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.iba) AS "iPhone_sessions", SUM(raw_mongo_user_traces_agg.aba) AS "Android_sessions",SUM(raw_mongo_user_traces_agg.wba) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-04-30'
AND dw_users.date_lister_activated is NOT NULL
AND dw_users.days_since_last_listing < 31
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt

/* last sell 7 days */
SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.iba) AS "iPhone_sessions", SUM(raw_mongo_user_traces_agg.aba) AS "Android_sessions",SUM(raw_mongo_user_traces_agg.wba) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-04-30'
AND dw_users.date_lister_activated is NOT NULL
AND dw_users.days_since_last_sell < 8
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt

/* last sell 30 days */
SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.iba) AS "iPhone_sessions", SUM(raw_mongo_user_traces_agg.aba) AS "Android_sessions",SUM(raw_mongo_user_traces_agg.wba) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-04-30'
AND dw_users.date_lister_activated is NOT NULL
AND dw_users.days_since_last_sell < 31
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt



Select DISTINCT A.activity_name
FROM analytics.dw_user_activity AS A
LIMIT 10
