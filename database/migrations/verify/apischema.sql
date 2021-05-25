-- Verify postgrest:apischema on pg

BEGIN;

DO $$
BEGIN
    ASSERT (select pg_catalog.has_schema_privilege('web_anon', 'api', 'usage')), 'web_anon cannot use api schema';
    ASSERT (select pg_catalog.has_schema_privilege('api_user', 'api', 'usage')), 'api_user cannot use api schema';
END $$;

ROLLBACK;
