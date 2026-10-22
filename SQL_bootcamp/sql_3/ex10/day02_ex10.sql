select 
	p.name as person_name1,
	p2.name as person_name2,
	p.address AS common_address
from person p
join person p2 on p.address = p2.address 
where p.name != p2.name and p.id > p2.id
order by person_name1, person_name2, address ;
