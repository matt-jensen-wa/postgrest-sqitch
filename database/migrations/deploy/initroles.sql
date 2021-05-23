-- Deploy postgrest:apiwebroles to pg

BEGIN;

create role authenticator noinherit login password '&pasword';
create role web_anon nologin;
grant web_anon to authenticator;

COMMIT;
