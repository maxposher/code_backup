


SELECT O.booked_at, O.buyer_id
FROM   analytics.dw_orders AS O
WHERE  O.booked_at > '2015-02-01'
AND    O.buyer_id = '4e279fbecd2af60592000161'
LIMIT 100



/* Resurrected Buyer */
SELECT O.buyer_id, O.booked_at, lag(O.booked_at,1) over(partition by O.buyer_id order by O.booked_at) AS Last_Order
FROM   analytics.dw_orders AS O
WHERE  O.booked_at > '2015-01-01'
--GROUP BY 1
LIMIT 100