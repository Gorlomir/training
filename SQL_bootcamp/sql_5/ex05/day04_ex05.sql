create view v_price_with_discount AS
(
    select
        name,
        pizza_name,
        price,
        CAST(price - price * 0.1 AS INTEGER) AS discount_price
    from person_order
    join menu on person_order.menu_id = menu.id
    join person on person_order.person_id = person.id
    order by name, pizza_name
);

