
/*Referred Users */
SELECT K.date_buyer_activated, count(distinct O.order_id), sum(O.order_gmv)
FROM analytics.dw_orders AS O
INNER JOIN 
  (SELECT U.date_buyer_activated, U.user_id, C.issued_at 
   FROM analytics.dw_posh_credits AS C
   INNER JOIN analytics.dw_users AS U ON C.user_id = U.user_id
   WHERE 
         C.reason = 'referred_user'
   AND   date(C.issued_at) < '2015-11-17'
   AND   U.user_status = 'active'  ) AS K ON K.user_id = O.buyer_id
WHERE date(O.booked_date) - date(K.date_buyer_activated) <= 6
AND O.order_number > 1
AND K.date_buyer_activated  > '2015-11-17'

GROUP BY K.date_buyer_activated
ORDER BY 1



   SELECT U.date_buyer_activated, COUNT (distinct U.user_id)
   FROM analytics.dw_posh_credits AS C
   INNER JOIN analytics.dw_users AS U ON C.user_id = U.user_id
   WHERE 
         C.reason = 'referred_user'
   AND   U.date_buyer_activated  > '2015-11-17'
   AND   date(C.issued_at) > '2015-11-17'
   AND   U.user_status = 'active'  
   GROUP BY U.date_buyer_activated
   ORDER BY 1
      
      
/* Normal Users */   
SELECT U.date_buyer_activated, count(distinct O.order_id), sum(O.order_gmv)
FROM analytics.dw_orders AS O
INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
WHERE date(O.booked_date) - date(U.date_buyer_activated) <= 6
AND O.order_number > 1
AND U.user_status = 'active' 
AND U.date_buyer_activated  > '2015-09-01'
AND U.user_id NOT IN 

  (SELECT C.user_id
   FROM analytics.dw_posh_credits AS C
   WHERE C.reason = 'referred_user'
   AND   date(C.issued_at) < '2015-11-30'
   GROUP BY 1)

GROUP BY U.date_buyer_activated
ORDER BY 1

SELECT U.date_buyer_activated, count (distinct U.user_id)
FROM analytics.dw_users AS U
WHERE  U.user_status = 'active' 
AND U.date_buyer_activated  > '2015-09-01'
AND U.user_id NOT IN 

  (SELECT C.user_id
   FROM analytics.dw_posh_credits AS C
   WHERE C.reason = 'referred_user'
   AND   date(C.issued_at) < '2015-11-30'
   GROUP BY 1)

GROUP BY U.date_buyer_activated
ORDER BY 1

SELECT K.date_buyer_activated, count(distinct A.user_id)
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS K ON A.user_id = K.user_id
WHERE date(A.activity_date) - date(K.date_buyer_activated) <= 6
AND date(A.activity_date) - date(K.date_buyer_activated) > 0
AND A.activity_name = 'active_on_app'
AND K.date_buyer_activated  > '2015-09-01'
AND K.user_id NOT IN

  (SELECT C.user_id
   FROM analytics.dw_posh_credits AS C
   WHERE C.reason = 'referred_user'
   AND   date(C.issued_at) < '2015-11-30'
   GROUP BY 1)
AND K.user_status = 'active' 
GROUP BY K.date_buyer_activated

ORDER BY 1   








   

   
SELECT U.date_buyer_activated, count(distinct U.user_id)
FROM  analytics.dw_users AS U 
WHERE U.user_id NOT IN 
  (SELECT  U.user_id 
   FROM analytics.dw_posh_credits AS C
   INNER JOIN analytics.dw_users AS U ON C.user_id = U.user_id
   WHERE 
         C.reason = 'referred_user'
   AND   date(C.issued_at) > '2015-09-01'
   GROUP BY 1)
AND U.user_status = 'active'    
AND U.date_buyer_activated  > '2015-09-01'
GROUP BY U.date_buyer_activated
ORDER BY 1   
   
   
   
   
SELECT K.date_buyer_activated, count(distinct A.user_id)
FROM analytics.dw_user_activity AS A
INNER JOIN 
  (SELECT U.date_buyer_activated, U.user_id, C.issued_at 
   FROM analytics.dw_posh_credits AS C
   INNER JOIN analytics.dw_users AS U ON C.user_id = U.user_id
   WHERE 
         C.reason = 'referred_user'
   AND   date(C.issued_at) > '2015-11-17'
   AND   U.user_status = 'active'  ) AS K ON K.user_id = A.user_id
WHERE date(A.activity_date) - date(K.date_buyer_activated) <= 6
AND date(A.activity_date) - date(K.date_buyer_activated) > 0
AND A.activity_name = 'active_on_app'
AND K.date_buyer_activated  > '2015-11-17'
GROUP BY K.date_buyer_activated
ORDER BY 1   
   

SELECT U.date_buyer_activated, COUNT (distinct U.user_id ) 
FROM  analytics.dw_users AS U 
INNER JOIN analytics.dw_posh_credits AS C ON C.user_id = U.user_id
INNER JOIN  
  (SELECT date(A.activity_date) AS activity_date, A.user_id
   FROM   analytics.dw_user_activity AS A
   WHERE  date(A.activity_date) > '2015-11-17'
   AND   A.activity_name = 'active_on_app'
   GROUP BY 1,2) AS A on A.user_id = U.user_id
   
WHERE U.date_buyer_activated  > '2015-11-17'
AND   C.reason = 'referred_user'
AND   date(C.issued_at) > '2015-11-17'
AND   date(A.activity_date) - date(U.date_buyer_activated) <= 6
AND   date(A.activity_date) - date(U.date_buyer_activated) > 0
AND   U.user_status = 'active'  
GROUP BY 1
ORDER BY 1


   
 SELECT U.date_buyer_activated, COUNT (distinct U.user_id ) 
FROM  analytics.dw_users AS U 
INNER JOIN analytics.dw_posh_credits AS C ON C.user_id = U.user_id

   
WHERE U.date_buyer_activated  > '2015-09-01'
AND   U.date_buyer_activated  < '2015-11-17'
AND   C.reason = 'referred_user'
AND   date(C.issued_at) > '2015-09-01'
AND   U.user_status = 'active'  
GROUP BY 1  
ORDER BY 1
   
   
   SELECT U.date_buyer_activated, COUNT (distinct U.user_id)
   FROM analytics.dw_posh_credits AS C
   INNER JOIN analytics.dw_users AS U ON C.user_id = U.user_id
   WHERE 
         C.reason = 'referred_user'
   AND   date(C.issued_at) > '2015-09-01'
   AND   U.date_buyer_activated  > '2015-09-01'
   AND   U.user_status = 'active'  
   GROUP BY U.date_buyer_activated
   ORDER BY 1   
   
   
   
   
      
 SELECT C.*
FROM   analytics.dw_posh_credits AS C 
WHERE issued_date > '2015-11-18'
AND reason = 'referred_user'
LIMIT 100   
   
   
   
   
  /*Referred Users */

SELECT O.booked_date, count(distinct O.order_id), sum(O.order_gmv)
FROM analytics.dw_orders AS O
INNER JOIN 
  (SELECT U.join_date, U.user_id 
   FROM analytics.dw_posh_credits AS C
   INNER JOIN analytics.dw_users AS U ON C.user_id = U.user_id
   WHERE C.credit_amount = 1000 
   AND   C.reason = 'referred_user'
   AND   date(C.issued_at) > '2015-11-17'
   AND   U.user_status = 'active'  ) AS K ON K.user_id = O.buyer_id
WHERE date(O.booked_at) - date(K.join_date) <= 6
GROUP BY O.booked_date 
ORDER BY 1



SELECT O.booked_date, count(distinct O.order_id), sum(O.order_gmv)
FROM analytics.dw_orders AS O
INNER JOIN 
(
   SELECT U.join_date, U.user_id
   FROM analytics.dw_users AS U 
   WHERE U.user_id NOT IN
   (
   SELECT C.user_id
   FROM analytics.dw_posh_credits AS C 
   WHERE C.credit_amount = 1000 
   AND   C.reason = 'referred_user'
   AND   date(C.issued_at) > '2015-11-17'
   GROUP BY C.user_id
   )
   AND U.join_date >= '2015-11-17'
   GROUP BY 1,2
   ORDER BY 1
) AS K on K.user_id = O.buyer_id
WHERE date(O.booked_at) - date(K.join_date) <= 6
GROUP BY O.booked_date 
ORDER BY 1
  