

    SELECT U.join_date, U.user_id
    FROM analytics.dw_users AS U
    INNER JOIN raw_events.all as R ON R."a|id" = U.user_id
    WHERE R."v" = 'l'
    AND U.join_date = '2015-12-10'
    limit 10
    
    
    
    
    /* mobile web analysis */
    select case when using.appname ='WEB' and using.useragent.value like '%iPhone%' Then 'Mobile Web'
             When using.appname ='WEB' and using.useragent.value like '%iPad%' Then 'Mobile Web'
             When using.appname ='WEB' and using.useragent.value like '%Macintosh%' Then 'Desktop Web' 
             When using.appname ='WEB' and using.useragent.value like '%Windows NT%' Then 'Mobile Web'
             when using.appname ='WEB' and using.useragent.value like '%Android%' Then 'Mobile Web'
             when using.appname ='WEB' and using.useragent.value IS NULL Then 'Desktop Web' 
                  else 
					case 
					when using.appname ='WEB' then'Desktop Web' 
					when using.appname ='IPHONE' then'iPhone' 
					when using.appname ='ipad' then'iPad' 
					when using.appname ='ANDROID' then'Android' 
					else 'Other' 
    
    
    SELECT      U.user_id,
                CASE WHEN R."u|a" ='web' and R."u|ua" like '%iPhone%' Then 'Mobile Web' 
                WHEN R."u|a" ='WEB' and R."u|ua"  like '%iPad%' Then 'Mobile Web'
                WHEN R."u|a" ='WEB' and R."u|ua"  like '%Macintosh%' Then 'Desktop Web' 
                WHEN R."u|a" ='WEB' and R."u|ua"  like '%Windows NT%' Then 'Mobile Web'
                WHEN R."u|a" ='WEB' and R."u|ua"  like '%Android%' Then 'Mobile Web'
                WHEN R."u|a" ='WEB' and R."u|ua"  IS NULL Then 'Desktop Web' 
                ELSE 
                CASE
	 	WHEN R."u|a" ='WEB' then'Desktop Web' 
	        WHEN R."u|a"='IPHONE' then'iPhone' 
	        WHEN R."u|a" ='ipad' then'iPad' 
	        WHEN R."u|a" ='ANDROID' then'Android' 
		ELSE 'Other' END END                 
    FROM  raw_events.all as R 
    INNER JOIN analytics.dw_users AS U on R."do|id" = U.user_id
    WHERE R."v" = 'su'
   
    
    
    	 /*       CASE
	 	WHEN R."u|a" ='WEB' then'Desktop Web' 
	/*	WHEN R."u|a"='IPHONE' then'iPhone' 
	/*	WHEN R."u|a" ='ipad' then'iPad' 
	/	WHEN R."u|a" ='ANDROID' then'Android' 
		ELSE 'Other' END   */
  