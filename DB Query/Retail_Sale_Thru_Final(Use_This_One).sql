/*
-nwt     -resale
-not_nwt -resale
-ret     -retail
-" "     -resale
-wlsl    -wholesale portal
*/
-- is_ws_brand is the brand carries in wholesale portal

/*
A single item listing has no parent.  A child listing is created when a multi-item listing is sold.
To count total inventory...count all the parent listing and count_inventory_units.  The setup 
is all parent and child listings currently.
ILIKE does matter
*/



/***
Inventory Analysis
**/
SELECT 
	TO_CHAR(dw_listings.created_at, 'YYYY-MM') AS "dw_listings.created_month",
	COALESCE(SUM(CASE WHEN (((dw_listings.parent_listing_id) IS NULL)) THEN dw_listings.count_inventory_units ELSE NULL END), 0) AS "dw_listings.count_manually_uploaded_inventory_units"
FROM analytics.dw_listings AS dw_listings
WHERE((dw_listings.created_at >= (TIMESTAMP '2014-01-01'))) 
--AND dw_listings.listing_condition ILIKE ('ret')
AND (dw_listings.listing_price*.01) <= 7500 
--AND  dw_listings.is_ws_brand
AND ((((dw_listings.listing_condition) IS NULL) OR dw_listings.listing_condition ILIKE 'not^_nwt' ESCAPE '^' OR dw_listings.listing_condition ILIKE 'nwt'))
AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NOT NULL) = TRUE
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




/***
Item Sold
**/
SELECT TO_CHAR(dw_listings.created_at, 'YYYY-MM') AS "dw_listings.created_month",
	count(O.listing_id)
FROM analytics.dw_listings AS dw_listings
LEFT JOIN  analytics.dw_order_items AS O ON dw_listings.listing_id = O.listing_id
LEFT JOIN  analytics.dw_listings AS parent on dw_listings.parent_listing_id = parent.listing_id
WHERE ((dw_listings.created_at >= (TIMESTAMP '2014-01-01'))) 
AND (dw_listings.listing_price*.01) <= 7500
AND dw_listings.listing_condition ILIKE ('ret') 
--AND ((((dw_listings.listing_condition) IS NULL) OR dw_listings.listing_condition ILIKE 'not^_nwt' ESCAPE '^' OR dw_listings.listing_condition ILIKE 'nwt'))
AND  dw_listings.is_ws_brand
--AND dw_listings.is_retail is true
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
AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NOT NULL) = TRUE 
AND  (CASE WHEN dw_listings.parent_listing_id IS NULL THEN date(O.booked_at_time) - date(dw_listings.created_at) + 1 <= 7
                                                     ELSE date(O.booked_at_time) - date(parent.created_at) + 1 <= 7 END)
GROUP BY 1
ORDER BY 1 DESC
LIMIT 100








SELECT count(listing_id)
from   analytics.dw_listings
WHERE  parent_listing_id IS NULL
AND is_retail
--AND    listing_condition = 'ret'
limit 10


SELECT *
from   analytics.dw_listings
WHERE  parent_listing_id IS NULL

limit 10




/*****Sold Listings********/
SELECT TO_CHAR(dw_listings.created_at, 'YYYY-MM') AS "dw_listings.created_month",
	count(distinct dw_listings.listing_id)
FROM analytics.dw_listings AS dw_listings
LEFT JOIN  analytics.dw_order_items AS O ON dw_listings.listing_id = O.listing_id
WHERE ((dw_listings.created_at >= (TIMESTAMP '2014-01-01'))) 

AND (dw_listings.listing_price*.01) <= 7500 
--AND dw_listings.listing_condition ILIKE 'ret'
--AND  dw_listings.is_ws_brand
AND dw_listings.is_retail 

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
GROUP BY 1
ORDER BY 1 DESC
LIMIT 100





