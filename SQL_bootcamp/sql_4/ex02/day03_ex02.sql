WITH cte_idk as (select *
from menu m 
where not exists ( select menu_id from person_order po where po.menu_id = m.id)
)
select cte_idk.pizza_name, cte_idk.price, pz.name as pizzeria_name 
from cte_idk
JOIN pizzeria pz ON cte_idk.pizzeria_id  = pz.id
order by pizza_name , price ;