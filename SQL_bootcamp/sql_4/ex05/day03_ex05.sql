select distinct pz.name as pizzeria_name
from person_visits pv 
join pizzeria pz on pv.pizzeria_id = pz.id 
join person p on pv.person_id =p.id 
join person_order po on p.id = po.person_id 
where p."name" = 'Andrey' 
				and  not exists (       SELECT 1 
      FROM person_order po
      JOIN menu m ON po.menu_id = m.id
      WHERE po.person_id = p.id 
        AND m.pizzeria_id = pz.id ) 
order by pizzeria_name ;