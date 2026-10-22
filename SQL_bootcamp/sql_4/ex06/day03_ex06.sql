select m.pizza_name, pz1.name as pizzeria_name1, pz2.name as pizzeria_name2, m.price 
from menu m
join menu m2 on m.price = m2.price 
join pizzeria pz1 on m.pizzeria_id = pz1.id 
join pizzeria pz2 on m2.pizzeria_id = pz2.id 
where m.id > m2.id and m.pizza_name = m2.pizza_name 
order by m.pizza_name ;