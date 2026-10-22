--create unique index idx_menu_unique on menu(pizzeria_id, pizza_name );

SET enable_seqscan TO OFF;
EXPLAIN analyse
select pizzeria_id, pizza_name, price
from menu
where pizzeria_id = 2 and pizza_name = 'sicilian pizza';