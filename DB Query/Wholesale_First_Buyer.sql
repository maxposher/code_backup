

SELECT *
FROM analytics.dw_orders
LIMIT 10


    SELECT *               
     FROM  raw_events.all as R 
     WHERE date(R."at") = '2016-04-15'
     AND   R."v" in ('p','b')
     AND   R."do|t" in ('o', 'of')
     LIMIT 100
     
     
     SELECT *               
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_offers AS OF ON R."do|id" = OF.offer_id
     WHERE date(R."at") = '2016-04-15'
     
     AND   R."v" in ('p','b')
     AND   R."do|t" in ('o', 'of')
     LIMIT 100
     
     
     SELECT     date(R."at"), count(distinct (CASE WHEN (R."v" = 'p' AND R."do|t" = 'of') THEN R."a|id" end)) AS  WS_Offer    
     FROM       raw_events.all as R 
     INNER JOIN analytics.dw_offers AS O ON R."do|id" = O.offer_id
     WHERE date(R."at") >= '2016-04-15'
     AND   R."v" in ('p')
     AND O.lister_id IN    
        (SELECT distinct (seller_id)
         FROM  analytics.dw_orders
         WHERE wholesale)
     GROUP BY 1    
  
     
     SELECT    date(offer_created_at), count(distinct buyer_id)
     FROM      analytics.dw_offers AS O
     WHERE 
     date(offer_created_at) >= '2016-03-29'
     AND O.lister_id IN    
        (SELECT distinct (seller_id)
         FROM  analytics.dw_orders
         WHERE wholesale)
     GROUP BY 1    
     ORDER BY 1
     
     
     
     SELECT    date(booked_at), count(distinct buyer_id)
     FROM      analytics.dw_orders AS O
     WHERE 
     date(booked_at) >= '2016-03-29'
     AND O.seller_id IN    
        (SELECT distinct (seller_id)
         FROM  analytics.dw_orders
         WHERE wholesale)
     GROUP BY 1    
     ORDER BY 1
     
     
     
          SELECT date(R."at"),
            count(distinct (CASE WHEN (R."v" = 'l')                    THEN R."a|id" end)) AS WS_Liker,
            count(distinct (CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN R."a|id" end)) AS WS_Commenter,
            count(distinct (CASE WHEN (R."v" = 's' AND R."do|t" = 'l')  THEN R."a|id" end)) AS WS_Internal_Sharer,
            count(distinct (CASE WHEN (R."v" = 'es' AND R."do|t" = 'l') THEN R."a|id" end)) AS WS_External_Sharer                    
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") > '2016-04-15'
     AND   L.wholesale
     AND   R."v" in ('l')
     GROUP BY 1
     ORDER BY 1



     SELECT COUNT(distinct R."a|id")
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") = '2016-04-15'
     AND   L.wholesale
     AND   R."v" in ('s')
     LIMIT 10
     
     
     
     SELECT *
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_orders AS O ON O.order_id =  R."do|id" 
     WHERE date(R."at") = '2016-05-20'
     AND R."v" in ('b')
     LIMIT 75
     
     
     
     
     SELECT   date(booked_at), extract(hour from booked_at) AS the_hour, count(distinct buyer_id)
     FROM      analytics.dw_orders AS O
     WHERE 
     date(booked_at) >= '2016-04-04'
     AND O.seller_id IN    
        (SELECT distinct (seller_id)
         FROM  analytics.dw_orders
         WHERE wholesale)
     GROUP BY 1,2    
     ORDER BY 1,2
     LIMIT 10
     
      (SELECT distinct (seller_id)
         FROM  analytics.dw_orders
         WHERE wholesale)
     
     
     
     
     
     
     
     
     
     
   
    
     SELECT date(R."at"), R."a|id" AS ID                
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") >= '2016-03-29'
     AND   L.wholesale
     AND   R."v" in ('l', 'p', 's', 'es')
     GROUP BY 1, 2
     ORDER BY 1
    
     union
    
     SELECT date(R."at"), R."a|id" AS ID       
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_users AS U ON U.user_id = R."do|id"
     WHERE date(R."at") >= '2016-03-29'
     AND   R."v" = 'f'
     AND   R."do|t" = 'u'
     AND   U.user_id IN  
          (SELECT distinct (seller_id)
           FROM  analytics.dw_orders
           WHERE wholesale)
     GROUP BY 1,2
     ORDER BY 1

     UNION ALL

     /* Make an offer */
     SELECT     date(R."at"), R."a|id" AS ID
     FROM       raw_events.all as R 
     INNER JOIN analytics.dw_offers AS O ON R."do|id" = O.offer_id
     WHERE date(R."at") >= '2016-03-29'
     AND   R."v" in ('p')
     AND R."do|t" = 'of'
     AND   O.lister_id IN    
           (SELECT distinct (seller_id)
            FROM  analytics.dw_orders
            WHERE wholesale)
     GROUP BY 1, 2
     ORDER BY 1    

     UNION ALL
     
     /* Booked Orders */
     SELECT date(R."at"), R."a|id" AS ID                 
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_orders AS O ON O.order_id = R."do|id" 
     WHERE date(R."at") >= '2016-03-29'
     AND   O.wholesale
     AND   R."v" in ('b')
     GROUP BY 1
     
     ) AS F
     GROUP BY 1
     
     
     
     
     
     
     
     
    SELECT date, COUNT(distinct ID)
    FROM ( 
     SELECT date(R."at"), R."a|id" AS ID                
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_listings AS L ON L.listing_id = CASE WHEN R."do|t" = 'c' THEN R."to|id" ELSE R."do|id" END
     WHERE date(R."at") >= '2016-03-29'
     AND   L.wholesale
     AND   R."v" in ('l', 'p', 's', 'es')
     
     UNION
     
     SELECT date(R."at"), R."a|id" AS ID       
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_users AS U ON U.user_id = R."do|id"
     WHERE date(R."at") >= '2016-03-29'
     AND   R."v" = 'f'
     AND   R."do|t" = 'u'
     AND   U.user_id IN  
          (SELECT distinct (seller_id)
           FROM  analytics.dw_orders
           WHERE wholesale)

     UNION

     SELECT     date(R."at"), R."a|id" AS ID
     FROM       raw_events.all as R 
     INNER JOIN analytics.dw_offers AS O ON R."do|id" = O.offer_id
     WHERE date(R."at") >= '2016-03-29'
     AND   R."v" in ('p')
     AND R."do|t" = 'of'
     AND   O.lister_id IN    
           (SELECT distinct (seller_id)
            FROM  analytics.dw_orders
            WHERE wholesale)
    
     UNION
     
     SELECT date(R."at"), R."a|id" AS ID                 
     FROM  raw_events.all as R 
     INNER JOIN analytics.dw_orders AS O ON O.order_id = R."do|id" 
     WHERE date(R."at") >= '2016-03-29'
     AND   O.wholesale
     AND   R."v" in ('b')
     GROUP BY 1, 2  )
     GROUP BY 1
     
     
     SELECT COUNT(distinct user_id)
     FROM analytics.dw_users
     WHERE lister_total_number_listings > 10
     AND (seller_rating_value/seller_rating_count) > 4.5
     
     
     SELECT seller_rating_value, seller_rating_count, coalesce(cast(seller_rating_value as float)/cast(seller_rating_count as float), 100)
     FROM analytics.dw_users
     WHERE lister_total_number_listings > 10
     AND  coalesce(seller_rating_value/seller_rating_count,0) < 5
     AND  coalesce(seller_rating_value/seller_rating_count,0) > 4.5
     AND (seller_rating_count IS NOT NULL or seller_rating_count != 0)
     LIMIT 100
     
     
     SELECT COUNT(distinct user_id)
     FROM analytics.dw_users
     WHERE lister_total_number_listings > 10
     AND   seller_rating_count IS NOT NULL
     AND   seller_rating_count > 0
     AND  cast(seller_rating_value as float)/seller_rating_count > 4.5
     LIMIT 100
     
     
     
     SELECT seller_rating_value, seller_rating_count ,
     cast(seller_rating_value as float)/seller_rating_count 
     FROM analytics.dw_users
     WHERE lister_total_number_listings > 10
     AND   seller_rating_count IS NOT NULL
     AND   seller_rating_count > 0
     AND  cast(seller_rating_value as float)/seller_rating_count > 4.5
     LIMIT 100
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     SELECT TO_CHAR(CASE WHEN (dw_orders.received_at > dw_orders.cancelled_on)  THEN dw_orders.cancelled_on
                         WHEN (dw_orders.received_at IS NULL and dw_orders.cancelled_on IS NOT NULL)  THEN dw_orders.cancelled_on Else NULL END , 'YYYY-MM') AS "dw_shipping_labels.finance_cancelled_month",
	COALESCE(SUM(CASE WHEN (dw_shipping_labels.state ILIKE 'used') THEN dw_shipping_labels.final_postage*.01 ELSE NULL END),0) AS "dw_shipping_labels.total_final_postage"
FROM analytics.dw_shipping_labels AS dw_shipping_labels
LEFT JOIN analytics.dw_orders AS dw_orders ON dw_shipping_labels.order_id = dw_orders.order_id

WHERE 
	(CASE 
WHEN (dw_orders.received_at > dw_orders.cancelled_on)  THEN dw_orders.cancelled_on
WHEN (dw_orders.received_at IS NULL and dw_orders.cancelled_on IS NOT NULL)  THEN dw_orders.cancelled_on
Else NULL END 
 >= (timestamp '2016-01-01'))
GROUP BY 1
ORDER BY 1 DESC
LIMIT 500
     
     
     
     
SELECT SUM(final_postage*.01) 
FROM analytics.dw_shipping_labels AS S
INNER JOIN analytics.dw_orders AS O ON S.order_id = O.order_id
WHERE S.state IN ('used')
AND date(O.cancelled_on)  BETWEEN '2016-01-01' AND  '2016-01-31'
AND (date(O.cancelled_on) < date(O.received_at)  OR date(O.received_at) IS NULL AND date(O.cancelled_on) IS NOT NULL)
     
     
     
     
SELECT *
FROM analytics.dw_shipping_labels
WHERE order_id = '4f35f5b4b2bb1b04820004f8'
LIMIT 20
     

SELECT order_id, count(distinct label_id)
FROM analytics.dw_shipping_labels
GROUP BY 1
HAVING count(distinct label_id) > 1
LIMIT 10
     
     
SELECT cancelled_on, received_at
FROM analytics.dw_orders
WHERE cancelled_on IS NOT NULL
AND   received_at IS NOT NULL
LIMIT 10
     
 
/* Doing it hard way */
SELECT SUM(final_postage*.01) 
FROM analytics.dw_shipping_labels AS S
INNER JOIN analytics.dw_orders AS O ON S.order_id = O.order_id
WHERE S.state IN ('used')
AND date(O.cancelled_on)  BETWEEN '2016-01-01' AND  '2016-01-31'
AND (O.cancelled_on < O.received_at  OR (O.received_at IS NULL))




SELECT *
FROM analytics.dw_shipping_labels
LIMIT 10



     