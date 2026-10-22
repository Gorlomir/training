select 
        COALESCE(person.name, '-') as person_name,
        visit_date AS visit_date,
        COALESCE(pizzeria.name, '-') AS pizzeria_name
from 
    (select *
     from person_visits
     where visit_date between  '2022-01-01' AND '2022-01-03') AS date
FULL JOIN pizzeria ON date.pizzeria_id = pizzeria.id
FULL JOIN person ON date.person_id = person.id
order by 1, 2, 3;