CREATE ROLE all_users LOGIN;

CREATE ROLE read_only_user WITH PASSWORD '1234' LOGIN;
CREATE ROLE read_write_user WITH PASSWORD '1234' LOGIN;
CREATE ROLE guest WITH PASSWORD '1234' LOGIN;
CREATE ROLE admin_user WITH PASSWORD '1234' LOGIN;

GRANT all_users TO read_only_user, read_write_user, admin_user, guest;

REVOKE all_users FROM guest;


GRANT SELECT, INSERT, UPDATE ON philosopher TO read_write_user;
GRANT SELECT ON philosopher TO read_only_user;


GRANT ALL PRIVILEGES ON philosopher to admin_user;

GRANT SELECT ON education,philosopher TO all_users;

-- \! chcp 1251