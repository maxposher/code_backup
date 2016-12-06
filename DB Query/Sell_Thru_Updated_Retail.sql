

--Inventory
SELECT 
	TO_CHAR(dw_listings.created_at, 'YYYY-MM-DD') AS "created_day",
	COUNT(DISTINCT CASE WHEN (((dw_listings.parent_listing_id) IS NULL)) THEN dw_listings.listing_id ELSE NULL END) AS "count listing"
FROM analytics.dw_listings AS dw_listings
WHERE((dw_listings.created_at >= (TIMESTAMP '2015-10-01'))) 
AND  dw_listings.listing_condition ILIKE 'ret'
--AND  dw_listings.listing_type is null   --Single Item
AND  dw_listings.listing_type = 'multi_item'
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
LIMIT 500


--Multi - Items - Testing
WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null 
AND    L.create_source_type IS NULL )

SELECT *
FROM Big_L
limit 100





--Multi - Items - Testing
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

SELECT *
FROM(
SELECT  TO_CHAR(dw_listings.created_at, 'YYYY-MM-DD') AS "created_day",
        dw_listings.listing_id,
        avg(dw_listings.count_inventory_units ) AS "Inventory_Units",
        COUNT(distinct O.listing_id) AS "Sold"
FROM Big_L AS dw_listings
LEFT JOIN analytics.dw_order_items AS O on O.listing_id = CASE WHEN child is not null then child else dw_listings.listing_id END
WHERE date(dw_listings.created_at) >= '2015-10-01'
AND  date(O.booked_at_time) -   date(created_at) + 1 <= 7
AND  dw_listings.listing_condition ILIKE 'ret'
AND (dw_listings.listing_price*.01) <= 7500 
AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NULL) 
--AND  dw_listings.listing_type is null
AND  dw_listings.listing_type = 'multi_item'
--AND  dw_listings.listing_id = '574f0b934127d016bb0049a3'
AND dw_listings.created_at > '2016-06-01'
GROUP BY 1,2
ORDER BY 1 ASC)
WHERE inventory_units*0.5 <= Sold
limit 100






--Single
WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null
AND    L.create_source_type IS NULL 
AND    L.listing_type is null or L.listing_type = 'multi_item') 

--Sold
SELECT  date(dw_listings.created_at), COUNT(*)
FROM Big_L AS dw_listings
LEFT JOIN analytics.dw_order_items AS O on O.listing_id = CASE WHEN child is not null then child else dw_listings.listing_id END
WHERE date(dw_listings.created_at) >= '2015-10-01'
AND  date(O.booked_at_time) -   date(created_at) + 1 <= 7
AND  dw_listings.listing_condition ILIKE 'ret'
AND (dw_listings.listing_price*.01) <= 7500 
AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NULL) 
--AND  dw_listings.listing_type is null
AND  dw_listings.listing_type = 'multi_item'
GROUP BY 1
ORDER BY 1 ASC





--Default Code
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
        AND  date(O.booked_at_time) -   date(created_at) + 1 <= 7
        AND  dw_listings.listing_condition ILIKE 'ret'
        AND (dw_listings.listing_price*.01) <= 7500 
        AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NULL) 
        --AND  dw_listings.listing_type is null
        --AND  dw_listings.listing_type = 'multi_item'
GROUP BY 1,2
ORDER BY 1 ASC
)
--WHERE inventory_units = Sold
GROUP BY 1
ORDER BY 1






/*Seller Tiers Inventory **/
/******************************/
With A AS (
SELECT 
	TO_CHAR(dw_listings.created_at, 'YYYY-MM-DD') AS "created_day", dw_listings.seller_id, 
	COUNT(DISTINCT CASE WHEN (((dw_listings.parent_listing_id) IS NULL)) THEN dw_listings.listing_id ELSE NULL END) AS "count listing"
FROM analytics.dw_listings AS dw_listings
WHERE((dw_listings.created_at >= (TIMESTAMP '2015-10-01'))) 
AND  dw_listings.listing_condition ILIKE 'ret'
--AND  dw_listings.listing_type is null   --Single Item
--AND  dw_listings.listing_type = 'multi_item'
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
GROUP BY 1, 2
ORDER BY 1 ASC
),
  B AS (
SELECT 
	seller.user_id AS "seller_id",
	CASE WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 0 and 20 THEN '1. 0-20' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 21 and 100 THEN '2. 21-100' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 101 and 500 THEN '3. 101-500' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 501 and 1500 THEN '4. 501-1500' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 1501 and 3000 THEN '5. 1501-3000' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 3001 and 5000 THEN '6. 3001-5000' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 >= 5001 THEN '7. 5001+' 
	     ELSE 'Other' END AS "Result"
FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS seller ON dw_orders.seller_id = seller.user_id
WHERE ((((dw_orders.booked_at) >= ((DATEADD(month,-11, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ))) 
AND (dw_orders.booked_at) < ((DATEADD(month,12, DATEADD(month,-11, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ) )))))) 
AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL 
and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 
'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1
--HAVING SUM((dw_orders.order_gmv*0.01)) <= 20
ORDER BY 2 DESC
)

SELECT A.created_day, B."result", sum(A."count listing")
FROM A LEFT JOIN B on A.seller_id = B.seller_id
GROUP By 1,2
ORDER BY 1, 2






--------------------------------------------------


WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null 
AND    L.create_source_type IS NULL 
AND    (L.listing_type is null or L.listing_type = 'multi_item')
), 
B AS (
SELECT  seller.user_id AS "seller_id",
	CASE WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 0 and 20 THEN '1. 0-20' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 21 and 100 THEN '2. 21-100' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 101 and 500 THEN '3. 101-500' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 501 and 1500 THEN '4. 501-1500' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 1501 and 3000 THEN '5. 1501-3000' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 BETWEEN 3001 and 5000 THEN '6. 3001-5000' 
	     WHEN COALESCE(SUM((dw_orders.order_gmv*0.01)), 0)::float/12 >= 5001 THEN '7. 5001+' 
	     ELSE 'Other' END AS "Result"
FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS seller ON dw_orders.seller_id = seller.user_id
WHERE ((((dw_orders.booked_at) >= ((DATEADD(month,-11, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ))) 
AND (dw_orders.booked_at) < ((DATEADD(month,12, DATEADD(month,-11, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ) )))))) 
AND (((dw_orders.order_gmv*0.01) < 50000 and dw_orders.booked_at IS NOT NULL 
and dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
'iu_status_update_failed', 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 
'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 
'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification') 
AND (DATE(dw_orders.booked_at))!=DATEADD(hour,-8,convert_timezone('US/Pacific',GETDATE()))::DATE) = TRUE)
GROUP BY 1
ORDER BY 2 DESC
)

SELECT created_day, "S_Type", count(listing_id)
  FROM(  
       SELECT  TO_CHAR(dw_listings.created_at, 'YYYY-MM-DD') AS "created_day", B."Result" AS "S_Type",
                dw_listings.listing_id,
                avg(dw_listings.count_inventory_units ) AS "Inventory_Units",
                COUNT(distinct O.listing_id) AS "Sold"
        FROM Big_L AS dw_listings
        LEFT JOIN B on dw_listings.seller_id = B.seller_id
        LEFT JOIN analytics.dw_order_items AS O on O.listing_id = CASE WHEN child is not null then child else dw_listings.listing_id END
        WHERE date(dw_listings.created_at) >= '2015-10-01'
        AND  date(O.booked_at_time) -   date(created_at) + 1 <= 90
        AND  dw_listings.listing_condition ILIKE 'ret'
        AND (dw_listings.listing_price*.01) <= 7500 
        AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NULL) 
        --AND  dw_listings.listing_type is null
        --AND  dw_listings.listing_type = 'multi_item'
        GROUP BY 1,2,3
        ORDER BY 1 ASC
       )
WHERE inventory_units*0.5 <= Sold
GROUP BY 1, 2
ORDER BY 1






















--Yet more testing
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
        AND  date(O.booked_at_time) -   date(created_at) + 1 <= 7
        AND  dw_listings.listing_condition ILIKE 'ret'
        AND (dw_listings.listing_price*.01) <= 7500 
        AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NULL) 
        AND  dw_listings.listing_type is null
        --AND  dw_listings.listing_type = 'multi_item'
GROUP BY 1,2
ORDER BY 1 ASC
)
WHERE inventory_units = Sold
GROUP BY 1
ORDER BY 1

