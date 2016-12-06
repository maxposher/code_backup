

SELECT  O.booked_date, O.order_id, O.order_gmv, O.inventory_unit_state 
FROM  analytics.dw_orders AS O 
WHERE date(O.booked_date) >= '2015-09-21'
AND   date(O.booked_date) < '2015-10-01'



SELECT  SUM(O.order_gmv)
FROM    analytics.dw_orders AS O 
WHERE   O.order_state = 'cancelled'
AND     O.cancelled_by = 'System'
AND     O.cancelled_reason = 'delayed_order'
AND     date(O.booked_date) > '2014-12-31'
AND     date(O.booked_date) < '2015-09-25'
GROUP BY O.seller_id
HAVING count(distinct O.order_id) = 1



SELECT  O.order_id
FROM    analytics.dw_orders AS O 
WHERE   O.order_state = 'cancelled'
AND     O.cancelled_reason = 'delayed_order'
AND     date(O.booked_date) > '2014-12-31'
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


/* Count repeated offender who sell more than 2 items */

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
/* HAVING count(distinct O.order_id) = 1 */
)
GROUP BY O.seller_id


SELECT  COUNT (distinct O.order_id)
FROM    analytics.dw_orders AS O 
WHERE   O.order_state = 'cancelled'
AND     O.cancelled_reason = 'delayed_order'
AND     date(O.booked_date) > '2014-12-31'
AND     date(O.booked_date) < '2015-09-24'
GROUP BY O.seller_id







    SELECT Cdate, COUNT(ID) FROM 
    (
      SELECT Cdate, ID
       FROM
       (select O.buyer_id AS ID, O.cancelled_on, date(O.booked_at) AS Cdate
        FROM analytics.dw_orders AS O
        WHERE O.order_state = 'cancelled'
        AND O.order_number > 1
        AND O.cancelled_reason = 'delayed_order'
        AND date(O.booked_date) >= '2015-01-01'
        GROUP BY O.buyer_id, O.cancelled_on, date(O.booked_at)) AS O
        
        INNER JOIN analytics.dw_user_activity AS UA ON O.ID = UA.user_id
        WHERE  UA.activity_name = 'item_purchased'
        AND date(UA.activity_date)  >= '2015-01-01'
        AND date(UA.activity_date) - date(O.cancelled_on) >= 10
        GROUP BY Cdate, ID
        )
        GROUP BY Cdate
        ORDER BY Cdate




/*****************************************************************/
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
        WHERE  date(A.booked_date) - date(O.CO) >= 10
        AND    date(A.booked_date) - date(O.CO) <= 90
        GROUP BY Cdate, ID
        )
        GROUP BY Cdate
        ORDER BY Cdate




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















      SELECT Cdate, ID, sum(A.order_gmv) AS GMV
       FROM
       (select O.buyer_id AS ID, min(date(O.cancelled_on)) AS OC, min(date(O.booked_at)) AS Cdate
        FROM analytics.dw_orders AS O
        WHERE O.order_state = 'cancelled'
        AND O.cancelled_reason = 'delayed_order'
        AND date(O.booked_date) >= '2015-01-01'
        AND O.buyer_id = '512a2b49d00cbf477e0121fb'
        GROUP BY O.buyer_id
        ) AS O
        
        INNER JOIN analytics.dw_orders AS A ON O.ID = A.buyer_id
        WHERE  date(A.booked_date) - date(OC) >= 10
        AND    date(A.booked_date) - date(OC) <= 90
        GROUP BY Cdate, ID
        LIMIT 100
   

        select O.buyer_id AS ID, date(O.cancelled_on), date(O.booked_at) AS Cdate
        FROM analytics.dw_orders AS O
        WHERE O.order_state = 'cancelled'
        AND O.cancelled_reason = 'delayed_order'
        AND date(O.booked_date) >= '2015-01-01'
        AND O.buyer_id = '512a2b49d00cbf477e0121fb'
        GROUP BY O.buyer_id, O.cancelled_on, O.booked_at






        SELECT COUNT(DISTINCT O.buyer_id), SUM(O.order_gmv) 
        FROM analytics.dw_orders AS O
        WHERE  date(O.booked_date) >= '2015-01-10'
        AND date(O.booked_date) <= '2015-04-10'
        AND O.buyer_id IN
       (
         select O.buyer_id 
         FROM analytics.dw_orders AS O
         WHERE O.order_state = 'cancelled'
         AND O.order_number = 1
         AND O.cancelled_reason = 'delayed_order'
         AND date(O.booked_date) >= '2015-01-06'
         AND date(O.booked_date) < '2015-01-07'
         GROUP BY O.buyer_id
        )
 
 
        select SUM(O.order_gmv) 
        FROM analytics.dw_orders AS O
        WHERE  date(O.booked_date) >= '2015-01-10'
        AND date(O.booked_date) <= '2015-04-10'
        AND O.buyer_id IN
       (
         select O.buyer_id 
         FROM analytics.dw_orders AS O
         WHERE O.inventory_unit_state = 'received'
         AND date(O.booked_date) >= '2015-01-06'
         AND date(O.booked_date) < '2015-01-07'
         AND O.order_number = 1
         GROUP BY O.buyer_id
        )
        AND O.buyer_id NOT IN
        (
         select O.buyer_id 
         FROM analytics.dw_orders AS O
         WHERE O.order_state = 'cancelled'
         AND O.order_number = 1
         AND O.cancelled_reason = 'delayed_order'
         AND date(O.booked_date) >= '2015-01-06'
         AND date(O.booked_date) < '2015-01-07'
         GROUP BY O.buyer_id 
        )








         select COUNT (distinct O.buyer_id)
         FROM analytics.dw_orders AS O
         WHERE O.inventory_unit_state = 'received'
         AND date(O.booked_date) >= '2015-01-06'
         AND date(O.booked_date) < '2015-01-07'
         AND O.order_number = 1
         AND O.buyer_id NOT IN
        (
         select O.buyer_id 
         FROM analytics.dw_orders AS O
         WHERE O.order_state = 'cancelled'
         AND O.order_number = 1
         AND O.cancelled_reason = 'delayed_order'
         AND date(O.booked_date) >= '2015-01-06'
         AND date(O.booked_date) < '2015-01-07'
         GROUP BY O.buyer_id )
