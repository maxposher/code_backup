



SELECT 
	DATE(buyer.date_buyer_activated) AS "buyer.buyer_activated_date",
	CASE WHEN dw_orders.order_number = 1 AND (((dw_orders.buyer_shipping_fee*.01) < 4.99 AND dw_orders.booked_at <  '2016-02-17 18:00:00') OR   ((dw_orders.buyer_shipping_fee*.01) < 5.95 AND dw_orders.booked_at >= '2016-02-17 18:00:00')) THEN 'Yes' ELSE 'No' END AS "dw_orders.is_first_order_discounted",
	CASE WHEN buyer.is_referred_with_code THEN 'Yes' ELSE 'No' END AS "buyer.is_referred_with_code",
	buyer.reg_app AS "buyer.reg_app",
	COALESCE(SUM((dw_orders.order_gmv*0.01)),0) AS "dw_orders.total_order_gmv"
FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id

WHERE  

ORDER BY 1 DESC
LIMIT 5000




SELECT date(U.buyer_activated_at) AS buyer_activation_date, OD.buyer_id, U.reg_app, COALESCE(Promo_Buyer,false) AS Promo,
       COALESCE(U.is_referred_with_code, false) AS referred_user, sum(OD.order_gmv*0.01) AS Cum_21day_GMV
FROM analytics.dw_orders AS OD
INNER JOIN analytics.dw_users AS U ON OD.buyer_id = U.user_id
LEFT  JOIN 

       (SELECT O.buyer_id, true AS Promo_Buyer
        FROM analytics.dw_orders AS O
        WHERE O.order_number = 1
        AND ((O.buyer_shipping_fee*.01 < 4.99 AND O.booked_at <  '2016-02-17 18:00:00') OR  
         (O.buyer_shipping_fee*.01 < 5.95  AND O.booked_at >= '2016-02-17 18:00:00')) 
        AND date(booked_at) >= '2015-01-01') AS B ON OD.buyer_id = B.buyer_id

WHERE date(OD.booked_at) - date(U.buyer_activated_at) <= 20
AND ((date(U.buyer_activated_at) BETWEEN '2016-02-01' AND '2016-04-11') OR (date(U.buyer_activated_at) BETWEEN '2015-02-01' AND '2015-04-11'))

AND OD.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
        'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
        'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND U.reg_app IN ('iphone', 'web', 'android')        
GROUP BY 2,1,3,4, 5


LIMIT 100


SELECT O.buyer_id, 1 AS Promo_Buyer
FROM analytics.dw_orders AS O
WHERE O.order_number = 1
AND ((O.buyer_shipping_fee*.01 < 4.99 AND O.booked_at <  '2016-02-17 18:00:00') OR  
    (O.buyer_shipping_fee*.01 < 5.95  AND O.booked_at >= '2016-02-17 18:00:00')) 
AND date(booked_at) >= '2016-02-01'
limit 100

    
SELECT label_id, COUNT(*)
FROM   analytics.dw_shipping_labels
GROUP BY 1
HAVING COUNT (*) > 1
LIMIT  20


SELECT received_at
FROM   analytics.dw_orders

LIMIT  20


SELECT COUNT(*)
FROM(

SELECT  U.date_buyer_activated, (U.date_buyer_activated - date(U.joined_at)) + 1 AS buyer_age, U.reg_app 
FROM    analytics.dw_users AS U
WHERE   U.date_buyer_activated = '2016-01-01'
AND     ((U.is_referred_with_code = false) or (U.is_referred_with_code IS NULL))
AND    U.reg_app IN ('iphone', 'android', 'web')
AND (U.date_buyer_activated - date(U.joined_at)) + 1 = 1
)

LIMIT 100


SELECT  COUNT(U.user_id)
FROM    analytics.dw_users AS U
WHERE   U.date_buyer_activated = '2016-01-01'
AND (U.date_buyer_activated - date(U.joined_at)) + 1 = 1
AND     ((U.is_referred_with_code = false) or (U.is_referred_with_code IS NULL))
LIMIT 100


SELECT COUNT(*)
FROM(

   SELECT  U.date_buyer_activated, (U.date_buyer_activated - date(U.joined_at)) + 1 AS buyer_age, U.reg_app,
      CASE WHEN acq_channel in 
        ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot',
         'poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw',
         'unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp') OR (acq_channel IS NULL ) THEN 'Organic'
          WHEN (acq_channel in ('rip')) THEN 'Referral_Organic'
          ELSE 'Paid' END AS Paid_Organic
   FROM    analytics.dw_users AS U
   WHERE   U.date_buyer_activated = '2016-01-01'
   AND     ((U.is_referred_with_code = false) or (U.is_referred_with_code IS NULL))
   AND    U.reg_app IN ('iphone', 'android', 'web') 
   ORDER BY 1
)WHERE Paid_Organic = 'Paid'
   
   limit 10




            SELECT  U.date_buyer_activated, (U.date_buyer_activated - date(U.joined_at)) + 1 AS buyer_age, U.reg_app
            FROM    analytics.dw_users AS U
            WHERE   U.date_buyer_activated = '2016-01-02'
            AND     ((U.is_referred_with_code = false) or (U.is_referred_with_code IS NULL))
            AND     U.reg_app IN ('iphone', 'android', 'web')
            AND    (U.date_buyer_activated - date(U.joined_at)) + 1 >= 120
            AND    U.reg_app = 'android'
            ORDER BY 1
            
            
            
            
            SELECT U.date_buyer_activated, SUM(order_gmv*0.01),
            CASE WHEN (U.is_referred_with_code IS NULL OR U.is_referred_with_code is false) THEN 'Not_Referral' 
            ELSE 'Referral' END AS Referred
              
            FROM analytics.dw_users AS U
            LEFT JOIN analytics.dw_orders AS O ON U.user_id = O.buyer_id
            
            WHERE O.order_state IN 
            ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
            'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
            'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
            'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
            'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
            AND (date(O.booked_at) - U.date_buyer_activated) < 30
            AND U.date_buyer_activated >= '2015-12-31'
            AND O.buyer_id IN 
            (
             SELECT buyer_id
             FROM analytics.dw_orders
             WHERE ((buyer_shipping_fee*.01 < 4.99 AND booked_at <  '2016-02-17 18:00:00') OR   
             (buyer_shipping_fee*.01 < 5.95 AND booked_at >= '2016-02-17 18:00:00'))
             AND order_number = 1  
            )
            
            GROUP BY 1, 3
            ORDER BY 1
            
            
            
            
            
                      SELECT U.date_buyer_activated, U.is_referred_with_code, SUM(order_gmv*0.01)
            CASE WHEN (U.is_referred_with_code IS NULL OR U.is_referred_with_code is false) THEN 'Not_Referral' 
            ELSE 'Referral' END AS Referred
            

            
            FROM analytics.dw_users AS U
            LEFT JOIN analytics.dw_orders AS O ON U.user_id = O.buyer_id
            LEFT JOIN alay
            WHERE O.order_state IN 
            ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
            'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
            'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
            'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
            'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
            AND (date(O.booked_at) - U.date_buyer_activated) < 30
            AND U.date_buyer_activated >= '2015-12-31'
            GROUP BY 1,2
            ORDER BY 1
            
            
            SELECT date_buyer_activated, COUNT (user_id)
            FROM analytics.dw_users
            WHERE (is_referred_with_code IS NULL or is_referred_with_code = 'false')
            AND date_buyer_activated = '2016-04-01'
            AND date_buyer_activated = date(joined_at)
            AND guest_user IS false
            GROUP BY 1
            