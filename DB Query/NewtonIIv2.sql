

   create table  analytics_scratch.all_new_jan_2016v2  as   
   (
    SELECT U.join_date, U.user_id, U.reg_app, U.date_buyer_activated,
        (CASE WHEN  DATEDIFF(hour, U.joined_at, U.buyer_activated_at) <= 48 THEN 1 ELSE 0 END) AS D1_BA,  
        (CASE WHEN (U.seller_activated_at < U.buyer_activated_at AND U.seller_activated_at <=dateadd(hour,48, U.joined_at)) THEN 1 ELSE 0 END) AS D1_SA,    
     SUM(CASE WHEN (R."v" = 'l' AND (L.inventory_status = 'available' OR L.inventory_status = 'sold_out'))   THEN 1 ELSE 0 END) AS Like_Avail_Listing,
     SUM(CASE WHEN (R."v" = 'l'AND L.inventory_status = 'not_for_sale' )  THEN 1 ELSE 0 END) AS Like_NFS_Listing,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'c')  THEN 1 ELSE 0 END) AS  Post_Comment,
     SUM(CASE WHEN (R."v" = 'p' AND R."do|t" = 'l')  THEN 1 ELSE 0 END) AS  Created_Listing,
     SUM(CASE WHEN (R."v" = 'f' AND R."do|t" = 'b')  THEN 1 ELSE 0 END) AS  Follow_Brand,
     SUM(CASE WHEN (R."v" = 'f' AND R."do|t" = 'u')  THEN 1 ELSE 0 END) AS  Follow_People,
     SUM(CASE WHEN (R."v" = 'sch' AND R."do|f" = 'l') THEN 1 ELSE 0 END) AS Search_Listing
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     LEFT  JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
     WHERE date(U.join_date) BETWEEN '2016-01-01' AND '2016-01-25'
     AND   R."at" <  least(U.buyer_activated_at, cast(date(joined_at + 1) AS timestamp))   
     GROUP BY 1,2,3,4,5,6
     );
     
     
     
     SELECT joined_at, dateadd(day,1, joined_at), cast(date(joined_at + 1) AS timestamp)
     FROM analytics.dw_users
     limit 100
     
     
     
 ---------Last Update (Hopefully) Newton II------------------
        SELECT U.join_date, U.user_id, U.reg_app, U.date_buyer_activated,
        (CASE WHEN  DATEDIFF(hour, U.joined_at, U.buyer_activated_at) <= 48 THEN 1 ELSE 0 END) AS D1_BA,  
        (CASE WHEN (U.seller_activated_at < U.buyer_activated_at AND U.seller_activated_at <=dateadd(hour,48, U.joined_at)) THEN 1 ELSE 0 END) AS D1_SA,    
     SUM(CASE WHEN (R."v" = 'l'   AND (L.inventory_status = 'available' OR L.inventory_status = 'sold_out'))   THEN 1 ELSE 0 END) AS Like_Avail_Listing,
     SUM(CASE WHEN (R."v" = 'l'   AND L.inventory_status = 'not_for_sale' )  THEN 1 ELSE 0 END) AS Like_NFS_Listing,
     SUM(CASE WHEN (R."v" = 'p'   AND R."do|t" = 'c')  THEN 1 ELSE 0 END) AS  Post_Comment,
     SUM(CASE WHEN (R."v" = 'p'   AND R."do|t" = 'l')  THEN 1 ELSE 0 END) AS  Created_Listing,
     SUM(CASE WHEN (R."v" = 'f'   AND R."do|t" = 'b')  THEN 1 ELSE 0 END) AS  Follow_Brand,
     SUM(CASE WHEN (R."v" = 'f'   AND R."do|t" = 'u')  THEN 1 ELSE 0 END) AS  Follow_People,
     SUM(CASE WHEN (R."v" = 'sch' AND R."do|f" = 'l') THEN 1 ELSE 0 END) AS   Search_Listing
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     LEFT  JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
     WHERE date(U.join_date) BETWEEN '2016-01-01' AND '2016-01-25'           --update
     AND   R."at" <  least(U.buyer_activated_at, cast(date(joined_at + 2) AS timestamp))   
     AND   (U.buyer_activated_at IS NULL OR  U.date_buyer_activated - U.join_date BETWEEN 2 AND 6)
     GROUP BY 1,2,3,4,5,6
     
     
     --Discount Buyer 
     SELECT  U.user_id, U.join_date, U.reg_app, Discount_Buyer 
     FROM    analytics.dw_users AS U
             LEFT JOIN (SELECT buyer_id, 
                        CASE WHEN buyer_shipping_fee < 499  THEN 1 ELSE 0 END AS Discount_Buyer
                        FROM      analytics.dw_orders 
                        WHERE     order_number = 1 
                        AND date(booked_at) >= '2015-10-05') AS O ON U.user_id = O.buyer_id       --update                     
     WHERE  date(U.join_date) BETWEEN '2015-10-07' AND '2015-11-07'      --update
   
     
     