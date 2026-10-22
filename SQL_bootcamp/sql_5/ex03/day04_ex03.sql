select distinct generated_date as missing_date
from v_generated_dates as vgd
left join person_visits pv on vgd.generated_date = pv.visit_date 
where pv.visit_date is null 
order by missing_date ;