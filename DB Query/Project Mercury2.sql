
    
     --D1 Buyers, GMV, date for Mercury
     SELECT A.m_date, A.signup_segment, A.reg_app, sum(Cohort) As Cohort, sum(d1_buyers) AS D1_Buyer, 
     sum(D1_Buyer_GMV) AS D1_Buyer_GMV, sum(new_buyers) AS New_Buyers, sum(all_buyers) AS All_Buyers,
     sum(all_buyer_gmv) AS All_Buyer_GMV, sum(new_buyer_gmv) AS New_Buyer_GMV
     
     FROM (
     
    (SELECT     join_date AS M_date, signup_segment, reg_app, count(distinct user_id) AS Cohort
     FROM       analytics.dw_users AS U
     WHERE      U.join_date BETWEEN '2016-01-25' AND '2016-02-26'
     GROUP BY   1, 2, 3
     ORDER BY   1) AS A      
     
LEFT JOIN 
    
    (SELECT     join_date AS M_date, signup_segment, reg_app, count(distinct user_id) AS D1_Buyers
     FROM       analytics.dw_users AS U
     WHERE      U.join_date BETWEEN '2016-01-25' AND '2016-02-26'
     AND        U.date_buyer_activated - U.join_date = 0
     GROUP BY   1, 2, 3
     ORDER BY   1) AS B ON A.M_date = B.M_date AND A.signup_segment = B.signup_segment AND A.reg_app = B.reg_app    

LEFT JOIN     

   ( SELECT     join_date AS M_date, signup_segment, reg_app, sum(order_gmv/100) AS D1_Buyer_GMV
     FROM       analytics.dw_users AS U INNER JOIN analytics.dw_orders AS O ON U.user_id = O.buyer_id
     WHERE      U.join_date BETWEEN '2016-01-25' AND '2016-02-26'
     AND        U.date_buyer_activated - U.join_date = 0
     AND        O.order_number = 1
     AND        O.order_state IN 
     ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')    
     GROUP BY    1, 2, 3
     ORDER BY   1)  AS C ON A.M_date = C.M_date AND A.signup_segment = C.signup_segment AND A.reg_app = C.reg_app      

LEFT JOIN 

    (SELECT     date(booked_at) AS O_date, signup_segment, reg_app, count(distinct buyer_id) AS new_buyers
     FROM       analytics.dw_orders AS O INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
     WHERE      date(O.booked_at) BETWEEN '2016-01-25' AND '2016-02-26'
     AND        O.order_number = 1
     AND        O.order_state IN 
     ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
     GROUP BY    1, 2, 3
     ORDER BY   1) AS D ON A.M_date = D.O_date AND A.signup_segment = D.signup_segment AND A.reg_app = D.reg_app

LEFT JOIN

    (SELECT     date(booked_at) AS O_date, signup_segment, reg_app, count(distinct buyer_id) AS all_buyers
     FROM       analytics.dw_orders AS O INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
     WHERE      date(O.booked_at) BETWEEN '2016-01-25' AND '2016-02-26'
     AND        O.order_state IN 
     ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
     GROUP BY   1, 2, 3
     ORDER BY   1) AS E ON A.M_date = E.O_date  AND A.signup_segment = E.signup_segment AND A.reg_app = E.reg_app     
     
 LEFT JOIN
    
    (SELECT     date(booked_at) AS O_date, signup_segment, reg_app, sum(order_gmv/100) AS all_buyer_gmv
     FROM       analytics.dw_orders AS O INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
     WHERE      date(O.booked_at) BETWEEN '2016-01-25' AND '2016-02-26'
     AND        O.order_state IN 
     ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
     GROUP BY   1, 2, 3
     ORDER BY   1) AS F ON A.M_date = F.O_date  AND A.signup_segment = F.signup_segment AND A.reg_app = F.reg_app     
     
LEFT JOIN     
    
    (SELECT     date(booked_at) AS O_date, signup_segment, reg_app, sum(order_gmv/100) AS new_buyer_gmv
     FROM       analytics.dw_orders AS O INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
     WHERE      date(O.booked_at) BETWEEN '2016-01-25' AND '2016-02-26'
     AND        O.order_number = 1
     AND        O.order_state IN 
     ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
     GROUP BY    1, 2, 3
     ORDER BY   1) AS G ON A.M_date = G.O_date AND A.signup_segment = G.signup_segment AND A.reg_app = G.reg_app     
     )
     GROUP BY 1, 2, 3
     ORDER BY A.m_date
     
     
     
     
     
    
    
    
    select *
    FROM analytics.dw_users
    WH
    
    
    
    
    
    (SELECT     date(booked_at) AS O_date, signup_segment, count(distinct buyer_id) AS all_buyers
     FROM       analytics.dw_orders AS O INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
     WHERE      date(O.booked_at) BETWEEN '2016-01-01' AND '2016-02-26'
     AND        O.order_state IN 
     ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
     GROUP BY   1, 2
     ORDER BY   1)
     
     
     
        
    (SELECT     date(booked_at) AS O_date, signup_segment, count(distinct buyer_id) AS new_buyers
     FROM       analytics.dw_orders AS O INNER JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
     WHERE      date(O.booked_at) BETWEEN '2016-01-01' AND '2016-02-26'
     AND        O.order_number = 1
     AND        O.order_state IN 
     ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
      'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
      'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
      'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
     GROUP BY   1, 2
     ORDER BY   1)
     
     
    (SELECT     join_date AS M_date, signup_segment, count(distinct user_id) AS D1_Buyers
     FROM       analytics.dw_users AS U
     WHERE      U.join_date BETWEEN '2016-02-01' AND '2016-02-21'
     AND        U.date_buyer_activated - U.join_date = 0
     GROUP BY   join_date, 2
     ORDER BY   1)
     

     