


                
                SELECT  DATE(A.activity_date), COUNT (distinct A.user_id)
                FROM analytics.dw_user_activity AS A
                WHERE DATE(A.activity_date) >= '2015-01-01' 
                AND A.activity_name = 'listing_created' 
                GROUP BY DATE(A.activity_date)

                ORDER BY DATE(A.activity_date)
                LIMIT 100 
                
                    HAVING MAX(A.activity_count) > 0
               SELECT A_date, count(distinct user_id)
               FROM (             
                SELECT  DATE(A.activity_date) AS A_date, A.user_id, MAX(A.activity_count)
                FROM analytics.dw_user_activity AS A
                WHERE DATE(A.activity_date) >= '2015-01-01' 
                AND A.activity_name = 'listing_created' 
                GROUP BY DATE(A.activity_date), A.user_id
                HAVING MAX(A.activity_count) > 10
                ORDER BY DATE(A.activity_date)
                )
                GROUP BY A_date
                ORDER BY A_date
                
                
                
                
                SELECT A_date, count(distinct user_id)
                FROM (             
                SELECT  DATE(A.activity_date) AS A_date, A.user_id, MAX(A.activity_count)
                FROM      analytics.dw_user_activity AS A
                INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
                WHERE DATE(A.activity_date) >= '2015-01-01'
                AND DATE(A.activity_date) - date(U.join_date) <= 30 
                AND A.activity_name = 'listing_created' 
                GROUP BY DATE(A.activity_date), A.user_id
                HAVING MAX(A.activity_count) > 5
                ORDER BY DATE(A.activity_date)
                )
                GROUP BY A_date
                ORDER BY A_date
/***********************************************************/
        SELECT DATE(L.created_at), COUNT (distinct L.listing_id) 
        FROM analytics.dw_listings AS L
        INNER JOIN analytics.dw_orders AS O ON L.listing_id = O.listing_id
        WHERE                 
        DATE(L.created_at) >= '2015-01-01'   
   /*     AND DATE(O.booked_at) - DATE(L.created_at) > 7  */
        AND DATE(O.booked_at) - DATE(L.created_at) > 30
        GROUP BY DATE(L.created_at)
        ORDER BY DATE(L.created_at)
                
       
       /* Re-construct available listing */
        SELECT DATE(L.created_at), COUNT (distinct L.listing_id) 
        FROM analytics.dw_listings AS L
        INNER JOIN analytics.dw_orders AS O ON L.listing_id = O.listing_id
        WHERE                 
        DATE(L.created_at) >= '2015-01-01'   
        AND DATE(O.booked_at) - DATE(L.created_at) > 7
        AND DATE(O.booked_at) - DATE(L.created_at) <= 30 
        AND( L.inventory_status = 'sold_out' OR (L.inventory_status = 'available' AND L.listing_status = 'published')
                                             OR (L.inventory_status = 'available' AND L.listing_status = 'archived'))
        GROUP BY DATE(L.created_at)
        ORDER BY DATE(L.created_at)         
                
       
       
        /* Re-construct available listing */ 
        SELECT DATE(L.created_at), COUNT (distinct L.listing_id) 
        FROM analytics.dw_listings AS L
        WHERE                 
        DATE(L.created_at) >= '2015-01-01'   
        AND( L.inventory_status = 'sold_out' OR (L.inventory_status = 'available' AND L.listing_status = 'published')
                                             OR (L.inventory_status = 'available' AND L.listing_status = 'archived'))
        GROUP BY DATE(L.created_at)
        ORDER BY DATE(L.created_at)                    
               
          
          
        SELECT DATE(L.created_at), L.listing_id, O.order_id 
        FROM analytics.dw_listings AS L
        INNER JOIN analytics.dw_orders AS O ON L.listing_id = O.listing_id
        WHERE                 
        DATE(L.created_at) = '2015-01-01'   
        AND DATE(O.booked_at) - DATE(L.created_at) > 90
       /* AND DATE(O.booked_at) - DATE(L.created_at) <= 90 */
        AND L.inventory_status != 'sold_out' 
        GROUP BY DATE(L.created_at)
        ORDER BY DATE(L.created_at)     
        


          