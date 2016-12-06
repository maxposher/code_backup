


--With SuperGroup

SELECT *,  CASE WHEN acq_channel_lc in ('rip') THEN 'Referral'
            WHEN ((platform1 in ('iphone', 'android', 'ipad') or platform1 is NULL) and ((acq_channel_lc in 
            ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage', 'home page', 'na','ntr','ot','poshmark','pulsenews','pvrl',
             'SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp', 'invitefriends-email', 
             'invitefriends-fb','invitefriends-sms','invitefriends-tu', 'invitefriends-tw', 'organic')) OR (acq_channel_lc IS NULL ))) 
             THEN 'Mobile_Organic'
            
            WHEN ((platform1 in ('iphone', 'android', 'ipad') or platform1 is NULL) and (acq_channel_lc not in 
            ('rip','cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter',
            'SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp') and (acq_channel_lc IS NOT NULL))) 
            THEN 'Mobile_Paid'
            
            WHEN (platform1 in ('web') and ((acq_channel_lc in 
            ('pi_sh_app', 'pi_sh_pub','tm_sh_pub','organic','em_sh_pub','ext_pn','fb_sh_msn' , 'fb_sh_mshn', 'fb_sh_pub', 'invitefriendsemail', 'invitefriendsms', 
             'invitefriendtu', 'invitefriendtw', 'cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl',
             'SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp', 'invfriendfb')) OR (acq_channel_lc IS NULL ))) 
             THEN 'Web_Organic'
    
            WHEN (platform1 in ('web') and acq_channel_lc in ('gdm','fb_dpa', 'bdm', 'fbdm', 'shopzila','shopzilla', 'ydm')) 
            THEN 'Web_Paid_GDM'
            ELSE 'Web_Paid' END AS "acq_channel_super_group"
FROM
 (select
 TO_CHAR(DATE(DATEADD(day,(0 - EXTRACT(DOW FROM lhs.pstday )::integer), lhs.pstday)), 'YYYY-MM-DD') AS Week,
 lhs.pstday as pstday1
 , lhs.platform as platform1
 , source
 , source_group
 , acq_channel_lc
 , count(distinct lhs.device_id) as num_install
 , count(distinct rhs.device_id) as num_buyers
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 1 then gmv else 0 end ) as D1ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 3 then gmv else 0 end ) as D3ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 7 then gmv else 0 end ) as D7ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 14 then gmv else 0 end ) as D14ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 30 then gmv else 0 end ) as D30ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 60 then gmv else 0 end ) as D60ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 90 then gmv else 0 end ) as D90ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 120 then gmv else 0 end ) as D120ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 150 then gmv else 0 end ) as D150ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 180 then gmv else 0 end ) as D180ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 210 then gmv else 0 end ) as D210ARPU
 , sum( case when datediff('day', lhs.pstday, rhs.pstday) <= 360 then gmv else 0 end ) as D360ARPU
 , sum(gmv) as GMV
from
 ((select distinct user_id as device_id , reg_app as platform,joined_at::date as pstday,
  case when acq_channel_lc='adaction interactive' then 'adaction interactive'
       when acq_channel_lc='facebook' then 'facebook'
       when acq_channel_lc='instagram' then 'instagram'
       when acq_channel_lc='pin_cpc' then 'pinterest'
       when acq_channel_lc='pinterest' then 'pinterest'
       when acq_channel_lc='yahoo ad manager' then 'other_paid'
       when acq_channel_lc='gks' then 'seo'
       when acq_channel_lc in ('na', 'gshm') then 'organic'
       when acq_channel_lc is null then 'organic'
       when acq_channel_lc='twitter ads' then 'twitter'
       when acq_channel_lc in ('ntr',  'dt' , 'gs', 'home_page') then 'other'
       when acq_channel_lc='rip' then 'referral'
       when acq_channel_lc in ('gdm','google adwords') then 'google'
       when acq_channel_lc='bdm' then 'bing'
      else acq_channel_group_lc end as source,
case when acq_channel_lc='adaction interactive' then 'mobile_paid'
       when acq_channel_lc='facebook' then 'mobile_paid'
       when acq_channel_lc='instagram' then 'mobile_paid'
       when acq_channel_lc='pin_cpc' then 'mobile_paid'
       when acq_channel_lc='pinterest' then 'mobile_paid'
       when acq_channel_lc='yahoo ad manager' then 'mobile_paid'
       when acq_channel_lc='gks' then 'seo'
       when acq_channel_lc in ('na' ) then 'mobile organic'
       when acq_channel_lc is null then 'mobile organic'
       when acq_channel_lc in ('twitter ads', 'twitter', 'motive interactive') then 'mobile_paid'
       when acq_channel_lc in ('ntr',  'dt' , 'gs', 'home_page','gshm', 'pi_sh_pub', 'fb') then 'web-others'
       when acq_channel_lc='rip' then 'referral'
       when acq_channel_lc in ('gdm','shopzilla', 'fb_dpa') then 'product ads'
       when acq_channel_lc in ('google adwords') then 'mobile_paid'
       when acq_channel_lc='bdm' then 'mobile_paid'
      else acq_channel_group_lc end as source_group, acq_channel_lc
from analytics.dw_users
--where  date(joined_at) >= '2015-01-01'
) as lhs
left join
(select buyer_id as device_id, booked_at::date as pstday, app as platform,
 sum(order_gmv)*0.01   as gmv
 from analytics.dw_orders
 WHERE  booked_at::date>= '2015-01-01' and dw_orders.booked_at IS NOT NULL
 AND (dw_orders.order_gmv*0.01) < 50000
 AND dw_orders.order_state IN ('ab_captured', 'ab_captured_skipped', 'buyer_confirm_initiated',
                                'cancelled', 'iu_status_update_failed', 'label_generate_failed',
                                'label_generated', 'seller_confirm_initiated', 'seller_kyc_verified',
                                'seller_notification_initiated', 'waiting_seller_kyc_info', 'waiting_seller_zip',
                                 'label_service_unavailable', 'iu_status_updated', 'order_enqueued', 'order_enqueue_failed',
                                 'seller_ab_updated', 'seller_ab_update_failed', 'waiting_seller_kyc_verification')
group by 1,2,3) as rhs
using ( device_id)) group by 1,2,3,4,5,6) AS e

left join
(select spent_on, spent_platform, acq_channel,
case when acq_channel='adaction interactive' then 'mobile_paid'
       when acq_channel='facebook' then 'mobile_paid'
       when acq_channel='instagram' then 'mobile_paid'
       when acq_channel='pin_cpc' then 'mobile_paid'
       when acq_channel='pinterest' then 'mobile_paid'
       when acq_channel='yahoo ad manager' then 'mobile_paid'
       when acq_channel='gks' then 'seo'
       when acq_channel in ('na' ) then 'mobile organic'
       when acq_channel is null then 'mobile organic'
       when acq_channel in ('twitter ads', 'twitter', 'motive interactive') then 'mobile_paid'
       when acq_channel in ('ntr',  'dt' , 'gs', 'home_page','gshm', 'pi_sh_pub', 'fb') then 'web-others'
       when acq_channel='rip' then 'referral'
       when acq_channel in ('gdm','shopzilla', 'fb_dpa') then 'product ads'
       when acq_channel in ('google adwords') then 'mobile_paid'
       when acq_channel='bdm' then 'mobile_paid'
      else acq_channel_group end as source_group_spend,
case when acq_channel='adaction interactive' then 'adaction interactive'
       when acq_channel='facebook' then 'facebook'
       when acq_channel='instagram' then 'instagram'
       when acq_channel='pin_cpc' then 'pinterest'
       when acq_channel='pinterest' then 'pinterest'
       when acq_channel='yahoo ad manager' then 'other_paid'
       when acq_channel='gks' then 'seo'
       when acq_channel in ('na', 'gshm') then 'organic'
       when acq_channel is null then 'organic'
       when acq_channel='twitter ads' then 'twitter'
       when acq_channel in ('ntr',  'dt' , 'gs', 'home_page') then 'other'
       when acq_channel='rip' then 'referral'
       when acq_channel in ('gdm','google adwords') then 'google'
       when acq_channel='bdm' then 'bing'
      else acq_channel_group end as source_spend,
sum(total_spend) as spend from analytics.dw_daily_manual_spend
group by 1,2,3,4,5) AS D
on spent_on=pstday1 and spent_platform=platform1 and
((source_group=D.source_group_spend) or (source_group is null and source_group_spend is null))
and
((source=D.source_spend) or (source is null and source_spend is null)   )
and
   ((D.acq_channel=acq_channel_lc) or (acq_channel is null and D.acq_channel is null))
WHERE date(pstday1) = '2016-11-30' --Max's update



