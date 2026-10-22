SELECT 
    m.pizza_name,
    m.price,
    pz.name AS pizzeria_name,
    pv.visit_date
FROM person_visits pv
JOIN person p ON p.id = pv.person_id      
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
JOIN menu m ON pz.id = m.pizzeria_id       
WHERE p.name = 'Kate' 
    AND m.price BETWEEN 800 AND 1000
order by m.pizza_name , m.price, pizzeria_name;
