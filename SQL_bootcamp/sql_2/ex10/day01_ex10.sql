SELECT 
    p.name AS person_name,
    m.pizza_name,
    pz.name AS pizzeria_name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
order by person_name, pizza_name, pizzeria_name;