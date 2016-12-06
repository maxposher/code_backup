


SELECT 
      buyer.user_id,  TO_CHAR(DATE_TRUNC('quarter', buyer_activated_at), 'YYYY-MM'), 
      buyer.reg_app,  date(buyer_activated_at) - date(buyer.joined_at) + 1 AS buyer_d_day,
      
      CASE WHEN (buyer.joined_at < '2014-10-01' and buyer.acq_channel not in ('rip')) THEN 'not_rip'
           WHEN (buyer.acq_channel IN ('rip') OR buyer.is_referred_with_code in ('Yes')) THEN 'rip' 
      ELSE 'not_rip' END AS Referral,
      
      CASE
      WHEN acq_channel in ('rip') THEN 'Referral'
      WHEN ((reg_app in ('iphone', 'android', 'ipad') or reg_app is NULL) and acq_channel in 
      ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage', 'home page', 'na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter',
      'SPRING+POP+UP','tm','tw','unknown', 'ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp', 'invitefriends-email', 'invitefriends-fb',
      'invitefriends-sms','invitefriends-tu', 'invitefriends-tw', 'organic')  
      OR acq_channel IS NULL ) THEN 'Mobile_Organic'
      
      WHEN ((reg_app in ('iphone', 'android', 'ipad') or reg_app is NULL) and acq_channel not in 
     ('rip','cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter',
      'SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')
      and acq_channel IS NOT NULL) THEN  'Mobile_Paid'
              
      WHEN (reg_app in ('web') and acq_channel in  
      ('pi_sh_app', 'pi_sh_pub','organic','em_sh_pub','ext_pn','fb_sh_mshn','fb_sh_pub', 'invitefriendsemail', 'invitefriendsms', 
      'invitefriendtu', 'invitefriendtw', 'cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark',
      'pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp', 'invfriendfb')
      OR (acq_channel IS NULL )) THEN 'Web_Organic'
      
      WHEN (reg_app in ('web') and acq_channel in  ('gdm','fb_dpa', 'bdm', 'fbdm', 'shopzila','shopillza', 'ydm')) THEN 'Web_Paid_GDM'
      ELSE 'Web_Paid' END AS acq_super
FROM analytics.dw_users AS buyer 
WHERE date(buyer.buyer_activated_at) >= '2013-01-01'
AND buyer.user_status = 'active'
AND TO_CHAR(DATE_TRUNC('quarter', buyer.buyer_activated_at), 'YYYY-MM') IN ('2013-04', '2014-04', '2015-04', '2016-04')
ORDER BY 1 DESC
LIMIT 100








SELECT  TO_CHAR(date_trunc('quarter', date(O.booked_at), 'YYYY-MM'))  AS DD,
sum(O.order_gmv*0.01), percentile_cont(0.01) 
within group (order by sum(O.order_gmv) desc) 
over(partition by date_trunc('mon', date(O.booked_at))                    ) 
FROM analytics.dw_orders AS O
WHERE TO_CHAR(DATE_TRUNC('quarter', O.booked_at), 'YYYY-MM')  = '2015-04' 
GROUP BY DD, O.buyer_id
LIMIT 500



SELECT COUNT (distinct buyer_id) 
FROM (

SELECT  TRUNC(date_trunc('quarter', date(O.booked_at))) AS Booked_QTR,
O.buyer_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) 
over(partition by  TRUNC(date_trunc('quarter', date(O.booked_at)))) AS Threshold
FROM analytics.dw_orders AS O
WHERE date(booked_at) >= '2015-01-01'
GROUP BY Booked_QTR, O.buyer_id
)
WHERE GMV >= Threshold
AND  booked_qtr = '2015-01-01'

LIMIT 500


-----------------------------------------------------------
-----------------------------------------------------------
---Seller from previous quarter-----------------        
SELECT TRUNC(date_trunc('quarter', date(O2.booked_at))) AS Booked_QTR, sum(O2.order_gmv*0.01) AS GMV
FROM   analytics.dw_orders AS O2
WHERE  TRUNC(date_trunc('quarter', date(O2.booked_at))) = '2015-07-01'
AND   O2.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND O2.seller_id IN

(SELECT seller_id
 FROM (
      SELECT  TRUNC(date_trunc('quarter', date(O.booked_at))) AS Booked_QTR,
      O.seller_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) 
      over(partition by  TRUNC(date_trunc('quarter', date(O.booked_at)))) AS Threshold
      FROM analytics.dw_orders AS O
      WHERE TRUNC(date_trunc('quarter', date(O.booked_at))) <= '2015-04-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY Booked_QTR, O.seller_id
      )
 WHERE GMV >= Threshold
)
GROUP BY 1

LIMIT 500




--------------------------------------------------------------------
-------Top Seller Current Quarter-----------------------------------
SELECT Booked_QTR, SUM(GMV)
FROM (
       SELECT  TRUNC(date_trunc('quarter', date(O.booked_at))) AS Booked_QTR,
       O.seller_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.25) within group (order by sum(O.order_gmv*0.01) desc) 
       over(partition by  TRUNC(date_trunc('quarter', date(O.booked_at)))) AS Threshold
       FROM analytics.dw_orders AS O
       WHERE TRUNC(date_trunc('quarter', date(O.booked_at))) >= '2013-01-01' and  date(O.booked_at) <= '2016-06-30'
       AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
       'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
       'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
       GROUP BY Booked_QTR, O.seller_id
       )
WHERE GMV >= Threshold
GROUP BY 1
ORDER BY 1






       SELECT  TRUNC(date_trunc('quarter', date(O.booked_at))) AS Booked_QTR,
       O.seller_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.25) within group (order by sum(O.order_gmv*0.01) desc) 
       over(partition by  TRUNC(date_trunc('quarter', date(O.booked_at)))) AS Threshold
       FROM analytics.dw_orders AS O
       WHERE TRUNC(date_trunc('quarter', date(O.booked_at))) >= '2016-04-01' and  date(O.booked_at) <= '2016-06-30'
       AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
       'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
       'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
       GROUP BY Booked_QTR, O.seller_id
       LIMIT 10



       SELECT  COUNT (distinct seller_id)
       FROM(
       SELECT  TRUNC(date_trunc('quarter', date(O.booked_at))) AS Booked_QTR, O.seller_id, COUNT (distinct O.seller_id)
       FROM analytics.dw_orders AS O
       WHERE TRUNC(date_trunc('quarter', date(O.booked_at))) >= '2016-04-01' and  date(O.booked_at) <= '2016-06-30'
       AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
       'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
       'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
       GROUP BY 1,2
       HAVING sum(O.order_gmv*0.01) > 150
       ORDER BY 1)
       
       LIMIT 10










---Seller from previous quarter-----------------        
SELECT TRUNC(date_trunc('quarter', date(O2.booked_at))) AS Booked_QTR, sum(O2.order_gmv*0.01) AS GMV
FROM   analytics.dw_orders AS O2
WHERE  TRUNC(date_trunc('quarter', date(O2.booked_at))) = '2015-07-01'
AND   O2.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND O2.seller_id IN

(SELECT seller_id
 FROM (
      SELECT  O.seller_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) 
      over(partition by  O.seller_id) AS Threshold
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) < '2015-07-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY O.seller_id
      )
 WHERE GMV >= Threshold
)
GROUP BY 1

LIMIT 500





      SELECT  O.seller_id, sum(O.order_gmv*0.01) AS GMV, COUNT 
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) < '2015-07-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY O.seller_id
      ORDER BY sum(O.order_gmv*0.01)
      LIMIT 




SELECT TRUNC(date_trunc('quarter', date(O2.booked_at))) AS Booked_QTR, sum(O2.order_gmv*0.01) AS GMV, COUNT(distinct order_id)
FROM   analytics.dw_orders AS O2
WHERE  TRUNC(date_trunc('quarter', date(O2.booked_at))) = '2015-07-01'
AND   O2.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND O2.seller_id IN      

     (SELECT  seller_id
      FROM
     (
      SELECT  O.seller_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) over()
      AS Threshold
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) < '2015-07-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY 1)
      WHERE GMV >= threshold)
GROUP BY 1
      
      
      
      
      
      --Defuatl code
       SELECT  threshold, COUNT (distinct seller_id)
      FROM
     (
      SELECT  O.seller_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) over()
      AS Threshold
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) < '2015-07-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY 1)
      WHERE GMV >= threshold
      GROUP BY 1
      
      
      
SELECT TRUNC(date_trunc('quarter', date(O2.booked_at))) AS Booked_QTR, sum(O2.order_gmv*0.01) AS GMV, COUNT(distinct order_id)
FROM   analytics.dw_orders AS O2
WHERE  date(O2.booked_at) BETWEEN '2015-07-01' AND '2015-09-30'
AND   O2.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND O2.seller_id IN      

     (SELECT  seller_id
      FROM
     (
      SELECT  O.seller_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) over()
      AS Threshold
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) < '2015-07-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY 1)
      WHERE GMV >= threshold)
GROUP BY 1      








--Top buyers based on lifetime GMV
SELECT TRUNC(date_trunc('quarter', date(O2.booked_at))) AS Booked_QTR, sum(O2.order_gmv*0.01) AS GMV, COUNT(distinct order_id)
FROM   analytics.dw_orders AS O2
WHERE  TRUNC(date_trunc('quarter', date(O2.booked_at))) = '2015-07-01'
AND   O2.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND O2.buyer_id IN      
     (SELECT  buyer_id
      FROM
     (
      SELECT  O.buyer_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) over()
      AS Threshold
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) < '2015-07-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY 1)
      WHERE GMV >= threshold)
GROUP BY 1
            
-------------------------------------------------------------------------------      
--Top buyers based on lifetime GMV
SELECT TRUNC(date_trunc('quarter', date(O2.booked_at))) AS Booked_QTR, sum(O2.order_gmv*0.01) AS GMV, COUNT(distinct order_id)
FROM   analytics.dw_orders AS O2
WHERE  TRUNC(date_trunc('quarter', date(O2.booked_at))) = '2015-07-01'
AND   O2.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND O2.buyer_id IN      
     (SELECT  buyer_id
      FROM
     (
      SELECT  O.buyer_id, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) over()
      AS Threshold
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) >= '2016-07-01' and date(O.booked_at) < '2016-08-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY 1)
      WHERE GMV >= threshold)
GROUP BY 1
      
      
      
      
      
      --SELECT depname, empno, salary, rank() OVER (PARTITION BY depname ORDER BY salary DESC) FROM empsalary;
      
      SELECT DD, Threshold
      FROM
      (
      SELECT  O.buyer_id, date(O.booked_at) AS DD, sum(O.order_gmv*0.01) AS GMV, percentile_cont(0.01) within group (order by sum(O.order_gmv*0.01) desc) over(partition by date(O.booked_at)) AS Threshold
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) >= '2016-07-01' and date(O.booked_at) < '2016-08-01'
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY 1, 2)
      GROUP BY 1, 2
      ORDER BY 1
      
      
      --QA top buyers by GMV
      SELECT  COUNT (distinct buyer_id)
      FROM(
      SELECT O.buyer_id, sum(order_gmv*0.01)
      FROM analytics.dw_orders AS O
      WHERE date(O.booked_at) = '2016-07-01' 
      AND O.order_state in  ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
      'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
      'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
      GROUP BY 1
      HAVING sum(order_gmv*0.01) >= 245)
      
      ORDER BY 1
      
      
     --Top users by ranking shares 
     SELECT *
     FROM(
     
     SELECT action_date, user_id, internal_share, rank() OVER (partition by action_date ORDER BY internal_share DESC) as ranking
     FROM(
     
     SELECT date(R."at") AS action_date, R."actor|id" AS user_id,  COUNT(R."actor|id") AS internal_share
     FROM   raw_events.all as R
     INNER JOIN analytics.dw_users AS U ON U.user_id = R."actor|id"
     WHERE  R."verb" = 'share'
     AND    U.suggested_user_featured IS TRUE
     AND  date(R."at") < date(SYSDATE)
     GROUP BY 1, 2
     ORDER BY 2 DESC)
     )
     WHERE ranking <= 35 
      