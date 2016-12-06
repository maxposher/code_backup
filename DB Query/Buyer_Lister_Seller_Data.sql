



    SELECT TO_CHAR(seller.lister_activated_at, 'YYYY-MM') AS "Lister Activated Month",
	   DATEDIFF(month, seller.lister_activated_at, O.booked_at) + 1 AS "dw_orders.months_since_lister_activated",
	   SUM(order_gmv*.01) AS "dw_orders.count_orders"
    FROM analytics.dw_orders AS O
    INNER JOIN analytics.dw_users AS seller ON O.seller_id = seller.user_id
    WHERE ((seller.lister_activated_at >= (timestamp '2013-01-01'))) AND ((((O.order_gmv*0.01) < 50000 and 
    O.booked_at IS NOT NULL and O.order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
    'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
    'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
    'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
    'seller_ab_update_failed', 'waiting_seller_kyc_verification'))   ))
    GROUP BY 1,2
    ORDER BY 1
    
    
    
    
    SELECT TO_CHAR(seller.lister_activated_at, 'YYYY-MM') AS "Lister Activated Month",
	   DATEDIFF(month, seller.lister_activated_at, O.booked_at) + 1 AS "dw_orders.months_since_lister_activated",
	   COUNT(O.order_id) AS "dw_orders.count_orders"
    FROM analytics.dw_orders AS O
    INNER JOIN analytics.dw_users AS seller ON O.seller_id = seller.user_id
    WHERE ((seller.lister_activated_at >= (timestamp '2013-01-01'))) AND ((((O.order_gmv*0.01) < 50000 and 
    O.booked_at IS NOT NULL and O.order_state IN 
    ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
    'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
    'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
    'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
    'seller_ab_update_failed', 'waiting_seller_kyc_verification'))   ))
    GROUP BY 1,2
    ORDER BY 1
    
    
    
    
    SELECT TO_CHAR(seller.lister_activated_at, 'YYYY-MM') AS "Lister Activated Month",
	   DATEDIFF(month, seller.lister_activated_at, A.activity_at) + 1 AS "months_since_lister_activated",
	   COUNT(distinct seller.user_id) AS "count_listings"
    FROM analytics.dw_user_activity AS A
    INNER JOIN analytics.dw_users AS seller ON A.user_id = seller.user_id
    WHERE (seller.lister_activated_at >= (timestamp '2013-01-01'))
    AND  A.activity_name IN ('listing_created', 'item_sold') 
    GROUP BY 1,2
    ORDER BY 1, 2
    
    
    SELECT count(A.user_id)
    FROM analytics.dw_users AS A
    WHERE date(lister_activated_at) BETWEEN '2016-04-01' AND '2016-04-30'
    LIMIT 10
    
    
    
    
    /***********************************************************/
    
    SELECT count(distinct user_id)
    FROM
    (
    SELECT dw_user_activity.user_id
    FROM analytics.dw_user_activity AS dw_user_activity
    WHERE date(dw_user_activity.activity_at) BETWEEN '2013-01-01' AND '2013-12-31'
    AND dw_user_activity.activity_name =  'item_purchased'
    GROUP BY 1

    INTERSECT
    
    SELECT A2.user_id
    FROM analytics.dw_user_activity AS A2
    WHERE date(A2.activity_at) BETWEEN '2013-01-01' AND '2013-12-31'
    AND A2.activity_name IN ( 'item_sold', 'listing_created' )
    GROUP BY 1
    )
  
   /*************************************/
   
   SELECT TO_CHAR(seller.lister_activated_at, 'YYYY-MM') AS "buyer.buyer_activated_month",
   DATEDIFF(month, seller.lister_activated_at,dw_orders.booked_at) + 1 AS "dw_orders.months_since_lister_activated",
   COALESCE(SUM((dw_orders.order_gmv*0.01)),0) AS "dw_orders.total_order_gmv"
   FROM analytics.dw_orders AS dw_orders
   LEFT JOIN analytics.dw_users AS seller ON dw_orders.seller_id = seller.user_id
   WHERE ((seller.lister_activated_at >= (TIMESTAMP '2013-01-01'))) AND ((((dw_orders.order_gmv*0.01) < 50000 
   and dw_orders.booked_at IS NOT NULL and dw_orders.order_state 
   IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification'))   ))
   GROUP BY 1,2
   ORDER BY 1,2
 
 
   SELECT TO_CHAR(seller.lister_activated_at, 'YYYY-MM') AS "buyer.buyer_activated_month",
   DATEDIFF(month, seller.lister_activated_at,dw_orders.booked_at) + 1 AS "dw_orders.months_since_lister_activated",
   COUNT (distinct order_id) AS "Sellers"
   FROM analytics.dw_orders AS dw_orders
   LEFT JOIN analytics.dw_users AS seller ON dw_orders.seller_id = seller.user_id
   WHERE ((seller.lister_activated_at >= (TIMESTAMP '2013-01-01'))) AND ((((dw_orders.order_gmv*0.01) < 50000 
   and dw_orders.booked_at IS NOT NULL and dw_orders.order_state 
   IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification'))   ))
   GROUP BY 1,2
   ORDER BY 1,2
 
 
    
    
   SELECT order_id, redeemable_credits_used
   FROM analytics.dw_orders
   WHERE redeemable_credits_used 
   AND order_id = '4ed6f9293d64136268001258'
   LIMIT 10 
    
    
  SELECT *
  FROM  analytics.dw_redeemable_credits
  WHERE order_id = '4ed6f9293d64136268001258'
  
  
  
       
   SELECT order_id, redeemable_credits_used
   FROM analytics.dw_orders
   WHERE redeemable_credits_used 

  
    
    
   SELECT C.*, O.order_gmv
   FROM  analytics.dw_redeemable_credits AS C
   INNER JOIN analytics.dw_orders AS O on C.order_id = O.order_id
   ORDER BY 1
   LIMIT 10
  
  
  /*****************************************/

SELECT    TO_CHAR(dw_users.buyer_activated_at, 'YYYY-MM') AS "dw_users.buyer_activated_month",
	  DATEDIFF(month,dw_users.buyer_activated_at, dw_user_activity.activity_at) + 1 AS "dw_user_activity.activity_month_since_buyer_activated",
	  COUNT(DISTINCT dw_users.user_id) AS "Buyer_Active_Users"
FROM      analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users ON dw_user_activity.user_id = dw_users.user_id
WHERE (dw_users.buyer_activated_at >= (TIMESTAMP '2013-01-01'))
AND dw_user_activity.activity_name = 'active_on_app'
AND DATEDIFF(month,dw_users.buyer_activated_at, dw_user_activity.activity_at) + 1 > 0
GROUP BY 1,2
ORDER BY 1

LIMIT 100
  
  
SELECT TO_CHAR(buyer_activated_at, 'YYYY-MM') AS "dw_users.buyer_activated_month", count(distinct user_id)
FROM   analytics.dw_users
WHERE  date(buyer_activated_at) >= '2013-01-01'
GROUP BY 1
ORDER By 1
LIMIT 100


SELECT    TO_CHAR(dw_users.lister_activated_at, 'YYYY-MM') AS "dw_users.seller_activated_month",
	  DATEDIFF(month,dw_users.lister_activated_at, dw_user_activity.activity_at) + 1 AS "dw_user_activity.activity_month_since_seller_activated",
	  COUNT(DISTINCT dw_users.user_id) AS "Seller_Active_Users"
FROM      analytics.dw_user_activity AS dw_user_activity
INNER JOIN analytics.dw_users AS dw_users ON dw_user_activity.user_id = dw_users.user_id
WHERE (dw_users.lister_activated_at >= (TIMESTAMP '2013-01-01'))
AND dw_user_activity.activity_name = 'active_on_app'
AND DATEDIFF(month,dw_users.lister_activated_at, dw_user_activity.activity_at) + 1 > 0
GROUP BY 1,2
ORDER BY 1



SELECT TO_CHAR(lister_activated_at, 'YYYY-MM') AS "dw_users.buyer_activated_month", count(distinct user_id)
FROM   analytics.dw_users
WHERE  date(lister_activated_at) >= '2013-01-01'
GROUP BY 1
ORDER By 1
LIMIT 100
  







   SELECT count(distinct user_id)
    FROM
    (
    SELECT dw_user_activity.user_id
    FROM analytics.dw_user_activity AS dw_user_activity
    WHERE date(dw_user_activity.activity_at) BETWEEN '2016-01-01' AND '2016-04-30'
    AND dw_user_activity.activity_name =  'item_purchased'
    GROUP BY 1

    INTERSECT
    
    SELECT A2.user_id
    FROM analytics.dw_user_activity AS A2
    WHERE date(A2.activity_at) BETWEEN '2016-01-01' AND '2016-04-30'
    AND A2.activity_name IN ('listing_created' )
    GROUP BY 1
    )
    
    
    
SELECT    TO_CHAR(dw_users.lister_activated_at, 'YYYY-MM') AS "dw_users.seller_activated_month",
	  DATEDIFF(month,dw_users.lister_activated_at, dw_user_activity.activity_at) + 1 AS "dw_user_activity.activity_month_since_seller_activated",
	  COUNT(DISTINCT dw_users.user_id) AS "Seller_Active_Users"
FROM      analytics.dw_user_activity AS dw_user_activity
INNER JOIN analytics.dw_users AS dw_users ON dw_user_activity.user_id = dw_users.user_id
WHERE (dw_users.lister_activated_at >= (TIMESTAMP '2013-01-01'))
AND dw_user_activity.activity_name in ('active_on_app')
AND DATEDIFF(month,dw_users.lister_activated_at, dw_user_activity.activity_at) + 1 > 0
GROUP BY 1,2
ORDER BY 1,2
    


SELECT    TO_CHAR(Committed_Seller, 'YYYY-MM') AS "dw_users.seller_activated_month",
	  DATEDIFF(month, Committed_Seller, dw_user_activity.activity_at) + 1 AS "dw_user_activity.activity_month_since_seller_activated",
	  COUNT(DISTINCT dw_user_activity.user_id) AS "Seller_Active_Users"
FROM      analytics.dw_user_activity AS dw_user_activity
INNER JOIN 
          (SELECT user_id, min(activity_at) AS Committed_Seller
           FROM   analytics.dw_user_activity 
           WHERE  activity_count = 5 
           AND    activity_name = 'listing_created'
           GROUP BY 1) AS A ON dw_user_activity.user_id = A.user_id
           
WHERE (Committed_Seller >= (TIMESTAMP '2013-01-01'))
AND dw_user_activity.activity_name IN ('item_sold', 'listing_created')
AND DATEDIFF(month, Committed_Seller , dw_user_activity.activity_at) + 1 > 0
GROUP BY 1,2
ORDER BY 1,2

LIMIT 100


('item_sold', 'listing_created')

           SELECT TO_CHAR(activity_at, 'YYYY-MM'), COUNT(distinct A.user_id) 
           FROM   analytics.dw_user_activity AS A
          /* INNER  JOIN analytics.dw_users AS U ON A.user_id = U.user_id*/
           WHERE  activity_count = 5 
           AND    activity_name = 'listing_created'
           /*AND    seller_activated_at < activity_at*/
           GROUP BY 1
           ORDER BY 1








   SELECT TO_CHAR(Committed_Seller, 'YYYY-MM') AS "Committed_Seller_activated_month",
   DATEDIFF(month, Committed_Seller, dw_orders.booked_at) + 1 AS "dw_orders.months_since_lister_activated",
   SUM (order_gmv*0.01) AS GMV
   FROM analytics.dw_orders AS dw_orders
   
   INNER JOIN 
          (SELECT user_id, activity_at AS Committed_Seller
           FROM   analytics.dw_user_activity 
           WHERE  activity_count = 5 
           AND    activity_name = 'listing_created') AS A ON dw_orders.seller_id = A.user_id
   
   WHERE ((Committed_Seller >= (TIMESTAMP '2013-01-01'))) AND ((((dw_orders.order_gmv*0.01) < 50000 
   and dw_orders.booked_at IS NOT NULL 
   AND  DATEDIFF(month, Committed_Seller, dw_orders.booked_at) + 1 > 0
   and dw_orders.order_state 
   IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification'))   ))
   GROUP BY 1,2
   ORDER BY 1,2
   
   
   
   SELECT COUNT (distinct order_id)
   FROM analytics.dw_orders as O
   WHERE date(O.received_at) BETWEEN '2016-02-01' AND '2016-02-29'
   
   
   
   
   
   
   
   
   
          SELECT date(O.cancelled_on), SUM(final_postage*.01)
          FROM  analytics.dw_orders AS O 
          INNER JOIN analytics.dw_shipping_labels AS L ON O.order_id = L.order_id
          WHERE 
               state = 'used'
          AND  date(O.cancelled_on) BETWEEN '2016-02-01' AND '2016-02-29'
          GROUP by 1
   
   
   
       SELECT label_id, count (order_id)
       FROM analytics.dw_shipping_labels
       GROUP BY 1
       HAVING count (order_id) > 1
       
       LIMIT 100
       
       
       SELECT *
       FROM analytics.dw_shipping_labels
       LIMIT 100