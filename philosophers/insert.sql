CREATE SEQUENCE current_seq;
CREATE SEQUENCE pbc_seq;
CREATE SEQUENCE country_resident_seq;
CREATE SEQUENCE country_seq;
CREATE SEQUENCE philosopher_seq;
CREATE SEQUENCE philosophical_work_seq;
CREATE SEQUENCE education_seq;

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Эмпиризм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Рационализм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Идеализм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Позитивизм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Стоицизм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Структурализм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Феноменология');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Материализм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Экзистенциализм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Скептицизм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Цинизм');

INSERT INTO philosophical_current (id, name)
VALUES (nextval('current_seq'), 'Догматизм');



INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Франция');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Германия');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Италия');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Греция');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Древний Рим');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Великобритания');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Англия');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'США');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Россия');

INSERT INTO country(id, name)
VALUES (nextval('country_seq'), 'Афины');



INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Фрэнсис', 'Бэкон', NULL,
        '1561-01-22', '1626-04-09', 16, 17);
INSERT INTO philosopher_belongs_current
VALUES (nextval('pbc_seq'), '1580-01-01', NULL, 1, (SELECT id FROM philosopher WHERE first_name = 'Фрэнсис' LIMIT 1));
INSERT INTO country_of_residence
VALUES (nextval('country_resident_seq'), '1561-01-22', NULL, (SELECT id FROM country WHERE name = 'Англия'),
        (SELECT id FROM philosopher WHERE first_name = 'Фрэнсис' LIMIT 1));
INSERT INTO philosophical_work
VALUES (nextval('philosophical_work_seq'), 'Новый Органон', '1620-01-01', NULL, 17,
        (SELECT id FROM philosopher WHERE first_name = 'Фрэнсис' LIMIT 1));
INSERT INTO philosophical_work
VALUES (nextval('philosophical_work_seq'), 'Мир и воля', '1620-01-01', NULL, 17,
        (SELECT id FROM philosopher WHERE first_name = 'Фрэнсис' LIMIT 1));


INSERT INTO philosophical_work
VALUES (nextval('philosophical_work_seq'), 'Аформизмы', '1620-01-01', NULL, 17,
        null);


INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Платон', NULL, NULL,
        '428-01-01 BC', '348-01-01 BC', -5, -4);
INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Платон2', NULL, NULL,
        '428-01-01 BC', '348-01-01 BC', -5, -4);
INSERT INTO country_of_residence
VALUES (nextval('country_resident_seq'), '428-01-01 BC', '348-01-01 BC', (SELECT id FROM country WHERE name = 'Греция'),
        (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1));
INSERT INTO philosopher_belongs_current
VALUES (nextval('pbc_seq'), '408-01-01 BC', NULL, (SELECT id FROM philosophical_current WHERE name = 'Идеализм'),
        (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1));
INSERT INTO philosopher_belongs_current
VALUES (nextval('pbc_seq'), '350-01-01 BC', NULL, (SELECT id FROM philosophical_current WHERE name = 'Феноменология'),
        (SELECT id FROM philosopher WHERE first_name = 'Платон2' LIMIT 1));
INSERT INTO philosophical_work
VALUES (nextval('philosophical_work_seq'), 'Диалоги', '400-01-01 BC', NULL, 17,
        (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1));

INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Аристотель', NULL, NULL, '384-01-01 BC', '322-01-01 BC', -4, -4);
INSERT INTO country_of_residence
VALUES (nextval('country_resident_seq'), '384-01-01 BC', '322-01-01 BC', 4,
        (SELECT id FROM philosopher WHERE first_name = 'Аристотель' LIMIT 1));
INSERT INTO philosopher_belongs_current
VALUES (nextval('pbc_seq'), '362-02-05 BC', NULL, (SELECT id FROM philosophical_current WHERE name = 'Идеализм'),
        (SELECT id FROM philosopher WHERE first_name = 'Аристотель' LIMIT 1));


INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Сократ', NULL, NULL, '469-01-01 BC', '399-01-01 BC', -5, -4);
INSERT INTO country_of_residence
VALUES (nextval('country_resident_seq'), '469-01-01 BC', '399-01-01 BC', (SELECT id FROM country WHERE name = 'Греция'),
        (SELECT id FROM philosopher WHERE first_name = 'Сократ' LIMIT 1));
INSERT INTO philosopher_belongs_current
VALUES (nextval('pbc_seq'), '442-01-11 BC', NULL, (SELECT id FROM philosophical_current WHERE name = 'Стоицизм'),
        (SELECT id FROM philosopher WHERE first_name = 'Сократ' LIMIT 1));


INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Жан-Поль', 'Сартр', 'Шарль Эма́р',
        '1905-06-21', '1980-04-15', 20, 20);
INSERT INTO philosopher
VALUES (nextval('philosopher_seq'), 'Жан-Поль2', 'Сартр', 'Шарль Эма́р',
        '1905-06-21', '1980-04-15', 20, 20);
INSERT INTO country_of_residence
VALUES (nextval('country_resident_seq'), '1905-06-21', '1980-04-15', (SELECT id FROM country WHERE name = 'Франция'),
        (SELECT id FROM philosopher WHERE first_name = 'Жан-Поль' LIMIT 1));
INSERT INTO philosopher_belongs_current
VALUES (nextval('pbc_seq'), '1920-01-21', '1980-04-15',
        (SELECT id FROM philosophical_current WHERE name = 'Экзистенциализм'),
        (SELECT id FROM philosopher WHERE first_name = 'Жан-Поль' LIMIT 1));
INSERT INTO philosopher_belongs_current
VALUES (nextval('pbc_seq'), '1920-01-21', '1980-04-15',
        (SELECT id FROM philosophical_current WHERE name = 'Экзистенциализм'),
        (SELECT id FROM philosopher WHERE first_name = 'Жан-Поль2' LIMIT 1));


INSERT INTO education
VALUES (nextval('education_seq'), (SELECT id FROM philosopher WHERE first_name = 'Аристотель' LIMIT 1),
        (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1),
        '360-01-01 BC', '350-01-01 BC'); -- учитель платон, ученик аристотель

INSERT INTO education
VALUES (nextval('education_seq'), (SELECT id FROM philosopher WHERE first_name = 'Платон' LIMIT 1),
        (SELECT id FROM philosopher WHERE first_name = 'Сократ' LIMIT 1), '407-01-01 BC',
        '400-01-01 BC'); -- ученик платон, учитель сократ


