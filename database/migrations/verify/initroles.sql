-- Verify postgrest:apiwebroles on pg

BEGIN;

SELECT pg_catalog.pg_has_role('authenticator', 'authenticator', 'member');
SELECT pg_catalog.pg_has_role('web_anon', 'web_anon', 'member');
SELECT pg_catalog.pg_has_role('authenticator', 'web_anon', 'usage');

ROLLBACK;
