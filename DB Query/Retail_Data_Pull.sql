

  SELECT COUNT (distinct "a|id") 
  FROM raw_events.all 
  INNER JOIN analytics.dw_listings As L ON "a|id" = L.seller_id
  WHERE v='u' 
  AND "do|t"='l'
  AND L.listing_condition = 'nwt'
  AND L.created_at >= '2015-09-01'
  AND L.created_at <= '2015-09-02'
  LIMIT 10
  
  SELECT distinct "do|t"
  FROM raw_events.all 
  LIMIT 10
  
  
  
  SELECT date(at),COUNT (distinct L.listing_id) 
  FROM raw_events.all 
  INNER JOIN analytics.dw_listings As L ON "a|id" = L.seller_id
  WHERE v='u' 
  AND "do|t"='l'
  AND L.listing_condition = 'ret'
  AND  date(at) = '2015-09-03'
  GROUP BY date(at)
  

 /* Default for pulling Retail Data */
  SELECT date(at) AS last_update, L.listing_title, L.seller_id,L.brand, L.category, L.listing_price, L.listing_condition
  FROM raw_events.all 
  INNER JOIN analytics.dw_listings As L ON "a|id" = L.seller_id
  WHERE v='u' 
  AND "do|t"='l'
  AND L.listing_condition = 'ret'
  AND  date(at) > '2015-09-20'
  GROUP BY date(at), L.seller_id,L.brand, L.category, L.listing_price, L.listing_title, L.listing_condition
  ORDER BY date(at) 
  
  
