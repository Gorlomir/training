select 
	(select p."name"  from person p where p.id = pv.person_id) as person_name,
	(select pz.name from pizzeria pz where pz.id = pv.pizzeria_id) as pizzeria_name
from (select person_id, pizzeria_id 
	  from person_visits pv 
	  where pv.visit_date between '2022-01-07' and '2022-01-09') as pv
order by person_name asc , pizzeria_name DESC;