

SELECT TO_CHAR(dw_users.joined_at, 'YYYY-MM') AS "dw_users.joined_month",
	COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
WHERE (NOT COALESCE(dw_users.guest_user, FALSE)) AND ((dw_users.joined_at >= (TIMESTAMP '2013-10-01')))
AND   (is_referred_with_code is null or is_referred_with_code = 'false')
GROUP BY 1
ORDER BY 1 






SELECT TO_CHAR(dw_users.joined_at, 'YYYY-MM') AS "dw_users.joined_month",
	COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
WHERE (NOT COALESCE(dw_users.guest_user, FALSE)) AND ((dw_users.joined_at >= (TIMESTAMP '2013-10-01')))
AND   (is_referred_with_code is null or is_referred_with_code = 'false')
GROUP BY 1
ORDER BY 1 
LIMIT 500


SELECT TO_CHAR(dw_users.joined_at, 'YYYY-MM') AS "dw_users.joined_month",
	COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
WHERE (NOT COALESCE(dw_users.guest_user, FALSE)) AND ((dw_users.joined_at >= (TIMESTAMP '2015-04-01')))
AND   datediff(month, dw_users.joined_at, dw_users.buyer_activated_at) <= 5
AND   datediff(month, dw_users.joined_at, lister_activated_at) <= 5
GROUP BY 1
ORDER BY 1 
LIMIT 500





/*Double check window function logic */
SELECT TO_CHAR(dw_users.joined_at, 'YYYY-MM') AS "dw_users.joined_month",
	COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
INNER JOIN ( SELECT seller_id, booked_at
             FROM (SELECT booked_at, seller_id, rank() over (partition by seller_id order by booked_at ASC) as first_order
                   FROM   analytics.dw_orders)
             WHERE first_order = 1) AS B on dw_users.user_id = B.seller_id
WHERE (NOT COALESCE(dw_users.guest_user, FALSE)) AND ((dw_users.joined_at >= (TIMESTAMP '2015-06-01')))
AND   datediff(month, dw_users.joined_at, B.booked_at) <= 2
AND   datediff(month, dw_users.joined_at, dw_users.buyer_activated_at) + 1 <= 3
GROUP BY 1
ORDER BY 1 
LIMIT 500



     SELECT seller_id, booked_at
     FROM (   
        SELECT booked_at, seller_id, rank() over (partition by buyer_id order by booked_at ASC) as 1st_order
        FROM   analytics.dw_orders
        WHERE  )
     WHERE 1st_order = 1
     

SELECT seller_activated_at
FROM analytics.dw_users
limit 10



/* Non Referred Users */
SELECT TO_CHAR(dw_users.joined_at, 'YYYY-MM') AS "dw_users.joined_month",
	COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
INNER JOIN ( SELECT seller_id, booked_at
             FROM (SELECT booked_at, seller_id, rank() over (partition by buyer_id order by booked_at ASC) as first_order
                   FROM   analytics.dw_orders)
             WHERE first_order = 1) AS B on dw_users.user_id = B.seller_id
WHERE (NOT COALESCE(dw_users.guest_user, FALSE)) AND ((dw_users.joined_at >= (TIMESTAMP '2013-10-01')))
AND   datediff(month, dw_users.joined_at, B.booked_at) + 1 <= 6
AND   datediff(month, dw_users.joined_at, dw_users.buyer_activated_at) + 1 <= 6
AND   (is_referred_with_code is null or is_referred_with_code = 'false')
GROUP BY 1
ORDER BY 1 
LIMIT 500



SELECT TO_CHAR(dw_users.joined_at, 'YYYY-MM') AS "dw_users.joined_month",
	COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
WHERE (NOT COALESCE(dw_users.guest_user, FALSE)) AND ((dw_users.joined_at >= (TIMESTAMP '2013-10-01')))
AND   datediff(month, dw_users.joined_at, lister_activated_at) + 1 <= 6
AND   datediff(month, dw_users.joined_at, dw_users.buyer_activated_at) + 1 <= 6
AND   (is_referred_with_code is null or is_referred_with_code = 'false')
GROUP BY 1
ORDER BY 1 
LIMIT 500



SELECT TO_CHAR(dw_users.joined_at, 'YYYY-MM') AS "dw_users.joined_month",
	COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
FROM analytics.dw_users AS dw_users
WHERE (NOT COALESCE(dw_users.guest_user, FALSE)) AND ((dw_users.joined_at >= (TIMESTAMP '2013-10-01')))
AND   datediff(month, dw_users.joined_at, dw_users.buyer_activated_at) + 1 <= 3
AND   (is_referred_with_code is null or is_referred_with_code = 'false')
GROUP BY 1
ORDER BY 1 
LIMIT 500