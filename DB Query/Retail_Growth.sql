





     SELECT buyer_id, 1 AS 
     FROM   analytics.dw_orders
     WHERE  date_trunc('mon', date(booked_at)) >= '2015-10-01'
     AND    buyer_shipping_fee < 499
     AND    order_number = 1
     
     
     LIMIT 10
    
     buyer_shipping_fee < 499
    
     /* Actor Two - Non-TIme-Stamped */
     SELECT U.user_id, U.joined_at, U.buyer_activated_at, 
     CASE WHEN U.buyer_activated_at IS NOT NULL THEN 1 ELSE 0 END AS Buyer_non_timestamp
     FROM analytics.dw_users AS U 
     WHERE date_trunc('mon', date(U.join_date)) = '2015-10-01'     

     LIMIT 10
     
     
     
     
     
     SELECT U.join_date, U.user_id, U.reg_app, CASE WHEN date(E.date_like_activated) = U.join_date THEN 1 ELSE 0 END AS D1_Liker, Discount_Buyer 
     FROM   analytics.dw_users AS U
           LEFT JOIN (SELECT buyer_id, booked_at,  
                      CASE WHEN buyer_shipping_fee < 499  THEN 1 ELSE 0 END AS Discount_Buyer
                      FROM    analytics.dw_orders 
                      WHERE   order_number = 1 
                      AND date(booked_at) >= '2015-09-30') AS O ON U.user_id = O.buyer_id                          
           LEFT JOIN (SELECT R."a|id" AS user_id, min(R."at") AS date_like_activated
                      FROM raw_events.all as R 
                      WHERE R."v" = 'l'
                      AND R."at" >= '2015-10-01'
                      GROUP BY R."a|id"
                      ) AS E ON U.user_id = E.user_id
     WHERE  date_trunc('mon', date(U.join_date)) = '2015-10-01'
     
     
     
     
     
     
     /* Booked orders from top sellers */
     SELECT date_trunc('mon', date(O.booked_at)), COUNT (distinct O.order_id), SUM (O.order_gmv)
     FROM analytics.dw_orders AS O INNER JOIN analytics.dw_users AS U ON O.seller_id = U.user_id
     WHERE date(O.booked_at) >= '2012-01-01'
     AND O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
     'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
     'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
     AND U.username IN 
     ('nineve', 'jenaforsberg', 'itsmonikarose', 'mandysue', 'ocposh30', 'jackiecbelle', 'vivacouture', 'scanon', 'lovestoryshop', 'missaisha555', 'sfconway', 'mrsalliexo', 'aprils2ndcloset', 
      'jenangel89', 'leahannemae', 'edamerval', 'kmb42', 'chevelless', 'kleinlori', 'mackie61506', 'rawrie', 'ninascloset5', 'bagz_wit_labelz', 'buddy4321', 'tdgrable24', 'bella4', 'kaitlyn_hahn', 
      'jomarinpa44', 'bentleyclothing', 'amandafreeze', 'alvictoria', 'kreed324', 'tjsmama22', 'hegotkicks', 'grindl1', 'surferluv', 'felyposhfashion', 'lookgdfeelgd', 'crazyposh', 'kimmiedee', 
      'usbfly', 'deenasells', 'icingonthecake', 'wendygonzalez', 'fancypantsmcgee', 'pursetym811', '24me04u', 'mayfaircloset', 'sungah_', 'kate73', 'kissmedeals', 'luckyducky17', 'cali1018', 
      'shah2122', 'ashleylindsay', 'randeedaren', 'violettestudios', 'latina_style', 'blessboom', 'xclassynchicx', 'sa3428', 'kaylyn14', 'premkicks', 'sara_leee', 'shopluckyduck', 'paigecolette', 
      'closetsclosets', 'melvy310', 'itselaine', 'msjoi', 'allygirl1964', 'strivetobefab', 'staniheart', 'luxuryboutiquer', 'hannaho', 'wearinla', 'shev4eto', 'jessikabaileyg', 'chicbabygirl', 
      'uughiforgot', 'alew430', 'theyteensandi', 'angelafayer', 'coribauer73', 'nboyd25', 'linsleppo', 'etrading', 'kaprior1203', 'viviglam', 'madidoll', 'sadangel0890', 'jeffrust', 'herparallax', 
      'blaheal', 'meboutique', 'tfullerton12', 'briebrie101788', 'signedbrooklynn', 'uattah', 'cmjla') 
     GROUP BY 1 
     ORDER BY 1
     
     
     /* Active Users */
     SELECT date_trunc('mon', date(A.activity_date)), COUNT (distinct (U.user_id))
     FROM analytics.dw_users AS U 
     LEFT JOIN analytics.dw_user_activity AS A ON U.user_id = A.user_id
     WHERE 
     A.activity_name = 'active_on_app'
     AND date(A.activity_date) >= '2012-01-01'
     AND U.username IN 
     ('nineve', 'jenaforsberg', 'itsmonikarose', 'mandysue', 'ocposh30', 'jackiecbelle', 'vivacouture', 'scanon', 'lovestoryshop', 'missaisha555', 'sfconway', 'mrsalliexo', 'aprils2ndcloset', 
      'jenangel89', 'leahannemae', 'edamerval', 'kmb42', 'chevelless', 'kleinlori', 'mackie61506', 'rawrie', 'ninascloset5', 'bagz_wit_labelz', 'buddy4321', 'tdgrable24', 'bella4', 'kaitlyn_hahn', 
      'jomarinpa44', 'bentleyclothing', 'amandafreeze', 'alvictoria', 'kreed324', 'tjsmama22', 'hegotkicks', 'grindl1', 'surferluv', 'felyposhfashion', 'lookgdfeelgd', 'crazyposh', 'kimmiedee', 
      'usbfly', 'deenasells', 'icingonthecake', 'wendygonzalez', 'fancypantsmcgee', 'pursetym811', '24me04u', 'mayfaircloset', 'sungah_', 'kate73', 'kissmedeals', 'luckyducky17', 'cali1018', 
      'shah2122', 'ashleylindsay', 'randeedaren', 'violettestudios', 'latina_style', 'blessboom', 'xclassynchicx', 'sa3428', 'kaylyn14', 'premkicks', 'sara_leee', 'shopluckyduck', 'paigecolette', 
      'closetsclosets', 'melvy310', 'itselaine', 'msjoi', 'allygirl1964', 'strivetobefab', 'staniheart', 'luxuryboutiquer', 'hannaho', 'wearinla', 'shev4eto', 'jessikabaileyg', 'chicbabygirl', 
      'uughiforgot', 'alew430', 'theyteensandi', 'angelafayer', 'coribauer73', 'nboyd25', 'linsleppo', 'etrading', 'kaprior1203', 'viviglam', 'madidoll', 'sadangel0890', 'jeffrust', 'herparallax', 
      'blaheal', 'meboutique', 'tfullerton12', 'briebrie101788', 'signedbrooklynn', 'uattah', 'cmjla') 
     GROUP BY 1
     ORDER BY 1
     
     
      /* Created Listing */
     SELECT date_trunc('mon', date(L.created_date)), COUNT (distinct (L.listing_id))
     FROM analytics.dw_users AS U 
     LEFT JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     WHERE 
     L.inventory_status != 'not_for_sale'
     AND date(L.created_date) >= '2012-01-01'
     AND U.username IN 
     ('nineve', 'jenaforsberg', 'itsmonikarose', 'mandysue', 'ocposh30', 'jackiecbelle', 'vivacouture', 'scanon', 'lovestoryshop', 'missaisha555', 'sfconway', 'mrsalliexo', 'aprils2ndcloset', 
      'jenangel89', 'leahannemae', 'edamerval', 'kmb42', 'chevelless', 'kleinlori', 'mackie61506', 'rawrie', 'ninascloset5', 'bagz_wit_labelz', 'buddy4321', 'tdgrable24', 'bella4', 'kaitlyn_hahn', 
      'jomarinpa44', 'bentleyclothing', 'amandafreeze', 'alvictoria', 'kreed324', 'tjsmama22', 'hegotkicks', 'grindl1', 'surferluv', 'felyposhfashion', 'lookgdfeelgd', 'crazyposh', 'kimmiedee', 
      'usbfly', 'deenasells', 'icingonthecake', 'wendygonzalez', 'fancypantsmcgee', 'pursetym811', '24me04u', 'mayfaircloset', 'sungah_', 'kate73', 'kissmedeals', 'luckyducky17', 'cali1018', 
      'shah2122', 'ashleylindsay', 'randeedaren', 'violettestudios', 'latina_style', 'blessboom', 'xclassynchicx', 'sa3428', 'kaylyn14', 'premkicks', 'sara_leee', 'shopluckyduck', 'paigecolette', 
      'closetsclosets', 'melvy310', 'itselaine', 'msjoi', 'allygirl1964', 'strivetobefab', 'staniheart', 'luxuryboutiquer', 'hannaho', 'wearinla', 'shev4eto', 'jessikabaileyg', 'chicbabygirl', 
      'uughiforgot', 'alew430', 'theyteensandi', 'angelafayer', 'coribauer73', 'nboyd25', 'linsleppo', 'etrading', 'kaprior1203', 'viviglam', 'madidoll', 'sadangel0890', 'jeffrust', 'herparallax', 
      'blaheal', 'meboutique', 'tfullerton12', 'briebrie101788', 'signedbrooklynn', 'uattah', 'cmjla') 
     GROUP BY 1
     ORDER BY 1
     
     
     
     
     SELECT date_trunc('mon', date(L.created_date)), COUNT (distinct (L.listing_id))
     FROM analytics.dw_users AS U 
     LEFT JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     WHERE 
     date(L.created_date) >= '2012-01-01'
     AND U.username IN 
     ('nineve', 'jenaforsberg', 'itsmonikarose', 'mandysue', 'ocposh30', 'jackiecbelle', 'vivacouture', 'scanon', 'lovestoryshop', 'missaisha555', 'sfconway', 'mrsalliexo', 'aprils2ndcloset', 
      'jenangel89', 'leahannemae', 'edamerval', 'kmb42', 'chevelless', 'kleinlori', 'mackie61506', 'rawrie', 'ninascloset5', 'bagz_wit_labelz', 'buddy4321', 'tdgrable24', 'bella4', 'kaitlyn_hahn', 
      'jomarinpa44', 'bentleyclothing', 'amandafreeze', 'alvictoria', 'kreed324', 'tjsmama22', 'hegotkicks', 'grindl1', 'surferluv', 'felyposhfashion', 'lookgdfeelgd', 'crazyposh', 'kimmiedee', 
      'usbfly', 'deenasells', 'icingonthecake', 'wendygonzalez', 'fancypantsmcgee', 'pursetym811', '24me04u', 'mayfaircloset', 'sungah_', 'kate73', 'kissmedeals', 'luckyducky17', 'cali1018', 
      'shah2122', 'ashleylindsay', 'randeedaren', 'violettestudios', 'latina_style', 'blessboom', 'xclassynchicx', 'sa3428', 'kaylyn14', 'premkicks', 'sara_leee', 'shopluckyduck', 'paigecolette', 
      'closetsclosets', 'melvy310', 'itselaine', 'msjoi', 'allygirl1964', 'strivetobefab', 'staniheart', 'luxuryboutiquer', 'hannaho', 'wearinla', 'shev4eto', 'jessikabaileyg', 'chicbabygirl', 
      'uughiforgot', 'alew430', 'theyteensandi', 'angelafayer', 'coribauer73', 'nboyd25', 'linsleppo', 'etrading', 'kaprior1203', 'viviglam', 'madidoll', 'sadangel0890', 'jeffrust', 'herparallax', 
      'blaheal', 'meboutique', 'tfullerton12', 'briebrie101788', 'signedbrooklynn', 'uattah', 'cmjla') 
     
     AND 
	(CASE WHEN (L.listing_status = 'published' and L.inventory_status = 'available') THEN 'Available' 
              WHEN (L.listing_status = 'published' and L.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
              WHEN (L.inventory_status = 'sold_out') THEN 'Sold_Out' 
              WHEN (L.listing_status = 'archived' and L.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
              WHEN (L.listing_status = 'archived') THEN 'Deleted_by_User' 
              WHEN (L.listing_status = 'hidden' or L.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
              WHEN (L.listing_status = 'draft' or L.listing_status = 'for_review') THEN 'Draft_InReview' 
              ELSE 'Unknown' 
              END = 'Available' OR CASE
              WHEN (L.listing_status = 'published' and L.inventory_status = 'available') THEN 'Available' 
              WHEN (L.listing_status = 'published' and L.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
                WHEN (L.inventory_status = 'sold_out') THEN 'Sold_Out' 
                WHEN (L.listing_status = 'archived' and L.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
                WHEN (L.listing_status = 'archived') THEN 'Deleted_by_User' 
                WHEN (L.listing_status = 'hidden' or L.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
                WHEN (L.listing_status = 'draft' or L.listing_status = 'for_review') THEN 'Draft_InReview' 
                ELSE 'Unknown' 
                END LIKE 'Sold_Out' OR CASE
                WHEN (L.listing_status = 'published' and L.inventory_status = 'available') THEN 'Available' 
                WHEN (L.listing_status = 'published' and L.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
                WHEN (L.inventory_status = 'sold_out') THEN 'Sold_Out' 
                WHEN (L.listing_status = 'archived' and L.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
                WHEN (L.listing_status = 'archived') THEN 'Deleted_by_User' 
                WHEN (L.listing_status = 'hidden' or L.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
                WHEN (L.listing_status = 'draft' or L.listing_status = 'for_review') THEN 'Draft_InReview' 
                ELSE 'Unknown' 
                END LIKE 'Deleted_Available_Listing')
     GROUP BY 1
     ORDER BY 1
     
     
     
     
     
     
     
     
     
     
     SELECT date_trunc('mon', date(L.created_date)), 
     L.category_v2 AS "dw_listings.category_v2",
     COUNT (distinct L.listing_id)
    
     FROM analytics.dw_users AS U 
     LEFT JOIN analytics.dw_listings AS L ON U.user_id = L.seller_id
     WHERE 
     date(L.created_date) >= '2012-01-01'
     AND U.username IN 
     ('nineve', 'jenaforsberg', 'itsmonikarose', 'mandysue', 'ocposh30', 'jackiecbelle', 'vivacouture', 'scanon', 'lovestoryshop', 'missaisha555', 'sfconway', 'mrsalliexo', 'aprils2ndcloset', 
      'jenangel89', 'leahannemae', 'edamerval', 'kmb42', 'chevelless', 'kleinlori', 'mackie61506', 'rawrie', 'ninascloset5', 'bagz_wit_labelz', 'buddy4321', 'tdgrable24', 'bella4', 'kaitlyn_hahn', 
      'jomarinpa44', 'bentleyclothing', 'amandafreeze', 'alvictoria', 'kreed324', 'tjsmama22', 'hegotkicks', 'grindl1', 'surferluv', 'felyposhfashion', 'lookgdfeelgd', 'crazyposh', 'kimmiedee', 
      'usbfly', 'deenasells', 'icingonthecake', 'wendygonzalez', 'fancypantsmcgee', 'pursetym811', '24me04u', 'mayfaircloset', 'sungah_', 'kate73', 'kissmedeals', 'luckyducky17', 'cali1018', 
      'shah2122', 'ashleylindsay', 'randeedaren', 'violettestudios', 'latina_style', 'blessboom', 'xclassynchicx', 'sa3428', 'kaylyn14', 'premkicks', 'sara_leee', 'shopluckyduck', 'paigecolette', 
      'closetsclosets', 'melvy310', 'itselaine', 'msjoi', 'allygirl1964', 'strivetobefab', 'staniheart', 'luxuryboutiquer', 'hannaho', 'wearinla', 'shev4eto', 'jessikabaileyg', 'chicbabygirl', 
      'uughiforgot', 'alew430', 'theyteensandi', 'angelafayer', 'coribauer73', 'nboyd25', 'linsleppo', 'etrading', 'kaprior1203', 'viviglam', 'madidoll', 'sadangel0890', 'jeffrust', 'herparallax', 
      'blaheal', 'meboutique', 'tfullerton12', 'briebrie101788', 'signedbrooklynn', 'uattah', 'cmjla') 
     
     AND 
	(CASE WHEN (L.listing_status = 'published' and L.inventory_status = 'available') THEN 'Available' 
              WHEN (L.listing_status = 'published' and L.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
              WHEN (L.inventory_status = 'sold_out') THEN 'Sold_Out' 
              WHEN (L.listing_status = 'archived' and L.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
              WHEN (L.listing_status = 'archived') THEN 'Deleted_by_User' 
              WHEN (L.listing_status = 'hidden' or L.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
              WHEN (L.listing_status = 'draft' or L.listing_status = 'for_review') THEN 'Draft_InReview' 
              ELSE 'Unknown' 
              END = 'Available' OR CASE
              WHEN (L.listing_status = 'published' and L.inventory_status = 'available') THEN 'Available' 
              WHEN (L.listing_status = 'published' and L.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
                WHEN (L.inventory_status = 'sold_out') THEN 'Sold_Out' 
                WHEN (L.listing_status = 'archived' and L.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
                WHEN (L.listing_status = 'archived') THEN 'Deleted_by_User' 
                WHEN (L.listing_status = 'hidden' or L.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
                WHEN (L.listing_status = 'draft' or L.listing_status = 'for_review') THEN 'Draft_InReview' 
                ELSE 'Unknown' 
                END LIKE 'Sold_Out' OR CASE
                WHEN (L.listing_status = 'published' and L.inventory_status = 'available') THEN 'Available' 
                WHEN (L.listing_status = 'published' and L.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
                WHEN (L.inventory_status = 'sold_out') THEN 'Sold_Out' 
                WHEN (L.listing_status = 'archived' and L.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
                WHEN (L.listing_status = 'archived') THEN 'Deleted_by_User' 
                WHEN (L.listing_status = 'hidden' or L.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
                WHEN (L.listing_status = 'draft' or L.listing_status = 'for_review') THEN 'Draft_InReview' 
                ELSE 'Unknown' 
                END LIKE 'Deleted_Available_Listing')
     GROUP BY 1,2
     ORDER BY 1
     
     
     
     
     SELECT date_trunc('mon', date(O.booked_at)),  L.category_v2 AS Category,
     COUNT (distinct O.order_id), SUM (O.order_gmv)
     FROM analytics.dw_orders AS O INNER JOIN analytics.dw_users AS U ON O.seller_id = U.user_id
     LEFT JOIN analytics.dw_listings AS L ON O.listing_id = L.listing_id
     WHERE date(O.booked_at) >= '2012-01-01'
     AND O.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
     'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip', 
     'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
     AND U.username IN 
     ('nineve', 'jenaforsberg', 'itsmonikarose', 'mandysue', 'ocposh30', 'jackiecbelle', 'vivacouture', 'scanon', 'lovestoryshop', 'missaisha555', 'sfconway', 'mrsalliexo', 'aprils2ndcloset', 
      'jenangel89', 'leahannemae', 'edamerval', 'kmb42', 'chevelless', 'kleinlori', 'mackie61506', 'rawrie', 'ninascloset5', 'bagz_wit_labelz', 'buddy4321', 'tdgrable24', 'bella4', 'kaitlyn_hahn', 
      'jomarinpa44', 'bentleyclothing', 'amandafreeze', 'alvictoria', 'kreed324', 'tjsmama22', 'hegotkicks', 'grindl1', 'surferluv', 'felyposhfashion', 'lookgdfeelgd', 'crazyposh', 'kimmiedee', 
      'usbfly', 'deenasells', 'icingonthecake', 'wendygonzalez', 'fancypantsmcgee', 'pursetym811', '24me04u', 'mayfaircloset', 'sungah_', 'kate73', 'kissmedeals', 'luckyducky17', 'cali1018', 
      'shah2122', 'ashleylindsay', 'randeedaren', 'violettestudios', 'latina_style', 'blessboom', 'xclassynchicx', 'sa3428', 'kaylyn14', 'premkicks', 'sara_leee', 'shopluckyduck', 'paigecolette', 
      'closetsclosets', 'melvy310', 'itselaine', 'msjoi', 'allygirl1964', 'strivetobefab', 'staniheart', 'luxuryboutiquer', 'hannaho', 'wearinla', 'shev4eto', 'jessikabaileyg', 'chicbabygirl', 
      'uughiforgot', 'alew430', 'theyteensandi', 'angelafayer', 'coribauer73', 'nboyd25', 'linsleppo', 'etrading', 'kaprior1203', 'viviglam', 'madidoll', 'sadangel0890', 'jeffrust', 'herparallax', 
      'blaheal', 'meboutique', 'tfullerton12', 'briebrie101788', 'signedbrooklynn', 'uattah', 'cmjla') 
     GROUP BY 1,2 
     ORDER BY 1
     
     
     
     