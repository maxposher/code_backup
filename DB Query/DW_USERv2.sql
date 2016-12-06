
/*
SELECT O.booked_at, SUM(O.order_gmv),SUM(CASE WHEN O.fraud=1 THEN 1 ELSE 0 END) AS Fraud, SUM(CASE WHEN O.chargeback > 0 THEN 1 ELSE 0 END) AS CB
FROM analytics.dw_orders AS O
WHERE O.fraud = 1
GROUP BY O.booked_at
ORDER BY O.booked_at
*/

/*
SELECT L.created_at, COUNT(L.listing_id)
FROM analytics.dw_orders AS O
INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
WHERE L.listing_price < L.original_price AND L.created_at > '2015-01-01'
GROUP BY L.created_at
ORDER BY L.created_at
*/

/*
SELECT like_or_share_setting, COUNT(*)
FROM analytics.dw_users
GROUP BY like_or_share_setting
*/

/*Default*/
/*
SELECT L.created_date, COUNT(L.listing_id)
FROM analytics.dw_orders AS O
LEFT JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id AND O.seller_id = L.seller_id
WHERE O.buyer_shipping_fee < 499 AND DATEDIFF(Day, L.created_at, O.booked_at_time) <= 1 AND L.created_at >= '2015-01-01'
GROUP BY L.created_date
ORDER BY L.created_date
*/

/*
SELECT TOP 10 *
FROM analytics.shipping_labels 
*/


/*
Select SUM((O.card_payment*0.000229) + 0.17)
FROM analytics.dw_orders AS O
WHERE O.received_at >= '2015-05-01' AND O.received_at < '2015-06-01'
*/


SELECT O.booked_at, O.order_id
FROM analytics.dw_orders AS O
WHERE O.booked_at >= '2014-11-01' AND O.booked_at < '2014-12-01'


SELECT Count (*)
FROM analytics.dw_orders AS O
WHERE O.booked_at >= '2014-12-01' AND O.booked_at < '2015-06-01'

SELECT Count (*)
FROM analytics.dw_orders AS O
WHERE O.buyer_shipping_fee > 499

SELECT O.order_id, O.order_gmv, O.fraud, O.chargeback
FROM analytics.dw_orders AS O
WHERE O.booked_at >= '2014-12-01' AND O.booked_at < '2015-06-01'
AND (O.fraud = 1 OR O.chargeback = 1)

SELECT TOP 10 * O.booked_at, O.order_id
FROM analytics.dw_orders AS O
WHERE O.booked_at >= '2014-12-01' AND O.booked_at < '2015-02-01'


SELECT SUM (O.card_payment)
FROM analytics.dw_orders AS O
WHERE O.booked_at >='2015-03-01' AND O.booked_at <'2015-04-01'
AND O.inventory_unit_state = 'cancelled'


Select SUM(credit_amount)
FROM dw_redeemable_credits AS P
INNER JOIN dw_orders AS O ON P.order_id = O.order_id
WHERE P.issued_date >= '2015-05-01' AND P.issued_date <= '2015-05-31'

Select SUM(credit_amount)
FROM dw_redeemable_credits AS P
INNER JOIN dw_orders AS O ON P.order_id = O.order_id
WHERE O.booked_at >= '2015-05-01' AND O.booked_at <= '2015-05-31'

Select SUM(credit_amount)
FROM dw_redeemable_credits AS P
WHERE P.issued_date >= '2015-05-01' AND P.issued_date <= '2015-05-31'


SELECT *
FROM analytics.dw_redeemable_credits AS C
WHERE C.issued_date >= '06-01-2015' AND C.issued_date < '06-08-15'
ORDER BY C.issued_date



Select O.booked_at, O.order_id, R.credit_amount
FROM analytics.dw_redeemable_credits AS R
INNER JOIN analytics.dw_orders AS O on R.order_id = O.order_id
WHERE O.booked_at >= '2015-06-01' 

/*

Select O.booked_at, sum(O.order_gmv)
FROM analytics.dw_orders AS O
WHERE O.booked_at >= '2015-05-01'
GROUP BY O.booked_at
ORDER BY O.booked_at
*/

/*
Select top 100 *
FROM analytics.dw_Orders AS O
WHERE O.booked_at >= '2015-05-01' AND O.booked_at < '2015-06-01'
*/


/*
SELECT TOP 100 *
FROM analytics.dw_listings
*/

/*
SELECT L.created_at, COUNT(L.listing_id)
FROM analytics.dw_listings AS L
WHERE L.created_at > '2015-03-01' AND L.listing_status = 'published'
GROUP BY L.created_at
ORDER BY L.created_at
*/

/*
SELECT TOP 100 *
FROM analytics.dw_listings AS list
WHERE list.listing_id = '4ddbef00cd2af65611000011'
*/

/*
SELECT *
FROM analytics.dw_listings AS A
WHERE A.seller_id = '4ee28c87b2bb1b6e5c002e6f' AND A.inventory_status = 'not_for_sale'
LIMIT 100
*/

/*
SELECT U.user_id, U.own_shares
FROM analytics.dw_users AS U 

WHERE U.own_shares IS NOT NULL
LIMIT 100
*/

/*
SELECT U.user_id, U.num_visits_per_month, U.join_date
FROM analytics.dw_users AS U
WHERE U.num_visits_per_month > 0
LIMIT 500
*/

/*50342131bdb6007d810008f1*/
/*
SELECT U.user_id, U.invites
FROM analytics.dw_users AS U  
WHERE U.invites > 0
LIMIT 100
*/
