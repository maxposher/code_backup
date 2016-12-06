/*
SELECT *
FROM analytics.dw_listings AS A
WHERE A.seller_id = '4e266a58cd2af64ddc000013'
ORDER BY A.created_at
*/

/*
SELECT L.created_at, L.listing_id, O.buyer_shipping_fee ,L.created_at_time, O.booked_at_time, DATEDIFF(Day, L.created_at_time, O.booked_at_time)
FROM analytics.dw_orders AS O
LEFT JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id AND O.seller_id = L.seller_id
WHERE O.buyer_shipping_fee < 499 AND DATEDIFF(Day, L.created_at_time, O.booked_at_time) <= 1 AND L.created_at > '2015-03-01'
*/

/* Default for counting < 24 hours */

/*
SELECT L.created_at, COUNT(L.listing_id)
FROM analytics.dw_orders AS O
INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
WHERE O.buyer_shipping_fee < 499 AND DATEDIFF(Hour, L.created_at_time, O.booked_at_time) <= 5 AND L.created_at > '2014-12-31'
GROUP BY L.created_at
ORDER BY L.created_at
*/

/*
SELECT *
FROM analytics.dw_orders AS O
WHERE O.Booked_at > '2015-04-30' AND (O.chargeback = 1 OR O.fraud = 1)
*/


SELECT *
FROM analytics.dw_orders AS O
WHERE (O.Booked_at > '2014-11-30' AND O.Booked_at <'2015-05-31') AND (O.fraud = TRUE OR O.chargeback = TRUE)






/*
SELECT O.booked_at, count(*)
FROM analytics.dw_orders AS O
WHERE O.booked_at = '2015-05-11'
GROUP BY O.booked_at
AND O.buyer_shipping_fee >=0
GROUP BY O.booked_at
*/


/*
SELECT *
FROM analytics.dw_orders AS O
WHERE O.Booked_at = '2015-01-01' AND O.Chargeback = 1 AND O.fraud <> 1
*/

/*
SELECT *
FROM analytics.dw_orders AS O
WHERE O.Booked_at = '2015-01-01' AND O.Chargeback = 1 AND O.fraud <> 1
*/

/*
SELECT L.created_at, COUNT(*)
FROM  analytics.dw_listings AS L
WHERE L.created_at >= '2015-01-01'
GROUP BY L.created_at
ORDER BY L.created_at
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


SELECT O.booked_at, COUNT(*)
FROM analytics.dw_orders AS O
INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id 
WHERE O.buyer_shipping_fee < 499 AND DATEDIFF(Day, L.created_at, O.booked_at) <= 1 AND O.booked_at > '2014-12-31'
GROUP BY O.booked_at
ORDER BY O.booked_at


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
