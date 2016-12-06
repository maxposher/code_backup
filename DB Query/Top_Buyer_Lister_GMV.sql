

SELECT  date_trunc('mon', date(O.booked_at)) AS DD,
sum(O.order_gmv), percentile_cont(0.1) 
within group (order by date_trunc('mon', date(O.booked_at))) over(partition by O.seller_id) 
FROM analytics.dw_orders AS O
WHERE date(O.booked_at) > '2015-01-01' 
GROUP BY DD, O.seller_id
LIMIT 50

SELECT  date_trunc('mon', date(O.booked_at)) AS DD,
sum(O.order_gmv), percentile_cont(0.1) 
within group (order by sum(O.order_gmv)) over()
FROM analytics.dw_orders AS O
WHERE date(O.booked_at) > '2015-01-01' 
GROUP BY DD, O.seller_id
LIMIT 50


/* The works */
SELECT  date_trunc('mon', date(O.booked_at)) AS DD,
sum(O.order_gmv*0.01), percentile_cont(0.01) 
within group (order by sum(O.order_gmv) desc) 
over(partition by date_trunc('mon', date(O.booked_at))                    ) 
FROM analytics.dw_orders AS O
WHERE date(O.booked_at) >= '2015-01-01' 
GROUP BY DD, O.buyer_id
LIMIT 500





SELECT O.buyer_id AS ID, sum(O.order_gmv), percentile_cont(0.01) 
within group (order by sum(O.order_gmv) desc) over()
FROM analytics.dw_orders AS O
WHERE date(O.booked_at)  >= '2015-07-01' 
AND   date(O.booked_at) <= '2015-09-30' 
GROUP BY O.buyer_id
LIMIT 10




SELECT O.buyer_id AS ID, count(O.order_id), percentile_cont(0.01) 
within group (order by sum(O.order_id) desc) over()
FROM analytics.dw_orders AS O
WHERE date(O.booked_at)  >= '2015-07-01' 
AND   date(O.booked_at) <= '2015-09-30' 
GROUP BY O.buyer_id
LIMIT 10




SELECT SUM(O2.order_gmv)/100
FROM  analytics.dw_orders AS O2
WHERE date(O2.booked_at) >= '2015-07-01' 
AND   date(O2.booked_at) <= '2015-09-30' 
AND  O2.buyer_id IN
    (SELECT O.buyer_id
     FROM analytics.dw_orders AS O
     WHERE date(O.booked_at) >= '2015-07-01' 
     AND   date(O.booked_at) <= '2015-09-30' 
     GROUP BY O.buyer_id
     HAVING sum(O.order_gmv) >= 122682.75
     ORDER BY SUM(O.order_gmv) DESC)




SELECT SUM(O2.order_gmv)
FROM  analytics.dw_orders AS O2
WHERE date(O2.booked_at) >= '2015-07-01'
AND   date(O2.booked_at) <= '2015-09-30'
AND  O2.seller_id IN
    (SELECT distinct O.seller_id
     FROM analytics.dw_orders AS O
     WHERE date(O.booked_at) <= '2015-06-30' 
     GROUP BY O.seller_id
     HAVING sum(O.order_gmv) >= 482100
     )





SELECT date_trunc('mon', date(O2.booked_at)) AS DD, sum (O2.order_gmv)
FROM  analytics.dw_orders AS O2
WHERE date(O2.booked_at) >= '2015-07-01'
AND  O2.buyer_id IN
    (SELECT distinct O.buyer_id
     FROM analytics.dw_orders AS O
     WHERE date(O.booked_at) <= '2015-07-01' 
     GROUP BY O.buyer_id
     HAVING sum(O.order_gmv) >= 336600
     ORDER BY SUM(O.order_gmv) DESC)
GROUP BY DD
ORDER BY DD


SELECT SUM(CC)
FROM(

     SELECT COUNT (distinct O.seller_id) AS CC
     FROM analytics.dw_orders AS O
     WHERE date(O.booked_at)  < '2015-07-01' 
     GROUP BY O.seller_id
     HAVING sum(O.order_gmv) >= 94000
     ORDER BY SUM(O.order_gmv) DESC
)

     SELECT COUNT (distinct O.seller_id)
     FROM analytics.dw_orders AS O
     WHERE date(O.booked_at) < '2015-07-01' 
     GROUP BY O.seller_id
     HAVING sum(O.order_gmv) >= 94000
     
     
     SELECT COUNT (distinct O.buyer_id)
     FROM analytics.dw_orders AS O
     WHERE date(O.booked_at) < '2015-07-01' 
     GROUP BY O.buyer_id
     HAVING sum(O.order_gmv) >= 60300



SELECT SUM(GMV)/100
FROM(
select SUM(order_gmv) AS GMV 
FROM analytics.dw_orders
WHERE date(booked_at) >= '2015-07-01' 
AND   date(booked_at) <= '2015-09-30' 
GROUP BY seller_id
HAVING SUM (order_gmv) >= 482100
)


SELECT O.buyer_id AS ID, sum(O.order_gmv), percentile_cont(0.01) 
within group (order by sum(O.order_gmv) desc) over()
FROM analytics.dw_orders AS O
WHERE date(O.booked_at) >= '2015-09-01' 
AND   date(O.booked_at) <= '2015-09-30' 
GROUP BY O.buyer_id
LIMIT 30



SELECT SUM(GMV)/100
FROM(
select SUM(order_gmv) AS GMV 
FROM analytics.dw_orders
WHERE date(booked_at) >= '2015-08-01' 
AND   date(booked_at) <= '2015-08-31' 
GROUP BY seller_id
HAVING SUM (order_gmv) >= 32000
)




select SUM(order_gmv) AS GMV 
FROM analytics.dw_orders
WHERE date(booked_at) >= '2015-08-01' 
GROUP BY date_trunc('mon', date(booked_at))


/* User who buyr or lister activiated in the first month */
SELECT date_trunc('mon', date(A.activity_date)), COUNT(distinct A.user_id)
FROM analytics.dw_user_activity AS A
INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
WHERE A.activity_count = 1
AND   date_trunc('mon', date(U.join_date)) = date_trunc('mon', date(A.activity_date))
AND   (A.activity_name = 'item_purchased' OR A.activity_name = 'listing_created')
AND   date( A.activity_date) >= '2015-09-01'
GROUP BY  date_trunc('mon', date(A.activity_date))
ORDER BY  date_trunc('mon', date(A.activity_date))




SELECT SUM (O2.order_gmv)
FROM  analytics.dw_orders AS O2
WHERE date(O2.booked_at) >= '2015-07-01'
AND   date(O2.booked_at) <= '2015-09-30'
AND  O2.seller_id IN
         
    (SELECT distinct O.seller_id
     FROM analytics.dw_orders AS O
     WHERE date(O.booked_at) <= '2015-07-01' 
     GROUP BY O.seller_id
     HAVING sum(O.order_gmv) >= 482100
     )
AND O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 
'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')     
     
     

COUNT (distinct O2.order_id)

SELECT COUNT (distinct O2.order_id)
FROM  analytics.dw_orders AS O2
WHERE date(O2.booked_at) >= '2015-07-01'
AND   date(O2.booked_at) <= '2015-09-30'
AND  O2.buyer_id IN
         
    (SELECT distinct O.buyer_id
     FROM analytics.dw_orders AS O
     WHERE date(O.booked_at) <= '2015-07-01' 
     GROUP BY O.buyer_id
     HAVING sum(O.order_gmv) >= 60300
     )
AND O2.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 
'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 


SELECT COUNT (distinct O2.order_id)
FROM  analytics.dw_orders AS O2
WHERE date(O2.booked_at) >= '2015-07-01'
AND   date(O2.booked_at) <= '2015-09-30'


