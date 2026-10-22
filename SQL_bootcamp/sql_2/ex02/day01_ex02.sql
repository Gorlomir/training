SELECT pizza_name
FROM menu

UNION

SELECT pizza_name
FROM menu

order by pizza_name desc;