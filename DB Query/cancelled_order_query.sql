
    /* How many cancelled sale are first sale */
          select O.seller_id
          FROM analytics.dw_orders AS O
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND O.booked_date >= '2015-01-01'
          AND extract(year from O.cancelled_on) = 2015
          AND extract(month from O.cancelled_on) = 6
          AND O.listing_id IN
               (SELECT  L.listing_id
                FROM analytics.dw_listings AS L
                WHERE L.listing_number = 1
                AND date(created_date) > '2013-01-01' 
                GROUP BY L.listing_id
                )
         GROUP BY O.seller_id
         
         
         
         
         
         
         
      
          SELECT O.seller_id AS ID, SUM(DATE(O.booked_date) - DATE(L.created_at)) AS Tot, COUNT(O.seller_id) AS Diff
          FROM analytics.dw_orders AS O
          INNER JOIN analytics.dw_listings AS L on L.listing_id = O.listing_id
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND extract(year from O.booked_date) = 2015
          AND extract(month from O.booked_date) = 8
          GROUP BY O.seller_id
          HAVING COUNT(O.seller_id) > 1
    
       
          SELECT O.seller_id AS ID, SUM(DATE(O.booked_date) - DATE(L.created_at)) AS Tot, COUNT(O.seller_id) AS Diff
          FROM analytics.dw_orders AS O
          INNER JOIN analytics.dw_listings AS L on L.listing_id = O.listing_id
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND extract(year from O.booked_date) = 2015
          AND extract(month from O.booked_date) = 8
          GROUP BY O.seller_id
          HAVING COUNT(O.seller_id) = 1
       
       
          SELECT O.seller_id AS ID, SUM(DATE(O.booked_date) - DATE(L.created_at)) AS Tot, COUNT(O.seller_id) AS Diff
          FROM analytics.dw_orders AS O
          INNER JOIN analytics.dw_listings AS L on L.listing_id = O.listing_id
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND date(O.booked_date) > '2015-07-31'
          AND date(O.booked_date) < '2015-09-01'
          AND O.seller_id IN
          (
               SELECT O.seller_id 
               FROM analytics.dw_orders AS O
               INNER JOIN analytics.dw_listings AS L on L.listing_id = O.listing_id
               WHERE O.order_state = 'cancelled'
               AND O.cancelled_reason = 'delayed_order'
               AND date(O.booked_date) > '2015-07-31'
               AND date(O.booked_date) < '2015-09-01'
               GROUP BY O.seller_id
               HAVING COUNT(O.seller_id) > 1
          )
          GROUP BY O.seller_id
          
     
          LIMIT 1000
          
    HAVING SUM(DATE(O.booked_date) - DATE(L.created_at)) > 2000
   
   
          
          
         SELECT AVG(dcount) FROM (
         
          SELECT O.seller_id AS ID, AVG(DATE(O.booked_date) - DATE(L.created_at)) AS DCOUNT
          FROM analytics.dw_orders AS O
          INNER JOIN analytics.dw_listings AS L on L.listing_id = O.listing_id
          WHERE O.order_state = 'cancelled'
          AND O.cancelled_reason = 'delayed_order'
          AND O.booked_date >= '2015-01-01'
          AND extract(year from O.cancelled_on) = 2015
          GROUP BY O.seller_id
          )



          
             AND L.listing_number =       
          
          AND O.seller_id IN
               (SELECT  L.seller_id
                FROM analytics.dw_listings AS L
                WHERE L.listing_number = 1
                AND date(created_date) > '2013-01-01' 
                GROUP BY L.seller_id
                )
         GROUP BY O.seller_id
         
         