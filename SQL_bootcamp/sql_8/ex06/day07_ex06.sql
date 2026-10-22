select pz.name as name, count(pz.name) as count_of_orders, 
round(avg(m.price), 2) as average_price, max(m.price) as max_price, min(m.price) as min_price
from pizzeria pz
join menu m on pz.id = m.pizzeria_id 
join person_order po on m.id = po.menu_id 
group by pz."name" 
order by pz.name;