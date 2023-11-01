-- \! chcp 1251

CREATE OR REPLACE FUNCTION find_count_of_students(id_teach int)
    RETURNS numeric AS
$BODY$
BEGIN
    RETURN (SELECT COUNT(1) FROM education WHERE teacher_id = id_teach);

END;
$BODY$
    LANGUAGE plpgsql
    SECURITY INVOKER;

SELECT find_count_of_students(2);

-----------------------

CREATE OR REPLACE FUNCTION find_count_of_students_def(id_teach int)
    RETURNS numeric AS
$BODY$
BEGIN
    RETURN (SELECT COUNT(1) FROM education WHERE teacher_id = id_teach);

END;
$BODY$
    LANGUAGE plpgsql
    SECURITY DEFINER;


SELECT find_count_of_students_def(2);

-----------------------

CREATE OR REPLACE PROCEDURE update_philosophers_witch_name_starts_with(ch char)
AS
$BODY$
BEGIN
    UPDATE philosopher
    SET first_name = concat(lower(substring(first_name for 1)), substring(first_name from 2))
    WHERE first_name LIKE concat(ch, '%');
END;
$BODY$
    LANGUAGE plpgsql
    SECURITY DEFINER;

CALL update_philosophers_witch_name_starts_with('ж');


