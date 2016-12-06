


      SELECT * 
      FROM(  
        
      SELECT action_date, 
             percentile_cont(0.98) within group (order by FB)  over(partition by action_date) AS FB_Threshold
      FROM      
                        
     (      
      SELECT DATE(R."at") AS action_date, R."a|id", 
      SUM(CASE WHEN (R."v" = 'f' and R."do|t"  = 'u') THEN 1  ELSE 0 END) AS FB
      
      FROM raw_events."all" AS R
      WHERE DATE(R."at") ='2016-03-14'
      AND R."v" = 'f'
      AND R."do|t" = 'u'
      GROUP BY 1,2
      ORDER BY 1 DESC)
   
      ORDER BY 1
      )
      LIMIT 5
      
      
      
            SELECT * 
      FROM(  
        
      SELECT action_date, 
             percentile_cont(0.999) within group (order by FB)  over(partition by action_date) AS FB_Threshold
      FROM      
                        
     (      
      SELECT DATE(R."at") AS action_date, R."a|id", 
      SUM(CASE WHEN (R."v" = 's' and R."do|t"  = 'l') THEN 1  ELSE 0 END) AS FB
      
      FROM raw_events."all" AS R
      WHERE DATE(R."at") ='2016-03-14'
      AND R."v" = 's'
      AND R."do|t" = 'l'
      GROUP BY 1,2
      ORDER BY 1 DESC)
   
      ORDER BY 1
      )
      LIMIT 5
      
      
      
      
     SELECT distinct R."v" 
     FROM raw_events."all" AS R
     WHERE R."v" NOT IN ('b', 'p', 'l', 's', 'es', 'f', 'p', 'u', 'su')
     AND date(R."at") = '2016-03-15'
     
     SELECT COUNT(*)
     FROM raw_events."all" AS R
     WHERE R."v" = 'b'
     AND date(R."at") = '2016-03-10'
    

     SELECT max(R."u|v")
     FROM raw_events."all" AS R
     WHERE R."v" = 'b'
     AND date(R."at") = '2016-03-10'    
     LIMIT 10
     
    
      SELECT *, GETDATE()
      FROM analytics.dw_shipping_labels
      LIMIT 10
      
      
        SELECT R."u|a", max(R."u|v") 
        FROM raw_events."all" AS R
        WHERE 
        date(R."at") = '2016-03-10'
        AND R."u|a" = 'iphone'
        GROUP BY 1
        LIMIT 10
        
        
        
        
        SELECT DATE(raw_events.at) AS "raw_events.action_date",
	COUNT(DISTINCT (raw_events."a|id")) AS "raw_events.count_users"
        FROM raw_events."all" AS raw_events
        WHERE date(raw_events.at) = '2016-03-13'
        AND   (raw_events."u|a" = 'iphone') 
        AND    raw_events."u|v" = '2.36'
        GROUP BY 1
        LIMIT  500
        
        
           (SELECT max(R."u|v")
       FROM raw_events."all" AS R
       WHERE R."v" = 'b'
       AND date(R."at") = date(GETDATE())   
       LIMIT 10)
      
      
SELECT COUNT(*)
FROM(
 SELECT DATE(R."at") AS action_date, R."a|id", 
      SUM(CASE WHEN (R."v" = 'f' and R."do|t"  = 'u') THEN 1  ELSE 0 END) AS FB
      
      FROM raw_events."all" AS R
      WHERE DATE(R."at") ='2016-03-14'
      AND R."v" = 'f'
      AND R."do|t" = 'u'
      GROUP BY 1,2
      ORDER BY 1 DESC)
   WHERE FB > 897