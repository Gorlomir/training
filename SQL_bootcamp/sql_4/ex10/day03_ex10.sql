insert into person_order  (id, person_id, menu_id, order_date)
values ((select MAX(id)+1 from person_order po ), (select id from person where name = 'Denis' ),
		(select id from menu m  where m.pizza_name  = 'sicilian pizza'),
		'2022-02-24');

insert into person_order (id, person_id, menu_id, order_date)
values ((select MAX(id)+1 from person_order po), (select id from person where name = 'Irina' ),
		(select id from menu m  where m.pizza_name = 'sicilian pizza'),
		'2022-02-24');