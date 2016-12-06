

/* Part I */
/******************************************************************************************************************************************************************************/

WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null) 

/* Sold Item */
SELECT 
        TO_CHAR(DATEADD(day,(0 - EXTRACT(DOW FROM dw_listings.created_at)::integer), dw_listings.created_at ), 'YYYY-MM-DD') AS "dw_listings.created_week",
	/*DATE(dw_listings.created_at) AS "dw_listings.created_date",*/
	dw_listings.category_v2 AS "dw_listings.category_v2",
	CASE
        WHEN (dw_listings.listing_price*.01) < 0 THEN 'Below 0' 
        WHEN (dw_listings.listing_price*.01) >= 0 AND (dw_listings.listing_price*.01) < 25 THEN '0 to 24' 
        WHEN (dw_listings.listing_price*.01) >= 25 AND (dw_listings.listing_price*.01) < 50 THEN '25 to 49' 
        WHEN (dw_listings.listing_price*.01) >= 50 AND (dw_listings.listing_price*.01) < 100 THEN '50 to 99' 
        WHEN (dw_listings.listing_price*.01) >= 100 THEN '100 or Above' 
        ELSE 'Undefined' END AS "dw_listings.price_tier_max",
	COUNT(distinct O.listing_id) AS "dw_listings.count_listings"
FROM Big_L AS dw_listings
INNER JOIN analytics.dw_order_items AS O ON O.listing_id = CASE WHEN child IS NOT NULL THEN child ELSE dw_listings.listing_id  END
WHERE ((((dw_listings.created_at) >= ((TIMESTAMP '2015-01-01')) AND (dw_listings.created_at) < ((TIMESTAMP '2016-06-01'))))) AND (CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END IN ('Available','Sold_Out', 'Deleted_Available_Listing')) AND (((dw_listings.listing_price*.01) < 75000 AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
AND listing_condition  in( 'nwt', 'ret')
AND is_popular_brand = FALSE
AND wholesale IS NULL
AND  initcap(dw_listings.brand) IN 
     ('Adia Kibur', 'Alicia Jean', 'Ananda Design', 'Anitanja', 'April Spirit', 'Karen Zambos', 'Atid Clothing', 'Banjanan', 'Billeno',
       'Bellino Clothing','Bellino ', 'Beltshazzar Jewels ', 'Beltshazzar Jewelry', 'Beora', 'Beora Jewelry', 'Boho Gypsy Sisters',
       'Bun Maternity', 'C''Est Ã‡a New York', 'C''Est  Ã‡a New York', 'Classic Woman/Romeo Romeo', 'Colette Malouf',
       'Diana Broussard', 'E.Kammeyer Accessories', 'Electric Yoga', 'Emily Keller', 'Emily Hsu Designs',
       'Empowered By You', 'Farah Jewlry', 'Farah Jewelry', 'Farah Jewlery', 'Fashionomics ', 'Flash Tattoos', 'Function & Fringe', 'Free People', 'Half United', 'Hues Of Ego',
       'Ire Fashion ', 'Jessica Elliot', 'Karen Zambos', 'Ketzali', 'Mila', 'Knighbury',
       'Leota', 'Lia Larrea', 'Loup', 'Loveriche ', 'Miilla', 'Mint Pear Beauty', 'Mintpear', 'Mintpearbeauty', 'Frnch', 'Mur Mur',
       'Mono', 'Monoreno', 'Mur Mur By Monoreno', 'Bellino', 'Mooncollection', 'Moon Collection', 'Muse Refined',
       'Etoileby Muse Refined', 'Etoile By Muse Refined', 'Etiole By Muse Refined', 'Etoile Bu Muse Refined', 'Naked Truth',
       'Naked Truth Lifestyle','Nisolo','Nytt','October Love','Pastels Clothing','Pastels','Peony And Moss','Prince Peter Collection','Lulumari','Lush',
       'Timing','Paper Crane','Gilli','Under Skies','Catch Me ','Blu Pepper','Joa','Relished','Cotton Daisy Apparel','Jella Couture ','Aryeh','Debut','Staccato','Sadie & Sage',
       'Salt Lake Clothing','Salt Lake Clothing Co','Salt Lake Clithing Co.','Salt Lake Clothing Co. ','American Apparel','Satya Jewelry','Vida','Wila','Shushop','Snob Essentials', 'Sofrancisco',
       'Style Mafia','Sunahara Jewelry', 'Sunahara Malibu','Sunahara Jeweley','Kate Spade','T&J Designs', 'T+J Designs', 'Tanya-B','Tea & Cup', 'Tea N Cup', 'Tea Na D Group',
       'Tea And Cup ','Pol','Three Bird Nest','Angie','22nd Street','Lolli','Love Fashion','Twilight Gypsy Collective','Valleau Apparel','Very J','Whitney Eve','Woman''S Touch Apparel')
AND DATE(O.booked_at_time) - DATE(dw_listings.created_at) + 1 <= 30
AND '2016-06-01' - date(dw_listings.created_at) + 1 >= 30
GROUP BY 1,2,3
ORDER BY 1






/**********************Total Listing - Retail ******************/

WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null) 


SELECT 
        TO_CHAR(DATEADD(day,(0 - EXTRACT(DOW FROM dw_listings.created_at)::integer), dw_listings.created_at ), 'YYYY-MM-DD') AS "dw_listings.created_week",
	/*DATE(dw_listings.created_at) AS "dw_listings.created_date",*/
	dw_listings.category_v2 AS "dw_listings.category_v2",
	
	CASE
        WHEN (dw_listings.listing_price*.01) < 0 THEN 'Below 0' 
        WHEN (dw_listings.listing_price*.01) >= 0 AND (dw_listings.listing_price*.01) < 25 THEN '0 to 24' 
        WHEN (dw_listings.listing_price*.01) >= 25 AND (dw_listings.listing_price*.01) < 50 THEN '25 to 49' 
        WHEN (dw_listings.listing_price*.01) >= 50 AND (dw_listings.listing_price*.01) < 100 THEN '50 to 99' 
        WHEN (dw_listings.listing_price*.01) >= 100 THEN '100 or Above' 
        ELSE 'Undefined' END AS "dw_listings.price_tier_max",
	SUM(count_inventory_units) AS "dw_listings.count_listings"
FROM Big_L AS dw_listings
WHERE ((((dw_listings.created_at) >= ((TIMESTAMP '2015-01-01')) AND (dw_listings.created_at) < ((TIMESTAMP '2016-06-01'))))) AND (CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END IN ('Available','Sold_Out', 'Deleted_Available_Listing')) AND (((dw_listings.listing_price*.01) < 75000 AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
AND listing_condition  in( 'nwt', 'ret')
AND is_popular_brand = FALSE
AND wholesale IS NULL
AND  initcap(dw_listings.brand) IN 
     ('Adia Kibur', 'Alicia Jean', 'Ananda Design', 'Anitanja', 'April Spirit', 'Karen Zambos', 'Atid Clothing', 'Banjanan', 'Billeno',
       'Bellino Clothing','Bellino ', 'Beltshazzar Jewels ', 'Beltshazzar Jewelry', 'Beora', 'Beora Jewelry', 'Boho Gypsy Sisters',
       'Bun Maternity', 'C''Est Ã‡a New York', 'C''Est  Ã‡a New York', 'Classic Woman/Romeo Romeo', 'Colette Malouf',
       'Diana Broussard', 'E.Kammeyer Accessories', 'Electric Yoga', 'Emily Keller', 'Emily Hsu Designs',
       'Empowered By You', 'Farah Jewlry', 'Farah Jewelry', 'Farah Jewlery', 'Fashionomics ', 'Flash Tattoos', 'Function & Fringe', 'Free People', 'Half United', 'Hues Of Ego',
       'Ire Fashion ', 'Jessica Elliot', 'Karen Zambos', 'Ketzali', 'Mila', 'Knighbury',
       'Leota', 'Lia Larrea', 'Loup', 'Loveriche ', 'Miilla', 'Mint Pear Beauty', 'Mintpear', 'Mintpearbeauty', 'Frnch', 'Mur Mur',
       'Mono', 'Monoreno', 'Mur Mur By Monoreno', 'Bellino', 'Mooncollection', 'Moon Collection', 'Muse Refined',
       'Etoileby Muse Refined', 'Etoile By Muse Refined', 'Etiole By Muse Refined', 'Etoile Bu Muse Refined', 'Naked Truth',
       'Naked Truth Lifestyle','Nisolo','Nytt','October Love','Pastels Clothing','Pastels','Peony And Moss','Prince Peter Collection','Lulumari','Lush',
       'Timing','Paper Crane','Gilli','Under Skies','Catch Me ','Blu Pepper','Joa','Relished','Cotton Daisy Apparel','Jella Couture ','Aryeh','Debut','Staccato','Sadie & Sage',
       'Salt Lake Clothing','Salt Lake Clothing Co','Salt Lake Clithing Co.','Salt Lake Clothing Co. ','American Apparel','Satya Jewelry','Vida','Wila','Shushop','Snob Essentials', 'Sofrancisco',
       'Style Mafia','Sunahara Jewelry', 'Sunahara Malibu','Sunahara Jeweley','Kate Spade','T&J Designs', 'T+J Designs', 'Tanya-B','Tea & Cup', 'Tea N Cup', 'Tea Na D Group',
       'Tea And Cup ','Pol','Three Bird Nest','Angie','22nd Street','Lolli','Love Fashion','Twilight Gypsy Collective','Valleau Apparel','Very J','Whitney Eve','Woman''S Touch Apparel')
GROUP BY 1,2,3
ORDER BY 1


/* Part II */
/******************************************************************************************************************************************************************************/
WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null) 

SELECT 
        TO_CHAR(DATEADD(day,(0 - EXTRACT(DOW FROM dw_listings.created_at)::integer), dw_listings.created_at ), 'YYYY-MM-DD') AS "dw_listings.created_week",
	/*DATE(dw_listings.created_at) AS "dw_listings.created_date",*/
	dw_listings.category_v2 AS "dw_listings.category_v2",
	CASE
        WHEN (dw_listings.listing_price*.01) < 0 THEN 'Below 0' 
        WHEN (dw_listings.listing_price*.01) >= 0 AND (dw_listings.listing_price*.01) < 25 THEN '0 to 24' 
        WHEN (dw_listings.listing_price*.01) >= 25 AND (dw_listings.listing_price*.01) < 50 THEN '25 to 49' 
        WHEN (dw_listings.listing_price*.01) >= 50 AND (dw_listings.listing_price*.01) < 100 THEN '50 to 99' 
        WHEN (dw_listings.listing_price*.01) >= 100 THEN '100 or Above' 
        ELSE 'Undefined' END AS "dw_listings.price_tier_max",
	COUNT(distinct O.listing_id) AS "dw_listings.count_listings"
FROM Big_L AS dw_listings
INNER JOIN analytics.dw_order_items AS O ON O.listing_id = CASE WHEN child IS NOT NULL THEN child ELSE dw_listings.listing_id  END
WHERE ((((dw_listings.created_at) >= ((TIMESTAMP '2015-01-01')) AND (dw_listings.created_at) < ((TIMESTAMP '2016-06-01'))))) AND (CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END IN ('Available','Sold_Out', 'Deleted_Available_Listing')) AND (((dw_listings.listing_price*.01) < 75000 AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
AND listing_condition  in( 'ret')
AND is_popular_brand = FALSE
AND wholesale IS NULL
AND  initcap(dw_listings.brand) NOT IN 
     ('Adia Kibur', 'Alicia Jean', 'Ananda Design', 'Anitanja', 'April Spirit', 'Karen Zambos', 'Atid Clothing', 'Banjanan', 'Billeno',
       'Bellino Clothing','Bellino ', 'Beltshazzar Jewels ', 'Beltshazzar Jewelry', 'Beora', 'Beora Jewelry', 'Boho Gypsy Sisters',
       'Bun Maternity', 'C''Est Ã‡a New York', 'C''Est  Ã‡a New York', 'Classic Woman/Romeo Romeo', 'Colette Malouf',
       'Diana Broussard', 'E.Kammeyer Accessories', 'Electric Yoga', 'Emily Keller', 'Emily Hsu Designs',
       'Empowered By You', 'Farah Jewlry', 'Farah Jewelry', 'Farah Jewlery', 'Fashionomics ', 'Flash Tattoos', 'Function & Fringe', 'Free People', 'Half United', 'Hues Of Ego',
       'Ire Fashion ', 'Jessica Elliot', 'Karen Zambos', 'Ketzali', 'Mila', 'Knighbury',
       'Leota', 'Lia Larrea', 'Loup', 'Loveriche ', 'Miilla', 'Mint Pear Beauty', 'Mintpear', 'Mintpearbeauty', 'Frnch', 'Mur Mur',
       'Mono', 'Monoreno', 'Mur Mur By Monoreno', 'Bellino', 'Mooncollection', 'Moon Collection', 'Muse Refined',
       'Etoileby Muse Refined', 'Etoile By Muse Refined', 'Etiole By Muse Refined', 'Etoile Bu Muse Refined', 'Naked Truth',
       'Naked Truth Lifestyle','Nisolo','Nytt','October Love','Pastels Clothing','Pastels','Peony And Moss','Prince Peter Collection','Lulumari','Lush',
       'Timing','Paper Crane','Gilli','Under Skies','Catch Me ','Blu Pepper','Joa','Relished','Cotton Daisy Apparel','Jella Couture ','Aryeh','Debut','Staccato','Sadie & Sage',
       'Salt Lake Clothing','Salt Lake Clothing Co','Salt Lake Clithing Co.','Salt Lake Clothing Co. ','American Apparel','Satya Jewelry','Vida','Wila','Shushop','Snob Essentials', 'Sofrancisco',
       'Style Mafia','Sunahara Jewelry', 'Sunahara Malibu','Sunahara Jeweley','Kate Spade','T&J Designs', 'T+J Designs', 'Tanya-B','Tea & Cup', 'Tea N Cup', 'Tea Na D Group',
       'Tea And Cup ','Pol','Three Bird Nest','Angie','22nd Street','Lolli','Love Fashion','Twilight Gypsy Collective','Valleau Apparel','Very J','Whitney Eve','Woman''S Touch Apparel')
AND DATE(O.booked_at_time) - DATE(dw_listings.created_at) + 1 <= 30
AND '2016-06-01' - date(dw_listings.created_at) + 1 >= 30
GROUP BY 1,2,3
ORDER BY 1



/**********************Total Listing - Retail ******************/
WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
/*WHERE  L.parent_listing_id is null*/) 

SELECT  TO_CHAR(DATEADD(day,(0 - EXTRACT(DOW FROM dw_listings.created_at)::integer), dw_listings.created_at ), 'YYYY-MM-DD') AS "dw_listings.created_week",
	/*DATE(dw_listings.created_at) AS "dw_listings.created_date",*/
	dw_listings.category_v2 AS "dw_listings.category_v2",
  CASE  WHEN (dw_listings.listing_price*.01) < 0 THEN 'Below 0' 
        WHEN (dw_listings.listing_price*.01) >= 0 AND (dw_listings.listing_price*.01) < 25 THEN '0 to 24' 
        WHEN (dw_listings.listing_price*.01) >= 25 AND (dw_listings.listing_price*.01) < 50 THEN '25 to 49' 
        WHEN (dw_listings.listing_price*.01) >= 50 AND (dw_listings.listing_price*.01) < 100 THEN '50 to 99' 
        WHEN (dw_listings.listing_price*.01) >= 100 THEN '100 or Above' 
        ELSE 'Undefined' END AS "dw_listings.price_tier_max",
	SUM(count_inventory_units) AS "dw_listings.count_listings"
FROM Big_L AS dw_listings
WHERE ((((dw_listings.created_at) >= ((TIMESTAMP '2015-01-01')) AND (dw_listings.created_at) < ((TIMESTAMP '2016-06-01'))))) AND (CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END IN ('Available','Sold_Out', 'Deleted_Available_Listing')) AND (((dw_listings.listing_price*.01) < 75000 AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
AND listing_condition  in( 'ret')
AND is_popular_brand = FALSE
AND wholesale IS NULL
AND  initcap(dw_listings.brand) NOT IN 
     ('Adia Kibur', 'Alicia Jean', 'Ananda Design', 'Anitanja', 'April Spirit', 'Karen Zambos', 'Atid Clothing', 'Banjanan', 'Billeno',
       'Bellino Clothing','Bellino ', 'Beltshazzar Jewels ', 'Beltshazzar Jewelry', 'Beora', 'Beora Jewelry', 'Boho Gypsy Sisters',
       'Bun Maternity', 'C''Est Ã‡a New York', 'C''Est  Ã‡a New York', 'Classic Woman/Romeo Romeo', 'Colette Malouf',
       'Diana Broussard', 'E.Kammeyer Accessories', 'Electric Yoga', 'Emily Keller', 'Emily Hsu Designs',
       'Empowered By You', 'Farah Jewlry', 'Farah Jewelry', 'Farah Jewlery', 'Fashionomics ', 'Flash Tattoos', 'Function & Fringe', 'Free People', 'Half United', 'Hues Of Ego',
       'Ire Fashion ', 'Jessica Elliot', 'Karen Zambos', 'Ketzali', 'Mila', 'Knighbury',
       'Leota', 'Lia Larrea', 'Loup', 'Loveriche ', 'Miilla', 'Mint Pear Beauty', 'Mintpear', 'Mintpearbeauty', 'Frnch', 'Mur Mur',
       'Mono', 'Monoreno', 'Mur Mur By Monoreno', 'Bellino', 'Mooncollection', 'Moon Collection', 'Muse Refined',
       'Etoileby Muse Refined', 'Etoile By Muse Refined', 'Etiole By Muse Refined', 'Etoile Bu Muse Refined', 'Naked Truth',
       'Naked Truth Lifestyle','Nisolo','Nytt','October Love','Pastels Clothing','Pastels','Peony And Moss','Prince Peter Collection','Lulumari','Lush',
       'Timing','Paper Crane','Gilli','Under Skies','Catch Me ','Blu Pepper','Joa','Relished','Cotton Daisy Apparel','Jella Couture ','Aryeh','Debut','Staccato','Sadie & Sage',
       'Salt Lake Clothing','Salt Lake Clothing Co','Salt Lake Clithing Co.','Salt Lake Clothing Co. ','American Apparel','Satya Jewelry','Vida','Wila','Shushop','Snob Essentials', 'Sofrancisco',
       'Style Mafia','Sunahara Jewelry', 'Sunahara Malibu','Sunahara Jeweley','Kate Spade','T&J Designs', 'T+J Designs', 'Tanya-B','Tea & Cup', 'Tea N Cup', 'Tea Na D Group',
       'Tea And Cup ','Pol','Three Bird Nest','Angie','22nd Street','Lolli','Love Fashion','Twilight Gypsy Collective','Valleau Apparel','Very J','Whitney Eve','Woman''S Touch Apparel')
GROUP BY 1,2,3
ORDER BY 1







SELECT *
FROM analytics.dw_listings
WHERE listing_id = '570d48329c6fcf6fe8000b66'




WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id, count_inventory_units 
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null) 


SELECT  child, dw_listings.listing_id, O.*, count_inventory_units
FROM Big_L AS dw_listings
INNER JOIN analytics.dw_order_items AS O ON O.listing_id = CASE WHEN child IS NOT NULL THEN child ELSE dw_listings.listing_id  END
WHERE child is not null
LIMIT 100