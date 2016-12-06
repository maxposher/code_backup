



SELECT COUNT (distinct U.user_id)
FROM analytics.dw_users AS U
INNER JOIN analytics.dw_listings As L ON L.seller_id = U.user_id
WHERE L.listing_status = 'published'
GROUP BY U.user_id
HAVING COUNT(distinct L.listing_id) >= 10


SELECT COUNT (distinct U.user_id)
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND A.activity_name ='active_on_app'
AND DATE(A.activity_date)  >= '2015-09-03'
AND DATE(A.activity_date)  <= '2015-09-16'
AND (date_buyer_activated IS NOT NULL) OR (date_buyer_activated IS NOT NULL)


SELECT COUNT (distinct ID)
FROM(

SELECT U.user_id AS ID, COUNT(distinct L.listing_id)
FROM analytics.dw_users AS U
INNER JOIN analytics.dw_listings As L ON L.seller_id = U.user_id
WHERE L.listing_status = 'published'
AND NOT U.guest_user
GROUP BY U.user_id
HAVING COUNT(distinct L.listing_id) >= 10

)


SELECT COUNT (distinct U.user_id)
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE NOT U.guest_user
AND A.activity_name ='active_on_app'
AND U.user_score >= 75
AND DATE(A.activity_date)  >= '2015-08-26'
AND DATE(A.activity_date)  <= '2015-09-16'

select A."_id"
from raw_mongo.shipping_labels AS A
LIMIT 10


select raw_mongo.shipping_labels.*
FROM raw_mongo.shipping_labels
INNER JOIN raw_mongo.shipping_labels_features ON raw_mongo.shipping_labels_features.shipping_labels_id = raw_mongo.shipping_labels.generated_id 
LIMIT 10


/* Working Code - Payment */
select raw_mongo.shipping_labels_payments_pay_amount.*
FROM raw_mongo.shipping_labels
INNER JOIN raw_mongo.shipping_labels_payments_pay_amount ON raw_mongo.shipping_labels_payments_pay_amount.shipping_labels_id = raw_mongo.shipping_labels.generated_id 
LIMIT 10


/* Working Code - Refund Payment */
select raw_mongo.shipping_labels_refund_payments_pay_amount.*
FROM raw_mongo.shipping_labels
INNER JOIN raw_mongo.shipping_labels_refund_payments_pay_amount ON raw_mongo.shipping_labels_refund_payments_pay_amount.shipping_labels_id = raw_mongo.shipping_labels.generated_id 
LIMIT 10



select * 
FROM analytics.dw_orders AS O
WHERE O.order_state = 'cancelled'
AND O.cancelled_reason = 'delayed_order'
LIMIT 10





select raw_mongo.shipping_labels.*
FROM raw_mongo.shipping_labels
INNER JOIN raw_mongo.shipping_labels_payments ON raw_mongo.shipping_labels_payments.shipping_labels_id = raw_mongo.shipping_labels."_id"
LIMIT 10


select raw_mongo.shipping_labels.*
FROM raw_mongo.shipping_labels
INNER JOIN raw_mongo.shipping_labels_payments ON raw_mongo.shipping_labels_payments.shipping_labels_id = raw_mongo.shipping_labels."_id"
LIMIT 10

