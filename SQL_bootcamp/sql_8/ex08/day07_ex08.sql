select p.address, pz.name, count(pz.name) as count_of_orders
from person p 
join person_order po on p.id = po.person_id 
join menu m  on po.menu_id = m.id 
join pizzeria pz on m.pizzeria_id = pz.id 
group by p.address , pz."name" 
order by p.address , pz."name" ;