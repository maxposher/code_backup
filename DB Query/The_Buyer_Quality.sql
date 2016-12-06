

 SELECT max(FP)
      FROM(
      
      SELECT R."a|id" AS user_id, 
      SUM(CASE WHEN (R."v" = 'f' and R."do|t"  = 'u') THEN 1  ELSE 0 END) AS FP

      FROM raw_events."all" AS R
      WHERE DATE(R."at") = '2016-03-14'
      AND R."v" = 'f'
      GROUP BY 1
      ORDER BY 1)
      
      WHERE FP >= 191
      
      
      SELECT * 
      FROM(  
        
      SELECT percentile_cont(0.50) within group (order by FB ASC)  over() AS FB_Threshold,  
             percentile_cont(0.50) within group (order by FP ASC)  over() AS FP_Threshold,
             percentile_cont(0.50) within group (order by I_S ASC)  over() AS IS_Threshold,
             percentile_cont(0.50) within group (order by ES ASC)  over() AS ES_Threshold             
      FROM                        
     (      
      SELECT DATE(R."at") AS action_date, R."a|id", 
      SUM(CASE WHEN (R."v" = 'f' and R."do|t"  = 'b') THEN 1  ELSE 0 END) AS  FB,
      SUM(CASE WHEN (R."v" = 'f' and R."do|t"  = 'u') THEN 1  ELSE 0 END) AS  FP,
      SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN 1 ELSE 0 END)  AS  I_S,
      SUM(CASE WHEN (R."v" = 'es' AND R."do|t" = 'l') THEN 1 ELSE 0 END)  AS  ES

      FROM raw_events."all" AS R
      WHERE DATE(R."at") ='2016-03-14'
      AND  (R."v" = 'f' OR R."v" = 's' OR R."v" = 'es')
      GROUP BY 1,2
      ORDER BY 1 DESC)
      
      ORDER BY 1
      )
      LIMIT 10
      
      
      
      
      
      
      
      
      SELECT * 
      FROM(  
      SELECT action_date, percentile_cont(0.5) within group (order by FB ASC)  over(partition by action_date) AS FB_Threshold 
        
      FROM                        
     (      
      SELECT DATE(R."at") AS action_date, R."a|id", 
      SUM(CASE WHEN (R."v" = 'f' and R."do|t"  = 'u') THEN 1  ELSE 0 END) AS  FB

      FROM raw_events."all" AS R
      WHERE DATE(R."at") = '2016-03-14'
      AND  (R."v" = 'f')
      AND  (R."do|t") = 'u'
      GROUP BY 1,2
      ORDER BY 1 DESC)
      GROUP BY 1
      ORDER BY 1
      )
      GROUP BY 
      LIMIT 10


/*************************************************************/
SELECT  DATE(dw_users.date_buyer_activated) AS "dw_users.buyer_activated_date",
	DATE(dw_user_activity.activity_date) - DATE(dw_users.date_buyer_activated) + 1 AS "dw_user_activity.day_since_ba_1",
	COUNT(DISTINCT CASE WHEN (dw_user_activity.activity_name ILIKE 'active_on_app') THEN dw_user_activity.user_id ELSE NULL END) AS "dw_user_activity.count_active_users"
FROM      analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users  AS dw_users ON dw_user_activity.user_id = dw_users.user_id
LEFT JOIN analytics.dw_orders AS O        ON dw_users.user_id = O.buyer_id
WHERE (DATE(dw_user_activity.activity_date) - DATE(dw_users.date_buyer_activated) + 1 >= 1) 
AND   (dw_user_activity.activity_name ILIKE 'active_on_app') 
AND   ((((dw_users.date_buyer_activated) >= (DATEADD(day,-89, DATE_TRUNC('day',GETDATE()) )) 
AND   (dw_users.date_buyer_activated) < (DATEADD(day,90, DATEADD(day,-89, DATE_TRUNC('day',GETDATE()) ) )))))
------------------------------------------------------
AND    O.order_number = 1
AND  ((O.buyer_shipping_fee < 499 AND O.booked_at  < '2016-02-17 18:00:00') OR (O.buyer_shipping_fee < 599 AND O.booked_at >= '2016-02-17 18:00:00'))
GROUP BY 1,2
ORDER BY 1 DESC
LIMIT 5000    
      

      
      
      
      
      
      
      
      
      
      
      
      
