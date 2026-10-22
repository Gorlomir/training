select p.name, count(p.name) as count_of_visits
from person_visits pv 
join person p on pv.person_id = p.id 
group by p."name" 
order by count_of_visits desc, name
limit 4;