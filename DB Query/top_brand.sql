



     SELECT date(R."at"), L.brand, COUNT(distinct U.user_id) 
     FROM analytics.dw_users AS U
     INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
     LEFT  JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
     WHERE  date(R."at") BETWEEN '2016-02-01' AND '2016-02-29'
     AND    R."v"    = 'f' 
     AND    R."do|t" = 'b'
     AND    L.brand in ('nike')
     GROUP By 1, 2


     SELECT  date(R."at"), R."do|n", COUNT(R."a|id")
     FROM    raw_events.all as R 
     WHERE   date(R."at") BETWEEN '2016-02-01' AND '2016-02-29'
     AND     R."v"    = 'f' 
     AND     R."do|t" = 'b'
     AND     R."do|n" in ('T&J Designs', 'Three Bird Nest', 'Function & Fringe')
     GROUP BY 1,2
     ORDER BY 1
     
     LIMIT 100
     
     GROUP By 1, 2