DO
$do$
    BEGIN
        FOR i IN 1..1000000
            LOOP
                INSERT INTO philosopher
                VALUES (nextval('philosopher_seq'), concat('Философ_', i), NULL, NULL,
                        '428-01-01 BC', '348-01-01 BC', -5, -4);
            END LOOP;
    END
$do$;
DROP TABLE test_philosopher;

CREATE TABLE test_philosopher
(
    LIKE philosopher
)
    WITH (autovacuum_enabled = false);


INSERT INTO test_philosopher
SELECT *
FROM philosopher;


SELECT DISTINCT tablename, null_frac, correlation
FROM pg_stats
WHERE schemaname = 'public';


SELECT reltuples, relpages, relallvisible
FROM pg_class
WHERE relname = 'test_philosopher';


EXPLAIN ANALYZE
SELECT *
FROM test_philosopher
WHERE id = 5;

ANALYZE test_philosopher;


SELECT attname,
       inherited,
       n_distinct,
       array_to_string(most_common_vals, E'\n') as most_common_vals
FROM pg_stats
WHERE tablename = 'test_philosopher';