select (
	select p2.name 
	from person p2 
	where p2.id = po.person_id) as name
from person_order po 
where po.order_date = '2022-01-07' and (po.menu_id = 13 or po.menu_id = 14 or po.menu_id = 18);
