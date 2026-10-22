(select pz.name, count(pz.name) as count,
'order' as action_type
from person_order po
join menu m on po.menu_id = m.id 
join pizzeria pz on m.pizzeria_id = pz.id 
group by "name" 
order by count desc
limit 3)
union
(select  pz.name, count(pz.name) as count, 'visit' as action_type 
from person_visits pv 
join pizzeria pz on pv.pizzeria_id = pz.id 
group by name
order by count desc
limit 3)
order by action_type, count desc;