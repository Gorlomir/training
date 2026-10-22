SELECT 
    po.order_date AS action_date,
    (SELECT name FROM person WHERE id = po.person_id) AS person_name
FROM person_order po

INTERSECT

SELECT 
    pv.visit_date AS action_date,
    (SELECT name FROM person WHERE id = pv.person_id) AS person_name
FROM person_visits pv

ORDER BY action_date, person_name DESC;