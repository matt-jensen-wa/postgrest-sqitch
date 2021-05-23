-- Revert postgrest:apischema from pg

BEGIN;

DROP SCHEMA api;
DROP ROLE api_admin;
DROP ROLE api_user;

COMMIT;
