/* Actor Zero */
SELECT U.user_id, U.reg_app, CASE WHEN date(E.date_like_activated) = U.join_date THEN 1 ELSE 0 END AS D1_Liker, Discount_Buyer 
     FROM   analytics.dw_users AS U
           LEFT JOIN (SELECT buyer_id, 
                      CASE WHEN buyer_shipping_fee < 499  THEN 1 ELSE 0 END AS Discount_Buyer
                      FROM    analytics.dw_orders 
                      WHERE   order_number = 1 
                      AND date(booked_at) >= '2015-10-01') AS O ON U.user_id = O.buyer_id                          
           LEFT JOIN (SELECT R."a|id" AS user_id, min(R."at") AS date_like_activated
                      FROM  raw_hive.october_events AS R
                      WHERE R."v" = 'l'
                      AND R."at" >= '2015-10-01'
                      GROUP BY R."a|id"
                      ) AS E ON U.user_id = E.user_id
     WHERE              date(U.join_date) BETWEEN '2015-10-07' AND '2015-10-31'
     
   UNION
   
     SELECT U.user_id, U.reg_app, CASE WHEN date(E.date_like_activated) = U.join_date THEN 1 ELSE 0 END AS D1_Liker, Discount_Buyer 
     FROM   analytics.dw_users AS U
           LEFT JOIN (SELECT buyer_id, 
                      CASE WHEN buyer_shipping_fee < 499  THEN 1 ELSE 0 END AS Discount_Buyer
                      FROM    analytics.dw_orders 
                      WHERE   order_number = 1 
                      AND date(booked_at) >= '2015-11-01') AS O ON U.user_id = O.buyer_id                          
           LEFT JOIN (SELECT R."a|id" AS user_id, min(R."at") AS date_like_activated
                      FROM raw_hive.november_events AS R
                      WHERE R."v" = 'l'
                      AND R."at" >= '2015-11-01'
                      GROUP BY R."a|id"
                      ) AS E ON U.user_id = E.user_id
     WHERE           date(U.join_date) BETWEEN '2015-11-01' AND  '2015-11-10'  
/**********************/
