CREATE TABLE country
(
    id   INTEGER PRIMARY KEY,
    name VARCHAR(60) NOT NULL
);
ALTER TABLE country
    ADD CONSTRAINT uk_country_name
        UNIQUE (name);


CREATE TABLE philosopher
(
    id               INTEGER PRIMARY KEY,
    first_name       VARCHAR(60) NOT NULL,
    second_name      VARCHAR(60),
    patronymic       VARCHAR(60),
    date_of_birth    DATE,
    date_of_death    DATE,
    century_of_birth INTEGER     NOT NULL,
    century_of_death INTEGER     NOT NULL
);
ALTER TABLE philosopher
    ADD CONSTRAINT good_date
        CHECK ( date_of_birth < date_of_death AND century_of_birth <= century_of_death );


CREATE TABLE country_of_residence
(
    id             INTEGER PRIMARY KEY,
    start_date     DATE NOT NULL,
    end_date       DATE,
    country_id     INTEGER,
    philosopher_id INTEGER
);
ALTER TABLE country_of_residence
    ADD CONSTRAINT fk_country
        FOREIGN KEY (country_id)
            REFERENCES country (id)
            ON DELETE CASCADE;
ALTER TABLE country_of_residence
    ADD CONSTRAINT fk_philosopher
        FOREIGN KEY (philosopher_id)
            REFERENCES philosopher (id)
            ON DELETE CASCADE;
ALTER TABLE country_of_residence
    ADD CONSTRAINT good_date
        CHECK ( start_date < end_date );


CREATE TABLE education
(
    id         INTEGER PRIMARY KEY,
    student_id INTEGER,
    teacher_id INTEGER,
    start_date DATE NOT NULL,
    end_date   DATE
);
ALTER TABLE education
    ADD CONSTRAINT fk_student
        FOREIGN KEY (student_id)
            REFERENCES philosopher (id)
            ON DELETE CASCADE;
ALTER TABLE education
    ADD CONSTRAINT fk_teacher
        FOREIGN KEY (teacher_id)
            REFERENCES philosopher (id)
            ON DELETE CASCADE;
ALTER TABLE education
    ADD CONSTRAINT different_philosophers
        CHECK ( student_id <> teacher_id );
ALTER TABLE education
    ADD CONSTRAINT good_date
        CHECK ( start_date < end_date);


CREATE TABLE philosophical_work
(
    id                    INTEGER PRIMARY KEY,
    name                  TEXT    NOT NULL,
    start_date_of_writing DATE    NOT NULL,
    end_date_of_writing   DATE,
    century_of_writing    INTEGER NOT NULL,
    philosopher_id        INTEGER
);
ALTER TABLE philosophical_work
    ADD CONSTRAINT fk_philosopher
        FOREIGN KEY (philosopher_id)
            REFERENCES philosopher (id)
            ON DELETE CASCADE;
ALTER TABLE philosophical_work
    ADD CONSTRAINT good_date
        CHECK ( start_date_of_writing < end_date_of_writing);


CREATE TABLE philosophical_current
(
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);
ALTER TABLE philosophical_current
    ADD CONSTRAINT uk_name
        UNIQUE (name);

CREATE TABLE philosopher_belongs_current
(
    id                       INTEGER PRIMARY KEY,
    start_date               DATE NOT NULL,
    end_date                 DATE,
    philosophical_current_id INTEGER,
    philosopher_id           INTEGER
);
ALTER TABLE philosopher_belongs_current
    ADD CONSTRAINT fk_philosophical_current
        FOREIGN KEY (philosophical_current_id)
            REFERENCES philosophical_current (id);
ALTER TABLE philosopher_belongs_current
    ADD CONSTRAINT fk_philosopher
        FOREIGN KEY (philosopher_id)
            REFERENCES philosopher (id);
ALTER TABLE philosopher_belongs_current
    ADD CONSTRAINT good_date
        CHECK ( start_date < end_date );
