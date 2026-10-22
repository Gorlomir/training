--session #1--
begin;
--session #2--
begin;
--session #1--
select sum(rating) from pizzeria;
--session #2--
insert into pizzeria(id,name,rating)
values(10, 'Kazan Pizza', 5);

commit;
--session #1--
select sum(rating) from pizzeria;
commit;
select sum(rating) from pizzeria;
--session #2--
select sum(rating) from pizzeria;
