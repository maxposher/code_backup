
/* Return Buyers */
 SELECT Booked_L28, COUNT(distinct user_id) AS Return_Buyer
      FROM    
     (
      SELECT user_id, Booked_L28, L28_number, lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order
      FROM                   
       (         
        SELECT U.user_id, O.booked_at, O.order_number,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',         U.buyer_activated_at)/28)), '2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', U.buyer_activated_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00') AS BA_Cohort_L28,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1, '00')         AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00', U.buyer_activated_at)/28)+1) + 1                    AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE date(booked_at) >= '2011-01-01' 
        AND   date(U.buyer_activated_at) >= '2011-01-01' 
        AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
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
       
 /***********************Return Buyer GMV*************************************/
 SELECT Booked_L28, SUM(GMV) AS Total_GMV
      FROM    
     (
      SELECT user_id, order_gmv*0.01 AS GMV, Booked_L28, L28_number, lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order
      FROM                   
       (         
        SELECT U.user_id, O.booked_at, O.order_number, O.order_gmv,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',         U.buyer_activated_at)/28)), '2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', U.buyer_activated_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00') AS BA_Cohort_L28,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1, '00')         AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00', U.buyer_activated_at)/28)+1) + 1                    AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE date(booked_at) >= '2011-01-01' 
        AND   date(U.buyer_activated_at) >= '2011-01-01' 
        AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
        )
                )
       WHERE L28_number - last_order > 1
       GROUP BY 1 
       ORDER BY 1
 
 
       
       
/************************Expansion Contraction*******************************/
   With A AS(    
      SELECT user_id, GMV, Booked_L28, L28_number, 
               lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order, 
               lag(GMV,1) over(partition by user_id order by L28_number) AS Last_Order_GMV
      FROM                   
       (         
        SELECT U.user_id, O.booked_at, O.order_number, O.order_gmv/100 AS GMV,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',          U.buyer_activated_at )/28)), '2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',  U.buyer_activated_at )/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00') AS BA_Cohort_L28,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1                               AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00', date(U.buyer_activated_at) )/28)+1) + 1                    AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE date(booked_at) >= '2012-01-01' 
        AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
        ))
        
     , B AS (
     SELECT A.booked_l28, A.user_id, sum(gmv) -  sum(last_order_gmv) AS GMV_Diff 
     FROM   A
     WHERE   L28_number - last_order = 1
     GROUP BY 1,2
     ORDER BY 1)
     
     SELECT booked_l28, sum(GMV_Diff)
     FROM  B
     WHERE gmv_diff < 0
     GROUP BY 1
     ORDER BY 1

     
  /*****************************************************************************/
   With A AS(    
      SELECT user_id, GMV, Booked_L28, L28_number, 
               lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order, 
               lag(GMV,1) over(partition by user_id order by L28_number) AS Last_Order_GMV
      FROM                   
       (         
        SELECT U.user_id, O.booked_at, O.order_number, O.order_gmv/100 AS GMV,
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
        ))
        
 
  /**********************************************************/
  /** The works contraction and expansion
          /* Set up stage layer for L28 */
        With A AS  
        (SELECT U.user_id, sum(O.order_gmv*0.01) AS GMV,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00')  AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00', U.buyer_activated_at)/28)+1) + 1          AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE date(O.booked_at) >= '2013-03-01' 
        AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
        GROUP BY 1,3,4),
        
        B AS (SELECT A.*, 
              lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order, 
              lag(gmv,1) over(partition by user_id order by L28_number) AS Last_Order_GMV
              FROM A
              ORDER BY l28_number),
              
        C AS (SELECT B.*, (gmv - last_order_gmv) AS gmv_delta
              FROM   B
              WHERE  l28_number - last_order = 1)
        
        /* Data Org Layer */      
        SELECT booked_l28, sum(gmv_delta)
        FROM C
        WHERE gmv_delta < 0
        GROUP BY 1
        ORDER BY 1
        
        
        
         /* The works MMR */
        
        SELECT 
	EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', dw_orders.booked_at)/28)),'2012-01-01 00:00:00'))||'_'|| 
	to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', dw_orders.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00')  AS Booked_L28,
	SUM(dw_orders.order_gmv * 0.01) AS New_Buyer_GMV
        FROM analytics.dw_orders AS dw_orders 
        INNER JOIN analytics.dw_users AS U ON dw_orders.buyer_id = U.user_id
        WHERE
        
            ((EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', dw_orders.booked_at)/28)),'2012-01-01 00:00:00'))||'_'|| 
            ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',dw_orders.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1))
        =      
            ((EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', U.buyer_activated_at)/28)),'2012-01-01 00:00:00'))||'_'|| 
            ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',U.buyer_activated_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1))
        
        and dw_orders.booked_at IS NOT NULL 
        and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
        'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
        GROUP BY 1
        ORDER BY 1
        
        
        /**************************************Resurrected Buyers GMV**********************************/
        
        SELECT 
	EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', dw_orders.booked_at)/28)),'2012-01-01 00:00:00'))||'_'|| 
	((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',dw_orders.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1 AS "dw_orders.booked_l28",
	COUNT(distinct dw_orders.buyer_id) AS "Buyers"
        FROM analytics.dw_orders AS dw_orders
        WHERE dw_orders.booked_at IS NOT NULL 
        and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
        'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
        
        AND buyer_id NOT IN
       /* Not from previous month */
       (SELECT buyer_id
        FROM analytics.dw_orders AS dw_orders
        WHERE dw_orders.booked_at IS NOT NULL 
        and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
        'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
        GROUP BY 1)
        
        AND buyer_id NOT IN  
       /* Not first time buyer */ 
       (SELECT buyer_id
        FROM analytics.dw_orders AS dw_orders
        WHERE dw_orders.order_number = 1
        and dw_orders.booked_at IS NOT NULL 
        and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
        'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
        GROUP BY 1)
        GROUP BY 1
        
        
        
        
        
        
        
        
        
        With A AS(    
      SELECT user_id, GMV, Booked_L28, L28_number, 
               lag(l28_number,1) over(partition by user_id order by L28_number) AS Last_Order, 
               lag(GMV,1) over(partition by user_id order by L28_number) AS Last_Order_GMV
      FROM                   
       (         
        SELECT U.user_id, O.booked_at, O.order_number, O.order_gmv/100 AS GMV,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',          U.buyer_activated_at )/28)), '2012-01-01 00:00:00'))||'_'||
        to_char(((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00',  U.buyer_activated_at )/28)),'2012-01-01 00:00:00'))-1)/28)+1,'00') AS BA_Cohort_L28,
        EXTRACT(YEAR FROM  DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))||'_'||
        ((EXTRACT(DOY FROM DATEADD(day, 14+(28*(DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)),'2012-01-01 00:00:00'))-1)/28)+1                               AS Booked_L28,
        ((DATEDIFF(day,'2012-01-01 00:00:00', O.booked_at)/28)+1) - ((DATEDIFF(day,'2012-01-01 00:00:00', date(U.buyer_activated_at) )/28)+1) + 1                    AS L28_Number
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
        WHERE date(booked_at) >= '2012-01-01' 
        AND order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
        'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 
        'seller_kyc_verified', 'seller_notification_initiated', 
        'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
        'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
        'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
        ))

     SELECT A.booked_l28, sum(gmv)
     FROM   A
     WHERE   L28_number - last_order > 1
     GROUP BY 1
     ORDER BY 1
