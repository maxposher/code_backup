


SE


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
     
     
     
     
     SELECT 
     to_char(R."at", 'DD:HH24'),
     R."a|ab",   R."a|id", R."a|t",
     (CASE WHEN (R."v" = 'b')  THEN 1 ELSE 0 END)  AS  Buyer,
     (CASE WHEN (R."v" = 'su')  THEN 1 ELSE 0 END) AS  New_User 
     FROM raw_events.all R
     WHERE R."at" >= '2016-02-09'
     AND   R."a|t" = 'u'
     GROUP BY 1,2,3,4,5,6
     LIMIT 10
     
     
     
     
     /* Join Date */
     
     SELECT to_char("min", 'DD:HH24'), "a|ab", COUNT(distinct "a|id")
     
     FROM
     
     --Join Date
     (SELECT R."do|id", date(R."at") AS Join_date
     FROM raw_events.all R
     WHERE date(R."at") >= '2016-02-10'
     AND   R."a|t" = 'v'
     AND   R."v" = 'su'
     GROUP BY 1,2) AS A

     INNER JOIN
     
     
     /* First Purchase */
    (SELECT R."a|id", R."a|ab", min(R."at")
     FROM   raw_events.all R
     WHERE  date(R."at") >= '2016-02-10'
     AND    R."a|t" = 'u'
     AND    R."v" = 'b'
     AND    R."a|id" IN
                         (SELECT Re."do|id"
                          FROM raw_events.all Re
                          WHERE date(Re."at") >= '2016-02-10'
                          AND   Re."a|t" = 'v'
                          AND   Re."v" = 'su'
                          GROUP BY 1) 
     GROUP BY 1,2     ) AS B on A."do|id" = B."a|id"
     GROUP BY 1, 2
     

     
     
     
     
   
     
     
     
     
