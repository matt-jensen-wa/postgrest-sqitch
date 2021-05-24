-- Revert postgrest:jwt_token from pg

BEGIN;

DROP EXTENSION pgcrypto;
DROP FUNCTION api.url_encode;
DROP FUNCTION api.url_decode;
DROP FUNCTION api.algorithm_sign;
DROP FUNCTION api.sign;
DROP FUNCTION api.verify;

COMMIT;
