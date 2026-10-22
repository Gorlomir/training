----session1
begin; ---begin transaction
select * from pizzeria where name = 'Pizza Hut' ----show info for Pizza hut
-----session2
begin; ---begin transaction
select * from pizzeria where name = 'Pizza Hut' ----show info for Pizza hut
----session1
update pizzeria set rating = 4 where name ='Pizza Hut' --- update rating for pizza hut
-----session2
update pizzeria set rating = 4 where name ='Pizza Hut' --- update rating for pizza hut
----session1
commit; ----confirm update
----session2
commit; ---- confirm update
----session1
select * from pizzeria where name = 'Pizza Hut';
----- commit session 1 is dissapear!!!!