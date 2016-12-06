
SELECT booked_at, count(distinct buyer_id) FROM
(
(SELECT distinct dw_orders.buyer_id, dw_orders.booked_at AS booked_at
FROM analytics.dw_orders AS dw_orders
WHERE dw_orders.booked_at >= '2015-01-01' 
AND dw_orders.order_number = 1 
AND (dw_orders.buyer_shipping_fee*.01) < 4.99 
GROUP BY 2,1
ORDER BY 2)

INTERSECT

(SELECT distinct dw_user_activity.user_id, dw_user_activity.activity_date AS booked_at
FROM analytics.dw_user_activity AS dw_user_activity
WHERE dw_user_activity.activity_name = 'item_purchased' 
AND dw_user_activity.activity_count = 1
AND dw_user_activity.activity_date >= '2015-01-01'
GROUP BY dw_user_activity.activity_date, dw_user_activity.user_id)
)
WHERE 
GROUP BY booked_at

/*******************/
/*  (max(activity_count) - min(activity_count)) */
SELECT booked_at, sum(CC), count(CC) FROM (
SELECT booked_at, buyer_id, (max(activity_count) - min(activity_count)) AS CC
FROM
(SELECT distinct dw_orders.buyer_id, dw_orders.booked_at 
FROM analytics.dw_orders AS dw_orders
WHERE dw_orders.booked_at >= '2015-01-01' 
AND dw_orders.order_number = 1 
AND (dw_orders.buyer_shipping_fee*.01) >= 4.99 
GROUP BY 2,1
ORDER BY 2)
INNER JOIN dw_user_activity AS UA ON UA.user_id = buyer_id 
WHERE  (DATE(activity_date) - DATE(booked_at) + 1 <= 30)
AND (DATE(activity_date) - DATE(booked_at) + 1 >= 0)
AND activity_name = 'active_on_app'
GROUP BY booked_at, buyer_id
ORDER BY booked_at
)
GROUP BY booked_at
ORDER BY booked_at






(SELECT distinct dw_user_activity.user_id, dw_user_activity.activity_date 
FROM analytics.dw_user_activity AS dw_user_activity
WHERE dw_user_activity.activity_name = 'active_on_app' 
AND dw_user_activity.activity_count = 1
AND dw_user_activity.activity_date >= '2015-06-01'
GROUP BY dw_user_activity.activity_date, dw_user_activity.user_id)
)




select R.status, COUNT(R.*)
from raw_mongo.listings_inventory AS R
GROUP BY R.status

Select TOP 100 *
From raw_mongo.listings_inventory 


