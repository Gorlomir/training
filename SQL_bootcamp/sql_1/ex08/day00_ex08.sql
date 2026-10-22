select *
from person_order po 
where po.id % 2 = 0
order by id ;
