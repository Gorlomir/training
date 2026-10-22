create sequence seq_person_discounts increment by 1 start 1;

 alter table person_discounts 
 	alter column id set default nextval('seq_person_discounts');

select setval('seq_person_discounts',
				(select count(*) + 1 from person_discounts));