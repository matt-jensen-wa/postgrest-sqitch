-- Verify postgrest:authschema on pg

BEGIN;

DO $$
BEGIN
    ASSERT (select pg_catalog.has_schema_privilege('web_anon', 'auth', 'usage')), 'web_anon cannot use auth schema';
    ASSERT (select pg_catalog.has_schema_privilege('api_user', 'auth', 'usage')), 'api_user cannot use auth schema';
END $$;

ROLLBACK;
