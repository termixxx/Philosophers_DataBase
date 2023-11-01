-- 17.Выбрать название страны, ФИО философа, годы жизни в одном
-- столбце, название направления, названия и годы создания трудов.
-- Из результата исключить философов XX века.

--1
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

--2
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

-- 35. Выбрать названия философского направления, ФИО философа,
-- период работы в направлении и количество учеников в этот период.
--1
explain
SELECT pc.name                                  AS philosophical_direction,
       CONCAT(p.first_name, ' ', p.second_name) AS philosopher_name,
       pbc.start_date                           AS period_start,
       pbc.end_date                             AS period_end,
       COUNT(e.student_id)                      AS number_of_students
FROM philosophical_current pc
         JOIN philosopher_belongs_current pbc ON pc.id = pbc.philosophical_current_id
         JOIN philosopher p ON pbc.philosopher_id = p.id
         LEFT JOIN education e ON p.id = e.teacher_id AND e.start_date > pbc.start_date
GROUP BY pc.name, p.id, pbc.start_date, pbc.end_date
ORDER BY pc.name, p.id, pbc.start_date;

--2
explain
SELECT pc.name                                  AS philosophical_direction,
       CONCAT(p.first_name, ' ', p.second_name) AS philosopher_name,
       pbc.start_date                           AS period_start,
       pbc.end_date                             AS period_end,
       (SELECT COUNT(e.student_id)
        FROM education e
        WHERE e.teacher_id = p.id
          AND e.start_date > pbc.start_date)    AS number_of_students
FROM philosophical_current pc
         JOIN philosopher_belongs_current pbc ON pc.id = pbc.philosophical_current_id
         JOIN philosopher p ON pbc.philosopher_id = p.id
ORDER BY pc.name, p.id, pbc.start_date;

-- 41. Выбрать название страны, в которой жили философы всех направлений   ПОКАЗАТЬ

-- 1
EXPLAIN
SELECT c.name AS country_name
FROM country c
         JOIN country_of_residence cor ON c.id = cor.country_id
         JOIN philosopher_belongs_current pbc ON cor.philosopher_id = pbc.philosopher_id
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT pbc.philosophical_current_id) = (SELECT COUNT(DISTINCT pc.id)
                                                       FROM philosophical_current pc);


--2
EXPLAIN
SELECT c.name AS country_name
FROM country c
WHERE NOT EXISTS (SELECT pc.id
                  FROM philosophical_current pc
                  WHERE NOT EXISTS (SELECT pbc.philosopher_id
                                    FROM philosopher_belongs_current pbc
                                    WHERE pbc.philosopher_id IN (SELECT p.id
                                                                 FROM philosopher p
                                                                          JOIN country_of_residence cor ON p.id = cor.philosopher_id
                                                                 WHERE cor.country_id = c.id)
                                      AND pbc.philosophical_current_id = pc.id));

-- 49.Выбрать века нашей эры, в которые нет философов
-- зарегистрированных в БД
--1
EXPLAIN
WITH centyries AS (SELECT generate_series(1, EXTRACT(CENTURY FROM CURRENT_DATE)) AS century)

SELECT *
FROM centyries
WHERE century NOT IN (SELECT century_of_death FROM philosopher)
  AND century NOT IN (SELECT century_of_birth FROM philosopher)
ORDER BY century;

--2
EXPLAIN
WITH RECURSIVE centuries AS (SELECT 1 AS century
                             UNION ALL
                             SELECT century + 1
                             FROM centuries
                             WHERE century < EXTRACT(CENTURY FROM CURRENT_DATE))

SELECT century
FROM centuries
WHERE century NOT IN (SELECT DISTINCT century_of_birth
                      FROM philosopher
                      UNION
                      SELECT DISTINCT century_of_death
                      FROM philosopher)
ORDER BY century;