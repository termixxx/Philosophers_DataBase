-- \! chcp 1251

CREATE OR REPLACE FUNCTION insert_philosopher_function()
    RETURNS TRIGGER AS
$$
BEGIN

    IF NEW.date_of_birth >= NEW.date_of_death THEN
        RAISE EXCEPTION 'Дата смерти должна быть позже даты рождения.';
    END IF;

    -- Автоматическое определение века на основе года рождения и смерти
    NEW.century_of_birth := CEIL(EXTRACT(YEAR FROM NEW.date_of_birth) / 100.0);
    NEW.century_of_death := CEIL(EXTRACT(YEAR FROM NEW.date_of_death) / 100.0);

    INSERT INTO insert_log (table_name, record_id, action, timestamp)
    VALUES ('philosopher', NEW.id, 'INSERT', NOW());

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop function insert_philosopher_function();

CREATE OR REPLACE TRIGGER insert_new_philosopher
    BEFORE INSERT
    ON philosopher
    FOR EACH ROW
EXECUTE FUNCTION insert_philosopher_function();

drop trigger insert_new_philosopher on philosopher;

create table insert_log
(
    table_name text,
    record_id  bigint,
    action     text,
    timestamp  date
);

INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Плато1231512512', NULL, NULL,
        '328-01-01 BC', '358-01-01 BC');

INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Жан-Поль2', 'Сартр', 'Шарль Эма́р',
        '1805-06-21', '1980-04-15');
-----------------------------------




CREATE OR REPLACE FUNCTION check_teaching_relationship() RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (SELECT 1 FROM education WHERE student_id = NEW.teacher_id AND teacher_id = NEW.student_id) THEN
        RAISE EXCEPTION 'Один и тот же философ не может быть и учителем, и учеником другого философа!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_check_teaching_relationship
    BEFORE INSERT OR UPDATE
    ON education
    FOR EACH ROW
EXECUTE FUNCTION check_teaching_relationship();


INSERT INTO education
VALUES (nextval('education_seq'), (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1),
        (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1), '407-01-01 BC',
        '400-01-01 BC');

INSERT INTO education --good
VALUES (nextval('education_seq'), (SELECT id FROM philosopher WHERE first_name = 'Аристотель' LIMIT 1),
        (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1),
        '360-01-01 BC', '350-01-01 BC'); -- учитель платон, ученик аристотель
------



CREATE OR REPLACE FUNCTION check_teacher_and_student_were_alive_during_education() RETURNS TRIGGER AS
$$
BEGIN
    -- Проверка, что учитель родился до начала обучения и не умер до его завершения
    IF NOT EXISTS (SELECT 1
                   FROM philosopher
                   WHERE id = NEW.teacher_id
                     AND date_of_birth <= NEW.start_date
                     AND (date_of_death IS NULL OR date_of_death >= COALESCE(NEW.end_date, NEW.start_date))) THEN
        RAISE EXCEPTION 'Учитель не жил во время всего периода обучения ученика!';
    END IF;

    -- Проверка, что ученик родился до начала обучения и не умер до его завершения
    IF NOT EXISTS (SELECT 1
                   FROM philosopher
                   WHERE id = NEW.student_id
                     AND date_of_birth <= NEW.start_date
                     AND (date_of_death IS NULL OR date_of_death >= COALESCE(NEW.end_date, NEW.start_date))) THEN
        RAISE EXCEPTION 'Ученик не жил во время всего периода обучения у учителя!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_check_both_were_alive_during_education
    BEFORE INSERT OR UPDATE
    ON education
    FOR EACH ROW
EXECUTE FUNCTION check_teacher_and_student_were_alive_during_education();

INSERT INTO education
VALUES (nextval('education_seq'), (SELECT id FROM philosopher WHERE first_name = 'Жан-Поль' LIMIT 1),
        (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1), '407-01-01 BC',
        '400-01-01 BC');

INSERT INTO education -- good
VALUES (nextval('education_seq'), (SELECT id FROM philosopher WHERE first_name = 'Аристотель' LIMIT 1),
        (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1),
        '360-01-01 BC', '350-01-01 BC');
