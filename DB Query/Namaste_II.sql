

CASE WHEN A.activity_name ='item_purchased' THEN 1 ELSE 0 END AS Buyer,


Select 
       CASE WHEN L.brand in ('Victoria''s Secret','Coach', 'Forever 21', 'Nike', 'Michael Kors', 'J. Crew', 'Brandy Melville', 'lululemon athletica',
                              'Free People', 'American Eagle Outfitters', 'H&M', 'Juicy Couture', 'Tory Burch', 'kate spade', 'Zara')
       THEN 'A' ELSE 'Z' END AS Brand
       FROM analytics.dw_listings AS L
LIMIT 100





/* #1: 218,436 users */
SELECT U.user_id
FROM analytics.dw_users AS U
WHERE U.comments >= 40
AND U.last_active_date >= '2015-07-30'
AND (U.date_buyer_activated is NOT NULL OR U.date_seller_activated is NOT NULL)

/* #2: 90,573 users */
SELECT U.user_id
FROM analytics.dw_users AS U
WHERE U.shares >= 40	
AND U.last_active_date >= '2015-07-30'
AND (U.date_buyer_activated is NOT NULL OR U.date_seller_activated is NOT NULL)

/* #3: 333,602 users */
SELECT U.user_id
FROM analytics.dw_users AS U
WHERE U.followers >= 20	
AND   U.following >= 20
AND U.last_active_date >= '2015-07-30'
AND (U.date_buyer_activated is NOT NULL OR U.date_seller_activated is NOT NULL)

/* #4: 188,358 users */
SELECT U.user_id
FROM analytics.dw_users AS U
WHERE U.comments >= 25
AND U.likes_by_user >= 25
AND U.last_active_date >= '2015-07-30'
AND (U.date_buyer_activated is NOT NULL OR U.date_seller_activated is NOT NULL)
