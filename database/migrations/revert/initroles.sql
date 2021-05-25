-- Revert postgrest:apiwebroles from pg

BEGIN;

revoke web_anon from authenticator;
revoke api_user from authenticator;
revoke web_anon from current_user;
revoke api_user from current_user;
drop role authenticator;
drop role web_anon;
drop role api_user;

COMMIT;
