SELECT object_name
FROM (
    SELECT 
        name AS object_name,
        1 AS grp
    FROM person
    
    UNION ALL
    
    SELECT 
        pizza_name AS object_name,
        2 AS grp
    FROM menu
) AS combined
ORDER BY grp, object_name;