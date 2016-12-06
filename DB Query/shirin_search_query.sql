

           
           SELECT id, actor_id, at , 
                  case when  direct_object_usersearchrequest_query is not null then 1 else 0 end as keyword_search, 
                  case when direct_object_executedSearchRequest_query_and_facet_filters_brand_0 is not null then 1 else 0 end as brand_browsing, 
                  case when direct_object_executedSearchRequest_query_and_facet_filters_category_feature_0 is not null then 1 else 0 end as category_browsing 
           From raw_hive.search_events 
           where   at  >= '2015-10-30' 
           AND     at  <= '2015-11-05'   
                   and actor_type = 'User'      
       
          
          
          SELECT U.user_id, U.buyer_activated_at, SUM(keyword_search) AS KS, SUM(brand_browsing) AS BB, SUM(category_browsing) AS CB
          FROM analytics.dw_users AS U
          LEFT JOIN 
                 (SELECT id, actor_id, at AS action_time , 
                  case when  direct_object_usersearchrequest_query is not null then 1 else 0 end as keyword_search, 
                  case when direct_object_executedSearchRequest_query_and_facet_filters_brand_0 is not null then 1 else 0 end as brand_browsing, 
                  case when direct_object_executedSearchRequest_query_and_facet_filters_category_feature_0 is not null then 1 else 0 end as category_browsing 
                From raw_hive.search_events 
                where   at  >= '2015-10-30' 
                AND     at  <= '2015-11-05'  
                AND   actor_type = 'User') AS B ON U.user_id = B.actor_id   
          WHERE action_time <  least(U.buyer_activated_at, cast(date(joined_at + 1) AS timestamp))       
          AND   U.join_date BETWEEN '2015-10-30' AND '2015-11-04' 
         -- AND   U.reg_app = 'iphone'
          GROUP BY 1,2
          LIMIT 100
                     
          
          
          SELECT  min(updated_at)
          FROM   analytics.dw_posh_credits
          WHERE  updated_at IS NOT NULL
          AND    status = 'd'
          limit 100
          
          
          SELECT CHARINDEX('=', notes) 
          FROM   analytics.dw_posh_credits
          limit  100
          
          
          

          
          
          SELECT   SUBSTRING(notes, CHARINDEX('=', notes) + 2, len(notes) - CHARINDEX('=', notes)), notes
          FROM    analytics.dw_posh_credits
          limit   10
          





    SELECT O.order_id
    FROM analytics.dw_orders     AS O
    LEFT JOIN analytics.dw_users AS U ON O.buyer_id = U.user_id
    WHERE   DATE(O.booked_at) - date(U.date_buyer_activated) + 1 = 3
   --   DATE(O.booked_at) > '2015-11-15'
    AND  O.buyer_shipping_fee * .01 < 4.99 
    AND  O.order_number = 1
    limit 50
    
    SELECT buyer_shipping_fee
    FROM  analytics.dw_orders
    WHERE  order_number = 1
    AND buyer_shipping_fee * .01 < 4.99 
    AND DATE(booked_at) > '2016-01-15'
   limit 10


   SELECT U.* 
   FROM  analytics.dw_users AS U
   INNER JOIN analytics.dw_orders AS O ON U.user_id = O.buyer_id 
   WHERE  date_buyer_activated != date(booked_at)
   AND   O.order_number = 1
   LIMIT 100
   
    SELECT max(date_buyer_activated) 
   FROM  analytics.dw_users
   ORDER BY 1 ASC
   LIMIT 100