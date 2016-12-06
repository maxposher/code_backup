select distinct user_id from 
(select distinct B.seller_id as user_id
FROM
(SELECT L.listing_id
FROM analytics.dw_listings L
WHERE 
date(L.created_at) ='2015-09-03'
AND L.create_source_type = 'system'
MINUS
select "to|id" as listing_id from raw_events.all
where v='p' and "do|t" = 'c'
and (date(at) = '2015-09-03' OR date(at) = '2015-09-04' )) A,
   analytics.dw_listings B
where A.listing_id = B.listing_id
)
MINUS
(select distinct cohort_with_greetings.user_id
       from

(SELECT L.seller_id as user_id,min(B.at) as first_greeting_time
FROM analytics.dw_listings AS L
JOIN raw_events.all B ON L.listing_id = B."to|id"
WHERE 
DATE(L.created_at) = '2015-09-03'
AND L.create_source_type = 'system'
AND (B.v='p')
AND B."do|t" = 'c'
AND date(L.created_at)='2015-09-03'
AND (date(B.at) = '2015-09-03' OR date(B.at) = '2015-09-04')
GROUp BY L.seller_id) cohort_with_greetings
LEFT JOIN
(SELECT B."a|id" as user_id,B.at as purchase_event_time
FROM 
 raw_events.all B 
WHERE 
 B.v in ('l','f','s','b')
AND (date(B.at) = '2015-09-03' OR date(B.at) = '2015-09-04')
) events
ON cohort_with_greetings.user_id=events.user_id
where events.purchase_event_time < cohort_with_greetings.first_greeting_time
)