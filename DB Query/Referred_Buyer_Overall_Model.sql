SELECT  SUM(CASE WHEN first_order_price <= 5 THEN 1 ELSE 0 END) AS Five_Less, 
        SUM(CASE WHEN first_order_price BETWEEN 6 and 10 THEN 1 ELSE 0 END) AS six_ten, 
        SUM(CASE WHEN first_order_price BETWEEN 11 and 20 THEN 1 ELSE 0 END) AS eleven_twenty, 
        SUM(CASE WHEN first_order_price BETWEEN 21 and 50 THEN 1 ELSE 0 END) AS twenty_one_fifty, 
        SUM(CASE WHEN first_order_price > 50 THEN 1 ELSE 0 END) AS fifty_plus, 
date_buyer_activated, count(distinct user_id), sum(additional_order), sum(additional_Order_GMV), sum(retention)
 FROM(
   SELECT A.user_id, A.date_buyer_activated, C.additional_order, C.additional_Order_GMV,
   B.issued_at, A.user_status, B.reason, D.retention, E.first_order_price
   FROM (
      
      /* user main table */      
      (SELECT user_id, date_buyer_activated, user_status       
       FROM   analytics.dw_users
       WHERE  date_buyer_activated >= '2015-09-01'
       )  AS A   

INNER JOIN    /* posh credit table */ 
      (SELECT user_id, issued_at, reason
       FROM analytics.dw_posh_credits 
       WHERE date(issued_at) >= '2015-09-01'
       AND reason = 'referred_user'
       AND credit_amount > 0) AS B ON A.user_id = B.user_id
       
LEFT JOIN    /* addition purchase table */
      (SELECT U.user_id, count(distinct O.order_id) AS Additional_Order, sum(O.order_gmv) AS Additional_Order_GMV
       FROM analytics.dw_orders AS O
       INNER JOIN analytics.dw_users AS U ON U.user_id = O.buyer_id
       WHERE O.order_number > 1
       AND   date(O.booked_at) >= '2015-09-01'
       AND   date(date_buyer_activated) >= '2015-09-01'
       AND   date(O.booked_date) - date(date_buyer_activated) < 7
       GROUP BY 1)                      AS C ON A.user_id = C.user_id

LEFT JOIN   /* Retention table */
       (SELECT U.user_id, 1 AS Retention
        FROM  analytics.dw_users AS U 
        INNER JOIN  
        (SELECT date(A.activity_date) AS activity_date, A.user_id
         FROM   analytics.dw_user_activity AS A
         WHERE  date(A.activity_date) >= '2015-09-01'
         AND   A.activity_name = 'active_on_app'
         GROUP BY 1,2) AS A on A.user_id = U.user_id
         WHERE U.date_buyer_activated  >= '2015-09-01'
         AND   date(A.activity_date) - date(U.date_buyer_activated) <= 6
         AND   date(A.activity_date) - date(U.date_buyer_activated) > 0
         GROUP BY 1) AS D ON A.user_id = D.user_id

LEFT JOIN
        (SELECT buyer_id, order_gmv/100 AS first_order_price
         FROM analytics.dw_orders 
         WHERE    order_number = 1
         AND date(booked_at) >= '2015-09-01')    AS E ON A.user_id = E.buyer_id                                     
                                                                        
) 
 ) 
WHERE date_buyer_activated > '2015-11-17'
AND   reason = 'referred_user'
AND   user_status = 'active'
AND   date(issued_at) > '2015-11-17'
/*AND first_order_price > 10 */
GROUP BY date_buyer_activated
ORDER BY date_buyer_activated


 
 
 
/* Non - Referral */
SELECT 
date_buyer_activated, count(distinct user_id), sum(additional_order), sum(additional_Order_GMV), sum(retention)
 FROM(
   SELECT A.user_id, A.date_buyer_activated, C.additional_order, C.additional_Order_GMV,
   A.user_status, D.retention
   FROM (
      
      /* user main table */      
      (SELECT user_id, date_buyer_activated, user_status       
       FROM   analytics.dw_users
       WHERE  date_buyer_activated >= '2015-09-01'
       AND    referred_by_user_id IS NULL
       )  AS A   

       
LEFT JOIN    /* addition purchase table */
      (SELECT U.user_id, count(distinct O.order_id) AS Additional_Order, sum(O.order_gmv) AS Additional_Order_GMV
       FROM analytics.dw_orders AS O
       INNER JOIN analytics.dw_users AS U ON U.user_id = O.buyer_id
       WHERE O.order_number > 1
       AND   date(O.booked_at) >= '2015-09-01'
       AND   date(date_buyer_activated) >= '2015-09-01'
       AND   date(O.booked_date) - date(date_buyer_activated) < 7
       GROUP BY 1)                      AS C ON A.user_id = C.user_id

LEFT JOIN   /* Retention table */
       (SELECT U.user_id, 1 AS Retention
        FROM  analytics.dw_users AS U 
        INNER JOIN  
        (SELECT date(A.activity_date) AS activity_date, A.user_id
         FROM   analytics.dw_user_activity AS A
         WHERE  date(A.activity_date) >= '2015-09-01'
         AND   A.activity_name = 'active_on_app'
         GROUP BY 1,2) AS A on A.user_id = U.user_id
         WHERE U.date_buyer_activated  >= '2015-09-01'
         AND   date(A.activity_date) - date(U.date_buyer_activated) <= 6
         AND   date(A.activity_date) - date(U.date_buyer_activated) > 0
         GROUP BY 1) AS D ON A.user_id = D.user_id

) 
 ) 
WHERE date_buyer_activated > '2015-11-17'
AND   user_status = 'active'
/*AND first_order_price > 10 */
GROUP BY date_buyer_activated
ORDER BY date_buyer_activated

