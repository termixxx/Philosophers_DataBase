-- многоверсионность

begin;
select first_name, id
from philosopher;

UPDATE philosopher
SET first_name = 'first'
WHERE id = 1;

UPDATE philosopher
SET first_name = 'second'
WHERE id = 2;


select first_name, id, xmin, xmax
from philosopher;


--
UPDATE philosopher
SET first_name = 'first'
WHERE id = 1;


--
UPDATE philosopher
SET first_name = 'first'
WHERE id = 1;

select first_name, id
from philosopher;

UPDATE philosopher
SET first_name = 'second'
WHERE id = 2;