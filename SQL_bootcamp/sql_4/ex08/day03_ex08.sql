insert into menu (id, pizzeria_id, pizza_name, price)
values ((select MAX(id) + 1 from menu m ), 
(select id from pizzeria pz where name = 'Dominos'), 'sicilian pizza', 900)
returning *
