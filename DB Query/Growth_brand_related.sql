
/*Growth: Listing by brand and categories */
SELECT *
FROM (

  SELECT dw_listings_category_v2, rank() over (partition by dw_listings_category_v2  order by dw_orders_count_orders desc) AS ranking, listing_details_brand, dw_orders_count_orders

FROM(     

SELECT 
	initcap(listing_details.brand) AS "listing_details_brand",
	dw_listings.category_v2 AS "dw_listings_category_v2",
	COUNT(DISTINCT dw_orders.order_id) AS "dw_orders_count_orders"
FROM analytics.dw_order_items AS dw_order_items
LEFT JOIN analytics.dw_orders AS dw_orders ON dw_order_items.order_id = dw_orders.order_id
LEFT JOIN analytics.dw_listings AS dw_listings ON dw_order_items.listing_id = dw_listings.listing_id
LEFT JOIN analytics.dw_listings AS listing_details ON dw_order_items.listing_id = listing_details.listing_id AND ( listing_details.create_source_type IS NULL OR  listing_details.parent_listing_id IS NOT NULL )

WHERE (dw_order_items.sale_number = 1) 
AND ((((dw_orders.booked_at) >= (timestamp '2016-04-01') AND (dw_orders.booked_at) < (timestamp '2016-05-01')))) 
AND ((dw_order_items.order_gmv < 50000 * 100 
and dw_order_items.booked_at_time IS NOT NULL and dw_orders.order_state NOT IN ('ab_capture_failed')))
GROUP BY 1,2)
)
WHERE ranking <= 25



SELECT *
FROM (
  SELECT category_v2, rank() over (partition by category_v2  order by count_listings desc) AS O, brand, count_listings
FROM(     
        SELECT dw_listings.category_v2 AS "category_v2", initcap(dw_listings.brand) AS "brand", COUNT(distinct dw_listings.listing_id) AS "count_listings"
        FROM analytics.dw_listings AS dw_listings
        WHERE (((date(dw_listings.created_at) >= ('2015-05-01') AND date(dw_listings.created_at) <= ('2015-07-31'))))
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
        END ILIKE 'Sold_Out')) AND (dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)
        GROUP BY 1,2)
        )
 WHERE O <= 25



        SELECT dw_listings.category_v2 AS "category_v2", dw_listings.brand AS "brand", COUNT(*) AS "count_listings"
        FROM analytics.dw_listings AS dw_listings
        WHERE ((((dw_listings.created_at) >= (timestamp '2016-04-01') AND (dw_listings.created_at) < (timestamp '2016-05-01'))))
        AND initcap(dw_listings.brand) ILIKE  'Coach' 
        AND ((dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') OR dw_listings.inventory_status = 'sold_out' )
        AND (dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)
        AND dw_listings.category_v2 = 'Accessories'
        GROUP BY 1,2
        HAVING COUNT(*) > 1000
        
        
        
           SELECT dw_listings.category_v2 AS "category_v2", initcap(dw_listings.brand) AS "brand", COUNT(*) AS "count_listings"
        FROM analytics.dw_listings AS dw_listings
        WHERE ((((dw_listings.created_at) >= (timestamp '2016-04-01') AND (dw_listings.created_at) < (timestamp '2016-05-01'))))
       /* AND initcap(dw_listings.brand) ILIKE  'Coach' */
        AND ((dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') OR dw_listings.inventory_status = 'sold_out' )
        AND (dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)
        AND dw_listings.category_v2 = 'Accessories'
        GROUP BY 1,2
             

SELECT 
	initcap(dw_listings.brand) AS "dw_listings.brand",
	dw_listings.category_v2 AS "dw_listings.category_v2",
	COUNT(*) AS "dw_listings.count_listings"
FROM analytics.dw_listings AS dw_listings

WHERE ((initcap(dw_listings.brand) ILIKE 'coach' OR initcap(dw_listings.brand) ILIKE 'Coach')) AND ((((dw_listings.created_at) >= (timestamp '2016-04-01') AND (dw_listings.created_at) < (timestamp '2016-05-01')))) AND ((CASE
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
END ILIKE 'Sold_Out')) AND (dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)
GROUP BY 1,2
