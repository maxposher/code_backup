
SELECT distinct E."v"
FROM analytics.raw_events AS E

LIMIT 10



Select U.join_date, U.user_id
FROM analytics.dw_users AS U
INNER JOIN analytics.raw_events AS E on U.user_id = E."a|id"
WHERE E.v = 'sch'
AND NOT U.guest_user
AND U.join_date = '2015-08-12'
AND E."do|tm" != ''
AND E."a|t" = 'u'
AND E."do|f" = 'l'
AND (DATE(E.at) - DATE(U.join_date)) <= 6
GROUP BY U.join_date, U.user_id
ORDER BY U.join_date



Select dd,  avg(CAST (CC as FLOAT))
FROM (
Select date(E."at") AS dd, E."a|id", count(E."a|id") AS CC
FROM analytics.raw_events AS E 
INNER JOIN analytics.dw_users AS U on U.user_id = E."a|id"
WHERE E.v = 'sch'
AND (DATE(E.at) - DATE(U.join_date)) <= 6
AND E."do|tm" != ''
AND E."a|t" = 'u'
AND E."do|f" = 'l'
GROUP BY date(E."at"), E."a|id"
)
GROUP BY dd
ORDER BY dd



AND DATE(E."at") >= '2015-08-12'

Select date(E."at") AS dd, E."a|id", count(E."a|id") AS CC
FROM analytics.raw_events AS E 
WHERE E.v = 'sch'
AND E."do|tm" != ''
AND E."a|t" = 'u'
AND DATE(E."at") >= '2015-08-12'
GROUP BY date(E."at"), E."a|id"
HAVING count(E.id) > 1

