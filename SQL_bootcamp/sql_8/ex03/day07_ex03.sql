select name, SUM(count) as total_count
from(
(select pz.name, count(pz.name) as count
from person_order po
join menu m on po.menu_id = m.id 
join pizzeria pz on m.pizzeria_id = pz.id 
group by "name")
union all
(select  pz.name, count(pz.name) as count
from person_visits pv 
join pizzeria pz on pv.pizzeria_id = pz.id 
group by name)) as t
group by name
order by total_count  desc, name;