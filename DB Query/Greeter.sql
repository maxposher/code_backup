



       SELECT COUNT(L.seller_id)
       FROM analytics.dw_listings As L
       INNER JOIN raw_events.all as R ON R."to|id" = L.listing_id
       INNER JOIN analytics.dw_users AS U on L.seller_id = U.user_id
       WHERE L.create_source_type = 'system'
       AND R."v" = 'p' 
       AND R."do|t" = 'c'
       AND date(U.joined_at) BETWEEN '2016-04-01' AND '2016-04-10' 
       LIMIT 10
      
       GROUP BY L.seller_id                  
                                                                                                
    SELECT distinct R."v"
    FROM raw_events.all as R
    LIMIT 10
       
   
  
   