-- Revert postgrest:authschema from pg

BEGIN;

REVOKE USAGE ON SCHEMA auth FROM api_user;
REVOKE USAGE ON SCHEMA auth FROM web_anon;
REVOKE USAGE ON SCHEMA auth FROM current_user;
DROP SCHEMA auth cascade;

COMMIT;
