SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.aba) AS "raw_mongo_user_traces.android_sessions"
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-04-30'
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt


/* iPhone */ 
SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.iba) AS "iPhone_sessions", SUM(raw_mongo_user_traces_agg.aba) AS "Android_sessions",SUM(raw_mongo_user_traces_agg.wba) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-04-30'
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt


SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.wba) AS "raw_mongo_user_traces.Web_sessions"
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-04-30'
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt







Select TOP 10 *
FROM raw_mongo.user_traces_agg

Select TOP 10 *
FROM raw_mongo.user_traces