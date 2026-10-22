SELECT pizzeria_name
FROM (
    SELECT pz.name AS pizzeria_name, 'female' AS only_gender
    FROM pizzeria pz
    JOIN menu m ON pz.id = m.pizzeria_id
    JOIN person_order po ON m.id = po.menu_id
    JOIN person p ON po.person_id = p.id
    GROUP BY pz.id, pz.name
    HAVING COUNT(*) FILTER (WHERE p.gender = 'male') = 0
       AND COUNT(*) FILTER (WHERE p.gender = 'female') > 0
    
    UNION
    
    SELECT pz.name AS pizzeria_name, 'male' AS only_gender
    FROM pizzeria pz
    JOIN menu m ON pz.id = m.pizzeria_id
    JOIN person_order po ON m.id = po.menu_id
    JOIN person p ON po.person_id = p.id
    GROUP BY pz.id, pz.name
    HAVING COUNT(*) FILTER (WHERE p.gender = 'female') = 0
       AND COUNT(*) FILTER (WHERE p.gender = 'male') > 0
) AS only_gender_pizzerias
ORDER BY pizzeria_name;