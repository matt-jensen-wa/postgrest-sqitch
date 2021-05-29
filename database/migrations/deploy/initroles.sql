-- Deploy postgrest:apiwebroles to pg

BEGIN;

create role authenticator noinherit login password 'password';
create role web_anon nologin;
create role api_user nologin;
grant web_anon to authenticator;
grant api_user to authenticator;
grant api_user to current_user;
grant web_anon to current_user;

COMMIT;
