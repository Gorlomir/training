select 
    pz.name AS pizzeria_name
from person p
join person_visits pv on p.id  = pv.person_id
join pizzeria pz on pv.pizzeria_id = pz.id 
join menu m ON pz.id = m.pizzeria_id 
where p.name = 'Dmitriy' and pv.visit_date = '2022-01-08' and m.price < 800;