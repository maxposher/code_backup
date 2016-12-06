

     SELECT *
     FROM  raw_events.all as R
     WHERE R."verb" = 'update'
     LIMIT 100
     
     
     SELECT *
     FROM  raw_events.all as R
     WHERE R."verb" = 'update'
     AND  R."direct_object|type" = 'account_info_attribute'
     LIMIT 200
     
     
     
     SELECT(date_trunc('week',buyer_activated_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') buyer_activated_week, COUNT(*)
     FROM analytics.dw_users
     WHERE buyer_activated_at <= '2013-01-01'
     GROUP BY 1
     ORDER BY 1
     LIMIT 100
     
     
     
     
     SELECT t1.weeks_since_registration AS "weeks_since_registration"
     from
     (select distinct day_in_year as weeks_since_registration 
     from analytics.d_dates_id where full_dt >= '2011-01-01' and full_dt < '2012-01-01' and day_in_year < 401) as t1
     limit 200
     
     
     
      SELECT
           (date_trunc('week',buyer_activated_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') buyer_activated_week,
            COALESCE(acq_channel,'na') as acq_channel,
            signup_segment,
            reg_app,
            guest_user
            , count(*) as cohort_size
          FROM analytics.dw_users
          WHERE buyer_activated_at is not null
          Group By 1,2,3,4,5
          LIMIT 100
          
          
       SELECT
           (date_trunc('week',dw_users.buyer_activated_at + INTERVAL '1 day') - INTERVAL '1 day') AS "buyer_activated_week",
            Datediff(week, (date_trunc('week',dw_users.buyer_activated_at + INTERVAL '1 day') - INTERVAL '1 day'), (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day')) + 1 AS "weeks_since_registration",
            (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day') AS "order_booked_week",
            COALESCE(dw_users.acq_channel,'na') AS "acq_channel",
            dw_users.signup_segment AS "signup_segment",
            dw_users.reg_app AS "reg_app",
            dw_users.guest_user AS "guest_user",
            COUNT(dw_orders.order_id ) as orders_count,
            SUM(dw_orders.order_gmv) as orders_gmv
          FROM analytics.dw_orders AS dw_orders
          LEFT JOIN analytics.dw_users AS dw_users 
            ON 
              dw_orders.buyer_id = dw_users.user_id
          WHERE
           Datediff(week, (date_trunc('week',dw_users.buyer_activated_at + INTERVAL '1 day') - INTERVAL '1 day'), (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day')) < 101
           AND buyer_activated_at is not null
           AND dw_orders.booked_at >= '2016-01-01'
           AND dw_users.joined_at >= '2016-01-01'
          GROUP BY 1,2,3,4,5,6,7
          LIMIT 100   
          
          
     (SELECT
           (date_trunc('week',buyer_activated_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') buyer_activated_week,
            Datediff(week, (date_trunc('week',dw_users.buyer_activated_at + INTERVAL '1 day') - INTERVAL '1 day'), (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day')) + 1 AS "weeks_since_registration",
            (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day') AS "order_booked_week",
            COALESCE(dw_users.acq_channel,'na') AS "acq_channel",
            dw_users.signup_segment AS "signup_segment",
            dw_users.reg_app AS "reg_app",
            dw_users.guest_user AS "guest_user",
            COUNT(dw_orders.order_id ) as orders_count,
            SUM(dw_orders.order_gmv) as orders_gmv
          FROM analytics.dw_users AS dw_users
          LEFT JOIN analytics.dw_orders AS dw_orders
            ON 
              dw_orders.buyer_id = dw_users.user_id
          WHERE
           Datediff(week, (date_trunc('week',dw_users.buyer_activated_at + INTERVAL '1 day') - INTERVAL '1 day'), (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day')) < 101
           AND buyer_activated_at is not null
           AND (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day') = '2013-01-06 00:00:00'
          GROUP BY 1,2,3,4,5,6,7
          ) limit 100
          
          
 --------------------------------------         
 /*************************************/         
 ---------------------------------------         
     With ld_cohort_sizes_tmp AS 
         (SELECT (date_trunc('week',buyer_activated_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') buyer_activated_week,
          COALESCE(acq_channel,'na') as acq_channel,
          signup_segment,
          reg_app,
          guest_user, 
          count(*) as cohort_size
          FROM analytics.dw_users
          WHERE buyer_activated_at is not null
          Group By 1,2,3,4,5),
          
          ld_orders_tmp AS 
          (SELECT (date_trunc('week',buyer_activated_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') buyer_activated_week,
           (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day') AS "order_booked_week",
            COALESCE(dw_users.acq_channel,'na') AS "acq_channel",
            dw_users.signup_segment AS "signup_segment",
            dw_users.reg_app AS "reg_app",
            dw_users.guest_user AS "guest_user",
            COUNT(dw_orders.order_id ) as orders_count,
            SUM(dw_orders.order_gmv) as orders_gmv
            FROM analytics.dw_users AS dw_users
            LEFT JOIN analytics.dw_orders AS dw_orders ON dw_orders.buyer_id = dw_users.user_id
            WHERE buyer_activated_at is not null
            GROUP BY 1,2,3,4,5,6
            ),
               
          --All Posiible Booked Week
          ld_week_since_tmp_dummy as 
          (SELECT  (date_trunc('week', booked_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') booked_week
           FROM     analytics.dw_orders 
           GROUP BY 1)
          
          --Add all possible booked date to 
          SELECT *, datediff(week, ld_computed_cohort_size.buyer_activated_week, order_booked_week) as numweeks
          FROM ld_cohort_sizes_tmp           AS ld_computed_cohort_size
          CROSS JOIN ld_week_since_tmp_dummy AS ld_week_since_tmp_dummy
          
          LEFT  JOIN ld_orders_tmp ON ld_computed_cohort_size.buyer_activated_week = ld_orders_tmp.buyer_activated_week
          and   ld_week_since_tmp_dummy.booked_week = ld_orders_tmp.order_booked_week 
          and   ld_computed_cohort_size.acq_channel = ld_orders_tmp.acq_channel 
          and ((ld_computed_cohort_size.signup_segment = ld_orders_tmp.signup_segment) OR (ld_computed_cohort_size.signup_segment IS NULL AND ld_orders_tmp.signup_segment IS NULL)) 
          and   ld_computed_cohort_size.guest_user = ld_orders_tmp.guest_user 
          and ((ld_computed_cohort_size.reg_app = ld_orders_tmp.reg_app) OR (ld_computed_cohort_size.reg_app IS NULL AND ld_orders_tmp.reg_app IS NULL))
          
          WHERE 
          --ld_week_since_tmp_dummy.booked_week >= ld_computed_cohort_size.buyer_activated_week
          --AND orders_gmv is null
          ld_computed_cohort_size.buyer_activated_week = '2011-08-21 00:00:00'
          and ld_computed_cohort_size.signup_segment = 'J'
          ORDER BY numweeks
          LIMIT 300
          
          
 -----------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------
 --Test Code--
 ------
 
     With ld_cohort_sizes_tmp AS ( 
          SELECT (date_trunc('week',buyer_activated_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') buyer_activated_week,
          COALESCE(acq_channel,'na') as acq_channel,
          signup_segment,
          reg_app,
          guest_user, 
          count(*) as cohort_size
          FROM analytics.dw_users
          WHERE buyer_activated_at is not null
          AND date(buyer_activated_at) >= '2012-01-01'
          Group By 1,2,3,4,5),
          
          ld_orders_tmp AS (
          SELECT (date_trunc('week',buyer_activated_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') AS buyer_activated_week,
          (date_trunc('week',dw_orders.booked_at + INTERVAL '1 day') - INTERVAL '1 day') AS "order_booked_week",
          COALESCE(dw_users.acq_channel,'na') AS "acq_channel",
          signup_segment AS "signup_segment",
          reg_app AS "reg_app",
          guest_user AS "guest_user",
          COUNT(dw_orders.order_id ) AS orders_count,
          SUM(dw_orders.order_gmv)   AS orders_gmv
          FROM analytics.dw_users AS dw_users
          LEFT JOIN analytics.dw_orders AS dw_orders 
          ON dw_orders.buyer_id = dw_users.user_id
          WHERE buyer_activated_at is not null 
          AND   date(buyer_activated_at) >= '2012-01-01'
          AND   (dw_orders.order_gmv*0.01) < 50000 
          AND   dw_orders.booked_at IS NOT NULL 
          AND   dw_orders.order_state IN 
          ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
          'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
          'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 
          'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
          GROUP BY 1,2,3,4,5,6),
                      
          --All Posiible Booked Week 
          ld_week_since_tmp_dummy as 
         (SELECT  (date_trunc('week', booked_at::DATE + INTERVAL '1 day') - INTERVAL '1 day') booked_week
          FROM     analytics.dw_orders 
          WHERE   date(booked_at) >= '2012-01-01'
          GROUP BY 1),
          
          --Add all possible booked date to 
         cohort_temp as
         (SELECT *
          FROM ld_cohort_sizes_tmp           
          CROSS JOIN ld_week_since_tmp_dummy
          WHERE  buyer_activated_week <= booked_week)
          
         SELECT 
            ld_computed_cohort_size.buyer_activated_week AS "buyer_activated_week",
            ld_computed_cohort_size.acq_channel          AS "acq_channel",
            ld_computed_cohort_size.signup_segment       AS "signup_segment",
            ld_computed_cohort_size.cohort_size          AS "cohort_size",
            ld_computed_cohort_size.guest_user           AS "guest_user",
            ld_computed_cohort_size.reg_app              AS "reg_app",
            datediff(week, ld_computed_cohort_size.buyer_activated_week, booked_week) + 1 AS "weeks_since_registration",
            ld_computed_cohort_size.booked_week          AS "order_booked_week",
            ld_orders_tmp.orders_count                   AS "orders_count",
            ld_orders_tmp.orders_gmv                     AS "orders_gmv"
          
          FROM cohort_temp as ld_computed_cohort_size
          LEFT  JOIN ld_orders_tmp ON ld_computed_cohort_size.buyer_activated_week = ld_orders_tmp.buyer_activated_week
          and   ld_computed_cohort_size.booked_week = ld_orders_tmp.order_booked_week 
          and   ld_computed_cohort_size.acq_channel = ld_orders_tmp.acq_channel 
          and ((ld_computed_cohort_size.signup_segment = ld_orders_tmp.signup_segment) OR (ld_computed_cohort_size.signup_segment IS NULL AND ld_orders_tmp.signup_segment IS NULL)) 
          and   ld_computed_cohort_size.guest_user = ld_orders_tmp.guest_user 
          and ((ld_computed_cohort_size.reg_app = ld_orders_tmp.reg_app) OR (ld_computed_cohort_size.reg_app IS NULL AND ld_orders_tmp.reg_app IS NULL))
          
          WHERE 
          --ld_computed_cohort_size.buyer_activated_week >= '2013-01-01'
          --AND orders_gmv is null
          ld_computed_cohort_size.buyer_activated_week = '2013-01-06 00:00:00'
          and ld_computed_cohort_size.signup_segment = 'J'
          and ld_computed_cohort_size.acq_channel = 'rip'
          and ld_computed_cohort_size.reg_app = 'iphone'
          ORDER BY booked_week
          LIMIT 500
          
          
          