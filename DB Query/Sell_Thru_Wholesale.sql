
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
	COUNT(*) AS "dw_listings.count_listings"
FROM analytics.dw_listings AS dw_listings
WHERE ((((dw_listings.created_at) >= ((TIMESTAMP '2015-01-01')) AND (dw_listings.created_at) < ((TIMESTAMP '2016-06-01'))))) AND ((CASE
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
END ILIKE 'Deleted_Available_Listing')) AND (((dw_listings.listing_price*.01) < 75000 AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
AND seller_id IN ('569449adf9406c0b86013448', '5727e08a63c56588c2005929', '56f0774002e917f8cc011ace', '566f70d1faf526128060a6a6', '56abfa8f9ae22dc01604acb0',
'568ec8fe02e9172a3d137c05', '5695807202e9179a4f184e68', '5693e77b2e39e7537f02cbd6', '5671b12e31baf2ce57035886','568d63fcab07d73129108582', '56d49f570434d5edd4859302', '5728f07363c56542d3003334', 
'56d896cf63c565a12a00026b', '56ab9d384fb0105b4e040b65', '56607abd2e39e71e71017ced', '56a120b89f91f6c50b098d0a','56783f6133c1442aa92e059f', '569fe7960529c61210063337', '566f5c56968f41e21e09453f',
'56c75d3e5632a0adf3005b2e', '56704c5f52cbed82c46c87aa', '56afd50d7396915511202e0b', '571140495632a0cb11006340','56ddf7f39ae22d9bf70424fc', '56a035affef31cdb3b002134', '573619af3b6c8366593b9ab3', 
'56f187709c7041f9e81b1a6a', '56841b869adfff90d93880d1', '568c58404fb01047fc08d213', '56ba2704a0744ca83e7dddb7', '572ce75163c5658782006214', '56a13fdd6d72fb60360101d7',
'566b194d02e9172148204a81', '56670c453b6c838cba014a80', '5669bb39c22a9c09f902dc5f', '570bd0b85632a03f86013832', '566079bada57f9303b07ac94', '56705a3cfbca24f5776eb9b6', '570c240863c565419f0153ca',
'570ec9d5da57f9c929040e92', '5703f84263c56530c8006928', '560c0de29f91f67bc12ce956', '56607ef4b0c5fc8fee019c45', '566078edfd0d40010f07c5b3', '56bbd1672cb764bc3a0f61c5', '56b8e6f572b426a10f5ab3fc',
'56cb4bbd40b19e03bf83015e', '56ab96fe968f410498035893', '5732605d5632a045030014d2', '56fd8fdb72b426a5f072367b', '566077c8aaf4fc732307c34d',
'56e995e15632a0b02702228d', '56798b85a457c8fd62028c42', '570fc8095632a022ad00c9b7', '56f444778f005367250a8590', '5690265d9c7041b4fa291324',
'567992dc8d380cd34d02df45', '57190af663c5654dba005db7', '56b0f4a8d4486c927304bb3a', '5612bef738d4c50a59220804', '56b0e0f869e50dd624034045', '566f17d90d65de444b5a2821', '566b19c4d9eb4ca91020621c', '56607a3d366020ec1701791c',
'56d8872f5632a05c3200319b', '5669f42f69ac4976ca06169c', '567092e9968f41e3a4068de4', '570440d163c565ccca000e05', '56df754c63c565ffd500ef58', '56fc0fc6a0744cab6a46b374', '5670ae445a21faa064080dc7', '56e9ac625159e4e3364834e6', '5674ac5d0529c631f4003f1a')
AND '2016-06-01' - date(dw_listings.created_at) + 1 >= 60 
GROUP BY 1,2,3
ORDER BY 1
LIMIT 500


/**********************************************************************************************/



















SELECT 
	DATE(dw_listings.created_at) AS "dw_listings.created_date",
	dw_listings.category_v2 AS "dw_listings.category_v2",
	
	CASE
        WHEN (dw_listings.listing_price*.01) < 0 THEN 'Below 0' 
        WHEN (dw_listings.listing_price*.01) >= 0 AND (dw_listings.listing_price*.01) < 25 THEN '0 to 24' 
        WHEN (dw_listings.listing_price*.01) >= 25 AND (dw_listings.listing_price*.01) < 50 THEN '25 to 49' 
        WHEN (dw_listings.listing_price*.01) >= 50 AND (dw_listings.listing_price*.01) < 100 THEN '50 to 99' 
        WHEN (dw_listings.listing_price*.01) >= 100 THEN '100 or Above' 
        ELSE 'Undefined' END AS "dw_listings.price_tier_max",
	COUNT(distinct dw_listings.listing_id) AS "dw_listings.count_listings"
FROM analytics.dw_listings AS dw_listings
INNER JOIN analytics.dw_order_items AS O ON dw_listings.listing_id = O.listing_id
WHERE ((((dw_listings.created_at) >= ((TIMESTAMP '2015-01-01')) AND (dw_listings.created_at) < ((TIMESTAMP '2016-06-01'))))) AND ((CASE
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
END ILIKE 'Deleted_Available_Listing')) AND (((dw_listings.listing_price*.01) < 75000 AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL)) = TRUE)
AND dw_listings.seller_id IN ('569449adf9406c0b86013448', '5727e08a63c56588c2005929', '56f0774002e917f8cc011ace', '566f70d1faf526128060a6a6', '56abfa8f9ae22dc01604acb0',
'568ec8fe02e9172a3d137c05', '5695807202e9179a4f184e68', '5693e77b2e39e7537f02cbd6', '5671b12e31baf2ce57035886','568d63fcab07d73129108582', '56d49f570434d5edd4859302', '5728f07363c56542d3003334', 
'56d896cf63c565a12a00026b', '56ab9d384fb0105b4e040b65', '56607abd2e39e71e71017ced', '56a120b89f91f6c50b098d0a','56783f6133c1442aa92e059f', '569fe7960529c61210063337', '566f5c56968f41e21e09453f',
'56c75d3e5632a0adf3005b2e', '56704c5f52cbed82c46c87aa', '56afd50d7396915511202e0b', '571140495632a0cb11006340','56ddf7f39ae22d9bf70424fc', '56a035affef31cdb3b002134', '573619af3b6c8366593b9ab3', 
'56f187709c7041f9e81b1a6a', '56841b869adfff90d93880d1', '568c58404fb01047fc08d213', '56ba2704a0744ca83e7dddb7', '572ce75163c5658782006214', '56a13fdd6d72fb60360101d7',
'566b194d02e9172148204a81', '56670c453b6c838cba014a80', '5669bb39c22a9c09f902dc5f', '570bd0b85632a03f86013832', '566079bada57f9303b07ac94', '56705a3cfbca24f5776eb9b6', '570c240863c565419f0153ca',
'570ec9d5da57f9c929040e92', '5703f84263c56530c8006928', '560c0de29f91f67bc12ce956', '56607ef4b0c5fc8fee019c45', '566078edfd0d40010f07c5b3', '56bbd1672cb764bc3a0f61c5', '56b8e6f572b426a10f5ab3fc',
'56cb4bbd40b19e03bf83015e', '56ab96fe968f410498035893', '5732605d5632a045030014d2', '56fd8fdb72b426a5f072367b', '566077c8aaf4fc732307c34d',
'56e995e15632a0b02702228d', '56798b85a457c8fd62028c42', '570fc8095632a022ad00c9b7', '56f444778f005367250a8590', '5690265d9c7041b4fa291324',
'567992dc8d380cd34d02df45', '57190af663c5654dba005db7', '56b0f4a8d4486c927304bb3a', '5612bef738d4c50a59220804', '56b0e0f869e50dd624034045', '566f17d90d65de444b5a2821', '566b19c4d9eb4ca91020621c', '56607a3d366020ec1701791c',
'56d8872f5632a05c3200319b', '5669f42f69ac4976ca06169c', '567092e9968f41e3a4068de4', '570440d163c565ccca000e05', '56df754c63c565ffd500ef58', '56fc0fc6a0744cab6a46b374', '5670ae445a21faa064080dc7', '56e9ac625159e4e3364834e6', '5674ac5d0529c631f4003f1a')
AND DATE(O.booked_at_time) - DATE(dw_listings.created_at) + 1 <= 30
GROUP BY 1,2,3
ORDER BY 1
LIMIT 500






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
	COUNT(distinct dw_listings.listing_id) AS "dw_listings.count_listings"
FROM analytics.dw_listings AS dw_listings
INNER JOIN analytics.dw_order_items AS O ON dw_listings.listing_id = O.listing_id
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
	COUNT(distinct dw_listings.listing_id) AS "dw_listings.count_listings"
FROM analytics.dw_listings AS dw_listings
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
