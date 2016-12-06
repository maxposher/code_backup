SELECT TO_CHAR(O.booked_at, 'YYYY-MM'), L.brand, sum(DATEDIFF(day,L.created_date, O.booked_at)), count(*)
FROM analytics.dw_orders AS O
INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
WHERE O.booked_at_time >= (timestamp '2014-06-01') 
AND O.order_state = 'seller_confirm_initiated'
AND O.booked_at IS NOT NULL
AND (L.brand = 'Victoria''s Secret' OR L.brand = 'Coach' 
OR   L.brand = 'Forever 21' OR L.brand = 'Michael Kors' 
OR   L.brand = 'J. Crew' OR L.brand = 'Nike' 
OR   L.brand = 'Brandy Melville' OR L.brand = 'lululemon athletica' 
OR   L.brand = 'Free People' OR L.brand = 'Tory Burch' OR L.brand = 'PINK Victoria''s Secret')
GROUP BY 2,1
ORDER BY 2,1 DESC


