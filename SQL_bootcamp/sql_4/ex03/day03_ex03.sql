SELECT 
    pz.name AS pizzeria_name
FROM person_visits pv
JOIN person p ON pv.person_id = p.id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
GROUP BY pz.id, pz.name
HAVING COUNT(*) FILTER (WHERE p.gender = 'male') != 
       COUNT(*) FILTER (WHERE p.gender = 'female')
ORDER BY pz.name;