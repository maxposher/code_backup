

                        SELECT L.seller_id
                        FROM analytics.dw_listings As L
                        WHERE L.create_source_type = 'system'
                        AND UA.activity_name = 'comment_on_community_listing'
                        GROUP BY L.seller_id   
                        
                       
                        
                        
SELECT U.join_date, R."at",U.user_id, R."do|tm" 
FROM raw_events.all as R
INNER JOIN analytics.dw_users AS U ON R."a|id" = U.user_id
ORDER BY U.join_date, R."at"
LIMIT 100

SELECT * FROM raw_events.all
LIMIT 5


Select COUNT(distinct O.order_id)
FROM analytics.dw_orders AS O
WHERE date(O.booked_date) <= '2015-10-20' 
AND O.listing_id IN
(
SELECT L.listing_id
FROM analytics.dw_listings AS L
WHERE date(L.created_at) = '09-20-2015'
AND L.listing_number > 5
AND L.listing_status != 'not_for_sale'
AND L.seller_id IN
        (
         SELECT R."a|id"
         FROM raw_events.all as R
         WHERE date(R."at") >='2015-09-20'
         AND   date(R."at")<= '2015-10-20'
         AND (R."v" = 's' OR R."v" = 'es' )
         )
GROUP BY L.listing_id
)





Select COUNT(distinct O.order_id)
FROM analytics.dw_orders AS O
WHERE date(O.booked_date) <= '2015-10-20' 
AND date(O.booked_date) >= '2015-09-20' 
AND O.listing_id IN
(
SELECT L.listing_id
FROM analytics.dw_listings AS L
WHERE date(L.created_at) = '09-21-2015'
AND L.listing_number > 2
AND L.inventory_status != 'not_for_sale'
AND L.seller_id IN
        (
         SELECT R."a|id"
         FROM raw_events.all as R
         INNER JOIN analytics.dw_listings AS L ON L.listing_id = R."do|id"
         WHERE L.seller_id = R."a|id"
         AND   date(R."at") >='2015-09-20'
         AND   date(R."at")<= '2015-10-20'
         AND (R."v" = 's' OR R."v" = 'es' )
         GROUP BY R."a|id"
         )
GROUP BY L.listing_id
)


         SELECT R."do|id"
         FROM raw_events.all as R
         INNER JOIN analytics.dw_listings AS L ON L.listing_id = R."do|id"
         WHERE   
         L.seller_id = R."a|id"
         AND date(R."at") >='2015-09-20'
         AND   date(R."at")<= '2015-10-20'
         AND (R."v" = 's' OR R."v" = 'es' )
         GROUP BY R."a|id", R."do|id"
         LIMIT 100








Select COUNT(distinct O.order_id)
FROM analytics.dw_orders AS O
WHERE date(O.booked_date) <= '2015-10-20' 
AND O.listing_id IN
(
SELECT L.listing_id
FROM analytics.dw_listings AS L
WHERE date(L.created_at) = '09-20-2015'
AND L.listing_number > 2)



SELECT L.seller_id
FROM analytics.dw_listings AS L
WHERE date(L.created_at) = '09-20-2015'
AND L.listing_number > 2
AND L.listing_status != 'not_for_sale'
AND L.seller_id IN
        (
         SELECT R."a|id"
         FROM raw_events.all as R
         WHERE date(R."at") >='2015-09-20'
         AND   date(R."at")<= '2015-10-20'
         AND (R."v" = 's' OR R."v" = 'es' )
         )
GROUP BY L.seller_id




SELECT date(R."at")
FROM raw_events.all as R
WHERE date(R."at") > '2015-09-01'
AND (R."v" = 's' OR R."v" = 'es' )
GROUP BY date(R."at")
ORDER BY date(R."at")


