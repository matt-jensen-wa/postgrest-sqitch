-- Verify postgrest:apischema on pg

BEGIN;

SELECT pg_catalog.pg_has_role('api_admin', 'api_admin', 'member');
SELECT pg_catalog.pg_has_role('api_user', 'api_user', 'member');
SELECT pg_catalog.pg_has_role('api_admin', 'api_user', 'usage');
SELECT pg_catalog.has_schema_privilege('api_admin', 'api', 'create');
SELECT pg_catalog.has_schema_privilege('api_user', 'api', 'usage');
SELECT pg_catalog.has_schema_privilege('web_anon', 'api', 'usage');

ROLLBACK;
