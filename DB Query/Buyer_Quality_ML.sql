

/*Buyer 6 month GMV */
SELECT buyer_id, sum(order_gmv*0.01)
FROM  analytics.dw_orders AS O
INNER JOIN analytics.dw_users AS U on O.buyer_id = U.user_id
WHERE O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 
'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND date(buyer_activated_at) >= '2016-01-01'
AND date(buyer_activated_at) - date(booked_at) + 1 <= 180
AND U.reg_app in ('iphone', 'android', 'web')
GROUP BY 1
limit  10

SELECT COUNT(distinct buyer_id)
FROM (
SELECT buyer_id, order_gmv*0.01 AS first_order_gmv, reg_app, (date(buyer_activated_at) - date(joined_at)) - 1 AS Age,
       CASE WHEN is_referred_with_code = true THEN 1 else 0 end AS Referral,
       CASE WHEN ((O.buyer_shipping_fee*.01 < 4.99 AND O.booked_at <  '2016-02-17 18:00:00') 
                                                    OR 
                  (O.buyer_shipping_fee*.01 < 5.95 AND O.booked_at >= '2016-02-17 18:00:00')) THEN 1 ELSE 0 END AS Promo
   
FROM  analytics.dw_orders AS O
INNER JOIN analytics.dw_users AS U on O.buyer_id = U.user_id
WHERE O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 
'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
AND date(buyer_activated_at) >= '2016-01-01'
AND O.order_number = 1
AND U.reg_app in ('iphone', 'android', 'web')
)

LIMIT 10


(buyer_first_order.order_number = 1 AND (((buyer_first_order.buyer_shipping_fee*.01) < 4.99 
AND buyer_first_order.booked_at <  '2016-02-17 18:00:00') OR   ((buyer_first_order.buyer_shipping_fee*.01) < 5.95 AND buyer_first_order.booked_at >= '2016-02-17 18:00:00')))