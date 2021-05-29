-- Revert postgrest:jwt_token from pg

BEGIN;

DROP EXTENSION pgcrypto;
DROP FUNCTION auth.url_encode;
DROP FUNCTION auth.url_decode;
DROP FUNCTION auth.algorithm_sign;
DROP FUNCTION auth.sign;
DROP FUNCTION auth.verify;

COMMIT;
