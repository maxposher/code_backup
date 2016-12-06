

select at::CHAR(14)::TIMESTAMP,
count(*)
from raw_events.all re

WHERE re."a|t"='u'
and re.v='b'

and at::date>='2016-03-04'
group by 1 



select distinct E."verb"
from  raw_events.all AS E
WHERE E."verb" is not null
limit 100



Select *
from  raw_events.all AS E
WHERE E."verb" is not null
limit 100