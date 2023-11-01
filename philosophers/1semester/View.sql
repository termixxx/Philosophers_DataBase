INSERT INTO philosophical_work
SELECT nextval('philosophical_work_seq'), 'Новый Органон', '1620-01-01', NULL, 17, 1
FROM generate_series(1, 1000000);

INSERT INTO philosophical_work
SELECT nextval('philosophical_work_seq'), 'Мир как воля и представление', '1818-01-01', NULL, 19, 2
FROM generate_series(1, 1000);

INSERT INTO philosophical_work
SELECT nextval('philosophical_work_seq'), 'По ту сторону добра и зла', '1900-01-01', NULL, 20, 3
FROM generate_series(1, 1000000);
---------------------------------
-- 7. Выбрать названия трудов созданных в XVII-XVIII веках (17-18)

EXPLAIN ANALYZE
SELECT name, COUNT(*)
FROM philosophical_work
WHERE century_of_writing BETWEEN 17 AND 20
Group BY name;

DROP MATERIALIZED VIEW mv_philosophical_work;

CREATE MATERIALIZED VIEW mv_philosophical_work
AS
SELECT name, COUNT(*)
FROM philosophical_work
WHERE century_of_writing BETWEEN 17 AND 20
Group BY name;

SELECT *
FROM mv_philosophical_work;

REFRESH MATERIALIZED VIEW mv_philosophical_work;

-------------------------------------------------------

CREATE VIEW v_country(id, name)
AS
SELECT id, name
FROM country;

DROP VIEW v_country;

INSERT INTO v_country
VALUES (nextval('country_seq'), 'Абхазия');

SELECT *
FROM v_country;

---------------------------
DELETE
FROM philosophical_work
WHERE name = 'По ту сторону добра и зла';