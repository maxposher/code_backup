


         SELECT date(R."at"), COUNT(distinct R."do|id") 
         FROM raw_events.all as R
         INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
         WHERE R."v" = 'u'
         AND date(R."at") >='2015-09-11'
         AND L.seller_id = R."a|id"
         GROUP BY 1
         ORDER BY 1
         


         SELECT distinct date(R."at")
         FROM raw_events.all as R
         GROUP BY 1
         ORDER BY 1
         
         
   Select distinct U.acq_channel
   FROM analytics.dw_users AS U
   WHERE       
   
   
         SELECT R.*
         FROM raw_events.all as R
         LIMIT 10
   
    
         SELECT date(R."at"), COUNT(distinct R."do|id") 
         FROM raw_events.all as R
         INNER JOIN analytics.dw_listings AS L ON R."do|id" = L.listing_id
         WHERE R."v" = 'u'
         AND date(R."at") >='2015-10-01'
         AND date(R."at") <='2015-10-31' 
         
         
         
         SELECT CASE
         WHEN ((dw_users.reg_app in ('iphone', 'android', 'ipad') or dw_users.reg_app is NULL) and (((CASE WHEN (dw_users.join_date < '2014-10-01' and dw_users.acq_channel not in ('rip'))THEN dw_users.heuristical_acq_channel  ELSE dw_users.acq_channel END) in ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) OR ((CASE WHEN (dw_users.join_date < '2014-10-01' and dw_users.acq_channel not in ('rip'))THEN dw_users.heuristical_acq_channel  ELSE dw_users.acq_channel END) IS NULL ))) THEN 'Mobile_Organic' 
         WHEN ((dw_users.reg_app in ('iphone', 'android', 'ipad') or dw_users.reg_app is NULL) and (CASE WHEN (dw_users.join_date < '2014-10-01' and dw_users.acq_channel not in ('rip'))THEN dw_users.heuristical_acq_channel  ELSE dw_users.acq_channel END) not in ('rip','cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) THEN 'Mobile_Paid' 
         WHEN (dw_users.reg_app in ('web') and (((CASE WHEN (dw_users.join_date < '2014-10-01' and dw_users.acq_channel not in ('rip'))THEN dw_users.heuristical_acq_channel  ELSE dw_users.acq_channel END) in ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) OR ((CASE WHEN (dw_users.join_date < '2014-10-01' and dw_users.acq_channel not in ('rip'))THEN dw_users.heuristical_acq_channel  ELSE dw_users.acq_channel END) IS NULL ))) THEN 'Web_Organic' 
         WHEN ((CASE WHEN (dw_users.join_date < '2014-10-01' and dw_users.acq_channel not in ('rip'))THEN dw_users.heuristical_acq_channel  ELSE dw_users.acq_channel END) in ('rip')) THEN 'Referral_Organic' 
         ELSE 'Web_Paid' 
         END AS "Acq_channel_type", COUNT(DISTINCT dw_users.user_id) AS "dw_users.count_users"
         FROM analytics.dw_users AS dw_users
         WHERE date(dw_users.join_date) >= '2015-10-01'
         AND   date(dw_users.join_date) <= '2015-10-31'
         GROUP BY 1
         
         
         
         
         
         
         SELECT CASE
         WHEN ((U.reg_app in ('iphone', 'android', 'ipad') or U.reg_app is NULL) and (((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) in ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) OR ((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) IS NULL ))) THEN 'Mobile_Organic' 
         WHEN ((U.reg_app in ('iphone', 'android', 'ipad') or U.reg_app is NULL) and (CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) not in ('rip','cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) THEN 'Mobile_Paid' 
         WHEN (U.reg_app in ('web') and (((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) in ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) OR ((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) IS NULL ))) THEN 'Web_Organic' 
         WHEN ((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) in ('rip')) THEN 'Referral_Organic' 
         ELSE 'Web_Paid' 
         END AS "Acq_channel_type", COUNT(DISTINCT U.user_id) AS "Count_users"
         FROM analytics.dw_users AS U
         WHERE date(U.join_date) >= '2015-10-01'
         AND   date(U.join_date) <= '2015-10-31'
         AND U.user_id IN
                (
                 SELECT R."a|id"
                 FROM raw_events.all as R
                 INNER JOIN analytics.dw_users AS V ON R."a|id" = V.user_id
                 WHERE R."v" = 'f'
                 AND  R."do|t" = 'b'
                 AND date(V.join_date) >= '2015-10-01'
                 AND date(R."at") >='2015-10-01'
                 AND date(R."at") <='2015-10-31' 
                 AND  R."a|t" = 'u'
                 GROUP BY R."a|id"
                              )
          GROUP BY 1    
          ORDER BY 1             
          
          
          
          
          SELECT CASE
          WHEN ((U.reg_app in ('iphone', 'android', 'ipad') or U.reg_app is NULL) and (((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) in ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) OR ((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) IS NULL ))) THEN 'Mobile_Organic' 
          WHEN ((U.reg_app in ('iphone', 'android', 'ipad') or U.reg_app is NULL) and (CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) not in ('rip','cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) THEN 'Mobile_Paid' 
          WHEN (U.reg_app in ('web') and (((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) in ('cwgt','dt','fb','February+2014','gks','gs','gshm','homepage','na','ntr','ot','poshmark','pulsenews','pvrl','SavingsMania+Newsletter','SPRING+POP+UP','tm','tw','unknown','ext_fb', 'ext_tm', 'ext_tw', 'ext_pi', 'ext_gp')) OR ((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) IS NULL ))) THEN 'Web_Organic' 
          WHEN ((CASE WHEN (U.join_date < '2014-10-01' and U.acq_channel not in ('rip'))THEN U.heuristical_acq_channel  ELSE U.acq_channel END) in ('rip')) THEN 'Referral_Organic' 
          ELSE 'Web_Paid' 
          END AS "Acq_channel_type", COUNT(distinct R.id) AS "Count_Activities"
          FROM analytics.dw_users AS U
          INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
          WHERE date(U.join_date) >= '2015-10-01'
          AND   date(U.join_date) <= '2015-10-31'
          AND   date(R."at") >='2015-10-01'
          AND   date(R."at") <='2015-10-31' 
          AND   R."v" = 'f'
          AND  R."do|t" = 'b'
          AND  R."a|t" = 'u'
          GROUP BY 1  
          ORDER BY 1       
          
          
          SELECT R.id, R."v", R.at, R."do|id", R."a|t"
          FROM analytics.dw_users AS U
          INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
          WHERE date(U.join_date) >= '2015-10-01'
          AND   date(U.join_date) <= '2015-10-31'
          AND   date(R."at") >='2015-10-01'
          AND   date(R."at") <='2015-10-31' 
          AND R."a|id" = '560d0824fd0d409ad50395eb'
          AND   R."v" = 'f'
          AND  R."do|t" = 'u'
          LIMIT 50        
          
          
          SELECT distinct R."a|t"
          FROM raw_events.all as R
             