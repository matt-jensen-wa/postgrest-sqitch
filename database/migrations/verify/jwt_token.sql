-- Verify postgrest:jwt_token on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT 1/COUNT(*) FROM pg_extension WHERE extname = 'pgcrypto'), 'pgcrypto not installed';

    ASSERT (SELECT has_function_privilege('web_anon', 'auth.url_encode(bytea)', 'execute')), 'bad web_anon privilege';

    ASSERT (SELECT has_function_privilege('web_anon', 'auth.url_decode(text)', 'execute')), 'bad web_anon privilege';

    ASSERT (SELECT has_function_privilege('web_anon', 'auth.algorithm_sign(text, text, text)', 'execute')), 'bad web_anon privilege';

    ASSERT (SELECT has_function_privilege('web_anon', 'auth.sign(json, text, text)', 'execute')), 'bad web_anon privilege';

    ASSERT (SELECT has_function_privilege('web_anon', 'auth.verify(text, text, text)', 'execute')), 'bad web_anon privilege';
END $$;

ROLLBACK;
