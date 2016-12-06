

drop table if exists gdm_clicks;
create temp table gdm_clicks as
  (SELECT
     --"at",
     "at" as event_at,
     id,
     "using|app_type",
     "direct_object|url",
     "using|user_agent",
     "actor|id",
     "verb",
     "actor|type",
     "direct_object|id",
     "direct_object|type",
     case
          WHEN (position('utm_source=' IN "direct_object|url") > 0
                    and split_part(split_part(re."direct_object|url", 'utm_source=', 2), '&', 1)  ='gdm'
               and "direct_object|url" not like '%gretdm%')
               or (position('utm_source%3D' IN "direct_object|url") > 0 and "direct_object|url" not like '%gretdm%'
               and split_part(split_part(re."direct_object|url", 'utm_source%3D', 2), '%', 1)  = 'gdm') then 'gdm'
          WHEN (position('utm_source=' IN "direct_object|url") > 0
                    and split_part(split_part(re."direct_object|url", 'utm_source=', 2), '&', 1)  ='bdm')
               or (position('utm_source%3D' IN "direct_object|url") > 0
               and split_part(split_part(re."direct_object|url", 'utm_source%3D', 2), '%', 1)  = 'bdm') then 'bdm'
          WHEN (position('utm_source=' IN "direct_object|url") > 0
                    and split_part(split_part(re."direct_object|url", 'utm_source=', 2), '&', 1)  ='shopzilla')
               or (position('utm_source%3D' IN "direct_object|url") > 0
               and split_part(split_part(re."direct_object|url", 'utm_source%3D', 2), '%', 1)  = 'shopzilla') then 'shopzilla'
           WHEN (position('utm_source=' IN "direct_object|url") > 0
                    and split_part(split_part(re."direct_object|url", 'utm_source=', 2), '&', 1)  ='bing')
               or (position('utm_source%3D' IN "direct_object|url") > 0
               and split_part(split_part(re."direct_object|url", 'utm_source%3D', 2), '%', 1)  = 'bing') then 'bing'
          else null end as act_channel,
     case when position('campaign_id%' in "direct_object|url")=0 then split_part(split_part("direct_object|url", 'campaign_id=', 2), '&', 1)
          else split_part(split_part("direct_object|url", 'campaign_id%3D',2),'%',1) end AS campaign_id,
     CASE WHEN (position('poshmark.com/signup?' IN "direct_object|url") > 0 or position('/on/follow-brands' IN "direct_object|url") >0)
       THEN substring(split_part("direct_object|url", '%3Futm', 1), position('%3F' IN "direct_object|url") - 24, 24)
     ELSE substring(re."direct_object|url", position('?' IN re."direct_object|url") - 24, 24) END AS listing_id,
     CASE WHEN re."actor|type" = 'user'
       THEN re."actor|id"
     ELSE NULL END                                                                                AS user_id,
     CASE WHEN re."actor|type" = 'visitor'
       THEN re."actor|id"
     ELSE NULL END                                                                                AS visitor_id,
     case when lower(split_part(split_part("using|user_agent",'(',2),';',1)) like '%iphone%'
               or lower(split_part(split_part("using|user_agent",'(',2),';',1)) like '%android%'
               or lower(split_part(split_part("using|user_agent",'(',2),';',1)) like '%mobile%'
               or lower(split_part(split_part("using|user_agent",'(',2),';',1)) like '%windows phone%'
               or lower(split_part(split_part("using|user_agent",'(',2),';',1)) like '%ipod%'
               or lower(split_part(split_part("using|user_agent",'(',2),';',1)) like '%blackberry%'
       then 'Mobile'
          when
               lower(split_part(split_part("using|user_agent",'(',2),';',1)) like '%ipad%'
               or lower(split_part(split_part("using|user_agent",'(',2),';',1)) like '%hp-tablet%'
       then 'Tablet'
     else 'Desktop' end as web_flag
   FROM raw_events.all re

   WHERE re.verb = 'view'
         --and split_part(split_part(re."direct_object|url",'utm_source=',2),'&',1) in ('gdm')
         AND CASE WHEN position('utm_source=' IN "direct_object|url") > 0
     THEN split_part(split_part(re."direct_object|url", 'utm_source=', 2), '&', 1)
             WHEN position('utm_source%3D' IN "direct_object|url") > 0
               THEN split_part(split_part(re."direct_object|url", 'utm_source%3D', 2), '%', 1)
             ELSE NULL END IN ('gdm','shopzilla','bing','bdm')
    and "at"::date >='2016-08-03'
    and "using|app_type" ='web'
    and "using|user_agent" not LIKE  '%https%'
   );



drop table if exists ll_gdm_clicks_max;
create table ll_gdm_clicks_max as
  (select re.*,
     buyer_activated_at,
     first_value(re.event_at) over (partition by re.user_id order by event_at rows between unbounded preceding and unbounded following) as first_click_time,

     case when (u.buyer_activated_at >= first_value(event_at) over (partition by re.user_id order by event_at rows between unbounded preceding and unbounded following)
                 and u.buyer_activated_at is not null) then 1 else 0 end as new_buyer_flag,
     case when (u.buyer_activated_at<first_value(event_at) over (partition by re.user_id order by event_at rows between unbounded preceding and unbounded following)
                 and u.buyer_activated_at is not null) then 1 else 0 end as repeat_buyer_flag
     /*o1.booked_at as click_listing_sold_time,
     o1.order_id as click_listing_order_id,
     o1.buyer_id as click_listing_purchase_buyer_id,
     l.brand  as click_brand,
     l.category_v2 as click_category_v2,
     l.sub_category as click_sub_category,
     l.listing_price as click_listing_price,
     l.listing_condition as click_listing_condition,
     l.inventory_status*/

   from gdm_clicks re
     left join
     analytics.dw_users u
       on   re.user_id = u.user_id
     /*left join
     analytics.dw_order_items o
       on  re.listing_id = o.listing_id
           and o.order_line_item_index=1
     left join
     analytics.dw_orders o1
       on o.order_id = o1.order_id
     --and o1.order_state !='cancelled'
     left join
     analytics.dw_listings l
       on re.listing_id = l.listing_id*/

  );


/*buyer summary dedup last click before buyer activation*/
drop table if exists last_clicks_bf_purchase_new;
create temp table last_clicks_bf_purchase_new as
  (select x.*
   from (select *,
           case when datediff('day',event_at,buyer_activated_at)=0 then 'd1'
           when datediff('day',event_at,buyer_activated_at)=1 then 'd2'
           when datediff('day',event_at,buyer_activated_at)=2 then 'd3'
           when datediff('day',event_at,buyer_activated_at)=3 then 'd4'
           when datediff('day',event_at,buyer_activated_at)=4 then 'd5'
           when datediff('day',event_at,buyer_activated_at)=5 then 'd6'
           when datediff('day',event_at,buyer_activated_at)=6 then 'd7'
           else 'other' end as new_buyer_day_flag,
           case when datediff('hour',event_at,buyer_activated_at) <=24 then '24hr'
           when datediff('hour',event_at,buyer_activated_at)>24 and datediff('hour',event_at,buyer_activated_at) <=48 then '25-48hrs'
           when datediff('hour',event_at,buyer_activated_at)>48 and datediff('hour',event_at,buyer_activated_at) <=72 then '49-72hrs'
           else 'other' end as new_buyer_hr_flag,
           row_number() over (partition by user_id order by event_at desc) as click_rk,
           count(*) over (partition by user_id) as click_cnt
         from ll_gdm_clicks_max
         where event_at<= buyer_activated_at
               and datediff('day',event_at,buyer_activated_at)<=7
               and new_buyer_flag=1
        ) x
   where click_rk=1);
   
   
   
   select * from last_clicks_bf_purchase_new where act_channel = 'gdm' and new_buyer_day_flag= 'd1' limit 10
   
   
   SELECT date(U.buyer_activated_at),  COUNT(distinct U.user_id), COUNT(distinct O.buyer_id)
   FROM   analytics.dw_users AS U
   LEFT  JOIN last_clicks_bf_purchase_new AS LC ON   U.user_id   = LC.user_id
   LEFT  JOIN analytics.dw_orders         AS O  ON   LC.user_id  = O.buyer_id
   WHERE  act_channel = 'gdm' 
   AND    new_buyer_day_flag = 'd1'
   --AND    date(O.booked_at) - date(U.buyer_activated_at) +1 = 2
   AND    date(U.buyer_activated_at) > '2016-05-01'
   GROUP By 1
   ORDER BY 1
   limit 100
   
   
 
 
 
 
 SELECT O.app, extract(DOW from O.booked_at), datediff(day, O.booked_at,'2016-09-02'), O.booked_at
 FROM analytics.dw_orders AS O
 WHERE date(booked_at) BETWEEN '2016-09-01' AND '2016-09-30'

 LIMIT 100



   
  SELECT  U.reg_app, extract(DOW from U.joined_at), COUNT(distinct U.user_id),
          SUM(CASE WHEN datediff(hour, U.buyer_activated_at, U.joined_at) + 1 <= 24 THEN 1 ELSE 0 END) AS Trip_Comp
  FROM    analytics.dw_users AS U
  WHERE   datediff(day, U.joined_at,'2016-01-01') + 1 <= 7
  AND     U.reg_app IN ('iphone', 'web')
  GROUP BY 1,2
  ORDER BY 1, 2
  LIMIT 100
   
   
     
  SELECT  U.reg_app, extract(DOW from U.joined_at) AS Day_of_the_week, 
  (SUM(CASE WHEN datediff(hour, U.buyer_activated_at, U.joined_at) + 1 <= 24 THEN 1 ELSE 0 END) / COUNT(distinct U.user_id)::decimal(10,2))*100 
  AS Percentage_Of_Trip_Completion  
  FROM    analytics.dw_users AS U
  WHERE   datediff(day, U.joined_at,'2016-01-01') + 1 <= 7
  AND     U.reg_app IN ('iphone', 'web')
  GROUP BY 1,2
  ORDER BY 2, 1
  LIMIT 100 
   
   
   
   
    SELECT app, percentile_cont(0.9) within group (order by GMV_Diff desc) over(partition by app)
  FROM(
  SELECT 
	DATE(buyer_first_order.booked_at) AS "buyer_first_order.booked_date",
	dw_orders.app,
	
	percentile_cont(0.9) within group (order by COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) - COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)*0.75 desc)
	
	COALESCE(SUM((dw_orders.order_gmv*0.01)), 0) - COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)*0.75 AS "GMV_Diff"
	
  FROM analytics.dw_orders AS dw_orders
  LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
  LEFT JOIN analytics.dw_orders AS buyer_first_order ON dw_orders.buyer_id = buyer_first_order.buyer_id and buyer_first_order.order_number=1
  WHERE ((((buyer_first_order.booked_at) >= ((DATEADD(day,-30, DATE_TRUNC('day',GETDATE()) ))) 
  AND (buyer_first_order.booked_at) < ((DATEADD(day,31, DATEADD(day,-30, DATE_TRUNC('day',GETDATE()) ) )))))) 
  AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL and dw_orders.order_state 
  IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 
  'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 
  'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 
  'seller_ab_update_failed', 'waiting_seller_kyc_verification') AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
  GROUP BY 1,2
  ORDER BY 1 DESC
  limit 50)
  limit 5
  
  
  SELECT app, ninty_percentile
  FROM
  (
  SELECT app,  percentile_cont(0.1) within group (order by (order_gmv - order_gmv*0.75) asc) over(partition by app) AS ninty_percentile
  FROM analytics.dw_orders
  WHERE date(booked_at) = '2016-01-01')
  GROUP BY 1, 2
  limit 100
  
   
  SELECT COUNT (distinct order_id)
  FROM analytics.dw_orders
  WHERE date(booked_at) = '2016-01-01'
  AND (order_gmv - order_gmv*0.75) >= 1450
  AND app = 'iphone' 
   
   
  SELECT COUNT (distinct order_id)
  FROM analytics.dw_orders
  WHERE 
  CURRENT_Date - date(booked_at) = '2016-01-01'

  AND app = 'iphone'  
  
  
  SELECT date(booked_at), COUNT(*)
  FROM analytics.dw_orders
  WHERE CURRENT_Date - date(booked_at) + 1 <= 31
  GROUP BY 1
  
  SELECT max(booked_at)
  FROM analytics.dw_orders
 
  
  
  SELECT reg_app, day_of_week, sum(Trip_Comp ), COUNT(distinct user_id)
  FROM
  ( 
  SELECT  U.reg_app, extract(DOW from U.joined_at) AS Day_of_week, CASE WHEN datediff(hour, U.buyer_activated_at, U.joined_at) + 1 <= 24 THEN 1 END
  AS Trip_Comp, user_id
  
  FROM    analytics.dw_users AS U
  WHERE   datediff(day, U.joined_at,'2016-01-01') + 1 <= 7
  AND     U.reg_app IN ('iphone', 'web'))
  GROUP BY 1, 2
  ORDER BY 1, 2
 
  
  LIMIT 100 
   
   
   
   
   
   
   
   
