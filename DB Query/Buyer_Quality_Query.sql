

SELECT  
date_buyer_activated, count(distinct user_id), sum(additional_order), sum(additional_Order_GMV), sum(retention)
 FROM(
   SELECT A.user_id, A.date_buyer_activated, C.additional_order, C.additional_Order_GMV,
   A.user_status, D.retention, E.buyer_shipping_fee
   FROM (     
      /* user main table */      
      (SELECT user_id, date_buyer_activated, user_status       
       FROM   analytics.dw_users
       WHERE  date_buyer_activated >= '2015-11-18'
       )  AS A          
LEFT JOIN    /* addition purchase table */
      (SELECT U.user_id, count(distinct O.order_id) AS Additional_Order, sum(O.order_gmv) AS Additional_Order_GMV
       FROM analytics.dw_orders AS O
       INNER JOIN analytics.dw_users AS U ON U.user_id = O.buyer_id
       WHERE O.order_number > 1
       AND   date(O.booked_at) >= '2015-11-18'
       AND   date(date_buyer_activated) >= '2015-11-18'
       AND   date(O.booked_date) - date(date_buyer_activated) < 7
       GROUP BY 1)                      AS C ON A.user_id = C.user_id
LEFT JOIN   /* Retention table */
       (SELECT U.user_id, 1 AS Retention
        FROM  analytics.dw_users AS U 
        INNER JOIN  
        (SELECT date(A.activity_date) AS activity_date, A.user_id
         FROM   analytics.dw_user_activity AS A
         WHERE  date(A.activity_date) >= '2015-11-18'
         AND   A.activity_name = 'active_on_app'
         GROUP BY 1,2) AS A on A.user_id = U.user_id
         WHERE U.date_buyer_activated  >= '2015-11-18'
         AND   date(A.activity_date) - date(U.date_buyer_activated) <= 6
         AND   date(A.activity_date) - date(U.date_buyer_activated) > 0
         GROUP BY 1) AS D ON A.user_id = D.user_id
LEFT JOIN
        (SELECT buyer_id, buyer_shipping_fee
         FROM analytics.dw_orders 
         WHERE    order_number = 1
         AND date(booked_at) >= '2015-11-18')    AS E ON A.user_id = E.buyer_id                                                                                                          
) 
 ) 
WHERE date_buyer_activated >= '2015-11-18'
AND   user_status = 'active'
/*AND   buyer_shipping_fee < 499 */
/*AND first_order_price > 10 */
GROUP BY date_buyer_activated
ORDER BY date_buyer_activated


 
 
/******************************************************************/ 
/* Non - Referral */
SELECT 
date_buyer_activated, count(distinct user_id), sum(additional_order), sum(additional_Order_GMV), sum(retention)
 FROM(
   SELECT A.user_id, A.date_buyer_activated, C.additional_order, C.additional_Order_GMV,
   A.user_status, D.retention, buyer_shipping_fee
   FROM (
      
      /* user main table */      
      (SELECT user_id, date_buyer_activated, user_status       
       FROM   analytics.dw_users
       WHERE  date_buyer_activated >= '2015-10-01'
       AND    referred_by_user_id IS NULL
       )  AS A   
       
LEFT JOIN    /* addition purchase table */
      (SELECT U.user_id, count(distinct O.order_id) AS Additional_Order, sum(O.order_gmv) AS Additional_Order_GMV
       FROM analytics.dw_orders AS O
       INNER JOIN analytics.dw_users AS U ON U.user_id = O.buyer_id
       WHERE O.order_number > 1
       AND   date(O.booked_at) >= '2015-10-01'
       AND   date(date_buyer_activated) >= '2015-10-01'
       AND   date(O.booked_date) - date(date_buyer_activated) < 7
       GROUP BY 1)                      AS C ON A.user_id = C.user_id

LEFT JOIN   /* Retention table */
       (SELECT U.user_id, 1 AS Retention
        FROM  analytics.dw_users AS U 
        INNER JOIN  
        (SELECT date(A.activity_date) AS activity_date, A.user_id
         FROM   analytics.dw_user_activity AS A
         WHERE  date(A.activity_date) >= '2015-10-01'
         AND   A.activity_name = 'active_on_app'
         GROUP BY 1,2) AS A on A.user_id = U.user_id
         WHERE U.date_buyer_activated  >= '2015-10-01'
         AND   date(A.activity_date) - date(U.date_buyer_activated) <= 6
         AND   date(A.activity_date) - date(U.date_buyer_activated) > 0
         GROUP BY 1) AS D ON A.user_id = D.user_id
LEFT JOIN
        (SELECT buyer_id, buyer_shipping_fee
         FROM analytics.dw_orders 
         WHERE    order_number = 1
         AND date(booked_at) >= '2015-10-01')    AS E ON A.user_id = E.buyer_id             
) 
 ) 
WHERE date_buyer_activated >= '2015-10-01'
AND   user_status = 'active'
AND   buyer_shipping_fee < 499 
GROUP BY date_buyer_activated
ORDER BY date_buyer_activated


/*******************************************************/

SELECT date_buyer_activated, count(distinct A.user_id) 
FROM  analytics.dw_users A
INNER JOIN analytics.dw_orders B
ON    A.user_id = B.buyer_id
WHERE A.date_buyer_activated >= '2015-10-01'
AND   A.user_status = 'active'
AND   B.buyer_shipping_fee >= 499
AND   B.order_number = 1
/*AND first_order_price > 10 */
GROUP BY date_buyer_activated
ORDER BY date_buyer_activated







SELECT  
date_buyer_activated, count(distinct user_id), sum(additional_order), sum(additional_Order_GMV), sum(retention)
 FROM(
   SELECT A.user_id, A.date_buyer_activated, C.additional_order, C.additional_Order_GMV,
   A.user_status, D.retention, E.buyer_shipping_fee
   FROM (     
      /* user main table */      
      (SELECT user_id, date_buyer_activated, user_status       
       FROM   analytics.dw_users
       WHERE  date_buyer_activated >= '2014-09-01'
       AND    date_buyer_activated <= '2014-12-31'       
       )  AS A          
LEFT JOIN    /* addition purchase table */
      (SELECT U.user_id, count(distinct O.order_id) AS Additional_Order, sum(O.order_gmv) AS Additional_Order_GMV
       FROM analytics.dw_orders AS O
       INNER JOIN analytics.dw_users AS U ON U.user_id = O.buyer_id
       WHERE O.order_number > 1
       AND   date(O.booked_at) >= '2014-10-01'
       AND   date(date_buyer_activated) >= '2014-10-01'
       AND   date(O.booked_date) - date(date_buyer_activated) < 7
       GROUP BY 1)                      AS C ON A.user_id = C.user_id
LEFT JOIN   /* Retention table */
       (SELECT U.user_id, 1 AS Retention
        FROM  analytics.dw_users AS U 
        INNER JOIN  
        (SELECT date(A.activity_date) AS activity_date, A.user_id
         FROM   analytics.dw_user_activity AS A
         WHERE  date(A.activity_date) >= '2014-10-01'
         AND    A.activity_name = 'active_on_app'
         AND    date(A.activity_date) <= '2015-01-10'
         GROUP  BY 1,2) AS A on A.user_id = U.user_id
         WHERE  U.date_buyer_activated  >= '2014-10-01'
         AND    date(A.activity_date) - date(U.date_buyer_activated) <= 6
         AND    date(A.activity_date) - date(U.date_buyer_activated) > 0
         GROUP BY 1) AS D ON A.user_id = D.user_id
LEFT JOIN
        (SELECT  buyer_id, buyer_shipping_fee
         FROM    analytics.dw_orders 
         WHERE   order_number = 1
         AND date(booked_at) >= '2014-10-01')   AS E ON A.user_id = E.buyer_id                                                                                                          
) 
 ) 
WHERE date_buyer_activated >= '2014-10-01'
AND   date_buyer_activated <= '2014-12-31'
/*AND   user_status = 'active'*/
GROUP BY date_buyer_activated
ORDER BY date_buyer_activated



INNER JOIN    /* posh credit table */ 
      (SELECT user_id, issued_at, reason
       FROM analytics.dw_posh_credits 
       WHERE date(issued_at) >= '2015-09-01'
       AND reason = 'referred_user'
       AND credit_amount > 0) AS B ON A.user_id = B.user_id
