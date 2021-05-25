-- Revert postgrest:apischema from pg

BEGIN;

revoke usage on schema api from api_user;
revoke usage on schema api from web_anon;
revoke usage on schema api from current_user;
DROP SCHEMA api;

COMMIT;
