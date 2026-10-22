SET enable_seqscan TO OFF;
EXPLAIN ANALYZE
    SELECT
        pizza_name,
        pz.name AS pizzeria_name
FROM menu
JOIN pizzeria pz on pizzeria_id = pz.id;