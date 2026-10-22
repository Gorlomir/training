with cte_missing(missing_date) AS (
    (select days::DATE AS missing_date
               from generate_series('2022-01-01', '2022-01-10', interval '1 day') AS days
    ))
select missing_date from cte_missing
FULL JOIN
    (select *
    from person_visits where person_id = 1 OR person_id = 2
    AND visit_date between  '2022-01-01' AND '2022-01-10') AS d
ON missing_date = d.visit_date where  d.person_id is NULL
order by missing_date;