



SELECT M, DIST, COUNT(DIST), SUM(Ord)
FROM (
SELECT date_trunc('mon', date(O.booked_at)) AS M , O.seller_id, COUNT(distinct O.order_id) AS Ord,
        CASE WHEN  COUNT(distinct O.order_id) = 1 THEN 1
             WHEN  COUNT(distinct O.order_id) BETWEEN 2 AND 10 THEN 2
             WHEN  COUNT(distinct O.order_id) BETWEEN 11 AND 30 THEN 3
             WHEN  COUNT(distinct O.order_id) BETWEEN 31 AND 60 THEN 4
             WHEN  COUNT(distinct O.order_id) BETWEEN 61 AND 90 THEN 5
             WHEN  COUNT(distinct O.order_id) BETWEEN 91 AND 120 THEN 6
             WHEN  COUNT(distinct O.order_id) BETWEEN 121 AND 150 THEN 7
             WHEN  COUNT(distinct O.order_id) > 150 THEN 8
             ELSE 9
             END AS DIST
FROM analytics.dw_orders AS O
WHERE 
    (date_trunc('mon', date(O.booked_at)) = '2015-10-01' OR date_trunc('mon', date(O.booked_at)) = '2014-10-01'
                                                        OR date_trunc('mon', date(O.booked_at)) = '2013-10-01')                                                       
AND O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
                      'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')                                                                                      
GROUP BY 1,2
)
GROUP BY 1, 2
ORDER BY 1, 2



SELECT date_trunc('mon', date(O.booked_at)) AS M , O.seller_id, COUNT(distinct O.order_id) AS Ord,
        CASE WHEN  COUNT(distinct O.order_id) = 1 THEN 1
             WHEN  COUNT(distinct O.order_id) BETWEEN 2 AND 10 THEN 2
             WHEN  COUNT(distinct O.order_id) BETWEEN 11 AND 30 THEN 3
             WHEN  COUNT(distinct O.order_id) BETWEEN 31 AND 60 THEN 4
             WHEN  COUNT(distinct O.order_id) BETWEEN 61 AND 90 THEN 5
             WHEN  COUNT(distinct O.order_id) BETWEEN 91 AND 120 THEN 6
             WHEN  COUNT(distinct O.order_id) BETWEEN 121 AND 150 THEN 7
             WHEN  COUNT(distinct O.order_id) > 150 THEN 8
             ELSE 9
             END AS DIST
FROM analytics.dw_orders AS O
WHERE 
    date_trunc('mon', date(O.booked_at)) = '2015-10-01'                                                      
AND O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
                      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
                      'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
                      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                      'seller_ab_update_failed', 'waiting_seller_kyc_verification')                                                                                      
GROUP BY 1,2
ORDER BY Ord DESC

LIMIT 50

