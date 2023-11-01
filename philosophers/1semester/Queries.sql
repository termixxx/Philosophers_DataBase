-- 31. Выбрать фамилии всех философов, и если у философа были труды, то
-- их названия. Результат отсортировать по фамилии и по названию труда.
SELECT first_name, second_name, coalesce(pw.name, 'нет трудов') as philosophical_work_name
FROM philosopher
         LEFT JOIN philosophical_work pw on philosopher.id = pw.philosopher_id
ORDER BY second_name, pw.name;

-- 32. Выбрать названия всех стран. Если в стране были философы
-- XX века, то указать их фамилии.
SELECT country.name, coalesce(p.second_name, 'В этой стране не было философов 20 века') as second_name
FROM country
         LEFT JOIN country_of_residence cor on country.id = cor.country_id
         LEFT JOIN philosopher p on cor.philosopher_id = p.id
WHERE p.century_of_birth = 20
   OR p.century_of_death = 20
   OR p.id IS NULL;

-- 33. Выбрать ФИО и годы жизни всех философов и всех трудов. Учесть,
-- что в БД могут быть труды, авторство для которых не установлено,
-- и могут быть философы, не писавшие трудов.

SELECT first_name,
       second_name,
       patronymic,
       date_of_birth,
       date_of_death,
       name,
       start_date_of_writing,
       end_date_of_writing
FROM philosopher
         FULL JOIN philosophical_work pw on philosopher.id = pw.philosopher_id;

-- 34. Выбрать год и количество рожденных в этот год философов
-- по временам года. В результирующей таблице должно быть пять
-- столбцов (первый - год, последующие временя года).
SELECT EXTRACT(YEAR FROM date_of_birth)                                             AS year,
       COUNT(CASE WHEN EXTRACT(MONTH FROM date_of_birth) IN (12, 1, 2) THEN 1 END)  AS winter,
       COUNT(CASE WHEN EXTRACT(MONTH FROM date_of_birth) IN (3, 4, 5) THEN 1 END)   AS spring,
       COUNT(CASE WHEN EXTRACT(MONTH FROM date_of_birth) IN (6, 7, 8) THEN 1 END)   AS summer,
       COUNT(CASE WHEN EXTRACT(MONTH FROM date_of_birth) IN (9, 10, 11) THEN 1 END) AS autumn
FROM philosopher
GROUP BY year
ORDER BY year;

-- 35. Выбрать названия философского направления, ФИО философа,
-- период работы в направлении и количество учеников в этот период.
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

-- 36.Выбрать название самого старого труда.
SELECT name AS oldest_work
FROM philosophical_work
WHERE start_date_of_writing = (SELECT MIN(start_date_of_writing)
                               FROM philosophical_work);
-- 37. Выбрать для каждого философа название последнего его направления.
SELECT p.first_name, p.second_name, pc.name AS last_direction
FROM philosopher p
         JOIN (SELECT philosopher_id, MAX(start_date) AS max_date
               FROM philosopher_belongs_current
               GROUP BY philosopher_id) AS max_dates ON p.id = max_dates.philosopher_id
         JOIN philosopher_belongs_current pbc ON p.id = pbc.philosopher_id AND max_dates.max_date = pbc.start_date
         JOIN philosophical_current pc ON pbc.philosophical_current_id = pc.id;



---- 2 часть
-- 38. Выбрать для каждого философа название направления, в котором
-- он работал на определенную дату в прошлом.
SELECT p.id AS philosopher_id, p.first_name, p.second_name, pc.name AS philosophical_current_name
FROM philosopher p
         LEFT JOIN philosopher_belongs_current pbc ON p.id = pbc.philosopher_id
         LEFT JOIN philosophical_current pc ON pbc.philosophical_current_id = pc.id
WHERE (pbc.start_date <= '1580-01-01' AND pbc.end_date IS NULL
    OR pbc.start_date <= '1580-01-01' AND pbc.end_date >= '1580-01-01');
-- start <= date >= end

-- 39. Выбрать страны, в которых нет философов. ПОКАЗАТЬ
-- not exist
SELECT c.name AS country_name
FROM country c
WHERE NOT EXISTS (SELECT 1
                  FROM country_of_residence cor
                  WHERE cor.country_id = c.id);

-- старый
SELECT c.name
FROM country c
         LEFT JOIN country_of_residence cor ON c.id = cor.country_id
WHERE cor.philosopher_id IS NULL;

-- 40. Выбрать все данные философа, у которого было наибольшее
-- количество учеников.
SELECT p.*
FROM philosopher p
         JOIN (SELECT teacher_id, COUNT(*) AS student_count
               FROM education
               GROUP BY teacher_id
               HAVING COUNT(*) = (SELECT MAX(student_count)
                                  FROM (SELECT COUNT(*) AS student_count
                                        FROM education
                                        GROUP BY teacher_id) AS counts)) AS max_students
              ON p.id = max_students.teacher_id;


-- 41. Выбрать название страны, в которой жили философы всех направлений   ПОКАЗАТЬ

-- груп по стране кол-во напралвений distinct, общее кол-во направлений
EXPLAIN
SELECT c.name AS country_name
FROM country c
         JOIN country_of_residence cor ON c.id = cor.country_id
         JOIN philosopher_belongs_current pbc ON cor.philosopher_id = pbc.philosopher_id
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT pbc.philosophical_current_id) = (SELECT COUNT(DISTINCT pc.id)
                                                       FROM philosophical_current pc);


--старый
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


-- 42. Выбрать название направления, в котором больше всего философов.  ПОКАЗАТЬ

WITH philosopher_counts AS (SELECT philosophical_current_id, COUNT(*) AS num_philosophers
                            FROM philosopher_belongs_current
                            GROUP BY philosophical_current_id)

SELECT pc.name AS philosophical_current_name
FROM philosophical_current pc
         JOIN philosopher_counts pcnt ON pc.id = pcnt.philosophical_current_id
WHERE pcnt.num_philosophers = (SELECT MAX(num_philosophers)
                               FROM philosopher_counts);

-- 43. Выбрать все данные о философах, которые работали в направлении,
-- в котором работало больше всего философов.

SELECT p.*
FROM philosopher p
         JOIN philosopher_belongs_current pbc ON p.id = pbc.philosopher_id
WHERE pbc.philosophical_current_id IN (SELECT philosophical_current_id
                                       FROM philosopher_belongs_current
                                       GROUP BY philosophical_current_id
                                       HAVING COUNT(*) = (SELECT COUNT(*)
                                                          FROM philosopher_belongs_current
                                                          GROUP BY philosophical_current_id
                                                          ORDER BY COUNT(*) DESC
                                                          LIMIT 1));

-- 44. Выбрать названия трудов, для которых автор неизвестен.
SELECT name
FROM philosophical_work
WHERE philosopher_id IS NULL;



-- 3 часть
-- 45.Выбрать ФИО философов, которые не были ни учениками,
-- ни учителями.

SELECT CONCAT(first_name, ' ', COALESCE(second_name, ''), ' ', COALESCE(patronymic, '')) AS full_name
FROM philosopher
WHERE id NOT IN (SELECT student_id
                 FROM education
                 UNION
                 SELECT teacher_id
                 FROM education);

-- 46.Выбрать философа(ов), который поменял наибольшее количество
-- учителей.
SELECT p.id,
       CONCAT(p.first_name, ' ', COALESCE(p.second_name, ''), ' ', COALESCE(p.patronymic, '')) AS philosopher_name,
       COUNT(DISTINCT e.teacher_id)                                                            AS num_teachers
FROM philosopher p
         JOIN education e ON p.id = e.student_id
GROUP BY p.id, philosopher_name
ORDER BY num_teachers DESC
LIMIT 1;

-- 47.Выбрать все года имеющиеся в базе данных. Результат отсортировать
-- в порядке убывания.
SELECT DISTINCT EXTRACT(YEAR FROM date_of_birth) AS year
FROM philosopher
UNION
SELECT DISTINCT EXTRACT(YEAR FROM date_of_death) AS year
FROM philosopher
UNION
SELECT DISTINCT EXTRACT(YEAR FROM start_date) AS year
FROM country_of_residence
UNION
SELECT DISTINCT EXTRACT(YEAR FROM end_date) AS year
FROM country_of_residence
UNION
SELECT DISTINCT EXTRACT(YEAR FROM start_date) AS year
FROM education
UNION
SELECT DISTINCT EXTRACT(YEAR FROM end_date) AS year
FROM education
UNION
SELECT DISTINCT EXTRACT(YEAR FROM start_date_of_writing) AS year
FROM philosophical_work
UNION
SELECT DISTINCT EXTRACT(YEAR FROM end_date_of_writing) AS year
FROM philosophical_work
UNION
SELECT DISTINCT EXTRACT(YEAR FROM start_date) AS year
FROM philosopher_belongs_current
UNION
SELECT DISTINCT EXTRACT(YEAR FROM end_date) AS year
FROM philosopher_belongs_current
ORDER BY year DESC;

-- 48.Выбрать все данные о философах, для которых есть период, когда
-- неизвестно в каком направлении он работал.
SELECT *
FROM philosopher p
WHERE NOT EXISTS (SELECT 1
                  FROM philosopher_belongs_current pbc
                  WHERE p.id = pbc.philosopher_id);


-----
SELECT p.*
FROM philosopher p
WHERE p.date_of_death - p.date_of_birth <
      (SELECT sum( COALESCE(pb.end_date, CURRENT_DATE) - pb.start_date)
       FROM philosopher_belongs_current pb
       WHERE pb.philosopher_id = p.id)
ORDER BY p.id;
-----------------------

SELECT p.*, p.date_of_death - p.date_of_birth, COALESCE(pbc.end_date, p.date_of_death) - pbc.start_date,pbc.id, start_date, end_date
FROM philosopher p
         JOIN public.philosopher_belongs_current pbc on p.id = pbc.philosopher_id

ORDER BY p.id;

-- 49.Выбрать века нашей эры, в которые нет философов
-- зарегистрированных в БД
EXPLAIN
WITH centyries AS (SELECT generate_series(1, EXTRACT(CENTURY FROM CURRENT_DATE)) AS century)

SELECT *
FROM centyries
WHERE century NOT IN (SELECT century_of_death FROM philosopher)
  AND century NOT IN (SELECT century_of_birth FROM philosopher)
ORDER BY century;

---2вариант
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

-- 50.Выбрать ФИО философа, который создал наибольшее количество
-- трудов и выбрать ФИО философа(ов), труды которого неизвестны,
-- т.е. их нет в базе данных.
explain
SELECT p.first_name, p.second_name, COUNT(pw.id)
FROM philosopher p
         LEFT JOIN philosophical_work pw ON p.id = pw.philosopher_id
GROUP BY p.id, p.first_name, p.second_name
HAVING COUNT(pw.id) = (SELECT COUNT(pw.id)
                       FROM philosopher p
                                LEFT JOIN philosophical_work pw ON p.id = pw.philosopher_id
                       GROUP BY p.id, p.first_name, p.second_name
                       ORDER BY COUNT(pw.id) DESC
                       LIMIT 1)
    OR COUNT(pw.id) = 0
ORDER BY COUNT(pw.id) DESC;

-- 51.Выбрать страну, век, количество философов, проживавших в этом
-- веке в этой стране, и общее количество философов в этой стране.
EXPLAIN
SELECT c.name                        AS country_name,
       p.century_of_birth            AS century,
       COUNT(*)                      AS philosophers_in_century,
       (SELECT COUNT(*)
        FROM philosopher p2
                 JOIN country_of_residence cor ON p2.id = cor.philosopher_id
        WHERE cor.country_id = c.id) AS total_philosophers_in_country
FROM country c
         JOIN philosopher p
              ON c.id = (SELECT cor.country_id
                         FROM country_of_residence cor
                         WHERE cor.philosopher_id = p.id
                         LIMIT 1)
GROUP BY c.id, c.name, p.century_of_birth
ORDER BY c.name, p.century_of_birth;


-----
EXPLAIN
SELECT c.name                                 AS country_name,
       p.century_of_birth                     AS century,
       COUNT(*)                               AS philosophers_in_century,
       SUM(COUNT(*)) OVER (PARTITION BY c.id) AS total_philosophers_in_country
FROM country c
         JOIN philosopher p
              ON c.id = (SELECT cor.country_id
                         FROM country_of_residence cor
                         WHERE cor.philosopher_id = p.id
                         LIMIT 1)
GROUP BY c.id, c.name, p.century_of_birth
ORDER BY c.name, p.century_of_birth;

-- 48 49 51
