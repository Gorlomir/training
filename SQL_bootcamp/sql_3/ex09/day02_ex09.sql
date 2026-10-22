select
    p.name
from person p
JOIN person_order po ON p.id = po.person_id
JOIN menu m on po.menu_id = m.id 
where p.gender = 'female' and m.pizza_name in ('cheese pizza', 'pepperoni pizza')
order by "name" ;