select  generate_series::DATE AS missing_date
from  generate_series('2022-01-01'::DATE, '2022-01-10'::DATE, '1 day'::INTERVAL) AS generate_series
left join  (
    select visit_date
    from person_visits
    where person_id = 1 OR person_id = 2 ) pv on generate_series = pv.visit_date
where pv.visit_date is null
order by missing_date;