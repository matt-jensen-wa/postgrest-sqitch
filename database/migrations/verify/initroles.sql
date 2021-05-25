-- Verify postgrest:apiwebroles on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT pg_catalog.pg_has_role('authenticator', 'authenticator', 'member')), 'authenticator does not exist';
    ASSERT (SELECT pg_catalog.pg_has_role('web_anon', 'web_anon', 'member')), 'web_anon does not exist';
    ASSERT (SELECT pg_catalog.pg_has_role('api_user', 'api_user', 'member')), 'api_user does not exist';
    ASSERT (SELECT pg_catalog.pg_has_role('authenticator', 'web_anon', 'member')), 'authenticator not member of web_anon';
    ASSERT (SELECT pg_catalog.pg_has_role('authenticator', 'api_user', 'member')), 'authenticator not member of api_user';
END $$;

ROLLBACK;
