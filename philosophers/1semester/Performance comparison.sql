-- 7. Выбрать названия трудов созданных в XVII-XVIII веках (17-18)

SELECT name
FROM philosophical_work
WHERE century_of_writing BETWEEN 17 AND 18;

DO
$$
    DECLARE
        i integer := 1;
    BEGIN
        WHILE i <= 1500000
            LOOP
                PERFORM name
                FROM philosophical_work
                WHERE century_of_writing BETWEEN 17 AND 18;
                i := i + 1;
            END LOOP;
    END
$$;

SELECT name
FROM philosophical_work
WHERE century_of_writing >= 17
  AND century_of_writing <= 18;

DO
$$
    DECLARE
        i integer := 1;
    BEGIN
        WHILE i <= 1500000
            LOOP
                PERFORM name
                FROM philosophical_work
                WHERE century_of_writing >= 17
                  AND century_of_writing <= 18;
                i := i + 1;
            END LOOP;
    END
$$;
-- between работает медленнее

------------------------------------------------------------------

-- 15. Выбрать среднюю продолжительность жизни философов XIX века.

EXPLAIN ANALYSE
SELECT AVG(extract(YEAR FROM AGE(date_of_death, date_of_birth))) avg_age
FROM philosopher;

DO
$$
    DECLARE
        i integer := 1;
    BEGIN
        WHILE i <= 250000
            LOOP
                PERFORM AVG(extract(YEAR FROM AGE(date_of_death, date_of_birth))) avg_age
                FROM philosopher;
                i := i + 1;
            END LOOP;
    END
$$;
EXPLAIN ANALYSE
SELECT (SELECT SUM(extract(YEAR FROM AGE(date_of_death, date_of_birth)))
        FROM philosopher) / COUNT(*)
FROM philosopher;

DO
$$
    DECLARE
        i integer := 1;
    BEGIN
        WHILE i <= 250000
            LOOP
                PERFORM (SELECT SUM(extract(YEAR FROM AGE(date_of_death, date_of_birth)))
                         FROM philosopher) / COUNT(*)
                FROM philosopher;
                i := i + 1;
            END LOOP;
    END
$$;

-------------------------------------------------------------------


DO
$$
    DECLARE
        i integer := 1;
    BEGIN
        WHILE i <= 25000
            LOOP
                PERFORM c.name Страна, philosopher.first_name Имя, COALESCE(philosopher.second_name, 'Неизвестно') Фамилия, COALESCE(philosopher.patronymic, 'Неизвестно') Отчество, CONCAT(date_of_birth, ' — ', date_of_death) Годы_жизни, pc.name Направление, pw.name Название_труда, CASE
                                                                                                                                                                                                                                                                                              WHEN pw.start_date_of_writing IS NOT NULL
                                                                                                                                                                                                                                                                                                  AND
                                                                                                                                                                                                                                                                                                   pw.end_date_of_writing IS NOT NULL
                                                                                                                                                                                                                                                                                                  THEN CONCAT(pw.start_date_of_writing, ' — ', pw.end_date_of_writing)
                                                                                                                                                                                                                                                                                              ELSE CONCAT(pw.start_date_of_writing, '')
                    END Годы_создания_трудов
                FROM philosopher
                         JOIN country_of_residence cor ON philosopher.id = cor.philosopher_id
                         JOIN country c ON cor.country_id = c.id
                         JOIN philosopher_belongs_current pbc on philosopher.id = pbc.philosopher_id
                         JOIN philosophical_current pc on pbc.philosophical_current_id = pc.id
                         LEFT JOIN philosophical_work pw on philosopher.id = pw.philosopher_id
                EXCEPT
                SELECT c.name                                          Страна,
                       philosopher.first_name                          Имя,
                       COALESCE(philosopher.second_name, 'Неизвестно') Фамилия,
                       COALESCE(philosopher.patronymic, 'Неизвестно')  Отчество,
                       CONCAT(date_of_birth, ' — ', date_of_death)     Годы_жизни,
                       pc.name                                         Направление,
                       pw.name                                         Название_труда,
                       CASE
                           WHEN pw.start_date_of_writing IS NOT NULL
                               AND pw.end_date_of_writing IS NOT NULL
                               THEN CONCAT(pw.start_date_of_writing, ' — ', pw.end_date_of_writing)
                           ELSE CONCAT(pw.start_date_of_writing, '')
                           END                                         Годы_создания_трудов
                FROM philosopher
                         JOIN country_of_residence cor ON philosopher.id = cor.philosopher_id
                         JOIN country c ON cor.country_id = c.id
                         JOIN philosopher_belongs_current pbc on philosopher.id = pbc.philosopher_id
                         JOIN philosophical_current pc on pbc.philosophical_current_id = pc.id
                         LEFT JOIN philosophical_work pw on philosopher.id = pw.philosopher_id
                WHERE century_of_birth = 20;
                i := i + 1;
            END LOOP;
    END
$$;


EXPLAIN ANALYZE
SELECT c.name                                          Страна,
       philosopher.first_name                          Имя,
       COALESCE(philosopher.second_name, 'Неизвестно') Фамилия,
       COALESCE(philosopher.patronymic, 'Неизвестно')  Отчество,
       CONCAT(date_of_birth, ' — ', date_of_death)     Годы_жизни,
       pc.name                                         Направление,
       pw.name                                         Название_труда,
       CASE
           WHEN pw.start_date_of_writing IS NOT NULL
               AND pw.end_date_of_writing IS NOT NULL
               THEN CONCAT(pw.start_date_of_writing, ' — ', pw.end_date_of_writing)
           ELSE CONCAT(pw.start_date_of_writing, '')
           END                                         Годы_создания_трудов
FROM philosopher
         JOIN country_of_residence cor ON philosopher.id = cor.philosopher_id
         JOIN country c ON cor.country_id = c.id
         JOIN philosopher_belongs_current pbc on philosopher.id = pbc.philosopher_id
         JOIN philosophical_current pc on pbc.philosophical_current_id = pc.id
         LEFT JOIN philosophical_work pw on philosopher.id = pw.philosopher_id
WHERE century_of_birth <> 20;


DO
$$
    DECLARE
        i integer := 1;
    BEGIN
        WHILE i <= 25000
            LOOP
                PERFORM c.name Страна, philosopher.first_name Имя, COALESCE(philosopher.second_name, 'Неизвестно') Фамилия, COALESCE(philosopher.patronymic, 'Неизвестно') Отчество, CONCAT(date_of_birth, ' — ', date_of_death) Годы_жизни, pc.name Направление, pw.name Название_труда, CASE
                                                                                                                                                                                                                                                                                              WHEN pw.start_date_of_writing IS NOT NULL
                                                                                                                                                                                                                                                                                                  AND
                                                                                                                                                                                                                                                                                                   pw.end_date_of_writing IS NOT NULL
                                                                                                                                                                                                                                                                                                  THEN CONCAT(pw.start_date_of_writing, ' — ', pw.end_date_of_writing)
                                                                                                                                                                                                                                                                                              ELSE CONCAT(pw.start_date_of_writing, '')
                    END Годы_создания_трудов
                FROM philosopher
                         JOIN country_of_residence cor ON philosopher.id = cor.philosopher_id
                         JOIN country c ON cor.country_id = c.id
                         JOIN philosopher_belongs_current pbc on philosopher.id = pbc.philosopher_id
                         JOIN philosophical_current pc on pbc.philosophical_current_id = pc.id
                         LEFT JOIN philosophical_work pw on philosopher.id = pw.philosopher_id
                WHERE century_of_birth <> 20;
                i := i + 1;
            END LOOP;
    END
$$;


EXPLAIN
SELECT c.name                                          Страна,
       philosopher.first_name                          Имя,
       COALESCE(philosopher.second_name, 'Неизвестно') Фамилия,
       COALESCE(philosopher.patronymic, 'Неизвестно')  Отчество,
       CONCAT(date_of_birth, ' — ', date_of_death)     Годы_жизни,
       pc.name                                         Направление,
       pw.name                                         Название_труда,
       CASE
           WHEN pw.start_date_of_writing IS NOT NULL
               AND
                pw.end_date_of_writing IS NOT NULL
               THEN CONCAT(pw.start_date_of_writing, ' — ', pw.end_date_of_writing)
           ELSE CONCAT(pw.start_date_of_writing, '')
           END                                         Годы_создания_трудов
FROM philosopher
         JOIN country_of_residence cor ON philosopher.id = cor.philosopher_id
         JOIN country c ON cor.country_id = c.id
         JOIN philosopher_belongs_current pbc on philosopher.id = pbc.philosopher_id
         JOIN philosophical_current pc on pbc.philosophical_current_id = pc.id
         LEFT JOIN philosophical_work pw on philosopher.id = pw.philosopher_id
EXCEPT
SELECT c.name                                          Страна,
       philosopher.first_name                          Имя,
       COALESCE(philosopher.second_name, 'Неизвестно') Фамилия,
       COALESCE(philosopher.patronymic, 'Неизвестно')  Отчество,
       CONCAT(date_of_birth, ' — ', date_of_death)     Годы_жизни,
       pc.name                                         Направление,
       pw.name                                         Название_труда,
       CASE
           WHEN pw.start_date_of_writing IS NOT NULL
               AND pw.end_date_of_writing IS NOT NULL
               THEN CONCAT(pw.start_date_of_writing, ' — ', pw.end_date_of_writing)
           ELSE CONCAT(pw.start_date_of_writing, '')
           END                                         Годы_создания_трудов
FROM philosopher
         JOIN country_of_residence cor ON philosopher.id = cor.philosopher_id
         JOIN country c ON cor.country_id = c.id
         JOIN philosopher_belongs_current pbc on philosopher.id = pbc.philosopher_id
         JOIN philosophical_current pc on pbc.philosophical_current_id = pc.id
         LEFT JOIN philosophical_work pw on philosopher.id = pw.philosopher_id
WHERE century_of_birth = 20;