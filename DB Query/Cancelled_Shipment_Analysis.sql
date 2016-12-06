

    SELECT Cdate, COUNT(ID) FROM 
    (
      SELECT Cdate, ID
       FROM
       (select O.buyer_id AS ID, min(date(O.cancelled_on)) AS OC, min(date(O.booked_at)) AS Cdate
        FROM analytics.dw_orders AS O
        WHERE O.order_state = 'cancelled'
        AND O.order_number = 1
        AND O.cancelled_reason = 'delayed_order'
        AND date(O.booked_date) >= '2015-01-01'
        GROUP BY O.buyer_id) AS O
        
        INNER JOIN analytics.dw_user_activity AS UA ON O.ID = UA.user_id
        WHERE  UA.activity_name = 'item_purchased'
        AND date(UA.activity_date)  >= '2015-01-01'
        AND date(UA.activity_date) - date(O.OC) >= 10
        GROUP BY Cdate, ID
        )
        GROUP BY Cdate
        ORDER BY Cdate
        
        
        
        
        SELECT COUNT(distinct O.buyer_id), SUM (O.order_gmv)  
        FROM analytics.dw_orders AS O
        INNER JOIN analytics.dw_users AS U on O.buyer_id = U.user_id
        WHERE date(O.booked_at) - '2015-01-01' <= 90
        AND   date(O.booked_at) > '2015-01-01'
        AND U.date_buyer_activated < '2014-12-15'
        GROUP BY date(O.booked_at)
        
        
        /* 6 Month additional Purchase */
        SELECT COUNT(distinct O.buyer_id), SUM (O.order_gmv)  
        FROM analytics.dw_orders AS O
        WHERE date(O.booked_at) - '2015-01-01' <= 90
        AND   date(O.booked_at) > '2015-01-01'
        AND   O.buyer_id IN
        (
        SELECT A.user_id
        FROM  analytics.dw_user_activity AS A
        WHERE DATE(A.activity_date) = '2015-01-01'
        AND   A.activity_name = 'item_purchased' 
        GROUP BY A.user_id
        ) 
        
        
        select O.booked_date, count(O.order_id)
        FROM analytics.dw_orders AS O
        WHERE O.seller_id = '5074aa93af5ecc501c04366a'
        GROUP BY O.booked_date
        ORDER BY O.booked_date