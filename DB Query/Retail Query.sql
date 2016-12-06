
SELECT user_id, first_wholesale_order
FROM analtyics_dw_users 
LEFT JOIN
 
 (SELECT O.buyer_id, min(booked_at) 1st__portal_order
  FROM analytics.dw_orders AS O
  WHERE O.wholesale
  GROUP BY 1) AS A ON user_id = A.buyer_id

LEFT JOIN
 (SELECT O.buyer_id, min(booked_at) 1st_retail_buy
  FROM analytics.dw_orders AS O
  INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
  WHERE L.listing_condition = 'ret'
  GROUP BY 1) AS B ON user_id = B.buyer_id

LEFT JOIN
 (SELECT O.seller_id, min(booked_at) 1st_retail_sell
  FROM  analytics.dw_orders AS O
  INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
  WHERE L.listing_condition = 'ret'
  GROUP BY 1) AS C ON user_id = C.seller_id

 
 (SELECT O.seller_id, min(booked_at) 1st_retail_sell
  FROM  analytics.dw_orders AS O
  INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
  WHERE L.listing_condition = 'ret'
  GROUP BY 1
  
  )




  SELECT   AA.buyer_id, AB.order_id
  FROM       analytics.dw_orders AS AB
  INNER JOIN    
               (SELECT O.buyer_id, min(booked_at) first_time
                FROM analytics.dw_orders AS O
                WHERE O.wholesale
                GROUP BY 1) AS AA on AA.buyer_id = AB.buyer_id 
   WHERE  booked_at = first_time



  --First Retail Sell
  SELECT     AA.seller_id, AB.order_id
  FROM       analytics.dw_orders AS AB
  INNER JOIN 
             (SELECT O.seller_id, min(booked_at) first_time
              FROM  analytics.dw_orders AS O
              INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
              WHERE L.listing_condition = 'ret'
              GROUP BY 1) AS AA on AB.seller_id = AA.seller_id
  WHERE booked_at = first_time

  
  --First Retail Buyer
  SELECT     AA.buyer_id, Ab.order_id
  FROM       analytics.dw_orders AS AB
  INNER JOIN 
             (SELECT O.buyer_id, min(booked_at) first_time
              FROM  analytics.dw_orders AS O
              INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
              WHERE L.listing_condition = 'ret'
              GROUP BY 1) AS AA on AB.buyer_id = AA.buyer_id
  WHERE booked_at = first_time


/**********************************************************/
--First wholesale order

    SELECT U.user_id, first_wholesale, first_retail_sale, first_retail_buy
    From analytics.dw_users AS U
    LEFT JOIN
       (SELECT *
        FROM
        ( SELECT buyer_id, order_id AS first_wholesale,
          ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY booked_at asc) as rn
          FROM analytics.dw_orders
          WHERE wholesale   ) O
        WHERE O.rn = 1) AS A ON U.user_id = A.buyer_id
    LEFT JOIN  
         (SELECT *
          FROM
          ( SELECT O.seller_id, order_id AS first_retail_sale,
            ROW_NUMBER() OVER (PARTITION BY O.seller_id ORDER BY booked_at asc) as rn
            FROM       analytics.dw_orders   AS O 
            INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
            WHERE L.listing_condition = 'ret' 
            AND O.booked_at IS NOT NULL) O
          WHERE O.rn = 1) AS B ON U.user_id = B.seller_id
     LEFT JOIN
        (SELECT *
        FROM
        ( SELECT buyer_id, order_id AS first_retail_buy,
          ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY booked_at asc) as rn
          FROM analytics.dw_orders AS O 
          INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
          WHERE L.listing_condition = 'ret' 
          AND O.booked_at IS NOT NULL) O
        WHERE O.rn = 1) AS C ON U.user_id = C.buyer_id








  SELECT     AA.seller_id, AB.order_id
  FROM       analytics.dw_orders AS AB
  INNER JOIN 
             (SELECT O.seller_id, min(booked_at) first_time
              FROM  analytics.dw_orders AS O
              INNER JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
              WHERE L.listing_condition = 'ret'
              GROUP BY 1) AS AA on AB.seller_id = AA.seller_id
  WHERE booked_at = first_time




   
   
   /* Wholesale Query */
    SELECT DATE(TO_CHAR(
         (CASE
          WHEN EXTRACT(DOW FROM first_w) <= 6
          THEN first_w + (6 - EXTRACT(DOW FROM first_w)) * INTERVAL '1 days'
          ELSE first_w + ((6 + 7) - EXTRACT(DOW FROM first_w)) * INTERVAL '1 days'
          END)  + INTERVAL '-6 days', 'YYYY-MM-DD')) AS "booked_week",
    
    COUNT (distinct U.user_id)
    From analytics.dw_users AS U
    INNER JOIN
       (SELECT *
        FROM
        ( SELECT buyer_id, booked_at AS first_w,
          ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY booked_at asc) as rn
          FROM analytics.dw_orders
          WHERE wholesale   ) O
        WHERE O.rn = 1) AS A ON U.user_id = A.buyer_id
        GROUP BY 1
        ORDER BY 1
   



 