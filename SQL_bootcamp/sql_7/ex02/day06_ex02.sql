select p.name, m.pizza_name, m.price, round(m.price - (m.price * pd.discount/100)) as discount_price, pz.name as pizzeria_name
from person_order po 
join person p on po.person_id = p.id 
join menu m on po.menu_id = m.id 
join pizzeria pz on po.person_id = pz.id 
join person_discounts pd on p.id = pd.person_id and pz.id = pd.pizzeria_id  
order by 1, 2;