select p.name, count(name) as coun_of_visits
from person_visits pv 
join person p on p.id = pv.person_id 
group by name
having count(name) > 3;