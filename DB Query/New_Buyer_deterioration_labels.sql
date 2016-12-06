
--Create tiers on d-day
--Buyer D1
SELECT buyer.user_id, buyer.reg_app,  date(buyer_activated_at) - date(joined_at) + 1 AS buyer_d_day,
       CASE WHEN (buyer.joined_at < '2014-10-01' and buyer.acq_channel not in ('rip')) THEN 'not_rip'
            WHEN (buyer.acq_channel IN ('rip') OR buyer.is_referred_with_code in ('Yes')) THEN 'rip' 
       ELSE 'not_rip' END AS Referral,
       
       Case 
           when acq_channel = 'adaction interactive' then 'mobile_paid'
           when acq_channel = 'adcolony' then 'mobile_paid'
           when acq_channel = 'adparlor' then 'mobile_paid'
           when acq_channel = 'adperio' then 'mobile_paid'
           when acq_channel = 'advertising.com' then 'mobile_paid'
           when acq_channel = 'adxcel' then 'mobile_paid'
           when acq_channel = 'airpush' then 'mobile_paid'
           when acq_channel = 'altrooz' then 'mobile_paid'
           when acq_channel = 'altrooz - ios' then 'mobile_paid'
           when acq_channel = 'ampush' then 'mobile_paid'
           when acq_channel = 'apple iad' then 'mobile_paid'
           when acq_channel = 'applovin' then 'mobile_paid'
           when acq_channel = 'appnexus' then 'mobile_paid'
           when acq_channel = 'apsalar' then 'mobile_paid'
           when acq_channel = 'bdm' then 'seo_gks'
           when acq_channel = 'chirpads' then 'mobile_paid'
           when acq_channel = 'clicksmob' then 'mobile_paid'
           when acq_channel = 'cwgt' then 'mobile_organic'
           when acq_channel = 'dedicated media' then 'mobile_paid'
           when acq_channel = 'dedicated media - android' then 'mobile_paid'
           when acq_channel = 'direct agents' then 'mobile_paid'
           when acq_channel = 'drawbridge' then 'mobile_paid'
           when acq_channel = 'dt' then 'mobile_organic'
           when acq_channel = 'em_sh_pub' then 'mobile_paid'
           when acq_channel = 'ext_fb' then 'mobile_organic'
           when acq_channel = 'ext_gp' then 'mobile_organic'
           when acq_channel = 'ext_pi' then 'mobile_organic'
           when acq_channel = 'ext_pn' then 'mobile_organic'
           when acq_channel = 'ext_tm' then 'mobile_organic'
           when acq_channel = 'ext_tw' then 'mobile_organic'
           when acq_channel = 'Facebook' then 'mobile_paid'
           when acq_channel = 'facebook' then 'mobile_paid'
           when acq_channel = 'facebook android' then 'mobile_paid'
           when acq_channel = 'facebook ios' then 'mobile_paid'
           when acq_channel = 'facebookios' then 'mobile_paid'
           when acq_channel = 'famebit' then 'mobile_paid'
           when acq_channel = 'fb' then 'mobile_paid'
           when acq_channel = 'fb_beta' then 'mobile_paid'
           when acq_channel = 'fb_kshoo' then 'mobile_paid'
           when acq_channel = 'fb_retail' then 'mobile_paid'
           when acq_channel = 'fb_sh_msn' then 'mobile_paid'
           when acq_channel = 'fb_sh_pub' then 'mobile_paid'
           when acq_channel = 'fb_sokrati' then 'mobile_paid'
           when acq_channel = 'fbdm' then 'google_gdm_google_shopping'
           when acq_channel = 'fbretail' then 'mobile_paid'
           when acq_channel = 'february+2014' then 'mobile_organic'
           when acq_channel = 'flurry appcircle' then 'mobile_paid'
           when acq_channel = 'friend finder - sms' then 'mobile_organic'
           when acq_channel = 'gdm' then 'google_gdm_google_shopping'
           when acq_channel = 'getapp-mobile' then 'mobile_paid'
           when acq_channel = 'gks' then 'seo_gks'
           when acq_channel = 'glispa' then 'mobile_paid'
           when acq_channel = 'google adwords' then 'mobile_paid'
           when acq_channel = 'google adwords - ios' then 'mobile_paid'
           when acq_channel = 'googledisplay' then 'web_other'
           when acq_channel = 'googlesearch' then 'mobile_organic'
           when acq_channel = 'growmobile' then 'mobile_paid'
           when acq_channel = 'gs' then 'mobile_organic'
           when acq_channel = 'gshm' then 'web_other'
           when acq_channel = 'home page' then 'web_other'
           when acq_channel = 'homepage' then 'web_other'
           when acq_channel = 'iad' then 'mobile_paid'
           when acq_channel = 'ig_beta' then 'mobile_paid'
           when acq_channel = 'ig_kshoo' then 'mobile_paid'
           when acq_channel = 'ig_retail' then 'mobile_paid'
           when acq_channel = 'influencer 1' then 'mobile_paid'
           when acq_channel = 'influencer 2' then 'mobile_paid'
           when acq_channel = 'influencer 4' then 'mobile_paid'
           when acq_channel = 'influencer 5' then 'mobile_paid'
           when acq_channel = 'inmobi' then 'mobile_paid'
           when acq_channel = 'instagram' then 'mobile_paid'
           when acq_channel = 'intentbuy llc' then 'mobile_paid'
           when acq_channel = 'invfriendemail' then 'mobile_organic'
           when acq_channel = 'invfriendfb' then 'mobile_organic'
           when acq_channel = 'invfriendsms' then 'mobile_organic'
           when acq_channel = 'invfriendtu' then 'mobile_organic'
           when acq_channel = 'invfriendtw' then 'mobile_organic'
           when acq_channel = 'invitefriends-email' then 'mobile_organic'
           when acq_channel = 'invitefriends-fb' then 'mobile_organic'
           when acq_channel = 'invitefriends-sms' then 'mobile_organic'
           when acq_channel = 'invitefriends-tu' then 'mobile_organic'
           when acq_channel = 'invitefriends-tw' then 'mobile_organic'
           when acq_channel = 'iron source' then 'mobile_paid'
           when acq_channel = 'jumptap' then 'mobile_paid'
           when acq_channel = 'kixer inc.' then 'mobile_paid'
           when acq_channel = 'liftoff' then 'mobile_paid'
           when acq_channel = 'manage' then 'mobile_paid'
           when acq_channel = 'mdotm' then 'mobile_paid'
           when acq_channel = 'millennial media' then 'mobile_paid'
           when acq_channel = 'mobave' then 'mobile_paid'
           when acq_channel = 'mobvista' then 'mobile_paid'
           when acq_channel = 'motilityads' then 'mobile_paid'
           when acq_channel = 'motiveinteractive' then 'mobile_paid'
           when acq_channel = 'mpire' then 'mobile_paid'
           when acq_channel = 'mypoints' then 'mobile_organic'
           when acq_channel = 'na' then 'mobile_organic'
           when acq_channel = 'neverblue' then 'mobile_paid'
           when acq_channel = 'ntr' then 'mobile_organic'
           when acq_channel = 'ot' then 'mobile_organic'
           when acq_channel = 'pandora' then 'mobile_paid'
           when acq_channel = 'pi_sh_app' then 'mobile_paid'
           when acq_channel = 'pi_sh_pub' then 'mobile_paid'
           when acq_channel = 'pin_cpc' then 'mobile_paid'
           when acq_channel = 'pin_cpi' then 'mobile_paid'
           when acq_channel = 'pin_retail' then 'mobile_paid'
           when acq_channel = 'pinterest' then 'mobile_paid'
           when acq_channel = 'pinterestmob' then 'mobile_paid'
           when acq_channel = 'pinterestretail' then 'mobile_paid'
           when acq_channel = 'popsugar.com' then 'mobile_paid'
           when acq_channel = 'poshmark' then 'web_other'
           when acq_channel = 'pulsenews' then 'web_other'
           when acq_channel = 'pvrl' then 'mobile_organic'
           when acq_channel = 'reddit' then 'mobile_paid'
           when acq_channel = 'rip' then 'referral'
           when acq_channel = 'savingsmania+newsletter' then 'web_other'
           when acq_channel = 'searchman' then 'seo_gks'
           when acq_channel = 'sessionm' then 'mobile_paid'
           when acq_channel = 'shopzila' then 'seo_gks'
           when acq_channel = 'sitescout' then 'mobile_paid'
           when acq_channel = 'smsFF' then 'mobile_organic'
           when acq_channel = 'smsff' then 'mobile_organic'
           when acq_channel = 'spring+pop+up' then 'mobile_organic'
           when acq_channel = 'supersonicads' then 'mobile_paid'
           when acq_channel = 'tapcommerce' then 'mobile_paid'
           when acq_channel = 'tapjoy' then 'mobile_paid'
           when acq_channel = 'tapsense' then 'mobile_paid'
           when acq_channel = 'tapshop' then 'mobile_paid'
           when acq_channel = 'taptica' then 'mobile_paid'
           when acq_channel = 'thehunt.com' then 'mobile_paid'
           when acq_channel = 'tm' then 'mobile_paid'
           when acq_channel = 'tm_sh_pub' then 'mobile_paid'
           when acq_channel = 'tpn' then 'mobile_paid'
           when acq_channel = 'tumblr' then 'mobile_paid'
           when acq_channel = 'tw' then 'mobile_paid'
           when acq_channel = 'tw_comprendi' then 'mobile_paid'
           when acq_channel = 'tw_comprendi_tap' then 'mobile_paid'
           when acq_channel = 'tw_retail' then 'mobile_paid'
           when acq_channel = 'tw_tap' then 'mobile_paid'
           when acq_channel = 'twitter' then 'mobile_paid'
           when acq_channel = 'twitter - android' then 'mobile_paid'
           when acq_channel = 'twitter - ios' then 'mobile_paid'
           when acq_channel = 'twitter test' then 'mobile_paid'
           when acq_channel = 'twitter-android' then 'mobile_paid'
           when acq_channel = 'twitter-ios' then 'mobile_paid'
           when acq_channel = 'unknown' then 'mobile_organic'
           when acq_channel = 'vibrant media' then 'mobile_paid'
           when acq_channel = 'we heart it' then 'mobile_paid'
           when acq_channel = 'wheretoget.it' then 'mobile_paid'
           when acq_channel = 'yahoo ad manager' then 'mobile_paid'
           when acq_channel = 'yahoo web test' then 'mobile_paid'
           when acq_channel = 'ydm' then 'mobile_paid'
           when acq_channel = 'youappi' then 'mobile_paid'
           when acq_channel = 'zulily' then 'mobile_paid'
           ELSE 'Other' 
           END  AS acq_super         
FROM analytics.dw_users AS buyer 
WHERE 
buyer.buyer_activated_at >= TIMESTAMP '2013-01-01'
AND buyer.user_status = 'active'
AND TO_CHAR(DATE_TRUNC('quarter', buyer.buyer_activated_at), 'YYYY-MM') IN ('2013-04', '2014-04', '2015-04', '2016-04')
ORDER BY 1 DESC

limit 100







SELECT COUNT(distinct buyer_id)
FROM (



SELECT buyer_id, payment_method, order_gmv*0.01 AS first_order_price,
         CASE
         WHEN booked_at <  ('2016-02-17 18:00:00') AND buyer_shipping_fee*.01 >= 4.99 THEN 'Full Price'
         WHEN booked_at >  ('2016-02-17 18:00:00') AND buyer_shipping_fee*.01 >= 5.99 THEN 'Full Price'
         ELSE 'Discount' END AS Promo        
FROM analytics.dw_orders
WHERE order_number = 1
AND  order_gmv*0.01 < 50000 and dw_orders.booked_at IS NOT NULL 
AND TO_CHAR(DATE_TRUNC('quarter', booked_at), 'YYYY-MM') IN ('2013-04', '2014-04', '2015-04', '2016-04')
AND  order_state IN 
('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated', 'cancelled', 'iu_status_update_failed', 
 'label_generate_failed', 'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified', 'seller_notification_initiated', 
 'waiting_seller_kyc_info', 'waiting_seller_zip', 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 
 'order_enqueue_failed', 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
LIMIT 100 
 
 )
LIMIT 500