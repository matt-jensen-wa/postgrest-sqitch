-- Verify postgrest:jwt_token on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT 1/COUNT(*) FROM pg_extension WHERE extname = 'pgcrypto'), 'pgcrypto not installed';

    ASSERT (SELECT has_function_privilege('web_anon', 'api.url_encode(bytea)', 'execute')), 'bad web_anon privilege';

    ASSERT (SELECT has_function_privilege('web_anon', 'api.url_decode(text)', 'execute')), 'bad web_anon privilege';

    ASSERT (SELECT has_function_privilege('web_anon', 'api.algorithm_sign(text, text, text)', 'execute')), 'bad web_anon privilege';

    ASSERT (SELECT has_function_privilege('web_anon', 'api.sign(json, text, text)', 'execute')), 'bad web_anon privilege';

    ASSERT (SELECT has_function_privilege('web_anon', 'api.verify(text, text, text)', 'execute')), 'bad web_anon privilege';
END $$;

ROLLBACK;
