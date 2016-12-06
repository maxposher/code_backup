

Select max(booked_at)
FROM analytics.dw_orders


select *
from analytics.dw_posh_credits
limit 10


select date_part(month, created_at), sum(credit_amount)
from analytics.dw_posh_credits
WHERE status = 'a'
AND  date(created_at) >= '2015-09-01'
AND reason = 'referred_user'
GROUP BY 1
limit 10


select date_part(month, issued_at), sum(credit_amount)
from analytics.dw_posh_credits
WHERE --status = 'a'
date(issued_at) >= '2015-09-01'
AND reason = 'referred_user'
GROUP BY 1
ORDER BY 1
limit 10




            --    AND action_time <  least(U.buyer_activated_at, cast(date(joined_at + 1) AS timestamp)) 




                SELECT U.user_id, U.buyer_activated_at, 
                FROM   analytics.dw_users AS U
                WHERE  U.join_date BETWEEN '2015-10-01' AND '2015-11-04'


                --Keyword Search Query 
                SELECT actor_id,
                min(case when  direct_object_usersearchrequest_query is not null then R."at"  else NULL end) as keyword_search, 
                min(case when direct_object_executedSearchRequest_query_and_facet_filters_brand_0 is not null then R."at"  else NULL end) as brand_browsing, 
                min(case when direct_object_executedSearchRequest_query_and_facet_filters_category_feature_0 is not null then R."at" else NULL end) as category_browsing 
                From raw_hive.search_events AS R
                WHERE   at  >= '2015-10-30' 
                AND     at  <= '2015-11-05'  
                AND   actor_type = 'User'
                GROUP BY 1
  




                SELECT A.user_id,
                       max(case when A.activity_name  = 'like_listing'                  then A.activity_count  else NULL end) as likes,
                       max(case when A.activity_name  = 'listing_created'               then A.activity_count  else NULL end) as listings,
                       max(case when A.activity_name  = 'comment_on_own_listing'        then A.activity_count  else NULL end) as comment_o_s,
                       max(case when A.activity_name  = 'comment_on_community_listing'  then A.activity_count  else NULL end) as comment_c_s
                FROM         analytics.dw_user_activity AS A
                INNER  JOIN  analytics.dw_users AS U on A.user_id = U.user_id
                AND    U.join_date BETWEEN '2015-10-30' AND '2015-11-04' 
                AND    date(A.activity_date) BETWEEN '2015-10-30' AND '2015-11-05'
                AND    date(A.activity_date) - date(U.join_date) <= 1
                GROUP BY 1
                limit 100




#############################################################


               drop table analytics_scratch.search_like;
                    
          
          /* Table tracking search and user activities */
                SELECT U.user_id,  U.joined_at, U.reg_app, U.buyer_activated_at, keyword_search, brand_browsing, category_browsing, 
                       first_like, first_listing, comment_o, comment_c, first_buy
                FROM   analytics.dw_users AS U
                
                LEFT JOIN
             
               (SELECT actor_id,
                min(case when  direct_object_usersearchrequest_query is not null then R."at"  else NULL end) as keyword_search, 
                min(case when direct_object_executedSearchRequest_query_and_facet_filters_brand_0 is not null then R."at"  else NULL end) as brand_browsing, 
                min(case when direct_object_executedSearchRequest_query_and_facet_filters_category_feature_0 is not null then R."at" else NULL end) as category_browsing 
                From raw_hive.search_events AS R
                INNER JOIN analytics.dw_users AS U on R.actor_id = U.user_id
                WHERE   at  >= '2015-10-30' 
                AND     at  <= '2015-11-05'  
                AND   actor_type = 'User'
                AND    date(at) - U.join_date <= 1
                GROUP BY 1) AS B on U.user_id = B.actor_id

                LEFT JOIN  

               (SELECT A.user_id AS user_id_II,
                       min(case when A.activity_name  = 'like_listing'                  then A.activity_date  else NULL end) as first_like,
                       min(case when A.activity_name  = 'listing_created'               then A.activity_date  else NULL end) as first_listing,
                       min(case when A.activity_name  = 'comment_on_own_listing'        then A.activity_date  else NULL end) as comment_o,
                       min(case when A.activity_name  = 'comment_on_community_listing'  then A.activity_date  else NULL end) as comment_c,
                       min(case when A.activity_name  = 'item_purchased'                then A.activity_date  else NULL end) as first_buy
                FROM   analytics.dw_user_activity AS A
                INNER  join analytics.dw_users AS U on A.user_id = U.user_id
                WHERE  A.activity_count = 1
                AND    date(A.activity_date) BETWEEN '2015-10-30' AND '2015-11-05'
                AND    date(A.activity_date) - U.join_date <= 1
                GROUP BY 1)                                    AS C on U.user_id = C.user_id_II 
                WHERE  U.join_date BETWEEN '2015-10-30' AND '2015-11-04'    );
-----------------------------------------------------------------------------------------------------------------

                SELECT U.user_id,  U.joined_at, U.reg_app, U.buyer_activated_at, keyword_search, brand_browsing, category_browsing, 
                       first_like, first_listing, comment_o, comment_c, first_buy
                FROM   analytics.dw_users AS U
                
                LEFT JOIN
             
                SELECT actor_id,
                sum(case when  direct_object_usersearchrequest_query is not null then 1  else 0 end) as #_of_keyword_search, 
                sum(case when direct_object_executedSearchRequest_query_and_facet_filters_brand_0 is not null then 1  else 0 end) as #_of_brand_browsing, 
                sum(case when direct_object_executedSearchRequest_query_and_facet_filters_category_feature_0 is not null then 1 else 0 end) as #_of_category_browsing 
                From      analytics.dw_users AS U
                LEFT JOIN raw_hive.search_events AS R on U.user_id = R.actor_id 
                WHERE   R."at"  >= '2015-10-30' 
                AND     R."at"  <= '2015-11-05'  
                AND     actor_type = 'User'
                AND     date(R."at") - U.join_date <= 1
                AND     U.join_date BETWEEN '2015-10-30' AND '2015-11-04' 
                GROUP BY 1
                LIMIT 10
          
                
                
                
                SELECT *
                FROM analytics.dw_user_activity
                where user_id = '56331584a2c611bb4b0ed666'
                AND activity_name = 'like_listing'
                
                SELECT *
                FROM  raw_hive.search_events AS R
                WHERE actor_id = '563316c888942b38a20ee677'
                AND   direct_object_executedSearchRequest_query_and_facet_filters_category_feature_0 IS NOT NUll
                ORDER BY at