-- Verify postgrest:jwt_token on pg

BEGIN;

SELECT 1/count(*) FROM pg_extension WHERE extname = 'pgcrypto';
SELECT has_function_privilege('api_admin', 'api.url_encode(bytea)', 'execute');
SELECT has_function_privilege('api_admin', 'api.url_decode(text)', 'execute');
SELECT has_function_privilege('api_admin', 'api.algorithm_sign(text, text, text)', 'execute');
SELECT has_function_privilege('api_admin', 'api.sign(json, text, text)', 'execute');
SELECT has_function_privilege('api_admin', 'api.verify(text, text, text)', 'execute');

ROLLBACK;
