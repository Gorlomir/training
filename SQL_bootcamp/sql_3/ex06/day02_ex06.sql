select 
    m.pizza_name,
    pz.name AS pizzeria_name
from person p
JOIN person_order po ON p.id = po.person_id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
where p.name = 'Denis' OR p.name = 'Anna'
order by m.pizza_name, pz.name;