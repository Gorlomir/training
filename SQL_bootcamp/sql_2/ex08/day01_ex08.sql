SELECT 
    t.order_date,
    p.name || ' (age:' || p.age || ')' AS person_information
FROM (
    SELECT 
        order_date,
        person_id AS id 
    FROM person_order
) t
NATURAL JOIN person p
ORDER BY t.order_date, person_information;