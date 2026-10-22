insert into person_visits(id, person_id, pizzeria_id, visit_date)
values ( (select MAX(id) from person_visits) +1,
		(select id from person where name = 'Dmitriy'),
		(select distinct pz.id from pizzeria pz
		join menu on pz.id = pizzeria_id 
		join mv_dmitriy_visits_and_eats as mv on mv.pizzeria_name != pz."name" 
		where price < 800 limit 1),
		'2022-01-08');
refresh materialized view mv_dmitriy_visits_and_eats;