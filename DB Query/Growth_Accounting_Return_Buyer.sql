

        
        
        
        /* Setting up L28 for later query */
        SELECT U.user_id, O.booked_at, O.order_number,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',         U.date_buyer_activated)/28)), '2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', U.date_buyer_activated)/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00') AS BA_Cohort_L28,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1                          AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00', U.date_buyer_activated)/28)+1) + 1                    AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE date(booked_at) BETWEEN '2012-01-01' AND '2016-01-31'
        AND   O.order_number > 1
        AND   U.date_buyer_activated BETWEEN '2012-01-01' AND '2016-01-31'
        AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')         
        
    
        
        
        
        
    
    
    
    
  /* Default Code */
      SELECT Booked_L28, COUNT(distinct user_id) AS Return_Buyer
      FROM    
     (
      SELECT user_id, Booked_L28, L28_number, lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order
      FROM                   
       (         
        SELECT U.user_id, O.booked_at, O.order_number,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',         date(U.buyer_activated_at) )/28)), '2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', date(U.buyer_activated_at) )/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00') AS BA_Cohort_L28,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1, '00')           AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00',  date(U.buyer_activated_at)  )/28)+1) + 1                    AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE 
        order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
        )
                )
       WHERE L28_number - last_order = 1
       GROUP BY 1 
       ORDER BY 1

       
       
       
       
       
       
       
       
       SELECT date_buyer_activated
       FROM analytics.dw_users
       LIMIT 10
       
       SELECT booked_at
       FROM analytics.dw_orders
       ORDER BY booked_at
       DESC
       LIMIT 10
       
       
      SELECT user_id, Booked_L28, L28_number, booked_at,lead(l28_number,1) over(partition by user_id order by L28_number) AS Next_Order
      FROM(     
        SELECT U.user_id, O.booked_at, O.order_number,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',         U.date_buyer_activated)/28)), '2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', U.date_buyer_activated)/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00') AS BA_Cohort_L28,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1                          AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00', U.date_buyer_activated)/28)+1) + 1                    AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE date(booked_at) BETWEEN '2012-01-01' AND '2016-01-31'
        AND   O.order_number > 1
        AND   U.date_buyer_activated BETWEEN '2012-01-01' AND '2016-01-31'
        AND   U.user_id = '4f1ce9ab3d641313c0001fc9'
        AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')     
        ORDER BY 2
       )
      LIMIT 500 
       
       
       
       
       
       SELECT COUNT(distinct buyer_id), sum(Days_Between)
       FROM
       (
         SELECT TOP 1 buyer_id, order_number,  date(booked_at) - date(lag(booked_at,1) over(partition by buyer_id order by booked_at)) AS Days_Between
         FROM analytics.dw_orders 
         WHERE date(booked_at) BETWEEN '2012-01-01' AND '2016-12-31'  
         AND   order_number > 1
         AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
                'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                'seller_ab_update_failed', 'waiting_seller_kyc_verification')   
         ORDER BY ORDER_NUMBER DESC
       )
   
       WITH A AS (    
         SELECT  buyer_id, order_number, booked_at,  lag(booked_at,1) over(partition by buyer_id order by booked_at)
         FROM    analytics.dw_orders AS O
         WHERE date(booked_at) BETWEEN '2012-01-01' AND '2016-12-31'  
         AND  order_number > 1
         AND  order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
                'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                'seller_ab_update_failed', 'waiting_seller_kyc_verification')   
         )      
         
         SELECT A.buyer_id, count(distinct A.buyer_id)
         
         SELECT A.
         FROM A 
         INNER JOIN 
         (select buyer_id, max(order_number) AS mn from analytics.dw_orders group by 1) AS I 
         on A.buyer_id = I.buyer_id AND A.order_number = I.mn
         LIMIT 10
   

       
       
       
        /* Order Distribution */  
         WITH A AS (    
         SELECT  buyer_id, order_number, date(booked_at) - date(lag(booked_at,1) over(partition by buyer_id order by booked_at)) AS Days_Between
         FROM    analytics.dw_orders AS O
         WHERE date(booked_at) BETWEEN '2012-01-01' AND '2016-12-31'  
         AND  order_number <= 2
         AND  order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
                'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                'seller_ab_update_failed', 'waiting_seller_kyc_verification')   
         )      
         
         SELECT order_number, count(distinct buyer_id), sum(Days_Between)
         FROM(
                SELECT A.*
                FROM A INNER JOIN 
                      (SELECT buyer_id, max(order_number) AS mn 
                       FROM   analytics.dw_orders 
                       GROUP BY 1) AS I 
                       ON A.buyer_id = I.buyer_id AND A.order_number = I.mn
              )
         GROUP BY 1     
         LIMIT 10
       
         
         
         
         /* Probability of return purchase */
         WITH A AS (    
         SELECT  buyer_id, order_number, date(booked_at) - date(lag(booked_at,1) over(partition by buyer_id order by booked_at)) AS Days_Between
         FROM    analytics.dw_orders AS O
         WHERE date(booked_at) BETWEEN '2012-01-01' AND '2016-12-31'  
         AND  order_number <= 2
         AND  order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
                'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
                'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
                'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
                'seller_ab_update_failed', 'waiting_seller_kyc_verification')   
         )      
         
         SELECT percentile_cont(0.9) within group (order by Days_Between)  over() 
         FROM(
                SELECT A.*
                FROM A INNER JOIN 
                      (SELECT buyer_id, max(order_number) AS mn 
                       FROM   analytics.dw_orders 
                       GROUP BY 1) AS I 
                       ON A.buyer_id = I.buyer_id AND A.order_number = I.mn
              )
  
         LIMIT 5
         
         
    