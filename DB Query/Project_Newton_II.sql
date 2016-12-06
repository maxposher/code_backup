



SELECT 
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE 

AND   (A.activity_name = 'item_purchased' OR A.activity_name = 'listing_created')
AND   date( A.activity_date) = '2015-10-01'
GROUP BY  date_trunc('mon', date(A.activity_date))
ORDER BY  date_trunc('mon', date(A.activity_date))




/* The works */

   SELECT date(U.join_date),
          U.user_id,
          SUM(CASE WHEN (R."v" = 'f' AND R."do|t" = 'b') THEN 1 ELSE 0 END) AS Follow_Brand,
          SUM(CASE WHEN (R."v" = 's') THEN 1 ELSE 0 END) AS _share        
   FROM analytics.dw_users AS U
   INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
   WHERE date(R."at") < least(date(U.date_buyer_activated), date(U.date_lister_activated), date('2015-10-02'))
   AND date(U.join_date) = '2015-10-01'
   GROUP BY 1,2  
   LIMIT 10
   
   
   
   
   SELECT O.booked_at, O.buyer_id, (CASE WHEN O.buyer_shipping_fee < 499 THEN 1 ELSE 0 END) AS Discount
   FROM analytics.dw_orders AS O
   WHERE O.order_number = 1
   AND   O.booked_date = '2015-10-01'
   LIMIT 10
   
   
   
   
    SELECT date(U.join_date), U.user_id,
   (CASE WHEN date(O.booked_at) IS NOT NULL THEN 1 ELSE 0 END) AS D2_BA,
    SUM(CASE WHEN (R."v" = 'l')                    THEN 1 ELSE 0 END) AS Like_Listing,
    SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c') THEN 1 ELSE 0 END) AS Post_Comment,
    SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'l') THEN 1 ELSE 0 END) AS Created_Listing,
    SUM(CASE WHEN (R."v" = 'f' AND R."do|t" = 'b') THEN 1 ELSE 0 END) AS Follow_Brand,
    SUM(CASE WHEN  R."v" = 's' THEN 1 ELSE 0 END) AS internal_share,
    SUM(CASE WHEN  R."v" = 'es' THEN 1 ELSE 0 END) AS external_share        
    FROM analytics.dw_users AS U
         INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
         LEFT JOIN (SELECT booked_at, buyer_id, (CASE WHEN buyer_shipping_fee < 499 THEN 1 ELSE 0 END) AS Discount
                    FROM analytics.dw_orders 
                    WHERE order_number = 1
                    AND   booked_date = '2015-10-01') AS O on O.buyer_id = U.user_id
   WHERE date(U.join_date) = '2015-11-01'
   AND  (R."at") < least(O.booked_at, date('2015-11-03'))
   GROUP BY 1,2, 3  
   LIMIT 100
   
   
  SELECT A.user_id,
  CASE WHEN A.activity_name = 'join_poshmark'  THEN A.activity_date  ELSE NULL END AS join_day,
  CASE WHEN A.activity_name = 'item_sold'      THEN A.activity_date  ELSE NULL END AS seller_activated,
  CASE WHEN A.activity_name = 'item_purchased' THEN A.activity_date  ELSE NULL END AS buyer_activated
  FROM analytics.dw_user_activity AS A
  WHERE A.activity_count = 1
  GROUP BY 1, A.activity_date, A.activity_name, A.user_id
  LIMIT 300
   
   
   
   
   
   SELECT date(U.join_date), U.user_id, O.booked_at    
   FROM analytics.dw_users AS U
   INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
   LEFT JOIN (SELECT booked_at, buyer_id, (CASE WHEN buyer_shipping_fee < 499 THEN 1 ELSE 0 END) AS Discount
              FROM analytics.dw_orders 
              WHERE order_number = 1
              AND   booked_date = '2015-10-01') AS O on O.buyer_id = U.user_id
   WHERE date(U.join_date) = '2015-10-01'
   AND O.booked_at IS NOT NULL
   LIMIT 10
   
   
 