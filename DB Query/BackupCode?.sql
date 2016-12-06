

SELECT Date(re.at) as click_date, count(distinct re."a|id"),
      count(distinct case when o.buyer_id is null then re."a|id" 
                          when o.buyer_id is not null AND re."at" < O.booked_at then re."a|id" END) as non_buyer_count,
      count(distinct case when o.buyer_id is not null AND re."at" > O.booked_at then re."a|id" 
      else null end) as repeat_buyer_count
from raw_events.all re 
left join
    /*All Buyers */
   (SELECT buyer_id, booked_at  
    FROM analytics.dw_orders 
    WHERE order_number = 1) AS O on  re."a|id" = O.buyer_id 

WHERE re.v='v'
AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
group by 1
order by 1 






SELECT Date(re.at) as click_date, count(distinct re."a|id"),
      count(distinct case when o.buyer_id is null then re."a|id" 
                          when o.buyer_id is not null AND date(re."at") <= date(O.booked_at) then re."a|id" END) as non_buyer_count,
      count(distinct case when o.buyer_id is not null AND date(re."at") >  date(O.booked_at) then re."a|id" 
      else null end) as repeat_buyer_count
from raw_events.all re 
left join
    /*All Buyers */
   (SELECT buyer_id, booked_at  
    FROM analytics.dw_orders 
    WHERE order_number = 1) AS O on  re."a|id" = O.buyer_id 

WHERE re.v='v'
AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
group by 1
order by 1 




                            SELECT B.email
                            FROM   raw_mongo.users AS A
                            LEFT JOIN analytics.dw_users AS U ON U.user_id = A."_id"
                            LEFT JOIN raw_mongo.users_fb_info AS B ON A.fb_user_id = B.ext_user_id
                            WHERE U.date_buyer_activated IS NOT NULL





SELECT *
FROM  analytics_scratch.newton_all
WHERE user_id = '5614d2823ee7b04f3c330331'



SELECT A.user_id, A.username, A.email, max_n AS Total_Purchases
FROM analytics.dw_users AS A
INNER JOIN (SELECT buyer_id, max(order_number) max_n
            FROM Analytics.dw_orders 
            WHERE 
            order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 
            'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
            'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
            GROUP BY 1) AS B ON A.user_id = B.buyer_id
WHERE max_n >= 25        
ORDER BY RANDOM()
LIMIT 10000

