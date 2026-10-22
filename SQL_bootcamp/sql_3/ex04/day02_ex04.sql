select m.pizza_name,
		(select pz.name from pizzeria pz where pz.id = m.pizzeria_id ) as pizzeria_name,
		m.price 
from menu m 
where m.pizza_name LIKE 'pepperoni%' or m.pizza_name LIKE 'mushroom%'
order by pizza_name, pizzeria_name;