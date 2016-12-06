
/* Daily All clicks */
SELECT Date(re.at) as click_date, count(*)
from raw_events.all re 
WHERE re.v='v'
AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
group by 1
order by 1 


/* Daily All clickers */
SELECT Date(re.at) as click_date, count(distinct re."a|id")
from raw_events.all re 
WHERE re.v='v'
     AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
group by 1
order by 1 


/*Unique listing */
SELECT date(re."at"), COUNT (DISTINCT (SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20))))
from raw_events.all re 
INNER JOIN analytics.dw_users us ON re."a|id"=us.user_id
WHERE re.v='v'
AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
AND date(re."at") > '2015-12-05'
GROUP BY 1
ORDER BY 1
    

  
/* Gaurav Code */    
SELECT Date(re.at) as click_date, count(distinct us.user_id)
from raw_events.all re 
INNER JOIN analytics.dw_users us ON re."a|id"=us.user_id
WHERE re.v='v'
     AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
     AND datediff(day, re.at, us.date_buyer_activated) <= 0 AND datediff(day, re.at, us.date_buyer_activated) >= 0
AND us.date_buyer_activated is not null 
group by 1
order by 1 
limit 10




/*The works */
SELECT COUNT (DISTINCT (SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20))))
from raw_events.all re 
INNER JOIN analytics.dw_users us ON re."a|id"=us.user_id
WHERE re.v='v'
AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
AND date(re."at") > '2015-12-05'



/* View before sold */
SELECT date(re."at"), COUNT (distinct O.listing_id) AS Listing_Sold
FROM   raw_events.all re 
INNER JOIN analytics.dw_orders O ON O.listing_id = SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20))
WHERE re.v='v'
AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
AND   re."at" > O.booked_at 
AND   re."at" >= '2015-12-01'
GROUP BY 1
ORDER BY 1



/* O.booked_at the same day */
SELECT date(re."at"), COUNT (distinct O.listing_id) AS Listing_Sold
FROM   raw_events.all re 
INNER JOIN analytics.dw_orders O ON O.listing_id = SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20))
INNER JOIN 
         (SELECT min(date(re."at")) AS click_date, re."a|id" AS user_id   /* D1 clickers */
          FROM   raw_events.all as re 
          WHERE re.v='v'
          AND  re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
          GROUP BY 2) AS O2 ON O.buyer_id = O2.user_id
WHERE re.v='v'
/*AND   O2.click_date = date(O.booked_at) */
/*AND   O.order_number = 1 */
AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
AND   re."at" >= '2015-12-01'
GROUP BY 1
ORDER BY 1


/* number of clicks*/
SELECT date(re."at"), COUNT (*)
FROM   raw_events.all re 
WHERE re.v='v'
AND  re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
AND   re."at" >= '2015-12-01'
GROUP BY 1
ORDER BY 1




SELECT date(re."at"), COUNT (distinct O.listing_id) AS Listing_Sold
FROM   raw_events.all re 
INNER JOIN 
         (SELECT min(date(re."at")) AS click_date, re."a|id" AS user_id   /* D1 clickers */
          FROM   raw_events.all as re 
          WHERE re.v='v'
          AND  re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
          GROUP BY 2) AS O2 ON re."a|id" = O2.user_id
WHERE re.v='v'
/*AND   O2.click_date = date(O.booked_at) */
/*AND   O.order_number = 1 */
AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
AND   re."at" >= '2015-12-01'
GROUP BY 1
ORDER BY 1



/* O.booked_at the same day */
SELECT date(re."at"), COUNT (distinct O.listing_id) AS Listing_Sold
FROM   raw_events.all re 
INNER JOIN analytics.dw_orders O ON O.listing_id = SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20))
INNER JOIN 
         (SELECT min(re."at") AS click_date, re."a|id" AS user_id   /* D1 clickers */
          FROM   raw_events.all as re 
          WHERE re.v='v'
          AND  re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
          GROUP BY 2) AS O2 ON O.buyer_id = O2.user_id
WHERE re.v='v'
/*AND   date(O2.click_date) = date(O.booked_at) */
/*AND   O.order_number = 1 */
AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
/*AND   date(O.booked_at) = date(O2.click_date )*/
AND   re."at" >= '2015-12-01'
GROUP BY 1
ORDER BY 1






SELECT date(re."at"), COUNT (distinct re."a|id")
FROM   raw_events.all re 
INNER JOIN analytics.dw_users U ON re."a|id" = U.user_id
INNER JOIN 
         (SELECT min(re."at") AS click_date, re."a|id" AS user_id   /* D1 clickers */
          FROM   raw_events.all as re 
          WHERE re.v='v'
          AND  re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
          GROUP BY 2) AS O2 ON re."a|id" = O2.user_id
WHERE re.v='v'
/*AND   O2.click_date = date(O.booked_at) */
AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
/*AND   O.booked_at <= dateadd(hour,24, O2.click_date ) */
AND   datediff(day, date(re.at), U.date_buyer_activated) = 0 
AND   u.date_buyer_activated is not null 
GROUP BY 1
ORDER BY 1

/* Unique Buyers */
SELECT Date(re.at) as click_date, COUNT (distinct us.user_id)
from raw_events.all re 
INNER JOIN analytics.dw_users us ON re."a|id"=us.user_id
WHERE re.v='v'
AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
/*AND datediff(day, re.at, us.date_buyer_activated) <= 0 AND datediff(day, re.at, us.date_buyer_activated) >= 0*/
group by 1
order by 1 desc



/*Facebook users */
SELECT     U.user_id, B.username, B.email AS FB_email, U.email AS poshmark_email, B.*
FROM       raw_mongo.users AS A
INNER JOIN analytics.dw_users AS U ON U.user_id = A."_id"
INNER JOIN raw_mongo.users_fb_info AS B ON A.fb_user_id = B.ext_user_id
WHERE      U.date_buyer_activated IS NOT NULL
                     

SELECT     B.ext_user_id
FROM       raw_mongo.users AS A
INNER JOIN analytics.dw_users AS U ON U.user_id = A."_id"
INNER JOIN raw_mongo.users_fb_info AS B ON A.fb_user_id = B.ext_user_id
WHERE      U.date_buyer_activated IS NULL
                     
                     
                     
        
                     
/* Default O.booked_at the same day */
SELECT date(re."at"), COUNT (distinct O.listing_id) AS Listing_Sold
FROM   raw_events.all re 
INNER JOIN analytics.dw_orders O ON O.listing_id = SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20))
INNER JOIN 
         (SELECT min(re."at") AS click_date, re."a|id" AS user_id   /* D1 clickers */
          FROM   raw_events.all as re 
          WHERE re.v='v'
          AND  re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
          GROUP BY 2) AS O2 ON O.buyer_id = O2.user_id
WHERE re.v='v'
AND   O.order_number = 1 
AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
/*AND   O.booked_at <= dateadd(hour,24, O2.click_date ) */
AND   date(O.booked_at) = date(O2.click_date )
AND   re."at" >= '2015-12-01'
GROUP BY 1
ORDER BY 1



SELECT date(re."at"), COUNT (distinct O.buyer_id)
FROM   raw_events.all re 
INNER JOIN analytics.dw_orders O ON O.listing_id = SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20))
INNER JOIN 
         (SELECT min(re."at") AS click_date, re."a|id" AS user_id   /* D1 clickers */
          FROM   raw_events.all as re 
          WHERE re.v='v'
          AND  re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
          GROUP BY 2) AS O2 ON O.buyer_id = O2.user_id
WHERE re.v='v'
AND   O.order_number = 1 
AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
/*AND   O.booked_at <= dateadd(hour,24, O2.click_date ) */
AND   date(O.booked_at) = date(O2.click_date )
AND   re."at" >= '2015-12-01'
GROUP BY 1
ORDER BY 1




/*far right of the spreadsheet */
SELECT (date(re."at")), COUNT (distinct re."a|id")
FROM   raw_events.all re 
INNER JOIN analytics.dw_orders AS O ON O.buyer_id = re."a|id"
WHERE re.v='v'
/*AND   O.order_number = 1 */
AND   re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
/*AND   O.booked_at <= dateadd(hour,24, O2.click_date ) */
AND   date(O.booked_at) = date(re."at" )
AND   re."at" >= '2015-12-01'
GROUP BY 1
ORDER BY 1



                          SELECT COUNT (distinct B.email)
                          FROM   raw_mongo.users AS A
                          INNER JOIN analytics.dw_users AS U ON U.user_id = A."_id"
                          INNER JOIN raw_mongo.users_fb_info AS B ON A.fb_user_id = B.ext_user_id
                          WHERE U.date_buyer_activated IS NULL





SUBSTRING(re."do|u", 20, (CHARINDEX('?', re."do|u") -20))



SELECT re.*
FROM   raw_events.all re 
WHERE  re.v='v'
AND    re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%'
AND    re."at" >= '2015-12-01'
limit 100



SELECT re."do|u", CHARINDEX('26id%', re."do|u") 
from raw_events.all re 
WHERE re.v='v'
AND re."r|t" = 'ea' AND re."do|u" LIKE '%fb_dpa%' AND re."do|u" LIKE '%26id%'

limit 10

from "26id" to "%" is the id



                            