
SELECT buyer_id, 
CASE WHEN (Brand = 'Michael Kors' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Louis Vuitton' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Coach' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Nike' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Lululemon Athletica' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Tory Burch' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Pink Victoria''S Secret' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Victoria''S Secret' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Kate Spade' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Free People' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Chanel' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'J. Crew' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Ugg' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Gucci' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Anthropologie' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Burberry' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Lilly Pulitzer' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Miss Me' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Forever 21' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Tiffany & Co.' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Zara' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Steve Madden' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Brandy Melville' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Christian Louboutin' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'American Eagle Outfitters' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Jordan' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'North Face' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Ray-Ban' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Michael Michael Kors' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Urban Outfitters' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Pandora' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Express' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'H&M' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Juicy Couture' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Hunter Boots' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Dooney & Bourke' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Banana Republic' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'American Apparel' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Vera Bradley' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Mac Cosmetics' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Prada' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Bebe' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Betsey Johnson' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Converse' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Marc By Marc Jacobs' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Ralph Lauren' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Frye' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'True Religion' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Under Armour' )  THEN 1 ELSE 0 END,
CASE WHEN (Brand = 'Rock Revival' )  THEN 1 ELSE 0 END
FROM analytics.dw_orders AS O
INNER JOIN analytics.dw_listings AS L on O.listing_id = L.listing_id
WHERE date(booked_at) BETWEEN '2015-10-01' AND '2016-02-10'
AND order_state IN
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 
'iu_status_update_failed', 'label_generate_failed', 'label_generated', 
'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')










SELECT buyer.user_id AS "buyer.user_id",
	initcap(listing_details.brand) AS "Brand",
	COUNT(*) AS "Count_Orders"
FROM analytics.dw_orders AS dw_orders
LEFT JOIN analytics.dw_users AS buyer ON dw_orders.buyer_id = buyer.user_id
LEFT JOIN analytics.dw_listings AS listing_details ON dw_orders.listing_id = listing_details.listing_id AND listing_details.create_source_type IS NULL
WHERE 	 
and dw_orders.order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 'label_generate_failed', 'label_generated', 
 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 
 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification'))   ))
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 500



