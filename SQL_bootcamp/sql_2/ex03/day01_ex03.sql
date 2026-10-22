SELECT po.order_date as action_date,
		po.person_id as person_id
FROM person_order po 

INTERSECT

SELECT pv.visit_date as action_date,
		pv.person_id as person_id
FROM person_visits pv 

order by action_date, person_id desc;