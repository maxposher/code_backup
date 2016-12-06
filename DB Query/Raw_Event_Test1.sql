


UPDATE dw_users_tmp
SET kyc_flags_current_level = uskycf.cl
,kyc_flags_required_level = uskycf.rl
,kyc_flags_verification_status = uskycf.vst
,kyc_flags_terms_agreed = (CASE WHEN uskycf.toc = 'true' THEN 1 WHEN uskycf.toc = 'false' THEN 0 END)::BOOLEAN
FROM dw_users_tmp u
INNER JOIN raw_mongo.user_stats us on u.user_id = (substring(us._id, 21, 4) || substring(us._id, 5, 16) || substring(us._id, 3, 2) || substring(us._id, 1, 2))
INNER JOIN raw_mongo.user_stats_kycf uskycf ON us.generated_id = uskycf.user_stats_id;
COMMIT;



select L.brand, count(distinct L.listing_id)
FROM analytics.dw_listings AS L
WHERE L.listing_condition = 'ret'
GROUP BY brand


/* COUNT Listing BY Brand that fits condition of pending retail */
select COUNT(distinct _id)
FROM raw_mongo.listings_v2 AS S
INNER JOIN analytics.dw_listings AS L ON L.listing_id = (substring(S._id, 21, 4) || substring(S._id, 5, 16) || substring(S._id, 3, 2) || substring(S._id, 1, 2))
WHERE pcnd = 'ret'
GROUP BY brd

select rtlrst, count(distinct U.user_id)
FROM raw_mongo.user_stats as S
INNER JOIN analytics.dw_users AS U on U.user_id = (substring(S._id, 21, 4) || substring(S._id, 5, 16) || substring(S._id, 3, 2) || substring(S._id, 1, 2))
GROUP BY rtlrst





select rtlrst, COUNT(*)
FROM raw_mongo.user_stats as S
WHERE rtlrstuat IS NOT NULL
GROUP BY rtlrst

ORDER BY rtlrstuat desc
LIMIT 500

select rtlrstuat
FROM raw_mongo.user_stats as S
WHERE rtlrstuat IS NOT NULL
ORDER BY rtlrstuat desc
LIMIT 500


SELECT count(distinct order_id)
FROM analytics.dw_orders AS O
WHERE DATE(O.booked_at) >= '2015-02-01'
AND DATE(O.booked_at) <= '2015-02-28'

SELECT O.order_id
FROM analytics.dw_orders AS O
WHERE date(O.booked_at) >= '2015-02-21'
AND date(O.booked_at) <= '2015-02-'

SELECT *
FROM analytics.dw_orders AS O
WHERE O.buyer_id = '516dc64752ab0615d801be17'
AND O.seller_id = '54cdb1692922dc6cb4132a7a'
AND DATE(O.booked_at) = '2015-02-16'

547263959126440550031007 Missing