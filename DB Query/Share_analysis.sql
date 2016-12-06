
     
     
     SELECT date(R."at"), R."actor|id", 
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN 1 ELSE 0 END) AS internal_share
     FROM  raw_events.all as R
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = R."do|id" 
     WHERE R."v" = 'share'
     AND   L.seller_id != R."a|id"
     GROUP BY 1,2
     limit 10
     
     
     --SELECT depname, empno, salary, rank() OVER (PARTITION BY depname ORDER BY salary DESC) FROM empsalary;
     
     SELECT *
     FROM(
     
     SELECT action_date, user_id, internal_share, rank() OVER (partition by action_date ORDER BY internal_share DESC) as ranking
     FROM(
     
     SELECT date(R."at") AS action_date, R."actor|id" AS user_id,  COUNT(R."actor|id") AS internal_share
     FROM   raw_events.all as R
     INNER JOIN analytics.dw_users AS U ON U.user_id = R."actor|id"
     WHERE  R."verb" = 'share'
     AND    U.suggested_user_featured IS TRUE
     AND  date(R."at") < date(SYSDATE)
     GROUP BY 1, 2
     ORDER BY 2 DESC)
     )
     WHERE ranking <= 100 
     ORDER BY 1,4
  
     limit 100
     
     
     
     --Suggested Sharers
     
     SELECT R."actor|id",  COUNT(R."actor|id") AS internal_share
     FROM  raw_events.all as R
     INNER JOIN analytics.dw_users AS U ON U.user_id = R."actor|id"
     WHERE R."verb" = 'share'
     AND   U.suggested_user_featured IS TRUE
     AND  date(R."at") < date(SYSDATE)
     GROUP BY 1
     ORDER BY 2 DESC
     limit 100
     
     
     SELECT distinct R."verb"
     FROM raw_events.all as R
     
     
     SELECT *
     FROM analytics_scratch.buyer_quality
     WHERE first_order_price is null
     
     
     
     
     SELECT user_id, suggested_user_featured
     FROM analytics.dw_users
     LIMIT 10
     

   
     SELECT date(R."at"), R."actor|id", 
     SUM(CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN 1 ELSE 0 END) AS internal_share
     FROM  raw_events.all as R
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = R."do|id" 
     WHERE R."v" = 'share'
     AND   L.seller_id != R."a|id"
     GROUP BY 1,2
     limit 10




     SELECT *
     FROM  raw_events.all as R
     WHERE R."verb" = 'share'
     LIMIT 10
     

     SELECT ntile(4) over (partition by A.date order by internal_share) as quartile
     FROM  analytics_scratch.internal_share_own AS A  
     WHERE A.date = '2016-02-10'
     GROUP BY 1, internal_share
 
     
     
     /* Two thousand too high */
     SELECT date(R."at") AS DD,  R."a|id" AS user_id, 
     SUM(CASE WHEN L.seller_id = R."a|id"  THEN 1 ELSE 0 END) AS own_share,
     SUM(CASE WHEN L.seller_id != R."a|id"  THEN 1 ELSE 0 END) AS community_share,
     SUM(1) AS Total
     FROM  raw_events.all as R
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = R."do|id" 
     WHERE R."v" = 's'
     AND   date(R."at") BETWEEN '2016-02-10' AND '2016-02-16'
     GROUP BY 1,2
     HAVING SUM(1) >= 2000
     ORDER BY 1
     
     LIMIT 10
 
 
 
     SELECT R.*
     FROM   raw_events.all as R
     WHERE  R."v" = 's'
     AND    date(R."at") = '2016-02-10'
     AND    R."a|id" = '55c7d40f019f443e9813175b'
     LIMIT  50
 

     
select sellerid, qty, percentile_disc(0.5) 
within group (order by qty) 
over()     
     

SELECT A.date, percentile_disc(0.9) 
within group (order by internal_share)
over(partition by A.date) AS T
From analytics_scratch.internal_share_own AS A
WHERE A.date = '2016-02-09'
GROUP BY 1, internal_share


limit 10

GROUP BY 1,2


WHERE A.date BETWEEN '2016-02-09' AND '2016-02-10'
GROUP BY A.date


ntile(4)
over(order by pricepaid desc)



SELECT DD, N, min(internal_share), max(internal_share)
FROM
(
SELECT A.date AS DD, ntile(100) over (order by internal_share) AS N, internal_share
From analytics_scratch.internal_share_own AS A
WHERE A.date = '2016-02-09'
)
GROUP BY 1,2
ORDER BY n ASC


SELECT A.date,
       SUM(CASE WHEN internal_share = 1 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share = 2 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN  3  AND 5 THEN 1 ELSE 0  END),
       SUM(CASE WHEN internal_share BETWEEN  6  AND 10 THEN 1 ELSE 0  END),
       SUM(CASE WHEN internal_share BETWEEN 11  AND 25 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 26  AND 50 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 51  AND 100 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 101 AND 125  THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 126 AND 150 THEN 1 ELSE 0 END), 
       SUM(CASE WHEN internal_share BETWEEN 151 AND 200 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 201 AND 250 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 251 AND 500 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share >= 501  THEN 1 ELSE 0 END)
From analytics_scratch.internal_share_own AS A
GROUP BY 1
ORDER BY 1



SELECT SUM(internal_share)
FROM analytics_scratch.internal_share_com AS A
WHERE A.date = '2016-02-15'



SELECT  date_trunc('mon', date(O.booked_at)) AS DD,
sum(O.order_gmv), percentile_cont(0.1) 
within group (order by date_trunc('mon', date(O.booked_at))) over(partition by O.seller_id) 
FROM analytics.dw_orders AS O
WHERE date(O.booked_at) > '2015-01-01' 
GROUP BY DD, O.seller_id
LIMIT 50



SELECT DD, N, min(internal_share), max(internal_share)
FROM
(
SELECT A.date AS DD, ntile(100) over (order by internal_share) AS N, internal_share
From analytics_scratch.internal_share_com AS A
WHERE A.date = '2016-02-09'
)
GROUP BY 1,2
ORDER BY n ASC




SELECT A.date,
       SUM(CASE WHEN internal_share = 1 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share = 2 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 3   AND     5 THEN 1 ELSE 0  END),
       SUM(CASE WHEN internal_share BETWEEN 6   AND    10 THEN 1 ELSE 0  END),
       SUM(CASE WHEN internal_share BETWEEN 11  AND    25 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 26  AND    50 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 51  AND   100 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 101 AND   200 THEN 1 ELSE 0 END),   
       SUM(CASE WHEN internal_share BETWEEN 201 AND   300 THEN 1 ELSE 0 END), 
       SUM(CASE WHEN internal_share BETWEEN 301 AND   500 THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 501 AND 1000  THEN 1 ELSE 0 END),
       SUM(CASE WHEN internal_share >= 1001  THEN 1 ELSE 0 END)
From analytics_scratch.internal_share_com AS A
GROUP BY 1
ORDER BY 1



SELECT A.date,
       SUM(CASE WHEN internal_share = 1                   THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share = 2                   THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 3   AND     5 THEN internal_share ELSE 0  END),
       SUM(CASE WHEN internal_share BETWEEN 6   AND    10 THEN internal_share ELSE 0  END),
       SUM(CASE WHEN internal_share BETWEEN 11  AND    25 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 26  AND    50 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 51  AND   100 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 101 AND   200 THEN internal_share ELSE 0 END),   
       SUM(CASE WHEN internal_share BETWEEN 201 AND   300 THEN internal_share ELSE 0 END), 
       SUM(CASE WHEN internal_share BETWEEN 301 AND   500 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 501 AND 1000  THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share >= 1001  THEN internal_share ELSE 0 END)
From analytics_scratch.internal_share_com AS A
GROUP BY 1
ORDER BY 1




SELECT A.date,
       SUM(CASE WHEN internal_share = 1                 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share = 2                 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN  3  AND 5   THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN  6  AND 10  THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 11  AND 25  THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 26  AND 50  THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 51  AND 100 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 101 AND 125 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 126 AND 150 THEN internal_share ELSE 0 END), 
       SUM(CASE WHEN internal_share BETWEEN 151 AND 200 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 201 AND 250 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share BETWEEN 251 AND 500 THEN internal_share ELSE 0 END),
       SUM(CASE WHEN internal_share >= 501              THEN internal_share ELSE 0 END)
From analytics_scratch.internal_share_own AS A
WHERE A.date = '2016-02-12'
GROUP BY 1
ORDER BY 1


 SELECT R."a|id"
 FROM  raw_events.all as R
 


SELECT O.buyer_id, O.booked_at, lag(O.booked_at,1) over(partition by O.buyer_id order by O.booked_at) AS Last_Order
FROM   analytics.dw_orders AS O
WHERE  O.booked_at > '2015-01-01'
--GROUP BY 1
LIMIT 100


SELECt SUM (AA)
FROM(

     SELECT R."a|id", count(*) AS AA
     FROM  raw_events."e_2016_02_11" as R
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = R."do|id" 
     WHERE R."v" = 's'
     AND   L.seller_id != R."a|id"
   --  AND   date(R."at") = '2016-02-10'
     GROUP BY 1
)

     SELECT count(*) AS AA
     FROM  raw_events."e_2016_02_05" as R
     WHERE R."v" = 's'




    SELECT R."a|id", count(*) AS AA
     FROM  raw_events."e_2016_02_08" as R
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = R."do|id" 
     WHERE R."v" = 's'
    -- AND   L.seller_id != R."a|id"
     AND R."a|id" = '5201438fc712455dcf00becb'
     GROUP BY 1
     
     SELECT total_price_discount_amount
     FROM analytics.dw_orders
     WHERE total_price_discount_amount IS NOT NULL
     AND   total_price_discount_amount > 0
     LIMIT 100


     SELECT total_shipping_amount,  total_shipping_discount_amount
     from analytics.dw_orders 
     WHERE total_shipping_amount IS NOT NULL
     AND    total_shipping_amount < 499
     LIMIT 10

