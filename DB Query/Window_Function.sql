
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 

SELECT buyer_id, SUM(order_gmv*0.01) OVER (PARTITION BY buyer_id ORDER BY booked_at rows between 1 following and 1 following) AS running_total
FROM analytics.dw_orders 
WHERE booked_at > '2016-10-01'
limit 500


-- rows between 3 preceding and 1 following
SELECT booked_at, buyer_id, order_gmv*0.01, SUM(order_gmv*0.01) OVER (PARTITION BY buyer_id  ORDER BY booked_at rows between 3 preceding and 1 following) AS running_total
FROM analytics.dw_orders 
WHERE 
buyer_id = '4e952ad7e4b0e2cfd99c43c0'
and booked_at > '2016-10-01'
ORDER BY 1 
limit 500



SELECT buyer_id, lead(order_gmv*0.01) OVER () AS running_total
FROM analytics.dw_orders 
WHERE booked_at > '2016-10-01'
limit 500



/* Window Function - Cum Sum */
    SELECT DD, sum(num) over (order by DD rows unbounded preceding) 
    FROM(
     
    SELECT DD, COUNT(buyer_id) AS Num
     FROM (
       SELECT O.buyer_id, min(date(booked_at)) AS DD
       FROM   analytics.dw_orders AS O
       WHERE  wholesale
       GROUP BY 1)
    GROUP BY 1)
    limit 100
    
 /* Window Funciton - Rank */
      SELECT date(booked_at), sum(GMV), COUNT(distinct buyer_id)
     FROM (   
        SELECT booked_at, buyer_id, order_gmv*0.01 AS GMV, rank() over (partition by buyer_id order by booked_at ASC) as rank
        FROM   analytics.dw_orders
        WHERE  wholesale)
     WHERE rank = 1
     GROUP BY 1
     ORDER BY 1   


/* days_since_last_login */
SELECT O.buyer_id AS ID, sum(O.order_gmv*0.01), percentile_cont(0.01) 
within group (order by sum(O.order_gmv*0.01) desc) over()
FROM analytics.dw_users AS U
LEFT join analytics.dw_orders AS O on U.user_id = O.buyer_id
WHERE date(O.booked_at)  >= '2015-07-01' 
AND   date(O.booked_at) <= '2015-09-30' 
GROUP BY O.buyer_id
LIMIT 10


SELECT U.user_id, percentile_cont(0.5) within group (order by U.days_since_last_login desc) over()
FROM analytics.dw_users AS U
WHERE U.date_buyer_activated IS NULL
LIMIT 100



/* Percentage Function Example */
  SELECT percentile_cont(0.99) within group (order by mn)  over(),
                    percentile_cont(0.95) within group (order by mn)  over(),    
                    percentile_cont(0.9) within group (order by mn)  over(),
                    percentile_cont(0.8) within group (order by mn)  over(), 
                    percentile_cont(0.7) within group (order by mn)  over(), 
                    percentile_cont(0.6) within group (order by mn)  over(), 
                    percentile_cont(0.5) within group (order by mn)  over(), 
                    percentile_cont(0.4) within group (order by mn)  over(), 
                    percentile_cont(0.3) within group (order by mn)  over(), 
                    percentile_cont(0.2) within group (order by mn)  over(), 
                    percentile_cont(0.1) within group (order by mn)  over(),
                    percentile_cont(1) within group (order by mn)  over()   
              FROM
             (
                    SELECT buyer_id, count(distinct date(booked_at)) AS mn 
                    FROM   analytics.dw_orders AS O
                    WHERE                  
                    EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
                    ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1                 
                    = '2016_2'   
                    GROUP BY 1) 
            limit 10