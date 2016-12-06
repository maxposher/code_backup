


   With A AS  
        (SELECT U.user_id, sum(O.order_gmv/100) AS GMV,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1           AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00', U.date_buyer_activated)/28)+1) + 1     AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
        AND user_id = '4e60f90c9a0881326800000f'  
        GROUP BY 1,3,4),
        
        B AS (SELECT A.*, 
              lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order, 
              lag(gmv,1) over(partition by user_id order by L28_number) AS Last_Order_GMV
              FROM A
              ORDER BY l28_number),
              
        C AS (SELECT B.*, (gmv - last_order_gmv) AS gmv_delta
              FROM   B)
            /*  WHERE  l28_number - last_order >= 2)*/
          
         /* SELECT * FROM C  */
            
          SELECT sum(gmv_delta)
          FROM C
          WHERE l28_number - last_order = 1
          AND   gmv_delta < 0
          
          
          
          
          LIMIT 100   
        
       SELECT C.*
       FROM C
       WHERE l28_number > 1
       AND user_id = '4ddab29fcd2af63242000001'
       ORDER BY user_id, l28_number
       LIMIT 100