


            SELECT date(A.activity_date), COUNT(distinct A.user_id)
            FROM analytics.dw_user_activity AS A
            INNER  JOIN analytics.dw_users AS U ON A.user_id = U.user_id
            WHERE A.activity_name = 'active_on_app'
            AND date(A.activity_date) = '2015-10-17'
           /* AND U.reg_app != 'web' */
            AND '2015-10-17' - date(U.join_date) >= 10 
         /*   AND '2015-10-17' - date(U.join_date) <= 9 */ 
            AND A.user_id NOT IN                 
                (SELECT A.user_id
                 FROM analytics.dw_user_activity AS A
                 WHERE A.activity_name = 'item_purchased'
                 AND A.activity_count = 1
                 AND A.activity_date <= '2015-10-17'
                 GROUP BY A.user_id)
            GROUP BY date(A.activity_date)   
                  
                  
             select  U.user_id, U.followers
             from analytics.dw_users as U
             WHERE U.followers IS NOT NULL 
             ORDER BY U.followers DESC
             limit 5     
                  
             Select  U.user_id, U.seller_total_number_listings
             from analytics.dw_users as U
             WHERE U.seller_total_number_listings IS NOT NULL 
             ORDER BY U.seller_total_number_listings desc 
             limit 5         
                  
                  
                  
                  
SELECT COUNT(L.seller_id)
FROM analytics.dw_listings AS L
WHERE date(L.created_at) <= '10-22-2015'
AND L.listing_number > 2
AND L.inventory_status = 'available'
AND L.listing_status = 'published'
GROUP BY L.seller_id
                  