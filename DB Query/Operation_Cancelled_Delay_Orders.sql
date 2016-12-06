

select year(O.booked_date), month(O.booked_date), O.seller_id
FROM analytics.dw_orders AS O
WHERE O.order_state = 'cancelled'
AND O.cancelled_reason = 'delayed_order'
GROUP BY year(O.booked_date), month(O.booked_date)
LIMIT 20


SELECT  COUNT(distinct A.user_id ) AS ID
FROM analytics.dw_user_activity AS A
WHERE 
    DATE(A.activity_date) >= '2015-06-01' 
AND DATE(A.activity_date) <= '2015-06-30'
AND A.activity_name = 'active_on_app' 
AND A.user_id IN
        (
          select O.seller_id
          FROM analytics.dw_orders AS O
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND O.booked_date >= '2015-01-01'
          AND O.cancelled_by = 'Buyer'
          AND extract(year from O.cancelled_on) = 2015
          AND extract(month from O.cancelled_on) = 6
          GROUP BY O.seller_id, Count(O.order_id) > 1
                                )
                                
 
          select O.seller_id, COUNT(*)
          FROM analytics.dw_orders AS O
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND O.booked_date >= '2015-01-01'
          AND extract(year from O.booked_date) = 2015
          AND extract(month from O.booked_date) = 6                            
          GROUP BY O.seller_id                      
                          
                          
                          
          SELECT O.*
          FROM analytics.dw_orders AS O
          WHERE O.cancelled_on IS NOT NULL
          LIMIT 10 
                             
          SELECT distinct L.listing_condition
          FROM analytics.dw_listings AS L
          LIMIT 10                
                       
          SELECT L.*
          FROM   analytics.dw_listings AS L
          WHERE L.listing_status = 'archived'
          AND L.listing_condition = 'ret'
          LIMIT 10                           

      WHERE L.inventory_status = 'archived'
/* How many of cancelled listings are from first time seller */
          select O.seller_id
          FROM analytics.dw_orders AS O
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND O.booked_date >= '2015-01-01'
          AND extract(year from O.booked_date) = 2015
          AND extract(month from O.booked_date) = 6
          AND O.seller_id IN
               (SELECT  A.user_id
                FROM analytics.dw_user_activity AS A
                WHERE DATE(A.activity_date) >= '2013-01-01' 
                AND   DATE(A.activity_date) <= '2015-06-30'
                AND A.activity_name = 'listing_created' 
                AND A.activity_count = 1
                GROUP BY A.user_id
                )
         GROUP BY O.seller_id

          select O.seller_id
          FROM analytics.dw_orders AS O
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND O.booked_date >= '2015-01-01'
          AND extract(year from O.booked_date) = 2015
          AND extract(month from O.booked_date) = 6
          GROUP BY O.seller_id
         
/* How many are from first time buyers */
          SELECT O.buyer_id
          FROM analytics.dw_orders AS O
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND O.booked_date >= '2015-01-01'
          AND extract(year from O.cancelled_on) = 2015
          AND extract(month from O.cancelled_on) = 6
          AND O.buyer_id IN
               (SELECT  A.user_id
                FROM analytics.dw_user_activity AS A
                WHERE DATE(A.activity_date) >= '2012-01-01' 
                AND   DATE(A.activity_date) <= '2015-06-30'
                AND A.activity_name = 'item_purchased' 
                AND A.activity_count = 1
                GROUP BY A.user_id
                )
          GROUP BY O.buyer_id



          select O.seller_id
          FROM analytics.dw_orders AS O
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND O.booked_date >= '2015-01-01'
          AND extract(year from O.booked_date) = 2015
          AND extract(month from O.booked_date) = 6
          GROUP BY O.seller_id




/* Repated Offenders and their cancelled order % */
SELECT  O.seller_id, count(distinct O.order_id), 
SUM(CASE WHEN (O.order_state = 'cancelled' AND O.cancelled_reason = 'delayed_order')  THEN 1 ELSE 0 END) AS Delay
FROM    analytics.dw_orders AS O 
WHERE   date(O.booked_date) > '2014-12-31'
AND     date(O.booked_date) < '2015-09-25'
AND     O.seller_id IN
(
SELECT  O.seller_id
FROM    analytics.dw_orders AS O 
WHERE   O.order_state = 'cancelled'
AND     O.cancelled_reason = 'delayed_order'
AND     date(O.booked_date) > '2014-12-31'
AND     date(O.booked_date) < '2015-09-25'
GROUP BY O.seller_id
HAVING count(distinct O.order_id) > 2
)
GROUP BY O.seller_id




/* Doing month increment manually */
select O.seller_id
FROM analytics.dw_orders AS O
WHERE O.order_state = 'cancelled'
AND O.cancelled_reason = 'delayed_order'
AND O.booked_date >= '2015-01-01'
AND extract(year from O.booked_date) = 2015
AND extract(month from O.booked_date) = 1
GROUP BY O.seller_id


/* Default Code for Buyer GMV Analysis */

 SELECT Cdate, SUM(GMV), COUNT(distinct ID) 
    FROM
    (
      SELECT Cdate, ID, sum(A.order_gmv) AS GMV
       FROM
       (select O.buyer_id AS ID, min(date(O.cancelled_on)) AS CO, min(date(O.booked_at)) AS Cdate
        FROM analytics.dw_orders AS O
        WHERE O.order_state = 'cancelled'
        AND O.cancelled_reason = 'delayed_order'
        AND date(O.booked_date) >= '2015-01-01'
        GROUP BY O.buyer_id) AS O
        
        INNER JOIN analytics.dw_orders AS A ON O.ID = A.buyer_id
        WHERE  date(A.booked_date) - date(O.CO) >= 1
        AND    date(A.booked_date) - date(O.CO) <= 91
        GROUP BY Cdate, ID
        )
        GROUP BY Cdate
        ORDER BY Cdate