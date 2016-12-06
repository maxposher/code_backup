

SELECT DATE(dw_listings.created_at) AS "dw_listings.created_date",
        dw_listings.department,
	dw_order_items.size_set,
	COUNT(distinct dw_listings.listing_id) AS "dw_listings.count_listings"
FROM analytics.dw_listings AS dw_listings
LEFT JOIN analytics.dw_order_items AS dw_order_items ON dw_order_items.listing_id = dw_listings.listing_id 
AND (( dw_listings.listing_price*.01) <= 75000 
AND (   dw_listings.create_source_type IS NULL  OR  dw_listings.parent_listing_id IS NOT NULL)) = TRUE
WHERE (dw_listings.created_at >= TIMESTAMP '2013-01-01') AND ((CASE
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
END ILIKE 'Available' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Deleted_Available_Listing')) AND (NOT COALESCE(CASE
WHEN dw_listings.listing_type = 'multi_item' THEN 'Multi_Item' 
WHEN dw_listings.listing_type = 'intro' THEN 'Intro' 
WHEN dw_listings.listing_type = 'child_item' THEN 'Sold_Multi_Item_Listing' 
ELSE 'Single_Item' 
END = 'Multi_Item', FALSE)) AND (((dw_listings.listing_price*.01) <= 75000 AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
GROUP BY 1, 2, 3
ORDER BY 1 
LIMIT 5000