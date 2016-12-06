

SELECT TO_CHAR(dw_listings.created_at, 'YYYY-MM') AS "dw_listings.created_month",
	count(O.order_id)
FROM analytics.dw_listings AS dw_listings
LEFT JOIN  analytics.dw_order_items AS O ON dw_listings.listing_id = O.listing_id
WHERE dw_listings.is_retail AND ((dw_listings.created_at >= (TIMESTAMP '2016-01-01'))) AND ((CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Available' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Sold_Out' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Deleted_Available_Listing')) AND (((dw_listings.listing_price*.01)*(dw_listings.count_inventory_units)) < 750000) 
AND ((((dw_listings.listing_price*.01)*(dw_listings.count_inventory_units)) < 75000 
AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
AND   date(O.booked_at_time) - date(dw_listings.created_at) + 1 <= 7
GROUP BY 1
ORDER BY 1 DESC
LIMIT 100

/*************************************/








/*****Sold Listings********/
SELECT TO_CHAR(dw_listings.created_at, 'YYYY-MM') AS "dw_listings.created_month",
	count(distinct dw_listings.listing_id)
FROM analytics.dw_listings AS dw_listings
LEFT JOIN  analytics.dw_order_items AS O ON dw_listings.listing_id = O.listing_id
WHERE ((dw_listings.created_at >= (TIMESTAMP '2014-01-01'))) 

AND (dw_listings.listing_price*.01) <= 7500 
AND dw_listings.listing_condition ILIKE 'ret'
--AND  dw_listings.is_ws_brand
--AND dw_listings.is_retail 

AND ((CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Available' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Sold_Out' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Deleted_Available_Listing')) 
AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NOT NULL) = TRUE --Intro, 
AND  date(O.booked_at_time) - date(dw_listings.created_at) + 1 <= 30
GROUP BY 1
ORDER BY 1 DESC
LIMIT 100





AND  (dw_listings.listing_condition IS NULL OR dw_listings.listing_condition ILIKE 'nwt' 
OR dw_listings.listing_condition ILIKE 'ret' OR dw_listings.listing_condition ILIKE 'not^_nwt' ESCAPE '^')


SELECT distinct listing_condition
FROM analytics.dw_listings









SELECT 
	TO_CHAR(dw_listings.created_at, 'YYYY-MM') AS "dw_listings.created_month",
	COALESCE(SUM(CASE WHEN (((dw_listings.parent_listing_id) IS NULL)) THEN dw_listings.count_inventory_units ELSE NULL END), 0) AS "dw_listings.count_manually_uploaded_inventory_units"
FROM analytics.dw_listings AS dw_listings

WHERE((dw_listings.created_at >= (TIMESTAMP '2014-01-01'))) 
AND  dw_listings.listing_condition ILIKE 'ret'
AND (dw_listings.listing_price*.01) <= 7500 

AND  (dw_listings.listing_condition IS NULL OR dw_listings.listing_condition ILIKE 'nwt' 
OR dw_listings.listing_condition ILIKE 'ret' OR dw_listings.listing_condition ILIKE 'not^_nwt' ESCAPE '^')

AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL) = TRUE 
AND ((CASE
      WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
      WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
      WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
      WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
      WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
      WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
      WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Available' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Sold_Out' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Deleted_Available_Listing'))
GROUP BY 1
ORDER BY 1 DESC
LIMIT 500







  select count(*) from analytics.dw_listings AS L
  LEFT JOIN analytics.dw_order_items AS O on l.listing_id = O.listing_id
  where l.is_retail is true --965,784 --965784
  
  
  
  select sum(l.count_inventory_units) from analytics.dw_listings AS L
  LEFT JOIN analytics.dw_order_items AS O on l.listing_id = O.listing_id
  where listing_condition ILIKE 'ret'  
  AND   l.is_retail is false
  --969,946 --969946
  
   select count(*) from analytics.dw_listings where is_retail is true --965,784 --965784





