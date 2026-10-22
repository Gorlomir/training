-- Session #1 --
begin;
-- Session #2 --
begin;
-- Session #1 --
UPDATE pizzeria
SET rating = 4
WHERE id = 1;
-- Session #2 --
UPDATE pizzeria
SET rating = 5
WHERE id = 2;
-- Session #1 --
UPDATE pizzeria
SET rating = 1
WHERE id = 2;
-- Session #2 --
UPDATE pizzeria
SET rating = 2
WHERE id = 1;
-- Session #1 --
COMMIT;
-- Session #2 --
COMMIT;
