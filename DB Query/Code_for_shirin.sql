--Denoniator
--Inventory
SELECT 
	TO_CHAR(dw_listings.created_at, 'YYYY-MM-DD') AS "created_day",
	COUNT(DISTINCT CASE WHEN (((dw_listings.parent_listing_id) IS NULL)) THEN dw_listings.listing_id ELSE NULL END) AS "count listing"
FROM analytics.dw_listings AS dw_listings
WHERE((dw_listings.created_at >= (TIMESTAMP '2015-10-01')))
AND  dw_listings.listing_condition ILIKE 'ret'
AND (dw_listings.listing_price*.01) <= 7500 
AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL) 
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
ORDER BY 1 ASC




--Sold Analysis - Numerator
WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null 
AND    L.create_source_type IS NULL 
AND    (L.listing_type is null or L.listing_type = 'multi_item')
) 
SELECT created_day, count(listing_id)
FROM(  SELECT  TO_CHAR(dw_listings.created_at, 'YYYY-MM-DD') AS "created_day",
                dw_listings.listing_id,
                avg(dw_listings.count_inventory_units ) AS "Inventory_Units",
                COUNT(distinct O.listing_id) AS "Sold"
        FROM Big_L AS dw_listings
        LEFT JOIN analytics.dw_order_items AS O on O.listing_id = CASE WHEN child is not null then child else dw_listings.listing_id END
        WHERE date(dw_listings.created_at) >= '2015-10-01'
        AND  date(O.booked_at_time) -   date(created_at) + 1 <= 90  --logic for date
        AND  dw_listings.listing_condition ILIKE 'ret'
        AND (dw_listings.listing_price*.01) <= 7500 
        AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NULL) 
GROUP BY 1,2
ORDER BY 1 ASC
)
WHERE inventory_units*0.5 <= Sold   -- logic for 50%  comment out for 1 sale
GROUP BY 1
ORDER BY 1