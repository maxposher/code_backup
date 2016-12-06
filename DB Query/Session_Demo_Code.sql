


SELECT  CAST( SUM(raw_mongo_user_traces_agg.iba)/SUM(CASE WHEN raw_mongo_user_traces_agg.iba IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT)   AS "iPhone_sessions", 
        CAST( SUM(raw_mongo_user_traces_agg.aba)/SUM(CASE WHEN raw_mongo_user_traces_agg.aba IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT)   AS "Android_sessions",
        CAST( SUM(raw_mongo_user_traces_agg.wba)/SUM(CASE WHEN raw_mongo_user_traces_agg.wba IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT)   AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt = '2015-07-22'
AND dw_users.user_id IN
(
SELECT UA.user_id
FROM analytics.dw_user_activity AS UA
WHERE  UA.activity_name = 'listing_created'
AND '2015-07-22' - date(UA.activity_date) <= 7
AND '2015-07-22' - date(UA.activity_date) >= 1
)




SELECT  AVG(CAST(raw_mongo_user_traces_agg.iba  AS FLOAT))   AS "iPhone_sessions", 
        AVG(CAST(raw_mongo_user_traces_agg.aba  AS FLOAT))   AS "Android_sessions",
        AVG(CAST(raw_mongo_user_traces_agg.wba  AS FLOAT))   AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt = '2015-09-06'
AND dw_users.user_id IN
(
SELECT UA.user_id
FROM analytics.dw_user_activity AS UA
WHERE  UA.activity_name = 'item_sold'
AND '2015-09-06' - date(UA.activity_date) <= 30
AND '2015-09-06' - date(UA.activity_date) >= 1
GROUP BY UA.user_id
)





GROUP BY raw_mongo_user_traces.uid



