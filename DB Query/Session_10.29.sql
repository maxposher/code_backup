/*Old Session Reference Code */
/*When select specific platforms; need to set the other platform to null */
SELECT raw_mongo_user_traces.dt, SUM(raw_mongo_user_traces_agg.iba) AS "iPhone_sessions", SUM(raw_mongo_user_traces_agg.aba) AS "Android_sessions",SUM(raw_mongo_user_traces_agg.wba) AS "Web_sessions" 
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-06-30'
AND dw_users.date_lister_activated is NOT NULL
AND dw_users.days_since_last_listing < 8
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt




/* Android Session Analysis */
SELECT date(raw_mongo_user_traces.dt), 
	CASE
WHEN buyer.join_date < '2013-01-01' THEN 'A. 2011_2012' 
WHEN buyer.join_date >= '2013-01-01' AND buyer.join_date < '2013-04-01' THEN 'B. Q1-2013' 
WHEN buyer.join_date >= '2013-04-01' AND buyer.join_date < '2013-07-01' THEN 'C. Q2-2013' 
WHEN buyer.join_date >= '2013-07-01' AND buyer.join_date < '2013-10-01' THEN 'D. Q3-2013' 
WHEN buyer.join_date >= '2013-10-01' AND buyer.join_date < '2014-01-01' THEN 'E. Q4-2013' 
WHEN buyer.join_date >= '2014-01-01' AND buyer.join_date < '2014-04-01' THEN 'F. Q1-2014' 
WHEN buyer.join_date >= '2014-04-01' AND buyer.join_date < '2014-07-01' THEN 'G. Q2-2014' 
WHEN buyer.join_date >= '2014-07-01' AND buyer.join_date < '2014-10-01' THEN 'H. Q3-2014' 
WHEN buyer.join_date >= '2014-10-01' AND buyer.join_date < '2015-01-01' THEN 'I. Q4-2014' 
WHEN buyer.join_date >= '2015-01-01' AND buyer.join_date < '2015-04-01' THEN 'J. Q1-2015' 
WHEN buyer.join_date >= '2015-04-01' AND buyer.join_date < '2015-07-01' THEN 'K. Q2-2015' 
WHEN buyer.join_date >= '2015-07-01' AND buyer.join_date < '2015-10-01' THEN 'L. Q3-2015' 
WHEN buyer.join_date >= '2015-10-01' AND buyer.join_date < '2015-11-01' THEN 'M. Oct-2015' 
ELSE 'Unknown' 
END AS "Super_cohort", SUM(raw_mongo_user_traces_agg.aba), COUNT (distinct  raw_mongo_user_traces.uid)
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS buyer ON raw_mongo_user_traces.uid  = buyer.user_id
WHERE raw_mongo_user_traces.dt >= '2015-01-01'
AND raw_mongo_user_traces_agg.iba IS NULL
AND raw_mongo_user_traces_agg.wba IS NULL
GROUP BY date(raw_mongo_user_traces.dt), Super_cohort
ORDER BY date(raw_mongo_user_traces.dt)




Select D, Super_cohort, sum(P)
FROM
(
SELECT date(raw_mongo_user_traces.dt) AS D, 
	CASE
WHEN buyer.join_date < '2013-01-01' THEN 'A. 2011_2012' 
WHEN buyer.join_date >= '2013-01-01' AND buyer.join_date < '2013-04-01' THEN 'B. Q1-2013' 
WHEN buyer.join_date >= '2013-04-01' AND buyer.join_date < '2013-07-01' THEN 'C. Q2-2013' 
WHEN buyer.join_date >= '2013-07-01' AND buyer.join_date < '2013-10-01' THEN 'D. Q3-2013' 
WHEN buyer.join_date >= '2013-10-01' AND buyer.join_date < '2014-01-01' THEN 'E. Q4-2013' 
WHEN buyer.join_date >= '2014-01-01' AND buyer.join_date < '2014-04-01' THEN 'F. Q1-2014' 
WHEN buyer.join_date >= '2014-04-01' AND buyer.join_date < '2014-07-01' THEN 'G. Q2-2014' 
WHEN buyer.join_date >= '2014-07-01' AND buyer.join_date < '2014-10-01' THEN 'H. Q3-2014' 
WHEN buyer.join_date >= '2014-10-01' AND buyer.join_date < '2015-01-01' THEN 'I. Q4-2014' 
WHEN buyer.join_date >= '2015-01-01' AND buyer.join_date < '2015-04-01' THEN 'J. Q1-2015' 
WHEN buyer.join_date >= '2015-04-01' AND buyer.join_date < '2015-07-01' THEN 'K. Q2-2015' 
WHEN buyer.join_date >= '2015-07-01' AND buyer.join_date < '2015-10-01' THEN 'L. Q3-2015' 
WHEN buyer.join_date >= '2015-10-01' AND buyer.join_date < '2015-11-01' THEN 'M. Oct-2015' 
ELSE 'Unknown' 
END AS "Super_cohort",
COUNT (distinct  raw_mongo_user_traces.uid) AS P
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS buyer ON raw_mongo_user_traces.uid  = buyer.user_id
WHERE raw_mongo_user_traces.dt >= '2015-06-01'
AND raw_mongo_user_traces_agg.iba IS NULL
AND raw_mongo_user_traces_agg.wba IS NULL
GROUP BY date(raw_mongo_user_traces.dt), Super_cohort
ORDER BY date(raw_mongo_user_traces.dt)
)
GROUP BY D, Super_cohort
ORDER BY D







SELECT date(raw_mongo_user_traces.dt) AS D, COUNT (distinct  raw_mongo_user_traces.uid) AS ID, SUM(raw_mongo_user_traces_agg.aba)
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS buyer ON raw_mongo_user_traces.uid  = buyer.user_id
WHERE raw_mongo_user_traces.dt >= '2015-06-01'
AND 
AND 
GROUP BY date(raw_mongo_user_traces.dt)
ORDER BY date(raw_mongo_user_traces.dt)

SELECT raw_mongo_user_traces.dt, COUNT (distinct  raw_mongo_user_traces.uid)
FROM raw_mongo.user_traces AS raw_mongo_user_traces
LEFT JOIN raw_mongo.user_traces_agg AS raw_mongo_user_traces_agg ON raw_mongo_user_traces_agg.user_traces_id = raw_mongo_user_traces.generated_id
LEFT JOIN analytics.dw_users AS dw_users ON raw_mongo_user_traces.uid  = dw_users.user_id
WHERE raw_mongo_user_traces.dt > '2015-06-30'
AND dw_users.date_lister_activated is NOT NULL
AND  raw_mongo_user_traces_agg.aba IS NOT NULL
GROUP BY raw_mongo_user_traces.dt 
ORDER BY raw_mongo_user_traces.dt


