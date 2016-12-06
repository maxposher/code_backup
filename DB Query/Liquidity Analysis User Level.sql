

              (select count(distinct ID)
                 FROM
                 (SELECT A.user_id AS ID, MAX(A.activity_count) AS C
                  FROM analytics.dw_user_activity AS A
                  WHERE A.activity_name = 'listing_created'
                  AND date(A.activity_date) <= '2015-10-22'
                  GROUP BY A.user_id)
                  WHERE C >= 10
                  AND ID IN 
                        (SELECT A.user_id
                        FROM analytics.dw_user_activity AS A
                        WHERE A.activity_name = 'item_sold'    
                        AND   A.activity_count = 1
                        AND date(A.activity_date) <= '2015-10-22'
                        GROUP BY A.user_id)  
                 )
                 

          (select count(distinct ID)
                 FROM
                 (SELECT A.user_id AS ID, MAX(A.activity_count) AS C
                  FROM analytics.dw_user_activity AS A
                  WHERE A.activity_name = 'listing_created'
                  AND date(A.activity_date) <= '2015-10-22'
                  GROUP BY A.user_id)
                  WHERE C >= 10
                  AND ID IN 
                        (SELECT A.user_id
                        FROM analytics.dw_user_activity AS A
                        WHERE A.activity_name = 'item_purchased'    
                        AND   A.activity_count = 1
                        AND date(A.activity_date) <= '2015-10-22'
                        GROUP BY A.user_id
                       INTERSECT 
                         SELECT A.user_id
                        FROM analytics.dw_user_activity AS A
                        WHERE A.activity_name = 'item_sold'    
                        AND   A.activity_count = 1
                        AND date(A.activity_date) <= '2015-10-22'
                        GROUP BY A.user_id)
                 )










              SELECT COUNT(distinct U.user_id)
                FROM analytics.dw_users AS U
                INNER JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
                WHERE U.date_lister_activated IS NOT NULL
                AND A.activity_name = 'item_sold' 
                AND '2015-10-12' - DATE(A.activity_date) <= 31
                AND U.lister_total_number_listings >= 6  
                AND U.date_lister_activated <= '2015-10-12'
                
                
                   SELECT COUNT(distinct U.user_id)
                FROM analytics.dw_users AS U
                WHERE U.date_lister_activated IS NOT NULL 
                AND U.date_seller_activated IS NOT NULL 
                AND U.lister_total_number_listings = 4
                AND U.date_lister_activated <= '2015-10-12'
                
                
                
                SELECT COUNT(distinct U.user_id)
                FROM analytics.dw_users AS U
                INNER JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
                WHERE U.date_lister_activated IS NOT NULL
                AND A.activity_name = 'active_on_app' 
                AND '2015-10-12' - DATE(A.activity_date) <= 31
                AND U.lister_total_number_listings >= 6  
                AND U.date_lister_activated <= '2015-10-12'
                
                
                
                
                     SELECT DATE(L.created_at), COUNT (distinct L.listing_id) 
        FROM analytics.dw_listings AS L
        INNER JOIN analytics.dw_orders AS O ON L.listing_id = O.listing_id
        WHERE                 
        DATE(L.created_at) >= '2015-01-01'   
   /*     AND DATE(O.booked_at) - DATE(L.created_at) > 7  */
        AND DATE(O.booked_at) - DATE(L.created_at) > 30
        GROUP BY DATE(L.created_at)
        ORDER BY DATE(L.created_at)
        
        
        SELECT DATE(O.booked_at), COUNT (distinct O.order_id) 
        FROM analytics.dw_listings AS L
        INNER JOIN analytics.dw_orders AS O ON L.listing_id = O.listing_id
        WHERE                 
        DATE(O.booked_at) >= '2015-01-01'   
        AND DATE(O.booked_at) - DATE(L.created_at) >= 0 
        AND DATE(O.booked_at) - DATE(L.created_at) <= 30 
        GROUP BY DATE(O.booked_at)
        ORDER BY DATE(O.booked_at)
        
       
        SELECT DATE(O.booked_at), COUNT (distinct O.order_id) 
        FROM analytics.dw_listings AS L
        INNER JOIN analytics.dw_orders AS O ON L.listing_id = O.listing_id
        WHERE                 
        DATE(O.booked_at) >= '2015-01-01'   
        GROUP BY DATE(O.booked_at)
        ORDER BY DATE(O.booked_at)
        
        
        
                SELECT COUNT(distinct U.user_id)
                FROM analytics.dw_users AS U
                WHERE U.date_lister_activated IS NOT NULL  
                AND U.lister_total_number_listings >= 1
                AND U.date_lister_activated <= '2015-10-15'
                
                
                
                 SELECT COUNT(distinct U.user_id)
                FROM analytics.dw_users AS U
                INNER JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
                WHERE U.date_lister_activated IS NOT NULL 
                AND A.activity_name = 'active_on_app' 
                AND '2015-10-12' - DATE(A.activity_date) <= 31
                AND U.date_lister_activated <= '2015-10-12'
                AND U.user_id IN
                
                (select COUNT(ID)
                 FROM
                 (SELECT A.user_id AS ID, MAX(A.activity_count) AS C
                  FROM analytics.dw_user_activity AS A
                  WHERE A.activity_name = 'item_sold'
                  AND   DATE(A.activity_date) <= '2015-10-12'
                  GROUP BY A.user_id)
                  WHERE C >= 1
                 )
                
                
                 (select count(distinct ID)
                 FROM
                 (SELECT A.user_id AS ID, MAX(A.activity_count) AS C
                  FROM analytics.dw_user_activity AS A
                  WHERE A.activity_name = 'listing_created'
                  AND   DATE(A.activity_date) <= '2015-10-12'
                  GROUP BY A.user_id)
                  WHERE C >= 3
                  AND ID IN 
                        (SELECT A.user_id
                        FROM analytics.dw_user_activity AS A
                        WHERE A.activity_name = 'active_on_app'    
                        AND   DATE(A.activity_date) <= '2015-10-12'
                        AND   DATE(A.activity_date) >= '2015-09-12'
                        GROUP BY A.user_id)
                 )
                 
                 
                 
          
                  SELECT A.user_id AS ID, MAX(A.activity_count) AS C, U.lister_total_number_listings
                  FROM analytics.dw_user_activity AS A
                  INNER JOIN analytics.dw_users AS U ON A.user_id = U.user_id
                  WHERE A.activity_name = 'listing_created'
                  AND   DATE(A.activity_date) <= '2015-10-12'
                  GROUP BY A.user_id, U.lister_total_number_listings
                  HAVING MAX(A.activity_count) > U.lister_total_number_listings
                  LIMIT 10
                 
                 
                 
                SELECT date(O.booked_date), date(O.booked_date) - date(L.created_at)
                FROM analytics.dw_listings as L
                INNER JOIN analytics.dw_orders AS O ON L.listing_id = O.listing_id
                WHERE  date(O.booked_date) BETWEEN '2015-10-12' AND '2015-10-14'
             
                
                
                
                
                
                 (select count(distinct ID)
                 FROM
                 (SELECT A.user_id AS ID, MAX(A.activity_count) AS C
                  FROM analytics.dw_user_activity AS A
                  WHERE A.activity_name = 'listing_created'
                  AND   DATE(A.activity_date) <= '2015-10-12'
                  GROUP BY A.user_id)
                  WHERE C >= 1
                  AND ID IN 
                        (SELECT A.user_id
                        FROM analytics.dw_user_activity AS A
                        WHERE A.activity_name = 'item_purchased'  
                        AND   
                        GROUP BY A.user_id)
                 )
                 
     
         