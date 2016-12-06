SELECT seller_id, username, CAST(O_SUM as float)/CAST(O_COUNT as float) AS avg_time, C
FROM(


SELECT    O.seller_id, username, sum(O.shipped_at - date(O.booked_at)) AS O_SUM, count(O.shipped_at - date(O.booked_at)) AS O_COUNT, COUNT(distinct order_id) as C, SUM(order_gmv)
FROM      analytics.dw_users AS U
LEFT JOIN analytics.dw_orders as O on U.user_id = O.seller_id
WHERE     
          date(O.booked_at) >= '2016-01-01'  
AND       O.order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
 'seller_ab_update_failed', 'waiting_seller_kyc_verification')

GROUP BY 1,2
HAVING count(distinct order_id) > 100)
ORDER BY 3
LIMIT 100



SELECT sum(O2.order_gmv*0.01)
FROM analytics.dw_orders AS O2
LEFT JOIN analytics.dw_users AS U2 on O2.buyer_id = U2.user_id
WHERE O2.buyer_id in

(SELECT buyer_id
 FROM analytics.dw_orders AS O
 LEFT JOIN analytics.dw_users AS U on O.buyer_id = U.user_id
 WHERE O.order_number = 1
 AND  O.buyer_shipping_fee*0.01 < 5.95
 AND U.reg_app = 'android'
 AND date(buyer_activated_at) = '2016-04-11'
 AND U.is_referred_with_code IS NULL
 GROUP BY 1)

AND date(O2.booked_at) - date(U2.buyer_activated_at) <= 20
AND O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
                 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
                 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                 'seller_ab_update_failed', 'waiting_seller_kyc_verification')


SELECT U.is_referred_with_code, COUNT(distinct buyer_id)
FROM analytics.dw_orders AS O
LEFT JOIN analytics.dw_users AS U on O.buyer_id = U.user_id
WHERE O.order_number = 1
AND  O.buyer_shipping_fee*0.01 < 5.95
AND U.reg_app = 'android'
AND date(buyer_activated_at) = '2016-04-11'
AND U.is_referred_with_code IS NULL
GROUP BY 1










