CREATE TABLE philosophical_work_partition
(
    id                    INTEGER NOT NULL,
    name                  TEXT    NOT NULL,
    start_date_of_writing DATE    NOT NULL,
    end_date_of_writing   DATE,
    century_of_writing    INTEGER NOT NULL,
    philosopher_id        INTEGER
) PARTITION BY RANGE (century_of_writing);
ALTER TABLE philosophical_work_partition
    ADD CONSTRAINT fk_philosopher
        FOREIGN KEY (philosopher_id)
            REFERENCES philosopher (id)
            ON DELETE CASCADE;
ALTER TABLE philosophical_work_partition
    ADD CONSTRAINT good_date
        CHECK ( start_date_of_writing < end_date_of_writing);

select count(*) from philosophical_work;
select count(*) from philosophical_work_partition;
-- Создание партиций
CREATE TABLE philosophical_work_partition_1_to_5 PARTITION OF philosophical_work_partition
    FOR VALUES FROM (1) TO (6);

CREATE TABLE philosophical_work_partition_6_to_10 PARTITION OF philosophical_work_partition
    FOR VALUES FROM (6) TO (11);

CREATE TABLE philosophical_work_partition_11_to_15 PARTITION OF philosophical_work_partition
    FOR VALUES FROM (11) TO (16);

CREATE TABLE philosophical_work_partition_16_to_20 PARTITION OF philosophical_work_partition
    FOR VALUES FROM (16) TO (22);



INSERT INTO philosophical_work_partition
SELECT *
FROM philosophical_work;


-- Вставка философов
WITH philosophersdd AS (
    INSERT INTO philosopher (id, first_name, century_of_birth, century_of_death)
        SELECT nextval('philosopher_seq'), 'Philosopher ' || i, 20, 21
        FROM generate_series(1, 1000000) AS s(i)
        RETURNING id)
-- Вставка трудов философов
INSERT
INTO philosophical_work (id, name, start_date_of_writing, century_of_writing, philosopher_id)
SELECT nextval('philosophical_work_seq'),
       'Work ' || (row_number() OVER ()) % 10 + 1 || ' of Philosopher ' || p.id,
       '2000-01-01',
       floor(random() * 1) - 4,
       p.id
FROM philosophersdd p
         CROSS JOIN
     generate_series(1, 10) AS s(j);


select COUNT(*)
from philosopher;


-- првоерка кол-ва записей
EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work
WHERE century_of_writing <= 5;
EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_partition
WHERE century_of_writing <= 5;

EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work
WHERE century_of_writing BETWEEN 5 AND 10;
EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_partition
WHERE century_of_writing BETWEEN 5 AND 10;

EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work
WHERE century_of_writing BETWEEN 10 AND 15;
EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_partition
WHERE century_of_writing BETWEEN 10 AND 15;

EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work
WHERE century_of_writing BETWEEN 15 AND 21;
EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_partition
WHERE century_of_writing BETWEEN 15 AND 21;

EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work
WHERE century_of_writing BETWEEN 10 AND 21;
EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_partition
WHERE century_of_writing BETWEEN 10 AND 21;

CREATE TABLE philosophical_work_partition_BC
(
    LIKE philosophical_work_partition INCLUDING DEFAULTS INCLUDING CONSTRAINTS
);

drop table philosophical_work_partition_BC;

ALTER TABLE philosophical_work_partition_BC
    ADD CONSTRAINT century_range
        CHECK ( century_of_writing < 0 );

INSERT INTO philosophical_work_partition_BC
SELECT *
FROM philosophical_work
WHERE century_of_writing < 0;

-- присоединение
ALTER TABLE philosophical_work_partition
    ATTACH PARTITION philosophical_work_partition_BC
        FOR VALUES FROM (-10) TO (0);


-- Отсоединение партиции
ALTER TABLE philosophical_work_partition
    DETACH PARTITION philosophical_work_partition_BC;


EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work
WHERE century_of_writing < 0;

EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_partition
WHERE century_of_writing < 0;

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--hash
CREATE TABLE philosophical_work_hash_partition
(
    id                    INTEGER NOT NULL,
    name                  TEXT    NOT NULL,
    start_date_of_writing DATE    NOT NULL,
    end_date_of_writing   DATE,
    century_of_writing    INTEGER NOT NULL,
    philosopher_id        INTEGER,
    PRIMARY KEY (id, century_of_writing)
) PARTITION BY HASH (century_of_writing);
ALTER TABLE philosophical_work_hash_partition
    ADD CONSTRAINT fk_philosopher
        FOREIGN KEY (philosopher_id)
            REFERENCES philosopher (id)
            ON DELETE CASCADE;
ALTER TABLE philosophical_work_hash_partition
    ADD CONSTRAINT good_date
        CHECK ( start_date_of_writing < end_date_of_writing);

-- Создание партиций
CREATE TABLE philosophical_work_hash_partition_0 PARTITION OF philosophical_work_hash_partition FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE philosophical_work_hash_partition_1 PARTITION OF philosophical_work_hash_partition FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE philosophical_work_hash_partition_2 PARTITION OF philosophical_work_hash_partition FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE philosophical_work_hash_partition_3 PARTITION OF philosophical_work_hash_partition FOR VALUES WITH (MODULUS 4, REMAINDER 3);


INSERT INTO philosophical_work_hash_partition
SELECT *
FROM philosophical_work;


-- првоерка кол-ва записей
EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_hash_partition
WHERE century_of_writing <= 5;

EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_hash_partition
WHERE century_of_writing BETWEEN 5 AND 10;

EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_hash_partition
WHERE century_of_writing BETWEEN 10 AND 15;

EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_hash_partition
WHERE century_of_writing BETWEEN 15 AND 21;


EXPLAIN ANALYSE
select COUNT(*)
from philosophical_work_hash_partition
WHERE century_of_writing BETWEEN 10 AND 21;