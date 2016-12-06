
/* How to pull retail data */
UPDATE dw_users_tmp
SET kyc_flags_current_level = uskycf.cl
,kyc_flags_required_level = uskycf.rl
,kyc_flags_verification_status = uskycf.vst
,kyc_flags_terms_agreed = (CASE WHEN uskycf.toc = 'true' THEN 1 WHEN uskycf.toc = 'false' THEN 0 END)::BOOLEAN
FROM dw_users_tmp u
INNER JOIN raw_mongo.user_stats us on u.user_id = (substring(us._id, 21, 4) || substring(us._id, 5, 16) || substring(us._id, 3, 2) || substring(us._id, 1, 2))
INNER JOIN raw_mongo.user_stats_kycf uskycf ON us.generated_id = uskycf.user_stats_id;
COMMIT;




Select rtlrstuat, (substring(_id, 21, 4) || substring(_id, 5, 16) || substring(_id, 3, 2) || substring(_id, 1, 2)), rtlrst
From raw_mongo.user_stats
WHERE rtlrstuat IS NOT NULL
AND rtlrst = 'c'
ORDER BY rtlrstuat
limit 10


Select L.seller_id, count(distinct L.listing_id)
From raw_mongo.user_stats AS R INNER JOIN analytics.dw_listings AS L 
on (substring(R._id, 21, 4) || substring(R._id, 5, 16) || substring(R._id, 3, 2) || substring(R._id, 1, 2)) = L.seller_id 
WHERE rtlrstuat IS NOT NULL
AND L.listing_condition = 'ret'
AND R.rtlrst = 'c'
GROUP BY L.seller_id
HAVING count(distinct L.listing_id) > 20


select * 
from analytics.dw_listings 
LIMIT 100

SELECT
   CASE
      WHEN (date_trunc('week',cancelled_on ) ) >= (date_trunc('week', DATEADD('week', 8, booked_at))) THEN 13 AS Cancell
      WHEN cancelled_on IS NOT NULL THEN datediff('week', booked_at, cancelled_on)
      WHEN (date_trunc('week',received_at ) ) >= (date_trunc('week', DATEADD('week', 13, booked_at))) THEN 13 AS Received
      WHEN received_at IS NOT NULL THEN datediff('week',  booked_at, received_at)
      END
FROM analytics.dw_orders
LIMIT 100


SELECT
   
   CASE  WHEN received_at IS NOT NULL THEN 'MeowMeow' + CAST(datediff('week',  booked_at, received_at) AS CHAR) END 
FROM analytics.dw_orders
LIMIT 500





SELECT date(DD), COUNT(distinct ID)
FROM(
Select rtlrstuat AS DD, (substring(_id, 21, 4) || substring(_id, 5, 16) || substring(_id, 3, 2) || substring(_id, 1, 2)) AS ID, rtlrst
From raw_mongo.user_stats
WHERE rtlrstuat IS NOT NULL
AND rtlrst = 'c'
ORDER BY rtlrstuat
)
GROUP BY 1
ORDER BY 1
LIMIT 50

