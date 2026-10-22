insert into person_order(id, person_id, menu_id, order_date)
select
		generate_series(
          	(select MAX(id) from person_order) + 1,
        	(select MAX(id) from person) + (select MAX(id) from person_order),
          	1
        ),
        generate_series(
        		(select MIN(id) from person), (select MAX(id) from person)
        ),
        (select id from menu where pizza_name = 'greek pizza'),
        '2022-02-25';