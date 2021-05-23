-- Revert postgrest:apiwebroles from pg

BEGIN;

drop role authenticator;
drop role web_anon;

COMMIT;
