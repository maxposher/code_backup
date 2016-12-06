

     /* Potential Text Mining */
     SELECT date(R."at"), R."a|id", listagg(R."do|tm",'|') 
     FROM  raw_events.all as R 
     WHERE date(R."at") = '2016-03-13' 
     AND   R."v" = 'sch' 
     GROUP BY 1, 2
     LIMIT 20
     